control ProtectForward(inout header_t hdr, inout ingress_metadata_t ig_md, inout ingress_intrinsic_metadata_for_tm_t ig_tm_md, in ingress_intrinsic_metadata_t ig_intr_md, inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
    Register<protectionSeq_t, protectionId_t>(PROTECTION_STORAGE) protection_next_seq;
    RegisterAction<protectionSeq_t, protectionId_t, protectionSeq_t>(protection_next_seq) protection_next_seq_action = {
        void apply(inout protectionSeq_t value, out protectionSeq_t read_value) {
            read_value = value;
            value = value + 1;
        }
    };

    RegisterAction<protectionSeq_t, protectionId_t, protectionSeq_t>(protection_next_seq) protection_next_seq_reset = {
        void apply(inout protectionSeq_t value, out protectionSeq_t read_value) {
            read_value = value;
            value = 0;
        }
    };

    action forward(PortId_t port) {
        ig_tm_md.ucast_egress_port = port;

        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }

    action decap() {
         hdr.ipv4.setInvalid(); // remove ipv4 header
         hdr.ethernet.ether_type = ETHERTYPE_PROTECTION;
         //ig_tm_md.ucast_egress_port = RECIRCULATE_PORT;
    }


    table ipv4 {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            forward;
            decap;
        }
    }

    action none() {}

    action set_mc_grp(mcastGrp_t grp) {
        ig_tm_md.mcast_grp_a = grp;
    }

    action protect(protectionId_t i, protectionId_t id, mcastGrp_t grp, ipv4_addr_t srcAddr, ipv4_addr_t dstAddr){
        hdr.protection.setValid();
        hdr.protection.conn_id = id;
        hdr.protection.proto = TYPE_IP_IP;
        ig_md.conn_id = i;
        hdr.ipv4_inner.setValid();
        hdr.ipv4_inner = hdr.ipv4;
        hdr.ipv4.srcAddr = srcAddr;
        hdr.ipv4.dstAddr = dstAddr;
        hdr.ipv4.protocol = TYPE_IP_PROTECTION;

        set_mc_grp(grp);
    }

    table ProtectedFlows {
        key = {
            hdr.ipv4.srcAddr: ternary;
            hdr.ipv4.dstAddr: ternary;
            hdr.transport.src_port: ternary;
            hdr.transport.dst_port: ternary;
            hdr.ipv4.protocol: ternary;
        }
        actions = {
            protect;
        }
    }


    apply {
        if(hdr.ipv4.protocol == 0x9A) { // it's a protection request
            ig_tm_md.ucast_egress_port = CPU_PORT; // send to controller
        }
        else if(!ProtectedFlows.apply().hit) {
          ipv4.apply();
       }
       else { // reset connection
           if(hdr.protection_reset.isValid() && hdr.protection_reset.device_type == 0) {
               protection_next_seq_reset.execute((protectionId_t) hdr.protection_reset.conn_id);
           }
           else { // protect connection
               hdr.protection.seq = protection_next_seq_action.execute((protectionId_t) ig_md.conn_id);
           }
       }
  
    }
}
