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
 * Modified by Yuliang Li liyuliang001@gmail.com
 */

parser start {
	return parse_ethernet;
}

#define ETHERTYPE_IPV4 0x0800
#define IPV4_TCP 0x0006
#define IPV4_UDP 0x0011
#define IPV4_LOSSRADAR 0xFC //0xFC is not assigned [https://www.ietf.org/assignments/protocol-numbers/protocol-numbers.xml]

// parse ethernet header
header ethernet_t ethernet;

parser parse_ethernet {
    extract(ethernet);
    return select(latest.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}

// parse ipv4 header
header ipv4_t ipv4;

field_list ipv4_checksum_list {
        ipv4.version;
        ipv4.ihl;
        ipv4.diffserv;
        ipv4.totalLen;
        ipv4.identification;
        ipv4.flags;
        ipv4.fragOffset;
        ipv4.ttl;
        ipv4.protocol;
        ipv4.srcAddr;
        ipv4.dstAddr;
}

field_list_calculation ipv4_checksum {
    input {
        ipv4_checksum_list;
    }
    algorithm : csum16;
    output_width : 16;
}

calculated_field ipv4.hdrChecksum  {
    verify ipv4_checksum;
    update ipv4_checksum;
}

parser parse_ipv4 {
    extract(ipv4);
    return select(latest.protocol){
		IPV4_TCP : parse_tcp;
		IPV4_LOSSRADAR : parse_lossradar;
		default: ingress;
	}
}

// parse lossradar header
header lossradar_hdr_t lossradar_hdr;

parser parse_lossradar {
	extract(lossradar_hdr);
	return select(latest.protocol){
		IPV4_TCP : parse_tcp;
		default: ingress;
	}
}

// parse tcp header
header tcp_t tcp;

parser parse_tcp {
	extract(tcp);
	return ingress;
}

