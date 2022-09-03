# Copyright 2013-present Barefoot Networks, Inc. 
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# P4 Thrift RPC Input


include "res.thrift"

namespace py p4_pd_rpc
namespace cpp p4_pd_rpc
namespace c_glib p4_pd_rpc

typedef i32 EntryHandle_t
typedef i32 MemberHandle_t
typedef i32 GroupHandle_t
typedef binary MacAddr_t
typedef binary IPv6_t

struct prog_counter_value_t {
  1: required i64 packets;
  2: required i64 bytes;
}

struct prog_counter_flags_t {
  1: required bool read_hw_sync;
}

struct prog_packets_meter_spec_t {
  1: required i32 cir_pps;
  2: required i32 cburst_pkts;
  3: required i32 pir_pps;
  4: required i32 pburst_pkts;
  5: required bool color_aware;  // ignored for now
}

struct prog_bytes_meter_spec_t {
  1: required i32 cir_kbps;
  2: required i32 cburst_kbits;
  3: required i32 pir_kbps;
  4: required i32 pburst_kbits;
  5: required bool color_aware;  // ignored for now
}

# Match structs

struct prog_dmacTable_match_spec_t {
  1: required MacAddr_t ethernet_dstAddr;
}

struct prog_isThisIsland_match_spec_t {
  1: required i16 island_hop_dstIsland;
}

struct prog_islandTable_match_spec_t {
  1: required i16 island_hop_dstIsland;
}

struct prog_smacTable_match_spec_t {
  1: required MacAddr_t ethernet_srcAddr;
}



# Action structs

struct prog_add_island_header_action_spec_t {
  1: required i16 action_dstIsland;
  2: required i16 action_srcIsland;
}

struct prog_forward_to_island_action_spec_t {
  1: required i16 action_port;
}

struct prog_l2_broadcast_action_spec_t {
  1: required i16 action_group;
}

/* l2_forward has no parameters */

/* noop has no parameters */

/* send_l2_digest has no parameters */

/* strip_island_header has no parameters */





service prog {

    # Table entry add functions
    EntryHandle_t dmacTable_table_add_with_add_island_header(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_dmacTable_match_spec_t match_spec, 4:prog_add_island_header_action_spec_t action_spec);
    EntryHandle_t dmacTable_table_add_with_l2_broadcast(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_dmacTable_match_spec_t match_spec, 4:prog_l2_broadcast_action_spec_t action_spec);
    EntryHandle_t dmacTable_table_add_with_l2_forward(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_dmacTable_match_spec_t match_spec);
    EntryHandle_t isThisIsland_table_add_with_noop(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_isThisIsland_match_spec_t match_spec);
    EntryHandle_t isThisIsland_table_add_with_strip_island_header(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_isThisIsland_match_spec_t match_spec);
    EntryHandle_t islandTable_table_add_with_forward_to_island(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_islandTable_match_spec_t match_spec, 4:prog_forward_to_island_action_spec_t action_spec);
    EntryHandle_t smacTable_table_add_with_send_l2_digest(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_smacTable_match_spec_t match_spec);

    # Table entry modify functions
    i32 dmacTable_table_modify_with_add_island_header(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry, 4:prog_add_island_header_action_spec_t action_spec);
    i32 dmacTable_table_modify_with_l2_broadcast(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry, 4:prog_l2_broadcast_action_spec_t action_spec);
    i32 dmacTable_table_modify_with_l2_forward(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry);
    i32 isThisIsland_table_modify_with_noop(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry);
    i32 isThisIsland_table_modify_with_strip_island_header(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry);
    i32 islandTable_table_modify_with_forward_to_island(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry, 4:prog_forward_to_island_action_spec_t action_spec);
    i32 smacTable_table_modify_with_send_l2_digest(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry);

    # Table entry delete functions
    i32 dmacTable_table_delete(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry);
    i32 isThisIsland_table_delete(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry);
    i32 islandTable_table_delete(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry);
    i32 smacTable_table_delete(1:res.SessionHandle_t sess_hdl, 2:byte dev_id, 3:EntryHandle_t entry);

    # Table set default action functions
    EntryHandle_t dmacTable_set_default_action_add_island_header(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_add_island_header_action_spec_t action_spec);
    EntryHandle_t dmacTable_set_default_action_l2_broadcast(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_l2_broadcast_action_spec_t action_spec);
    EntryHandle_t dmacTable_set_default_action_l2_forward(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);
    EntryHandle_t isThisIsland_set_default_action_noop(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);
    EntryHandle_t isThisIsland_set_default_action_strip_island_header(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);
    EntryHandle_t islandTable_set_default_action_forward_to_island(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt, 3:prog_forward_to_island_action_spec_t action_spec);
    EntryHandle_t smacTable_set_default_action_send_l2_digest(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);

    # Table clear default action functions
    void dmacTable_table_reset_default_entry(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);
    void isThisIsland_table_reset_default_entry(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);
    void islandTable_table_reset_default_entry(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);
    void smacTable_table_reset_default_entry(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);

    # INDIRECT ACTION DATA AND MATCH SELECT




    i32 dmacTable_get_entry_count(1:res.SessionHandle_t sess_hdl, 2:byte dev_id);
    i32 isThisIsland_get_entry_count(1:res.SessionHandle_t sess_hdl, 2:byte dev_id);
    i32 islandTable_get_entry_count(1:res.SessionHandle_t sess_hdl, 2:byte dev_id);
    i32 smacTable_get_entry_count(1:res.SessionHandle_t sess_hdl, 2:byte dev_id);


    # clean all state
    i32 clean_all(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);

    # clean table state
    i32 tables_clean_all(1:res.SessionHandle_t sess_hdl, 2:res.DevTarget_t dev_tgt);

    # counters



    # meters


    # registers


    void set_learning_timeout(1: res.SessionHandle_t sess_hdl, 2: byte dev_id, 3: i32 msecs);

}
