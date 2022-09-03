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
    state start {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.ethertype){
            0x9001: parse_bitmask;
            default: accept;
        }
    }

    state parse_bitmask {
        packet.extract(hdr.valid_attribute_bitmask);
        meta.to_be_parsed = hdr.valid_attribute_bitmask.bitmask;
        transition parse_event;
    }

    state parse_event {
        transition select (meta.to_be_parsed) {
            0b0 &&& 32w0xffffffff: accept; // redundant with default rule
            0b1 &&& 0b1: parse_event_0;
            0b10 &&& 0b10: parse_event_1;
            0b100 &&& 0b100: parse_event_2;
            0b1000 &&& 0b1000: parse_event_3;
            0b10000 &&& 0b10000: parse_event_4;
            0b100000 &&& 0b100000: parse_event_5;
            0b1000000 &&& 0b1000000: parse_event_6;
            0b10000000 &&& 0b10000000: parse_event_7;
            0b100000000 &&& 0b100000000: parse_event_8;
            0b1000000000 &&& 0b1000000000: parse_event_9;
            0b10000000000 &&& 0b10000000000: parse_event_10;
            0b100000000000 &&& 0b100000000000: parse_event_11;
            0b1000000000000 &&& 0b1000000000000: parse_event_12;
            0b10000000000000 &&& 0b10000000000000: parse_event_13;
            0b100000000000000 &&& 0b100000000000000: parse_event_14;
            0b1000000000000000 &&& 0b1000000000000000: parse_event_15;
            0b10000000000000000 &&& 0b10000000000000000: parse_event_16;
            //and so on ...
            default: accept;
        }
    }

    state parse_event_0 {
        packet.extract(hdr.event[0]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 0)) ) ;
        transition parse_event;
    }
    state parse_event_1 {
        packet.extract(hdr.event[1]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 1)) ) ;
        transition parse_event;
    }
    state parse_event_2 {
        packet.extract(hdr.event[2]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 2)) ) ;
        transition parse_event;
    }
    state parse_event_3 {
        packet.extract(hdr.event[3]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 3)) ) ;
        transition parse_event;
    }
    state parse_event_4 {
        packet.extract(hdr.event[4]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 4)) ) ;
        transition parse_event;
    }
    state parse_event_5 {
        packet.extract(hdr.event[5]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 5)) ) ;
        transition parse_event;
    }
    state parse_event_6 {
        packet.extract(hdr.event[6]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 6)) ) ;
        transition parse_event;
    }
    state parse_event_7 {
        packet.extract(hdr.event[7]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 7)) ) ;
        transition parse_event;
    }
    state parse_event_8 {
        packet.extract(hdr.event[8]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 8)) ) ;
        transition parse_event;
    }
    state parse_event_9 {
        packet.extract(hdr.event[9]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 9)) ) ;
        transition parse_event;
    }
    state parse_event_10 {
        packet.extract(hdr.event[10]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 10)) ) ;
        transition parse_event;
    }
    state parse_event_11 {
        packet.extract(hdr.event[11]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 11)) ) ;
        transition parse_event;
    }
    state parse_event_12 {
        packet.extract(hdr.event[12]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 12)) ) ;
        transition parse_event;
    }
    state parse_event_13 {
        packet.extract(hdr.event[13]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 13)) ) ;
        transition parse_event;
    }
    state parse_event_14 {
        packet.extract(hdr.event[14]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 14)) ) ;
        transition parse_event;
    }
    state parse_event_15 {
        packet.extract(hdr.event[15]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 15)) ) ;
        transition parse_event;
    }
    state parse_event_16 {
        packet.extract(hdr.event[16]);
        meta.to_be_parsed = meta.to_be_parsed & (~( (bit<header_stack_size>)(1 << 16)) ) ;
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
            hdr.valid_attribute_bitmask.bitmask : ternary;
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

