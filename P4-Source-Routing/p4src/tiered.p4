 header_type ethernet_t {
     fields {
         dstAddr : 48;
         srcAddr : 48;
         etherType : 16;
     }
 }

header_type island_hop_t {
        fields {
            dstIsland: 48;
            srcIsland: 48;
            etherType: 16;
        }
}

 header_type ipv4_t {
     fields {
         version: 4;
         ihl: 4;
         diffserv: 8;
         totalLen: 16;
         identification: 16;
         flags: 3;
         fragOffset: 13;
         ttl: 8;
         protocol: 8;
         hdrChecksum: 16;
         srcAddr: 32;
         dstAddr: 32;
     }
 }

 header_type arp_t {
     fields {
         hwType : 16;
         protoType : 16;
         hwAddrLen : 8;
         protoAddrLen : 8;
         opcode : 16;
     }
 }

 // header_type arp_ipv4_t {
 //     fields {
 //         srcHwAddr    : 48;
 //         srcProtoAddr : 32;
 //         dstHwAddr    : 48;
 //         dstProtoAddr : 32;
 //     }
 // }
 //
 // header_type icmp_t {
 //     fields {
 //         icmp_type   : 8;
 //         icmp_code   : 8;
 //         hdrChecksum : 16;
 //     }
 // }

 header ethernet_t ethernet;
 header island_hop_t island_hop;
 header ipv4_t ipv4;
 // header icmp_t     icmp;
 header arp_t      arp;
 // header arp_ipv4_t arp_ipv4;

 header_type intrinsic_metadata_t {
    fields {
        ingress_global_timestamp : 48;
        lf_field_list : 8;
        mcast_grp : 16;
        egress_rid : 16;
        resubmit_flag : 8;
        recirculate_flag : 8;
    }
}
metadata intrinsic_metadata_t intrinsic_metadata;

header_type meta_temp_t {
    fields {
        ethertype: 16;
    }
}
metadata meta_temp_t meta_temp;
// Check whether to treat the packet as an inter-island packet or as a normal packet_in
 parser start {
     // extract(ethernet);
     // return select(ethernet.etherType) {
     //     0x0800: parse_ipv4;
     //     0x0806 : parse_arp;
     //     0xAAAA: parse_island_hop;
     //     default: ingress;
     // }
     // return select(current(95, 111)) {
     //     0x0800: parse_ethernet;
     //     0xAAAA: parse_island_hop;
     // }
     set_metadata(meta_temp.ethertype, current(96, 16));
     return select(meta_temp.ethertype) {
         0x0800: parse_ethernet;
         0xAAAA: parse_island_hop;
     }
 }

//Parse the ethernet header, and subsequent ARP or ipv4 header
 parser parse_ethernet {
     extract(ethernet);
     return select(ethernet.etherType) {
         0x0800: parse_ipv4;
         0x0806 : parse_arp;
         default: ingress;
     }
 }

//Parse an island hop, then move to parsing the ethernet header
 parser parse_island_hop {
     extract(island_hop);
     return parse_ethernet;
 }

//Extract the ipv4 headers
parser parse_ipv4 {
    extract(ipv4);
    // return select(ipv4.protocol) {
    //     0x000006 : parse_tcp;
    //     0x000011 : parse_udp;
    //     default  : ingress;
    // }
    return ingress;
}

//Parse the arp headers for the packet
 parser parse_arp {
     extract(arp);
     // return select(arp.hwType, arp.protoType) {
     //     0x00010800 : parse_arp_ipv4;
     //     default    : ingress;
     // }
     return ingress;
 }



 // parser parse_icmp {
 //     extract(icmp);
 //     return ingress;
 // }

/**
  Ingress Processing
  Stages:
    - Check if the packet is 'hopping' between islands
      -If it is hopping, check whether this is the destination switch
        - If we are the destination, treat it as a normal L2 packet_in
        - If not, we want the packet to go to egress for the next island
    - If the packet is not hopping, check the L2 table to see if it is known
        - If the destination is known locally, forward normally
        - If the destination MAC is part of a host to host intent, add the hop header and pass to egress
    //TODO implement forwarding IP based intents
*/

control ingress {
    if(valid(island_hop)) {
    //Packet is island hopping, are we the destination?
        apply(isThisIsland) {
            //We are the destination, forward it locally
            hit { apply(dmacTable); }
            //We aren't the destination, forward it to the next island
            miss { apply(islandTable); }
        }
    } else {
        /**
            Treat it as a normal packet, we always want to apply the incoming smac table for MAC learning
            Apply the dmac table, which can have either forward locally, broadcast or forward to another island
        */
        if(valid(ethernet)) {
            //Check whether the source is known
            apply(smacTable);
            //Forward to a local destination
            apply(dmacTable);

            }
        }

    }

control egress {

}

// Forward to the next island
table islandTable {
     reads {
         island_hop.dstIsland: exact;
     }
     actions {
         forward_to_island;
     }
 }

//Check whether the destination is this island
 table isThisIsland {
     reads {
         island_hop.dstIsland: exact;
     }
     actions {
         strip_island_header;
     }
     default_action: noop;
     size: 1;
 }

//Add an island hop header to the packet
 action add_island_header(dstIsland, srcIsland, egressPort) {
     add_header(island_hop);
     modify_field(island_hop.srcIsland, srcIsland);
     modify_field(island_hop.dstIsland, dstIsland);
     modify_field(island_hop.etherType, 0xAAAA);
     modify_field(standard_metadata.egress_spec, egressPort);
 }

// Remove the island header from the packet
 action strip_island_header() {
     remove_header(island_hop);
 }

//Forward the packet to a given island on this port
 action forward_to_island(port) {
     modify_field(standard_metadata.egress_spec, port);
 }

// Send the packet to the controller for it to manage somehow
 // action send_to_cpu() {
 //     modify_field(standard_metadata.egress_spec, 127);
 // }

// L2 multicast the packet on all ports
// TODO fix how this may end up with loops
 action l2_broadcast(group) {
     modify_field(intrinsic_metadata.mcast_grp, group);
 }

/** Read the source mac for automatic L2 learning */
table smacTable {
    reads {
        ethernet.srcAddr: exact;
    }
    actions {
        send_l2_digest;
        noop;
    }
    default_action: send_l2_digest();
    // size: MAC_TABLE_SIZE;
}

action noop() {
    no_op();
}

/** Read the outgoing mac address and forward to the appropriate port
    Also handles forwarding onto another island if an intent is installed */
table dmacTable {
    reads {
        ethernet.dstAddr: exact;
    }
    actions {
        l2_broadcast;
        add_island_header;
        l2_forward;
    }
    // default_action: l2_broadcast;
}

action send_island_packet() {
    no_op();
}

action l2_forward(port) {
    modify_field(standard_metadata.egress_spec, port);
}

field_list l2_digest {
    ethernet.srcAddr;
    standard_metadata.ingress_port;
}

action send_l2_digest() {
    generate_digest(0, l2_digest);
}
