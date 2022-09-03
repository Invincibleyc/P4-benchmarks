control CPU(inout header_t hdr,
            in ingress_intrinsic_metadata_t ig_intr_md,
            inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {

    apply {
        ig_tm_md.ucast_egress_port = (bit<9>) hdr.cpu.egress_port;
        hdr.ethernet.ether_type = hdr.cpu.next_proto;
	       hdr.cpu.setInvalid();
    }
}
