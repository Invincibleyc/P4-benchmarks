control Decaps_P(inout header_t hdr,
            in ingress_intrinsic_metadata_t ig_intr_md,
            inout ingress_intrinsic_metadata_for_tm_t ig_tm_md,
            inout ingress_metadata_t ig_md) {

Register<protectionSeq_t, protectionId_t>(PROTECTION_STORAGE) protection_assumed_next_seq;

    // if incoming seq is in second half
    RegisterAction<protectionSeq_t, protectionId_t, bit<1>>(protection_assumed_next_seq) protection_assumed_next_seq_action = {
        void apply(inout protectionSeq_t value, out bit<1> read_value) {

             if((hdr.protection.seq >= value) && ((hdr.protection.seq - value) <= SEQ_WINDOW)) {
                read_value = 1;
                value = hdr.protection.seq + 1;
            }
            else {
                read_value = 0;
                value = value;
            }
        }
    };

    // if incoming seq is in first half
    RegisterAction<protectionSeq_t, protectionId_t, bit<1>>(protection_assumed_next_seq) protection_assumed_next_seq_action2 = {
        void apply(inout protectionSeq_t value, out bit<1> read_value) {
             if((hdr.protection.seq >= value) || ((value - hdr.protection.seq) >= SEQ_WINDOW)) {
                read_value = 1;
                value = hdr.protection.seq + 1;
            }
            else {
                read_value = 0;
                value = value;
            }
        }
    };


    RegisterAction<protectionSeq_t, protectionId_t, bit<1>>(protection_assumed_next_seq) protection_assumed_next_seq_reset = {
        void apply(inout protectionSeq_t value, out bit<1> read_value) {
            read_value = 0;
            value = 0;
        }
    };

    apply {
        if(hdr.protection_reset.isValid() && hdr.protection_reset.device_type == 1) {
            protection_assumed_next_seq_reset.execute((protectionId_t) hdr.protection_reset.conn_id);
            
        }
        else {
        @atomic {
            bit<1> accepted;
            if(hdr.protection.seq >= SEQ_WINDOW) {
                accepted = protection_assumed_next_seq_action.execute((protectionId_t) hdr.protection.conn_id);
            }
            else {
                accepted = protection_assumed_next_seq_action2.execute((protectionId_t) hdr.protection.conn_id);
            }
	
            if(accepted == 1) {
                hdr.protection.setInvalid();

                hdr.ipv4.setValid();
                hdr.ipv4 = hdr.ipv4_inner;
                hdr.ipv4_inner.setInvalid();

                hdr.ethernet.ether_type = ETHERTYPE_IPV4;
            }
        }
      }
    }
}
