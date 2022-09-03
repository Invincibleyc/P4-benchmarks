/* bier-te.p4 -*- c -*-
 *
 *  Copyright 2017 Wolfgang Braun, Joshua Hartmann
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Removes one BIER header.  Cannot update ethernet.etherType because if BBE
 * (two BIER headers) is active, etherType must be kept at ETHERTYPE_BIER_TE.
 *
 * See `do_fix_ethertype'.
 */
action bier_te_decap(f_bm) {
  pop(bier, 1);

  // For slicing and recirculation of the packet copy
  clone_ingress_pkt_to_egress(1, bier_te_fields);
  modify_field(bier_md.bs, f_bm);
  modify_field(bier_md.recirculate, 1);
}

/*
 * Forwards a packet according to
 * https://datatracker.ietf.org/doc/draft-eckert-bier-te-arch/
 */
action bier_te_forward(f_bm, port, boi) {
  // Packet is forwarded with Bits of Interest (BoI) cleared.
  modify_field(bier[0].BitString, bier[0].BitString & ~boi);
  set_egress(port);

  // Create clone that is sliced and recirculated.  Clone removes BoI from the
  // header.
  // Reuses `table bier_slice_and_recirculate' from BIER forwarding
  clone_ingress_pkt_to_egress(1, bier_te_fields);
  modify_field(bier_md.bs, f_bm);
}

/*
 * Adds a BIER header.  Sets etherType and BIER_PROTO_IPV4.  Triggers
 * recirculation.
 *
 * See `do_bier_te_bbe' for BIER-in-BIER encapsulatoin.
 */
action add_bier_te(bs) {
  push(bier, 1);
  modify_field(bier[0].BitString, bs);
  modify_field(bier[0].Proto, BIER_PROTO_IPV4);
  modify_field(bier_md.recirculate, 1);
  modify_field(ethernet.etherType, ETHERTYPE_BIER_TE);
}

/*
 * BIER-TE Bit Index Fowarding Table matches on local significant bits called
 * Bits of Interest (BoI).  We use wildcard matching (ternary) to match on
 * those bits.
 *
 * Each entry can be *either* contain a decap or forward action.  _drop may
 * be used as well but should be necessary only as default action.
 *
 * Table default must be set to _drop using
 * table_set_default bier_te_bift _drop
 *
 * Create entries using
 * 1.) table_add bier_te_bift bier_te_forward <pos>&&&<pos> => <pos> <port> <boi> <prio>
 *    <pos> MUST be the same bitstring in this call, e.g.
 *          table_add bier_te_bift bier_te_decap 0b0100&&&0b0100 => 0b0100 3 0b1110 1
 *    <boi> bits of interests as bitstring
 *    <prio> Priority of the matching (because it is a wildcard match).  We
 *           suggest to use 1 for all entries
 * 2.) table_add bier_bift bier_decap <pos>&&&<pos> => <pos> <prio>
 *    <pos> MUST be the same bitstring in this call
 */
table bier_te_bift {
  reads {
    bier[0].BitString : ternary;
  }

  actions {
    bier_te_decap;
    bier_te_forward;
    _drop;
  }
}

/*
 * Action is called after `bier_te_decap' has matched in bier_te_bift.
 * bier_te_decap does not decide if bier[1] is valid and, thus, keeps the
 * ethernet.etherType field.
 *
 * See `control ingress' for application of fix_ethertype
 */
action do_fix_ethertype() {
  modify_field(ethernet.etherType, ETHERTYPE_IPV4);
}

/*
 * Pseudo table that is only used to execute an action regardless of packet or
 * metadata state
 *
 * Table MUST BE configured by:
 * table_set_default fix_ethertype do_fix_ethertype
 */
table fix_ethertype {
  actions {
    do_fix_ethertype;
  }
  size: 1;
}

/*
 * Collects Add- and ResetBitmasks in BIER BTAFT.
 */
action bier_te_add_reset(add_bm, reset_bm, link_bm) {
  // The Addbitmask is added to metadata on each match of BTAFT
  modify_field(bier_te_md.add, bier_te_md.add | add_bm);

  // ResetBitmask is also added to metadata on each match of BTAFT but not
  // applied to packet because we rely on resubmit.  We *keep* the metadata
  // while the packet is resubmitted.
  modify_field(bier_md.bs, bier_md.bs | reset_bm);
  resubmit(bier_te_fields);

  // bier_te_md.bs is a copy of the bitstring made once for each BIER-TE
  // packet (regardless of resubmits).
  // See bier_te_bfd for details
  modify_field(bier_te_md.bs, bier_te_md.bs & ~link_bm);
}

