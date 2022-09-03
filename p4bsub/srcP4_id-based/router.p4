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

#include <core.p4>
#include <v1model.p4>


#include "header.p4"

parser ParserImpl(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    nextId_t last;
    state start {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.ethertype){
            0x9001: parse_first_id;
            default: accept;
        }
    }

    state parse_first_id {
        packet.extract(hdr.event_prefix);
        meta.valid_values_bitmask = 0;
        last = hdr.event_prefix.first_attribute_id;
        // The first id is allowed to be 0,
        // but 0 is also the indicated header stack end, therefore we need a prefixed selection here
        transition select (last) {
            0: parse_event_0;
            default: parse_event;
        }
    }
    state parse_event {
        transition select (last) {
            0: accept;
            1: parse_event_1;
            2: parse_event_2;
            3: parse_event_3;
            4: parse_event_4;
            5: parse_event_5;
            6: parse_event_6;
            7: parse_event_7;
            8: parse_event_8;
            9: parse_event_9;
            10: parse_event_10;
            11: parse_event_11;
            12: parse_event_12;
            13: parse_event_13;
            14: parse_event_14;
            15: parse_event_15;
            16: parse_event_16;
            //and so on ...
            default: accept;
        }
    }

    state parse_event_0 {
        packet.extract(hdr.event[0]);
        last = hdr.event[0].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | 1;
        transition parse_event;
    }
    state parse_event_1 {
        packet.extract(hdr.event[1]);
        last = hdr.event[1].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 1);
        transition parse_event;
    }
    state parse_event_2 {
        packet.extract(hdr.event[2]);
        last = hdr.event[2].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 2);
        transition parse_event;
    }
    state parse_event_3 {
        packet.extract(hdr.event[3]);
        last = hdr.event[3].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 3);
        transition parse_event;
    }
    state parse_event_4 {
        packet.extract(hdr.event[4]);
        last = hdr.event[4].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 4);
        transition parse_event;
    }
    state parse_event_5 {
        packet.extract(hdr.event[5]);
        last = hdr.event[5].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 5);
        transition parse_event;
    }
    state parse_event_6 {
        packet.extract(hdr.event[6]);
        last = hdr.event[6].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 6);
        transition parse_event;
    }
    state parse_event_7 {
        packet.extract(hdr.event[7]);
        last = hdr.event[7].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 7);
        transition parse_event;
    }
    state parse_event_8 {
        packet.extract(hdr.event[8]);
        last = hdr.event[8].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 8);
        transition parse_event;
    }
    state parse_event_9 {
        packet.extract(hdr.event[9]);
        last = hdr.event[9].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 9);
        transition parse_event;
    }
    state parse_event_10 {
        packet.extract(hdr.event[10]);
        last = hdr.event[10].nextId;
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 10);
        transition parse_event;
    }
    state parse_event_11 {
        packet.extract(hdr.event[11]);
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 11);
        last = hdr.event[11].nextId;
        transition parse_event;
    }
    state parse_event_12 {
        packet.extract(hdr.event[12]);
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 12);
        last = hdr.event[12].nextId;
        transition parse_event;
    }
    state parse_event_13 {
        packet.extract(hdr.event[13]);
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 13);
        last = hdr.event[13].nextId;
        transition parse_event;
    }
    state parse_event_14 {
        packet.extract(hdr.event[14]);
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 14);
        last = hdr.event[14].nextId;
        transition parse_event;
    }
    state parse_event_15 {
        packet.extract(hdr.event[15]);
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 15);
        last = hdr.event[15].nextId;
        transition parse_event;
    }
    state parse_event_16 {
        packet.extract(hdr.event[16]);
        meta.valid_values_bitmask =  meta.valid_values_bitmask | (1 << 16);
        last = hdr.event[16].nextId;
        transition parse_event;
    }
    //...
}

control ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    action forward(bit<16> mcast_grp) {
        standard_metadata.mcast_grp = mcast_grp;
    }
    action forwardSingle(bit<9> egr) {
        standard_metadata.egress_spec = egr;
    }
    action drop() {
        mark_to_drop(standard_metadata);
    }
    table t_event {
        actions = {
            forward;
            forwardSingle;
            drop;
        }
        key = {
            meta.valid_values_bitmask : ternary;
            //range match kind is most suitable for this use case, however: P4_16 standard match types are only: "exact", "ternary" and "lpm"
            hdr.event[0].value : range;
            hdr.event[1].value : range;
            hdr.event[2].value : range;
            hdr.event[3].value : range;
            hdr.event[4].value : range;
            hdr.event[5].value : range;
            hdr.event[6].value : range;
            hdr.event[7].value : range;
            hdr.event[8].value : range;
            hdr.event[9].value : range;
            hdr.event[10].value : range;
            hdr.event[11].value : range;
            hdr.event[12].value : range;
            hdr.event[13].value : range;
            hdr.event[14].value : range;
            hdr.event[15].value : range;
            hdr.event[16].value : range;
        }
        default_action = drop;
    }
    apply {
        t_event.apply();
    }
}

control egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    action overwrite_dst_mac(bit<48> dst_mac) {
        hdr.ethernet.dst_addr = dst_mac;
    }

    table t_overwrite_dst_mac {
        actions = {
            overwrite_dst_mac;
        }
        key = {
         standard_metadata.egress_port : exact;
        }
    }
    apply {
        t_overwrite_dst_mac.apply();
    }
}



control DeparserImpl(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr);
    }
}

control verifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

control computeChecksum(inout headers hdr, inout metadata meta) {
    apply {
    }
}

V1Switch(ParserImpl(), verifyChecksum(), ingress(), egress(), computeChecksum(), DeparserImpl()) main;

