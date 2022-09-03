/* ipv4.p4 -*- c -*-
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

// convenience action to set egress port
action set_egress(port) {
  modify_field(standard_metadata.egress_spec, port);
}

// convenience action to drop the packet (add action to runtime switch)
// source: P4 tutorial
action _drop() {
  drop();
}

/*
 * Simplified IPv4 forwarding from P4 tutorial, omitted Ethernet MAC
 * rewriting.
 *
 * Performs longes prefix matching.  Entries can be added using
 * table_add ipv4_lpm set_egress <xxx.xxx.xxx.xxx/xx> => <port>
 */
table ipv4_lpm {
  // table matches only on ipv4.dstAddr and applies longest prefix match
  reads {
    ipv4.dstAddr : lpm;
  }

  // possible actions: only set_egress
  actions {
    set_egress;
  }

  // size of table
  size: 1024;
}

/****************
 * IP Multicast
 ****************
 *
 * Specific to multicast implementation of P4 reference switch (bmv2).
 *
 * Each switch has to be configured (when running) using command:
 *   mirroring_add 1 0
 *
 * This is necessary for clone_ingress_pkt_to_egress(1, <field-list>).
 * Cloned packets are mapped to egress_spec 0 using this command.
 * See P4 tutorial for explanations:
 * https://github.com/p4lang/tutorials/tree/master/examples/copy_to_cpu
 *
 * Each multicast group in the switch can be setup by the following commands:
 * 1.) mc_mgrp_create <grp_num>
 * 2.) mc_node_create <node_num> [<port>]
 *   Returns a node handle that is used in the next command
 * 3.) mc_node_associate <grp_num> <node_handle>
 *   ATTENTION: node handle is generally not equal to node_handle!  Node
 *              handle must be extracted from CLI output.
 */

// Function that sets the multicast group for packet duplication
action set_mc_group(group_id) {
  modify_field(intrinsic_metadata.mcast_grp, group_id);
}

/*
 * IP multicast table
 *
 * Entries can be installed using:
 *
 * table_add ip_mc set_mc_group <XXX.XXX.XXX.XXX> => <port>
 * table_add ip_mc add_bier <XXX.XXX.XXX.XXX> => <BIER bitstring>
 * table_add ip_mc add_bier_te <XXX.XXX.XXX.XXX> => <BIER-TE bitstring>
 */
table ip_mc {
  // matches exact multicast addresses to multicast actions
  reads {
    ipv4.dstAddr : exact;
  }

  // Each entry can be *either* contain an IP multicast, BIER or BIER-TE
  // action
  actions {
    set_mc_group;
    add_bier;
    add_bier_te;
  }
}
