/*
Copyright 2013-present Barefoot Networks, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

/*
 * Modified by Yuliang Li liyuliang001@gmail.com;
 */

#include "includes/headers.p4"
#include "includes/parser.p4"
#include "loss_radar.p4"

header_type drop_metadata_t {
	fields {
		drop : 1;
	}
}
metadata drop_metadata_t drop_metadata;

action _drop() {
	modify_field(drop_metadata.drop, 1);
    drop();
}

action _no_op(){
	no_op();
}

header_type routing_metadata_t {
    fields {
        nhop_ipv4 : 32;
    }
}

metadata routing_metadata_t routing_metadata;

action set_nhop(nhop_ipv4, port) {
    modify_field(routing_metadata.nhop_ipv4, nhop_ipv4);
    modify_field(standard_metadata.egress_spec, port);
    add_to_field(ipv4.ttl, -1);
}

table ipv4_lpm {
    reads {
        ipv4.dstAddr : lpm;
    }
    actions {
        set_nhop;
        _drop;
    }
    size: 1024;
}

action set_dmac(dmac) {
    modify_field(ethernet.dstAddr, dmac);
}

table forward {
    reads {
        routing_metadata.nhop_ipv4 : exact;
    }
    actions {
        set_dmac;
        _drop;
    }
    size: 512;
}

action rewrite_mac(smac) {
    modify_field(ethernet.srcAddr, smac);
}

table send_frame {
    reads {
        standard_metadata.egress_port: exact;
    }
    actions {
        rewrite_mac;
        _drop;
    }
    size: 256;
}


control ingress {
    apply(ipv4_lpm);
    apply(forward);
	apply(add_loss_radar_hdr_table);
	apply(loss_radar_calc_hash_table);
	apply(loss_radar_um_table);
	apply(loss_radar_dm_table);
}

control egress {
    apply(send_frame);
	apply(remove_loss_radar_hdr_table);
}
