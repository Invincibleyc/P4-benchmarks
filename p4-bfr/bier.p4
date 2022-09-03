/* bier.p4 -*- c -*-
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
 * Adds a BIER header.
 *
 * ATTENTION: We do not support BIER-in-BIER encapsulation for normal BIER!
 */
action add_bier(bs) {
  // Adds a new BIER header with bitstring bs
  push(bier, 1);
  modify_field(bier[0].BitString, bs);

  // Set ETHERTYPE and BIER_PROTO for parsing process
  modify_field(bier[0].Proto, BIER_PROTO_IPV4);
  modify_field(ethernet.etherType, ETHERTYPE_BIER);

  // Trigger recirculation (see `control ingress')
  modify_field(bier_md.recirculate, 1);
}

/*
 * Removes the BIER header
 */
action bier_decap(f_bm) {
  // Remove BIER header and set IPv4 as content (always IPv4 in the
  // implemenation inside BIER encapsulated packets).
  pop(bier, 1);
  modify_field(ethernet.etherType, ETHERTYPE_IPV4);

  // Trigger recirculation to make decap permanent.  Packet will then match on
  // IPv4 (multicast).
  modify_field(bier_md.recirculate, 1);

  // Create clone that is recirculated and sliced out the bier_decap bit
  // (f_bm) that triggered this decapsulation
  // See `table bier_slice_and_recirculate'
  clone_ingress_pkt_to_egress(1, bier_fields);
  modify_field(bier_md.bs, f_bm);
}

/*
 * Forwards the BIER packet to one multicast child of this node according to
 * https://datatracker.ietf.org/doc/draft-ietf-bier-architecture/
 */
action bier_forward(f_bm, port) {
  // Keep only relevant bits for the child
  modify_field(bier[0].BitString, bier[0].BitString & f_bm);
  set_egress(port);

  // Create clone that is sliced and recirculated.  Clone removes matching
  // bits from the header
  // See `table bier_slice_and_recirculate'
  clone_ingress_pkt_to_egress(1, bier_fields);
  modify_field(bier_md.bs, f_bm);
}

/*
 * BIER Bit Index Forwarding Table (BIFT) implementation
 *
 * Table default must be set to _drop using
 * table_set_default bier_bift _drop
 *
 * Create entries using
 * 1.) table_add bier_bift bier_decap <pos>&&&<pos> => <pos> <prio>
 *    <pos> MUST be the same bitstring in this call, e.g.
            table_add bier_bift bier_decap 0b0100&&&0b0100 => 0b0100 1
 *    <prio> Priority of the matching (because it is a wildcard match).  We
 *           suggest to use 1 for all entries
 * 2.) table_add bier_bift bier_forward <pos>&&&<pos> => <pos> <port> <prio>
 *    <pos> MUST be the same bitstring in this call
 */
table bier_bift {
  // Wildcard match on the bitstring
  reads {
    bier[0].BitString : ternary;
  }

  // Each entry can be *either* contain a decap or forward action.  _drop may
  // be used as well but should be necessary only as default action.
  actions {
    bier_decap;
    bier_forward;
    _drop;
  }
}

/*
 * The action is only applied to (BIER) packet clones after decap or forward
 * was matched.
 *
 * The matching bits of the action (forward bitmask) are removed the bitstring
 * (sliced out).  Packet is recirculated and inserted in the ingress.  The
 * removed bits are permanently removed from the packet!
 *
 * The term "permanently removed" will be clear after `control ingress' is
 * explained/discussed.
 *
 * BIER(-TE) metadata are discarded
 */
action do_bier_slice_and_recirc() {
  modify_field(bier[0].BitString, bier[0].BitString & ~bier_md.bs);
  recirculate(empty_list);
}

/*
 * Pseudo table that is only used to execute an action regardless of packet or
 * metadata state
 *
 * Table MUST BE configured by:
 * table_set_default bier_slice_and_recirc do_bier_slice_and_recirc
 */
table bier_slice_and_recirc {
  actions {
    do_bier_slice_and_recirc;
  }
 size: 1;
}

/*
 * Simply recirculate the packet and discard BIER(-TE) metadata.
 */
action do_recirc() {
  recirculate(empty_list);
}

/*
 * Pseudo table that is only used to execute an action regardless of packet or
 * metadata state
 *
 * Table MUST BE configured by:
 * table_set_default recirc do_recirc
 */
table recirc {
  actions {
    do_recirc;
  }
  size: 1;
}
