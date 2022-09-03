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

#include <iostream>
#include <mutex>
#include <map>
#include <cstring>

#include "pd/pd_learning.h"
#include "pd_client.h"

#define NUM_DEVICES 256

extern int *my_devices;

namespace {


struct LearnState {
};

LearnState *device_state[NUM_DEVICES];

template <int L>
void bytes_to_field(const char *bytes, char *field) {
  std::memcpy(field, bytes, L);
}

template <>
void bytes_to_field<1>(const char *bytes, char *field) {
  field[0] = bytes[0];
}

template <>
void bytes_to_field<2>(const char *bytes, char *field) {
#ifdef HOST_BYTE_ORDER_CALLER
  field[0] = bytes[1];
  field[1] = bytes[0];
#else
  field[0] = bytes[0];
  field[1] = bytes[1];
#endif
}

template <>
void bytes_to_field<3>(const char *bytes, char *field) {
#ifdef HOST_BYTE_ORDER_CALLER
  field[0] = bytes[2];
  field[1] = bytes[1];
  field[2] = bytes[0];
  field[3] = '\0';
#else
  field[0] = '\0';
  std::memcpy(field + 1, bytes, 3);
#endif
}

template <>
void bytes_to_field<4>(const char *bytes, char *field) {
#ifdef HOST_BYTE_ORDER_CALLER
  field[0] = bytes[3];
  field[1] = bytes[2];
  field[2] = bytes[1];
  field[3] = bytes[0];
#else
  std::memcpy(field, bytes, 4);
#endif
}

typedef struct {
  char sub_topic[4];
  uint64_t switch_id;
  uint32_t cxt_id;
  int list_id;
  unsigned long long buffer_id;
  unsigned int num_samples;
} __attribute__((packed)) learn_hdr_t;

static_assert(sizeof(learn_hdr_t) == 32u, "Invalid size for learn header");



}  // namespace

extern "C" {

p4_pd_status_t p4_pd_prog_set_learning_timeout
(
 p4_pd_sess_hdl_t sess_hdl,
 uint8_t device_id,
 uint64_t usecs
) {
  (void) sess_hdl;
  assert(my_devices[device_id]);
  try {
    // in bmv2, there can be a different timeout for each learn list, so this
    // RPC function is called for each learn list
    // bmv2 also takes a timeout in ms, thus the "/ 1000"
  } catch (InvalidLearnOperation &ilo) {
    const char *what =
      _LearnOperationErrorCode_VALUES_TO_NAMES.find(ilo.code)->second;
    std::cout << "Invalid learn operation (" << ilo.code << "): "
              << what << std::endl;
    return ilo.code;
  }
  return 0;
}


p4_pd_status_t p4_pd_prog_learning_new_device(int dev_id) {
  device_state[dev_id] = new LearnState();
  return 0;
}

p4_pd_status_t p4_pd_prog_learning_remove_device(int dev_id) {
  assert(device_state[dev_id]);
  delete device_state[dev_id];
  return 0;
}

void p4_pd_prog_learning_notification_cb(const char *hdr, const char *data) {
  const learn_hdr_t *learn_hdr = reinterpret_cast<const learn_hdr_t *>(hdr);
  // std::cout << "I received " << learn_hdr->num_samples << " samples"
  //           << std::endl;
  switch(learn_hdr->list_id) {
  default:
    assert(0 && "invalid lq id");
    break;
  }  
}

}
