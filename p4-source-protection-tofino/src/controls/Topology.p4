control Topology(inout header_t hdr,
                 in ingress_intrinsic_metadata_t ig_intr_md,
                 inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {

    apply {
        ig_tm_md.ucast_egress_port = CPU_PORT;
        hdr.topology.port = (bit<16>) ig_intr_md.ingress_port;
    }
}
