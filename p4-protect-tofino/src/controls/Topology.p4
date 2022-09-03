control Topology(inout header_t hdr,
            in ingress_intrinsic_metadata_t ig_intr_md,
            inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {

    apply {
        if(ig_intr_md.ingress_port == 68 || ig_intr_md.ingress_port == 196) {
            ig_tm_md.mcast_grp_a = 1; // flood group
        }
        else {
            ig_tm_md.ucast_egress_port = CPU_PORT;
            hdr.topology.port = (bit<16>) ig_intr_md.ingress_port;
        }
    }
}
