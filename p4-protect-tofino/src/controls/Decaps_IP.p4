control Decaps_IP(inout header_t hdr, inout ingress_metadata_t ig_md, inout ingress_intrinsic_metadata_for_tm_t ig_tm_md, in ingress_intrinsic_metadata_t ig_intr_md, inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
    action decap() {
         hdr.ipv4.setInvalid(); // remove ipv4 header
         hdr.ethernet.ether_type = ETHERTYPE_PROTECTION;
    }

    table ipv4_tunnel {
        key = {
            hdr.ipv4.dstAddr: exact;
        }
        actions = {
            decap;
        }
    }


    apply {
        ipv4_tunnel.apply();
    }
}
