control L2(inout header_t hdr, inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {

    action l2_forward(PortId_t port) {
        ig_tm_md.ucast_egress_port = port;
    }

    action l2_broadcast() {
        ig_tm_md.mcast_grp_a = 1; // flood group
    }

    table l2_forwarding {
        key = {
            hdr.ethernet.dst_addr: exact;
        }
        actions = {
            l2_forward;
            l2_broadcast;
        }
        default_action = l2_broadcast();
       
    }

    apply {
        l2_forwarding.apply();
    }
}
