control ARP(inout header_t hdr, 
            in ingress_intrinsic_metadata_t ig_intr_md,
            inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {

    apply {
        hdr.cpu.setValid(); // activate cpu header
        ig_tm_md.ucast_egress_port = CPU_PORT;
        hdr.cpu.ingress_port = (bit<16>) ig_intr_md.ingress_port;
        hdr.cpu.next_proto = hdr.ethernet.ether_type;
        hdr.ethernet.ether_type = ETHERTYPE_CPU;
    }
}