/*
 * Table implementing BIER-TE Fast Reroute (FRR) based on
 * https://datatracker.ietf.org/doc/draft-eckert-bier-te-frr/
 *
 * Table entries can be added using:
 * table_add bier_te_btaft bier_te_add_reset <link-pos>&&&<link-pos> <link-nnh-pos>&&&<link-nnh-pos> => <add> <reset> <nnh-pos> <prio>
 *   <link-pos> bitstring containing the failed link/adjacencies
 *   <nnh-pos> bitstring containing the downstream next-next-hop adjacency
 *   <link-nnh-pos> bitstring containing the failed link and the downstream
 *                  next-next-hop adjacency
 *   <add> AddBitmask
 *   <reset> ResetBitmask
 *   <prio> Matching priority.  We suggest using the same value 1 for all
 *          entries.
 *
 * Note: For each failed adjacencies and each DS-NNH following entries are
 * needed (using an example):
 * | Link | NNH  | add                  | reset            |
 * |------+------+----------------------+------------------|
 * | s3s6 | s6   | s3s4, s4s7, s7s6, s6 | s3s6, sXs6       |
 * |------+------+----------------------+------------------|
 * | s3s6 | s6s7 | s3s4, s4s7, s7       | s3s6, sXs7       |
 * |------+------+----------------------+------------------|
 * | s3s6 | s6s8 | s3s5, s5s8, s8       | s3s6, s6s8, s5s8 |
 * |------+------+----------------------+------------------|
 * | s3s6 | s3s6 |                      | s3s6             |
 * |------+------+----------------------+------------------|
 * where
 *  - link has failed (s3s6 - link between switches 3 and 6)
 *  - DS-NNHs are s6, s7, and s8
 *  - AddBitmasks comprise of the links around the failed node towards the
 *    DS-NNH
 *  - ResetBitmask contains failed adjacency and all adjacencies of the form
 *    sXsY where X is a neighbor of the DS-NNH y
 * ATTENTION: The last entry is required to make BTAFT matching work properly!
 */
table bier_te_btaft {
  reads {
    bier_te_md.bfd : ternary;
    bier_te_md.bs : ternary;
  }
  actions {
    bier_te_add_reset;
  }
}

/*
 * Extract failed adjacencies once per BIER-TE packet and stores a copy of the
 * bitstring for BTAFT processing.
 */
action do_bier_te_bfd(bm) {
  modify_field(bier_te_md.bs, bier[0].BitString);
  modify_field(bier_te_md.bfd, bm);
}

/*
 * Pseudo table that is only used to execute an action regardless of packet or
 * metadata state
 *
 * Table MUST BE configured by:
 * table_set_default bier_te_bfd do_bier_te_bfd <failed_adjacencies>
 *   <failed_adjacencies> is a bitstring containing all failed_adjacencies for
 *                        the node.  Should default to 0b0 and set by a BFD
 *                        component if links/adjancies fail.
 */
table bier_te_bfd {
  actions {
    do_bier_te_bfd;
  }
}

/*
 * Creates a copy of the packet that will remove the failed adjancies
 * collected by bier_te_add_reset(..).  The copy will be recirculated and will
 * process all not-failed adjacencies normally.
 *
 * The "original" packet in the pipeline has the collected ResetBitmask
 * applied.  In the egress pipeline, BBE encapsulation is applied if the
 * collected AddBitmask is not empty.
 *
 * See `control ingress', `control egress', and `bier_te_bbe'
 */
action do_bier_te_frr() {
  clone_ingress_pkt_to_egress(1, bier_te_fields);
  modify_field(bier[0].BitString, bier[0].BitString & ~bier_md.bs);
}

/*
 * Pseudo table that is only used to execute an action regardless of packet or
 * metadata state
 *
 * Table MUST BE configured by:
 * table_set_default bier_te_frr do_bier_te_frr
 */
table bier_te_frr {
  actions {
    do_bier_te_frr;
  }
  size : 1;
}

/*
 * Pushes a new BIER header and adjust BIER_PROTO_BIER.  Forces recirculation
 * to make the additional header permanent.
 */
action do_bier_te_bbe() {
  add_bier_te(bier_te_md.add);
  modify_field(bier[0].Proto, BIER_PROTO_BIER);
  recirculate(empty_list);
}

/*
 * Pseudo table that is only used to execute an action regardless of packet or
 * metadata state
 *
 * Table MUST BE configured by:
 * table_set_default bier_te_bbe do_bier_te_bbe
 */
table bier_te_bbe {
  actions {
    do_bier_te_bbe;
  }
  size : 1;
}
