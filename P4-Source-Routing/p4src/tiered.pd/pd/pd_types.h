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

#ifndef _P4_PD_TYPES_H_
#define _P4_PD_TYPES_H_

#include <stdint.h>

/* MATCH STRUCTS */

typedef struct p4_pd_prog_dmacTable_match_spec {
  uint8_t ethernet_dstAddr[6];
} p4_pd_prog_dmacTable_match_spec_t;

typedef struct p4_pd_prog_isThisIsland_match_spec {
  uint16_t island_hop_dstIsland;
} p4_pd_prog_isThisIsland_match_spec_t;

typedef struct p4_pd_prog_islandTable_match_spec {
  uint16_t island_hop_dstIsland;
} p4_pd_prog_islandTable_match_spec_t;

typedef struct p4_pd_prog_smacTable_match_spec {
  uint8_t ethernet_srcAddr[6];
} p4_pd_prog_smacTable_match_spec_t;



/* ACTION STRUCTS */

typedef struct p4_pd_prog_add_island_header_action_spec {
  uint16_t action_dstIsland;
  uint16_t action_srcIsland;
} p4_pd_prog_add_island_header_action_spec_t;

typedef struct p4_pd_prog_forward_to_island_action_spec {
  uint16_t action_port;
} p4_pd_prog_forward_to_island_action_spec_t;

typedef struct p4_pd_prog_l2_broadcast_action_spec {
  uint16_t action_group;
} p4_pd_prog_l2_broadcast_action_spec_t;

/* l2_forward has no parameters */

/* noop has no parameters */

/* send_l2_digest has no parameters */

/* strip_island_header has no parameters */


#endif
