/*
 * Define the Paco protocol header format. The pathlet_ids field consists of the segment 
 * numbers passing through the path in order. ori_etherType is the value of the original 
 * Ethernet type field in the received Ethernet frame.
 */
header_type paco_head_t {
    fields {
        pathlet_ids: 32;
        ori_etherType: 16;
    }
}

/*
 * Instantiate a paco protocol header
 */
header paco_head_t paco_head;

/*
 * Define the header required for the paco protocol to interact with the controller (cpu).
 * The device field is used to identify the current device id.
 */
header_type cpu_header_t {
    fields {
        device: 8;
    }
}

/*
 * Instantiate a cpu_header instance
 */
header cpu_header_t cpu_header;

/*
 * Define the Ethernet frame header format, the dstAddr field is the destination MAC address,
 * the srcAddr field is the source MAC address, and the etherType field is the protocol type.
 */
header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

/*
 * Instantiate an ether frame header instance
 */
header ethernet_t ethernet;

/* 
 * Define the ipv4 protocol header format, srcAddr is the source IP address, 
 * and dstAddr is the destination IP address.
 */
header_type ipv4_t {
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}

/*
 * Instantiate an ipv4 protocol header
 */
header ipv4_t ipv4;

/*
 * Parser entry
 */
parser start {
    /*
    return parse_ethernet;
    */
    return select(current(0,128)) {
        0 : parse_cpu_header;
        default : parse_ethernet;
    }
}

/*
 * Parsing cpu_header
 */
parser parse_cpu_header {
    extract(cpu_header);
    return ingress;
}

#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_PACO 0x0037
#define CPU_MIRROR_SESSION_ID 250

/*
 * Parsing Ethernet frames
 */
parser parse_ethernet{
    extract(ethernet);
    return select(ethernet.etherType){
        ETHERTYPE_IPV4: parse_ipv4;
        ETHERTYPE_PACO: parse_paco;
    }
}

/*
 * Parsing ipv4 frames
 */
parser parse_ipv4 {
    extract(ipv4);
    return ingress;
}

/*
 * Parsing paco frames
 */
parser parse_paco {
    extract(paco_head);
    return ingress;
}

/* 
 * Action: Specify the exit of the next hop
 */
action next_hop(output_port) {
    modify_field(standard_metadata.egress_spec, output_port);
}

/*
 * Action: ipv4 to paco
 */
action ipv42paco(ids, output_port){
    add_header(paco_head);
    modify_field(paco_head.ori_etherType, ethernet.etherType);
    modify_field(ethernet.etherType, 0x0037);
    modify_field(paco_head.pathlet_ids, ids);
    modify_field(standard_metadata.egress_spec, output_port);	
}

/*
 * Action: action performed by the router located in the middle of the 
 * segment when forwarding the paco packet
 */
action pathlet_mid_forward(output_port) {
    modify_field(standard_metadata.egress_spec, output_port);
}

/*
 * Action: forwarding action executed after matching pathlet_ids is 0
 */
action pathlet_NULL_forward(output_port) {
    modify_field(standard_metadata.egress_spec, output_port);
    modify_field(ethernet.etherType, paco_head.ori_etherType);
    remove_header(paco_head);
}

/*
 * Action: forwarding action of the router at the end of the segment
 */
action pathlet_tail_forward(output_port) {
    modify_field(standard_metadata.egress_spec, output_port);
    shift_left(paco_head.pathlet_ids, paco_head.pathlet_ids, 8);
}

/*
 * Action: Binding-ID action
 */
action pathlet_multi_forward(number, new_ids, output_port){
    bit_and(paco_head.pathlet_ids, paco_head.pathlet_ids, 0x00FFFFFF);
    shift_right(paco_head.pathlet_ids, paco_head.pathlet_ids, 8 * number);
    bit_or(paco_head.pathlet_ids, paco_head.pathlet_ids, new_ids);
    modify_field(standard_metadata.egress_spec, output_port);
}

field_list copy2cpu_fields {
    standard_metadata;
}

/*
 * Action: Copy to cpu, send a copy of the current data to the controller
 */
action copy2cpu() {
    clone_ingress_pkt_to_egress(CPU_MIRROR_SESSION_ID, copy2cpu_fields);
}

action forward() {
    /*
    modify_field(standard_metadata.egress_spec, standard_metadata.egress_spec);
    drop();
    */
}

/*
 * Action: Add the header of cpu_header,
 * the parameter device_id is the device id that sent the packet
 */
action do_cpu_encap(device_id) {
    add_header(cpu_header);
    modify_field(cpu_header.device, device_id);
}

/*
 * Ipv4 forwarding table: reads is the match list. For example: 
 * ipv4.srcAddr: exact; meaning to match the source ip address of ipv4,
 * the format is exact (here is the specific value, there are other, 
 * such as lmp, for example, 0x11223344/4 represents the first 4 digits 
 * of 0x11223344), actions is the action list, and the list of actions
 * that may be performed after matching the packet
 */
table forward_ipv4 {
    reads {
        ipv4.srcAddr : exact;
        ipv4.dstAddr : exact;
    }
    actions {
        ipv42paco;
        next_hop;
        copy2cpu;
    }
}

/*
 * Paco forwarding table
 */
table forward_paco{
    reads {
        paco_head.pathlet_ids : lpm;
    }
    actions{
        pathlet_mid_forward;
        pathlet_tail_forward;
        pathlet_NULL_forward;
        pathlet_multi_forward;
        copy2cpu;
    }
}

table redirect {
    reads {
        standard_metadata.instance_type : exact;
    }
    actions {
        forward;
        do_cpu_encap;
    }
}

/*
 * Ingress control, which determines which tables work based on the 
 * data parsed in the packet
 */
control ingress {
    if (ethernet.etherType == ETHERTYPE_PACO){
        apply(forward_paco);
    }
    if (ethernet.etherType == ETHERTYPE_IPV4){
        apply(forward_ipv4);
    }
}

/*
 * Egress control
 */
control egress {
    apply(redirect);
}
