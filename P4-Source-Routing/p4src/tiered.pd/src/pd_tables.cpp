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

#include <bm/pdfixed/pd_common.h>
#include <bm/pdfixed/int/pd_helpers.h>

#include <string>
#include <vector>
#include <iostream>

#include "pd/pd_types.h"
#include "pd_client.h"

#define PD_DEBUG 1

// default is disabled
// #define HOST_BYTE_ORDER_CALLER

extern int *my_devices;

namespace {

template <int L>
std::string string_from_field(char *field) {
  return std::string((char *) field, L);
}

template <>
std::string string_from_field<1>(char *field) {
  return std::string(field, 1);
}

template <>
std::string string_from_field<2>(char *field) {
  uint16_t tmp = *(uint16_t *) field;
#ifdef HOST_BYTE_ORDER_CALLER
  tmp = htons(tmp);
#endif
  return std::string((char *) &tmp, 2);
}

template <>
std::string string_from_field<3>(char *field) {
  uint32_t tmp = *(uint32_t *) field;
#ifdef HOST_BYTE_ORDER_CALLER
  tmp = htonl(tmp);
#endif
  return std::string(((char *) &tmp) + 1, 3);
}

template <>
std::string string_from_field<4>(char *field) {
  uint32_t tmp = *(uint32_t *) field;
#ifdef HOST_BYTE_ORDER_CALLER
  tmp = htonl(tmp);
#endif
  return std::string((char *) &tmp, 4);
}

template <int L>
void string_to_field(const std::string &s, char *field) {
  assert(s.size() <= L);
  size_t offset = L - s.size();
  std::memset(field, 0, offset);
  std::memcpy(field + offset, s.data(), s.size());
}

template <>
void string_to_field<1>(const std::string &s, char *field) {
  assert(s.size() <= 1);
  if (s.size() == 1) *field = s[0];
}

template <>
void string_to_field<2>(const std::string &s, char *field) {
  uint16_t *tmp = (uint16_t *) field;
  *tmp = 0;
  assert(s.size() <= 2);
  size_t offset = 2 - s.size();
  std::memcpy(field, s.data(), s.size());
#ifdef HOST_BYTE_ORDER_CALLER
  *tmp = ntohs(*tmp);
#endif
}

template <>
void string_to_field<3>(const std::string &s, char *field) {
  uint32_t *tmp = (uint32_t *) field;
  *tmp = 0;
  assert(s.size() <= 3);
  size_t offset = 3 - s.size();
  std::memcpy(field, s.data(), s.size());
#ifdef HOST_BYTE_ORDER_CALLER
  *tmp = ntohl(*tmp);
#endif
}

template <>
void string_to_field<4>(const std::string &s, char *field) {
  uint32_t *tmp = (uint32_t *) field;
  *tmp = 0;
  assert(s.size() <= 4);
  size_t offset = 4 - s.size();
  std::memcpy(field, s.data(), s.size());
#ifdef HOST_BYTE_ORDER_CALLER
  *tmp = ntohl(*tmp);
#endif
}

std::vector<BmMatchParam> build_key_dmacTable (
    p4_pd_prog_dmacTable_match_spec_t *match_spec
) {
  std::vector<BmMatchParam> key;
  key.reserve(1);

  BmMatchParam param;
  BmMatchParamExact param_exact; (void) param_exact;
  BmMatchParamLPM param_lpm; (void) param_lpm;
  BmMatchParamTernary param_ternary; (void) param_ternary;
  BmMatchParamValid param_valid; (void) param_valid;
  BmMatchParamRange param_range; (void) param_range;

  param_exact.key = string_from_field<6>((char *) &(match_spec->ethernet_dstAddr));
  param = BmMatchParam();
  param.type = BmMatchParamType::type::EXACT;
  param.__set_exact(param_exact); // does a copy of param_exact
  key.push_back(std::move(param));

  return key;
}

void unbuild_key_dmacTable (
    const std::vector<BmMatchParam> &key,
    p4_pd_prog_dmacTable_match_spec_t *match_spec
) {
  size_t i = 0;
  {
    const BmMatchParam &param = key.at(i++);
    assert(param.type == BmMatchParamType::type::EXACT);
    string_to_field<6>(param.exact.key, (char *) &(match_spec->ethernet_dstAddr));
  }

}

std::vector<BmMatchParam> build_key_isThisIsland (
    p4_pd_prog_isThisIsland_match_spec_t *match_spec
) {
  std::vector<BmMatchParam> key;
  key.reserve(1);

  BmMatchParam param;
  BmMatchParamExact param_exact; (void) param_exact;
  BmMatchParamLPM param_lpm; (void) param_lpm;
  BmMatchParamTernary param_ternary; (void) param_ternary;
  BmMatchParamValid param_valid; (void) param_valid;
  BmMatchParamRange param_range; (void) param_range;

  param_exact.key = string_from_field<2>((char *) &(match_spec->island_hop_dstIsland));
  param = BmMatchParam();
  param.type = BmMatchParamType::type::EXACT;
  param.__set_exact(param_exact); // does a copy of param_exact
  key.push_back(std::move(param));

  return key;
}

void unbuild_key_isThisIsland (
    const std::vector<BmMatchParam> &key,
    p4_pd_prog_isThisIsland_match_spec_t *match_spec
) {
  size_t i = 0;
  {
    const BmMatchParam &param = key.at(i++);
    assert(param.type == BmMatchParamType::type::EXACT);
    string_to_field<2>(param.exact.key, (char *) &(match_spec->island_hop_dstIsland));
  }

}

std::vector<BmMatchParam> build_key_islandTable (
    p4_pd_prog_islandTable_match_spec_t *match_spec
) {
  std::vector<BmMatchParam> key;
  key.reserve(1);

  BmMatchParam param;
  BmMatchParamExact param_exact; (void) param_exact;
  BmMatchParamLPM param_lpm; (void) param_lpm;
  BmMatchParamTernary param_ternary; (void) param_ternary;
  BmMatchParamValid param_valid; (void) param_valid;
  BmMatchParamRange param_range; (void) param_range;

  param_exact.key = string_from_field<2>((char *) &(match_spec->island_hop_dstIsland));
  param = BmMatchParam();
  param.type = BmMatchParamType::type::EXACT;
  param.__set_exact(param_exact); // does a copy of param_exact
  key.push_back(std::move(param));

  return key;
}

void unbuild_key_islandTable (
    const std::vector<BmMatchParam> &key,
    p4_pd_prog_islandTable_match_spec_t *match_spec
) {
  size_t i = 0;
  {
    const BmMatchParam &param = key.at(i++);
    assert(param.type == BmMatchParamType::type::EXACT);
    string_to_field<2>(param.exact.key, (char *) &(match_spec->island_hop_dstIsland));
  }

}

std::vector<BmMatchParam> build_key_smacTable (
    p4_pd_prog_smacTable_match_spec_t *match_spec
) {
  std::vector<BmMatchParam> key;
  key.reserve(1);

  BmMatchParam param;
  BmMatchParamExact param_exact; (void) param_exact;
  BmMatchParamLPM param_lpm; (void) param_lpm;
  BmMatchParamTernary param_ternary; (void) param_ternary;
  BmMatchParamValid param_valid; (void) param_valid;
  BmMatchParamRange param_range; (void) param_range;

  param_exact.key = string_from_field<6>((char *) &(match_spec->ethernet_srcAddr));
  param = BmMatchParam();
  param.type = BmMatchParamType::type::EXACT;
  param.__set_exact(param_exact); // does a copy of param_exact
  key.push_back(std::move(param));

  return key;
}

void unbuild_key_smacTable (
    const std::vector<BmMatchParam> &key,
    p4_pd_prog_smacTable_match_spec_t *match_spec
) {
  size_t i = 0;
  {
    const BmMatchParam &param = key.at(i++);
    assert(param.type == BmMatchParamType::type::EXACT);
    string_to_field<6>(param.exact.key, (char *) &(match_spec->ethernet_srcAddr));
  }

}


std::vector<std::string> build_action_data_add_island_header (
    p4_pd_prog_add_island_header_action_spec_t *action_spec
) {
  std::vector<std::string> action_data;
  action_data.push_back(string_from_field<2>((char *) &(action_spec->action_dstIsland)));
  action_data.push_back(string_from_field<2>((char *) &(action_spec->action_srcIsland)));
  return action_data;
}

void unbuild_action_data_add_island_header (
    const std::vector<std::string> &action_data,
    p4_pd_prog_add_island_header_action_spec_t *action_spec
) {
  size_t i = 0;
  string_to_field<2>(action_data.at(i++), (char *) &(action_spec->action_dstIsland));
  string_to_field<2>(action_data.at(i++), (char *) &(action_spec->action_srcIsland));
}
std::vector<std::string> build_action_data_forward_to_island (
    p4_pd_prog_forward_to_island_action_spec_t *action_spec
) {
  std::vector<std::string> action_data;
  action_data.push_back(string_from_field<2>((char *) &(action_spec->action_port)));
  return action_data;
}

void unbuild_action_data_forward_to_island (
    const std::vector<std::string> &action_data,
    p4_pd_prog_forward_to_island_action_spec_t *action_spec
) {
  size_t i = 0;
  string_to_field<2>(action_data.at(i++), (char *) &(action_spec->action_port));
}
std::vector<std::string> build_action_data_l2_broadcast (
    p4_pd_prog_l2_broadcast_action_spec_t *action_spec
) {
  std::vector<std::string> action_data;
  action_data.push_back(string_from_field<2>((char *) &(action_spec->action_group)));
  return action_data;
}

void unbuild_action_data_l2_broadcast (
    const std::vector<std::string> &action_data,
    p4_pd_prog_l2_broadcast_action_spec_t *action_spec
) {
  size_t i = 0;
  string_to_field<2>(action_data.at(i++), (char *) &(action_spec->action_group));
}

}


