action do_add_test_hdr(){
    add_header(test);
    modify_field(ipv4.protocol, IP_PROTOCOLS_TEST);
    modify_field(test.protocol, meta.ipv4_protocol); //UDP,TCP,ICMP
}
table add_test_hdr {
    reads {
        ig_intr_md.ingress_port: exact;
        tcp.dstPort: exact;
    }
    actions {
        do_add_test_hdr; nop;
    }
    size: 256;
}

action do_add_test_hdr_opp(){
    add_header(test);
    modify_field(ipv4.protocol, IP_PROTOCOLS_TEST);
    modify_field(test.protocol, meta.ipv4_protocol); //UDP,TCP,ICMP
}
table add_test_hdr_opp {
    reads {
        ig_intr_md.ingress_port: exact;
        tcp.srcPort: exact;
    }
    actions {
        do_add_test_hdr_opp; nop;
    }
    size: 256;
}


action do_forward(newSrcMAC, newDstMAC, egress_spec) {
    // 1. Set the egress port of the next hop
    modify_field(ig_intr_md_for_tm.ucast_egress_port, egress_spec);
    // 2. Update the ethernet destination address with the address of the next hop.
    modify_field(ethernet.dstAddr, newDstMAC);
    // 3. Update the ethernet source address with the address of the switch.
    modify_field(ethernet.srcAddr, newSrcMAC);
    // 4. Decrement the TTL
    add_to_field(ipv4.ttl, -1);
}

//@pragma stage 0
table forward{
    reads {
        ig_intr_md.ingress_port: exact;
        ipv4.dstAddr : exact; 
    }
    actions {
        do_forward;
        _drop;
    }
    size: 256;
}