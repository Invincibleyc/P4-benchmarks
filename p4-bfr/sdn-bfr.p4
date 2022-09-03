/* sdn-bfr.p4 -*- c -*-
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
 * Notes:
 * - Explanations are given at the defintions and in the control routines.
 * - Each switch must be configured appropriate when started:
 *   - Table defaults
 *   - Packet cloning specifics (see ipv4.p4)
 * - Examples to add table entries are provided at the table definitions
 */

// Contains the header definitions
#include "headers.p4"

// Defines the (de-)parsing process
#include "parser.p4"

// Defines tables and primitives for IPv4 traffic including IP multicast
// Simplified IP forwarding (not updating the Ethernet MACs)
#include "ipv4.p4"

// Defines tables and primitives for BIER traffic
#include "bier.p4"

// Defines tables and primitives for BIER-TE traffic
#include "bier-te.p4"

/*
 * Entry point for received, resubmitted and recirculated packets
 *
 * Note: applying clone_ingress_pkt_to_egress() will not be performed when
 *       resubmit() is also called.  The clone is just discarded.
 *       Resubmit() discards any changes to packet fields (except metadata).
 *
 *       Therefore, we use recirculate(..) in the egress pipeline to
 *       "permanently" store changes made to the header.  bier_md.recirculate
 *       flag triggers recirculation.
 */
control ingress {
  if (ethernet.etherType == ETHERTYPE_IPV4) {
    // IPv4 forwarding, including IP multicast
    // First check for multicast addresses and IPv4-LPM afterwards
    apply(ip_mc) {
      miss {
        apply(ipv4_lpm);
      }
    }
  }
  else if (ethernet.etherType == ETHERTYPE_BIER) {
    // Apply local decap and forward until bier.BitString is empty. Creates a
    // packet clone that is always "sliced and recirculated" to remove
    // matching bitpositions "permanently".
    apply(bier_bift);
  }
  else if (ethernet.etherType == ETHERTYPE_BIER_TE) {
    // FRR: Extract failed adjacencies from table bier_te_bfd into metadata.
    // Because BTAFT uses resubmit(..) we only extract bfd into the metadata
    // once
    if (bier_te_md.bfd == 0 and bier_te_md.bs == 0) {
      apply(bier_te_bfd);
    }

    // BTAFT should not applied to currently rerouting (BBE) packets because
    // we only support two BIER headers
    if (not valid(bier[1]) and bier_te_md.bfd != 0) {
      // BTAFT resubmits packet until all failed adjacencies are cleared from
      // bier_te_md.bs.  In each step, we accumulate AddBitmask and
      // ResetBitmask
      apply(bier_te_btaft) {
        miss {
          // Apply FRR, if BTAFT had resulted in a ResetBitmask (bier_md.bs)
          // and/or AddBitmask (bier_te_md.add)
          if (bier_te_md.add != 0 or bier_md.bs != 0) {
            apply(bier_te_frr);
          }
        }
      }
    }

    // Only apply BIER-TE BIFT if BTAFT has not resulted in Add/ResetBitmasks,
    // otherwise packet is handled by apply(bier_te_frr).
    if (bier_te_md.add == 0 and bier_md.bs == 0) {
      apply(bier_te_bift) {
        bier_te_decap {
          // Because BIER-TE supports up to two BIER headers, we have to fix
          // the Ethertype manually
          if (not valid(bier[0])) {
            apply(fix_ethertype);
          }
        }
      }
    }
  }
}

control egress {
  // Packet is a bier clone and needs slicing and recirculating
  // (a clone has always to be handled that way)
  if ((ethernet.etherType == ETHERTYPE_BIER or
       ethernet.etherType == ETHERTYPE_BIER_TE)
      and standard_metadata.instance_type == 1) {
      apply(bier_slice_and_recirc);
  }
  else if (bier_te_md.add != 0) {
    // Packet requires the additional backup path header (BIER-in-BIER
    // encapsulation) because BTAFT had resulted in an AddBitmask
    apply(bier_te_bbe);
  }
  else if (bier_md.recirculate == 1) {
    // 1.) Packet may be local_decap-ed and needs recirculation
    // 2.) Packet was encapsulated from IPv4 (BIER or BIER-TE) and must be
    //     recirculated (to store BIER header permanently: otherwise BIER-TE
    //     FRR might use resubmit and discards the BIER header)
    apply(recirc);
  }

  // Otherwise the packet is sent through the set port.  If no port was set
  // using `set_egress()' the packet is discarded (in fact, it is sent through
  // port 0).
}
