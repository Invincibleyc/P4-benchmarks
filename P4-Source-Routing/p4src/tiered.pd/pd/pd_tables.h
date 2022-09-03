/* Copyright 2013-present Barefoot Networks, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Antonin Bas (antonin@barefootnetworks.com)
 *
 */

#ifndef _P4_PD_TABLES_H_
#define _P4_PD_TABLES_H_

#include <bm/pdfixed/pd_common.h>

#include "pd_types.h"

#ifdef __cplusplus
extern "C" {
#endif


/* ADD ENTRIES */

p4_pd_status_t
p4_pd_prog_dmacTable_table_add_with_add_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_dmacTable_match_spec_t *match_spec,
 p4_pd_prog_add_island_header_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_dmacTable_table_add_with_l2_broadcast
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_dmacTable_match_spec_t *match_spec,
 p4_pd_prog_l2_broadcast_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_dmacTable_table_add_with_l2_forward
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_dmacTable_match_spec_t *match_spec,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_isThisIsland_table_add_with_noop
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_isThisIsland_match_spec_t *match_spec,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_isThisIsland_table_add_with_strip_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_isThisIsland_match_spec_t *match_spec,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_islandTable_table_add_with_forward_to_island
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_islandTable_match_spec_t *match_spec,
 p4_pd_prog_forward_to_island_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_smacTable_table_add_with_send_l2_digest
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_smacTable_match_spec_t *match_spec,
 p4_pd_entry_hdl_t *entry_hdl
);



/* DELETE ENTRIES */

p4_pd_status_t
p4_pd_prog_dmacTable_table_delete
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
);

p4_pd_status_t
p4_pd_prog_isThisIsland_table_delete
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
);

p4_pd_status_t
p4_pd_prog_islandTable_table_delete
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
);

p4_pd_status_t
p4_pd_prog_smacTable_table_delete
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
);


/* MODIFY ENTRIES */

p4_pd_status_t
p4_pd_prog_dmacTable_table_modify_with_add_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 p4_pd_prog_add_island_header_action_spec_t *action_spec
);

p4_pd_status_t
p4_pd_prog_dmacTable_table_modify_with_l2_broadcast
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 p4_pd_prog_l2_broadcast_action_spec_t *action_spec
);

p4_pd_status_t
p4_pd_prog_dmacTable_table_modify_with_l2_forward
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
);

p4_pd_status_t
p4_pd_prog_isThisIsland_table_modify_with_noop
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
);

p4_pd_status_t
p4_pd_prog_isThisIsland_table_modify_with_strip_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
);

p4_pd_status_t
p4_pd_prog_islandTable_table_modify_with_forward_to_island
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 p4_pd_prog_forward_to_island_action_spec_t *action_spec
);

p4_pd_status_t
p4_pd_prog_smacTable_table_modify_with_send_l2_digest
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
);



/* SET DEFAULT_ACTION */

p4_pd_status_t
p4_pd_prog_dmacTable_set_default_action_add_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_add_island_header_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_dmacTable_set_default_action_l2_broadcast
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_l2_broadcast_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_dmacTable_set_default_action_l2_forward
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_isThisIsland_set_default_action_noop
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_isThisIsland_set_default_action_strip_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_islandTable_set_default_action_forward_to_island
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_forward_to_island_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
);

p4_pd_status_t
p4_pd_prog_smacTable_set_default_action_send_l2_digest
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_entry_hdl_t *entry_hdl
);



/* CLEAR DEFAULT_ACTION */

p4_pd_status_t
p4_pd_prog_dmacTable_table_reset_default_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt
);

p4_pd_status_t
p4_pd_prog_isThisIsland_table_reset_default_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt
);

p4_pd_status_t
p4_pd_prog_islandTable_table_reset_default_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt
);

p4_pd_status_t
p4_pd_prog_smacTable_table_reset_default_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt
);





/* ENTRY RETRIEVAL */

p4_pd_status_t
p4_pd_prog_dmacTable_get_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 bool read_from_hw,
 p4_pd_prog_dmacTable_match_spec_t *match_spec,
 char **action_name,
 uint8_t *action_data,
 int *num_action_bytes
);

p4_pd_status_t
p4_pd_prog_isThisIsland_get_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 bool read_from_hw,
 p4_pd_prog_isThisIsland_match_spec_t *match_spec,
 char **action_name,
 uint8_t *action_data,
 int *num_action_bytes
);

p4_pd_status_t
p4_pd_prog_islandTable_get_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 bool read_from_hw,
 p4_pd_prog_islandTable_match_spec_t *match_spec,
 char **action_name,
 uint8_t *action_data,
 int *num_action_bytes
);

p4_pd_status_t
p4_pd_prog_smacTable_get_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 bool read_from_hw,
 p4_pd_prog_smacTable_match_spec_t *match_spec,
 char **action_name,
 uint8_t *action_data,
 int *num_action_bytes
);



p4_pd_status_t
p4_pd_prog_dmacTable_get_entry_count
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 uint32_t *count
);

p4_pd_status_t
p4_pd_prog_isThisIsland_get_entry_count
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 uint32_t *count
);

p4_pd_status_t
p4_pd_prog_islandTable_get_entry_count
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 uint32_t *count
);

p4_pd_status_t
p4_pd_prog_smacTable_get_entry_count
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 uint32_t *count
);



/* DIRECT COUNTERS */



/* Clean all state */
p4_pd_status_t
p4_pd_prog_clean_all(p4_pd_sess_hdl_t sess_hdl, p4_pd_dev_target_t dev_tgt);

#ifdef __cplusplus
}
#endif

#endif
