/* Protect.p4 -*- c -*-
 *
 * This control unit applies packet selection
 *
 */
control Protect(inout headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    register<protectionSeq_t>(PROTECTION_STORAGE) protection_assumed_next_seq;

    apply {
        if(hdr.protection_reset.isValid() && hdr.protection_reset.device_type == 1) {
            @atomic {
                // reset connection
                protection_assumed_next_seq.write((bit<32>) hdr.protection_reset.conn_id, 0);
            }
        }
        else {
            @atomic {
                protectionSeq_t seq_in = hdr.protection.seq;
                protectionSeq_t seq_assumed;
                protection_assumed_next_seq.read(seq_assumed, (bit<32>)hdr.protection.conn_id);
                bit<1> accepted = 0;

                // test if seq_in in (seq_assumed, (seq_assumed + seq_max/2) mod seq_max
                if((seq_in >= seq_assumed) && ((seq_in - seq_assumed) <= (SEQ_MAX / 2))) {
                    // accept
                    accepted = 1;
                }
                // test if seq_in in (seq_assumed, (seq_assumed + seq_max/2) mod seq_max
                else if((seq_in < seq_assumed) && ((seq_assumed - seq_in) >= (SEQ_MAX /2))) {
                    // accept
                    accepted = 1;
                }


                if(accepted == 1) {
                    protection_assumed_next_seq.write((bit<32>)hdr.protection.conn_id, seq_in + 1);

                    hdr.protection.setInvalid();

                    hdr.ipv4.setValid();
                    hdr.ipv4 = hdr.ipv4_inner;
                    hdr.ipv4_inner.setInvalid();

                    hdr.ethernet.etherType = TYPE_IPV4;

                    recirculate<metadata>(meta);
                }
            }

            // silently drop
        }

    }

}
