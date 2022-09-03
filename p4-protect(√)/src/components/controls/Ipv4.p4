/* Ipv4.p4 -*- c -*-
*
* This contorl unit applies layer 3 forwarding, adds bier(-te) layers and decaps
* ip packets
*/
control IPv4(inout headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata){

    register<protectionSeq_t>(PROTECTION_STORAGE) protection_next_seq;
    direct_counter(CounterType.packets) l3_match_to_index_stats;

    // do nothing, used to test if pkt should be protected
    action none() {}

    /*
    * Forward ipv4 packet
    * Set egress port and change source & dst mac adress for correct layer 2 header
    * decrement ttl
    */
    action forward(egressSpec_t port) {
            standard_metadata.egress_spec = port;

            // decrement time to live (ttl)
            hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }

    action decap() {
            hdr.ipv4.setInvalid(); // remove ipv4 header
            hdr.ethernet.etherType = TYPE_PROTECTION;
            recirculate<metadata>(meta);
    }

    // table for ipv4 unicast match
    table ipv4 {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            forward;
            decap;
        }
    }

    table ipv4_tunnel {
        key = {
            hdr.ipv4.dstAddr: exact;
        }
        actions = {
            forward;
            decap;
        }
    }

    // set mc group for mc traffic
    action set_mc_grp(mcastGrp_t grp) {
        standard_metadata.mcast_grp = grp;
    }

    action protect(protectionId_t id, mcastGrp_t grp, ip4Addr_t srcAddr, ip4Addr_t dstAddr) {
        l3_match_to_index_stats.count();
        @atomic {
            // read next seq
            protectionSeq_t next_seq;
            protection_next_seq.read(next_seq, (bit<32>) id);

            // activate protection
            hdr.protection.setValid();
            hdr.protection.conn_id = id;
            hdr.protection.seq = next_seq;
            hdr.protection.proto = TYPE_IP_IP;

            // update next seq
            protection_next_seq.write((bit<32>) id, next_seq + 1);
        }

        // add ip tunnel
        hdr.ipv4_inner.setValid();
        hdr.ipv4_inner = hdr.ipv4;
        hdr.ipv4.srcAddr = srcAddr;
        hdr.ipv4.dstAddr = dstAddr;
        hdr.ipv4.protocol = TYPE_IP_PROTECTION;

        set_mc_grp(grp);
    }

    table protected_services {
        key = {
            hdr.ipv4.srcAddr: ternary;
            hdr.ipv4.dstAddr: ternary;
            hdr.transport.src_port: ternary;
            hdr.transport.dst_port: ternary;
            hdr.ipv4.protocol: ternary;
        }
        actions = {
            none;
        }
    }

    table l3_match_to_index {
        key = {
            hdr.ipv4.srcAddr: exact;
            hdr.ipv4.dstAddr: exact;
            hdr.transport.src_port: exact;
            hdr.transport.dst_port: exact;
            hdr.ipv4.protocol: exact;
        }
        actions = {
            protect;
        }
        counters = l3_match_to_index_stats;
    }


    apply {
        if(hdr.protection_reset.isValid() && hdr.protection_reset.device_type == 0) {
            @atomic {
                // reset connection
                protection_next_seq.write((bit<32>) hdr.protection_reset.conn_id, 0);
            }
        }
        else if(!l3_match_to_index.apply().hit) { // do normal ipv4 forwarding
            if(protected_services.apply().hit) { // check if flow should be protected
                clone3<metadata>(CloneType.I2E, 1000, meta); // send copy to controller
            }

            if(!ipv4.apply().hit) { // there is no prot. connection, do normal forwarding
                ipv4_tunnel.apply(); // of do ip tunnel forwarding
            }
        }
    }
}