extern "C" {

/* ADD ENTRIES */

p4_pd_status_t
p4_pd_prog_dmacTable_table_add_with_add_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_dmacTable_match_spec_t *match_spec,
 p4_pd_prog_add_island_header_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<BmMatchParam> match_key = build_key_dmacTable(match_spec);
  std::vector<std::string> action_data = build_action_data_add_island_header(action_spec);
  BmAddEntryOptions options;
  try {
    *entry_hdl = pd_client(dev_tgt.device_id).c->bm_mt_add_entry(
        0, "dmacTable", match_key, "add_island_header", action_data, options);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_dmacTable_table_add_with_l2_broadcast
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_dmacTable_match_spec_t *match_spec,
 p4_pd_prog_l2_broadcast_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<BmMatchParam> match_key = build_key_dmacTable(match_spec);
  std::vector<std::string> action_data = build_action_data_l2_broadcast(action_spec);
  BmAddEntryOptions options;
  try {
    *entry_hdl = pd_client(dev_tgt.device_id).c->bm_mt_add_entry(
        0, "dmacTable", match_key, "l2_broadcast", action_data, options);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_dmacTable_table_add_with_l2_forward
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_dmacTable_match_spec_t *match_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<BmMatchParam> match_key = build_key_dmacTable(match_spec);
  std::vector<std::string> action_data;
  BmAddEntryOptions options;
  try {
    *entry_hdl = pd_client(dev_tgt.device_id).c->bm_mt_add_entry(
        0, "dmacTable", match_key, "l2_forward", action_data, options);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_isThisIsland_table_add_with_noop
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_isThisIsland_match_spec_t *match_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<BmMatchParam> match_key = build_key_isThisIsland(match_spec);
  std::vector<std::string> action_data;
  BmAddEntryOptions options;
  try {
    *entry_hdl = pd_client(dev_tgt.device_id).c->bm_mt_add_entry(
        0, "isThisIsland", match_key, "noop", action_data, options);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "isThisIsland" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_isThisIsland_table_add_with_strip_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_isThisIsland_match_spec_t *match_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<BmMatchParam> match_key = build_key_isThisIsland(match_spec);
  std::vector<std::string> action_data;
  BmAddEntryOptions options;
  try {
    *entry_hdl = pd_client(dev_tgt.device_id).c->bm_mt_add_entry(
        0, "isThisIsland", match_key, "strip_island_header", action_data, options);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "isThisIsland" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_islandTable_table_add_with_forward_to_island
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_islandTable_match_spec_t *match_spec,
 p4_pd_prog_forward_to_island_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<BmMatchParam> match_key = build_key_islandTable(match_spec);
  std::vector<std::string> action_data = build_action_data_forward_to_island(action_spec);
  BmAddEntryOptions options;
  try {
    *entry_hdl = pd_client(dev_tgt.device_id).c->bm_mt_add_entry(
        0, "islandTable", match_key, "forward_to_island", action_data, options);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "islandTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_smacTable_table_add_with_send_l2_digest
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_smacTable_match_spec_t *match_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<BmMatchParam> match_key = build_key_smacTable(match_spec);
  std::vector<std::string> action_data;
  BmAddEntryOptions options;
  try {
    *entry_hdl = pd_client(dev_tgt.device_id).c->bm_mt_add_entry(
        0, "smacTable", match_key, "send_l2_digest", action_data, options);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "smacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}



/* DELETE ENTRIES */

p4_pd_status_t
p4_pd_prog_dmacTable_table_delete
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
) {
  assert(my_devices[dev_id]);
  auto client = pd_client(dev_id);
  try {
    client.c->bm_mt_delete_entry(0, "dmacTable", entry_hdl);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_isThisIsland_table_delete
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
) {
  assert(my_devices[dev_id]);
  auto client = pd_client(dev_id);
  try {
    client.c->bm_mt_delete_entry(0, "isThisIsland", entry_hdl);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "isThisIsland" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_islandTable_table_delete
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
) {
  assert(my_devices[dev_id]);
  auto client = pd_client(dev_id);
  try {
    client.c->bm_mt_delete_entry(0, "islandTable", entry_hdl);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "islandTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_smacTable_table_delete
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
) {
  assert(my_devices[dev_id]);
  auto client = pd_client(dev_id);
  try {
    client.c->bm_mt_delete_entry(0, "smacTable", entry_hdl);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "smacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}


/* MODIFY ENTRIES */

p4_pd_status_t
p4_pd_prog_dmacTable_table_modify_with_add_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 p4_pd_prog_add_island_header_action_spec_t *action_spec
) {
  assert(my_devices[dev_id]);
  std::vector<std::string> action_data = build_action_data_add_island_header(action_spec);
  try {
    pd_client(dev_id).c->bm_mt_modify_entry(
        0, "dmacTable", entry_hdl, "add_island_header", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_dmacTable_table_modify_with_l2_broadcast
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 p4_pd_prog_l2_broadcast_action_spec_t *action_spec
) {
  assert(my_devices[dev_id]);
  std::vector<std::string> action_data = build_action_data_l2_broadcast(action_spec);
  try {
    pd_client(dev_id).c->bm_mt_modify_entry(
        0, "dmacTable", entry_hdl, "l2_broadcast", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_dmacTable_table_modify_with_l2_forward
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
) {
  assert(my_devices[dev_id]);
  std::vector<std::string> action_data;
  try {
    pd_client(dev_id).c->bm_mt_modify_entry(
        0, "dmacTable", entry_hdl, "l2_forward", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_isThisIsland_table_modify_with_noop
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
) {
  assert(my_devices[dev_id]);
  std::vector<std::string> action_data;
  try {
    pd_client(dev_id).c->bm_mt_modify_entry(
        0, "isThisIsland", entry_hdl, "noop", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "isThisIsland" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_isThisIsland_table_modify_with_strip_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
) {
  assert(my_devices[dev_id]);
  std::vector<std::string> action_data;
  try {
    pd_client(dev_id).c->bm_mt_modify_entry(
        0, "isThisIsland", entry_hdl, "strip_island_header", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "isThisIsland" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_islandTable_table_modify_with_forward_to_island
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl,
 p4_pd_prog_forward_to_island_action_spec_t *action_spec
) {
  assert(my_devices[dev_id]);
  std::vector<std::string> action_data = build_action_data_forward_to_island(action_spec);
  try {
    pd_client(dev_id).c->bm_mt_modify_entry(
        0, "islandTable", entry_hdl, "forward_to_island", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "islandTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_smacTable_table_modify_with_send_l2_digest
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 p4_pd_entry_hdl_t entry_hdl
) {
  assert(my_devices[dev_id]);
  std::vector<std::string> action_data;
  try {
    pd_client(dev_id).c->bm_mt_modify_entry(
        0, "smacTable", entry_hdl, "send_l2_digest", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "smacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}



/* SET DEFAULT_ACTION */

p4_pd_status_t
p4_pd_prog_dmacTable_set_default_action_add_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_add_island_header_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<std::string> action_data = build_action_data_add_island_header(action_spec);
  try {
    pd_client(dev_tgt.device_id).c->bm_mt_set_default_action(
        0, "dmacTable", "add_island_header", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_dmacTable_set_default_action_l2_broadcast
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_l2_broadcast_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<std::string> action_data = build_action_data_l2_broadcast(action_spec);
  try {
    pd_client(dev_tgt.device_id).c->bm_mt_set_default_action(
        0, "dmacTable", "l2_broadcast", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_dmacTable_set_default_action_l2_forward
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<std::string> action_data;
  try {
    pd_client(dev_tgt.device_id).c->bm_mt_set_default_action(
        0, "dmacTable", "l2_forward", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_isThisIsland_set_default_action_noop
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<std::string> action_data;
  try {
    pd_client(dev_tgt.device_id).c->bm_mt_set_default_action(
        0, "isThisIsland", "noop", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "isThisIsland" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_isThisIsland_set_default_action_strip_island_header
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<std::string> action_data;
  try {
    pd_client(dev_tgt.device_id).c->bm_mt_set_default_action(
        0, "isThisIsland", "strip_island_header", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "isThisIsland" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_islandTable_set_default_action_forward_to_island
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_prog_forward_to_island_action_spec_t *action_spec,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<std::string> action_data = build_action_data_forward_to_island(action_spec);
  try {
    pd_client(dev_tgt.device_id).c->bm_mt_set_default_action(
        0, "islandTable", "forward_to_island", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "islandTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_smacTable_set_default_action_send_l2_digest
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt,
 p4_pd_entry_hdl_t *entry_hdl
) {
  assert(my_devices[dev_tgt.device_id]);
  std::vector<std::string> action_data;
  try {
    pd_client(dev_tgt.device_id).c->bm_mt_set_default_action(
        0, "smacTable", "send_l2_digest", action_data);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "smacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}




/* CLEAR DEFAULT_ACTION */

p4_pd_status_t
p4_pd_prog_dmacTable_table_reset_default_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt
)
{
  (void)sess_hdl;
  (void)dev_tgt;
  return 0;
}
p4_pd_status_t
p4_pd_prog_isThisIsland_table_reset_default_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt
)
{
  (void)sess_hdl;
  (void)dev_tgt;
  return 0;
}
p4_pd_status_t
p4_pd_prog_islandTable_table_reset_default_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt
)
{
  (void)sess_hdl;
  (void)dev_tgt;
  return 0;
}
p4_pd_status_t
p4_pd_prog_smacTable_table_reset_default_entry
(
 p4_pd_sess_hdl_t sess_hdl,
 p4_pd_dev_target_t dev_tgt
)
{
  (void)sess_hdl;
  (void)dev_tgt;
  return 0;
}



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
) {
  assert(my_devices[dev_id]);
  BmMtEntry entry;
  try {
    pd_client(dev_id).c->bm_mt_get_entry(entry, 0, "dmacTable", entry_hdl);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  unbuild_key_dmacTable(entry.match_key, match_spec);

  const BmActionEntry &action_entry = entry.action_entry;
  assert(action_entry.action_type == BmActionEntryType::ACTION_DATA);
  *num_action_bytes = 0;
  // not efficient, but who cares
  if (action_entry.action_name == "add_island_header") {
    unbuild_action_data_add_island_header(
        action_entry.action_data,
        (p4_pd_prog_add_island_header_action_spec_t *) action_data);
    *num_action_bytes = sizeof(p4_pd_prog_add_island_header_action_spec_t);
    // not valid in C++, hence the cast, but I have no choice (can't change the
    // signature of the method)
    *action_name = (char *) "add_island_header";
  }
  if (action_entry.action_name == "l2_broadcast") {
    unbuild_action_data_l2_broadcast(
        action_entry.action_data,
        (p4_pd_prog_l2_broadcast_action_spec_t *) action_data);
    *num_action_bytes = sizeof(p4_pd_prog_l2_broadcast_action_spec_t);
    // not valid in C++, hence the cast, but I have no choice (can't change the
    // signature of the method)
    *action_name = (char *) "l2_broadcast";
  }


  return 0;
}

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
) {
  assert(my_devices[dev_id]);
  BmMtEntry entry;
  try {
    pd_client(dev_id).c->bm_mt_get_entry(entry, 0, "isThisIsland", entry_hdl);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "isThisIsland" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  unbuild_key_isThisIsland(entry.match_key, match_spec);

  const BmActionEntry &action_entry = entry.action_entry;
  assert(action_entry.action_type == BmActionEntryType::ACTION_DATA);
  *num_action_bytes = 0;
  // not efficient, but who cares


  return 0;
}

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
) {
  assert(my_devices[dev_id]);
  BmMtEntry entry;
  try {
    pd_client(dev_id).c->bm_mt_get_entry(entry, 0, "islandTable", entry_hdl);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "islandTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  unbuild_key_islandTable(entry.match_key, match_spec);

  const BmActionEntry &action_entry = entry.action_entry;
  assert(action_entry.action_type == BmActionEntryType::ACTION_DATA);
  *num_action_bytes = 0;
  // not efficient, but who cares
  if (action_entry.action_name == "forward_to_island") {
    unbuild_action_data_forward_to_island(
        action_entry.action_data,
        (p4_pd_prog_forward_to_island_action_spec_t *) action_data);
    *num_action_bytes = sizeof(p4_pd_prog_forward_to_island_action_spec_t);
    // not valid in C++, hence the cast, but I have no choice (can't change the
    // signature of the method)
    *action_name = (char *) "forward_to_island";
  }


  return 0;
}

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
) {
  assert(my_devices[dev_id]);
  BmMtEntry entry;
  try {
    pd_client(dev_id).c->bm_mt_get_entry(entry, 0, "smacTable", entry_hdl);
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "smacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  unbuild_key_smacTable(entry.match_key, match_spec);

  const BmActionEntry &action_entry = entry.action_entry;
  assert(action_entry.action_type == BmActionEntryType::ACTION_DATA);
  *num_action_bytes = 0;
  // not efficient, but who cares


  return 0;
}



p4_pd_status_t
p4_pd_prog_dmacTable_get_entry_count
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 uint32_t *count
) {
  assert(my_devices[dev_id]);
  auto client = pd_client(dev_id);
  *count = 0;
  try {
    *count = static_cast<uint32_t>(
        client.c->bm_mt_get_num_entries(0, "dmacTable"));
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "dmacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_isThisIsland_get_entry_count
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 uint32_t *count
) {
  assert(my_devices[dev_id]);
  auto client = pd_client(dev_id);
  *count = 0;
  try {
    *count = static_cast<uint32_t>(
        client.c->bm_mt_get_num_entries(0, "isThisIsland"));
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "isThisIsland" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_islandTable_get_entry_count
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 uint32_t *count
) {
  assert(my_devices[dev_id]);
  auto client = pd_client(dev_id);
  *count = 0;
  try {
    *count = static_cast<uint32_t>(
        client.c->bm_mt_get_num_entries(0, "islandTable"));
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "islandTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}

p4_pd_status_t
p4_pd_prog_smacTable_get_entry_count
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t dev_id,
 uint32_t *count
) {
  assert(my_devices[dev_id]);
  auto client = pd_client(dev_id);
  *count = 0;
  try {
    *count = static_cast<uint32_t>(
        client.c->bm_mt_get_num_entries(0, "smacTable"));
  } catch (InvalidTableOperation &ito) {
    const char *what =
      _TableOperationErrorCode_VALUES_TO_NAMES.find(ito.code)->second;
    std::cout << "Invalid table (" << "smacTable" << ") operation ("
	      << ito.code << "): " << what << std::endl;
    return ito.code;
  }
  return 0;
}


/* DIRECT COUNTERS */

/* legacy code, to be removed at some point */



/* Clean all state */
p4_pd_status_t
p4_pd_prog_clean_all(p4_pd_sess_hdl_t sess_hdl, p4_pd_dev_target_t dev_tgt) {
  assert(my_devices[dev_tgt.device_id]);
  pd_client(dev_tgt.device_id).c->bm_reset_state();
  return 0;
}

}
