/*
* Copyright 2020-present Ralf Kundel, Christoph Gärtner
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/


header ethernet_t {
    bit<48> dst_addr;
    bit<48> src_addr;
    bit<16> ethertype;
}

typedef bit<8> nextId_t;
#define header_stack_size 32


header event_t {
    bit<32> value;
}

header valid_attribute_bitmask_t {
   bit<header_stack_size> bitmask; 
}

struct headers {
    ethernet_t    ethernet; 
    valid_attribute_bitmask_t valid_attribute_bitmask;
    event_t [header_stack_size] event;
}

struct metadata {
    bit<header_stack_size> to_be_parsed;
}




