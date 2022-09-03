/* parser.p4 -*- c -*-
 *
 *  Copyright 2017 Wolfgang Braun, Joshua Hartmann
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Constant definitions
 */

#define ETHERTYPE_IPV4   0x0800

#define ETHERTYPE_BIER    0xBB00
#define ETHERTYPE_BIER_TE 0xBB01

// Used in BIER header proto field to identify the next protocol in the header
#define BIER_PROTO_BIER 0xBB
#define BIER_PROTO_IPV4 0x08

/*
 * Packet header structures in SDN-BIER
 *
 * a) Ethernet packet, e.g. ARP, etc.
 * |Ethernet|Payload|
 *
 * b) IPv4 packet
 * |Eth. - ETHERTYPE_IPV4|IPv4|Payload|
 *
 * c) BIER packet
 * |Eth. - ETHERTYPE_BIER|BIER - BSL, BIER_PROTO_IPV4|IPv4|Payload|
 *
 * d) BIER-TE packet
 * |Eth. - ETHERTYPE_BIER_TE|BIER - BIER_PROTO_IPV4|IPv4|Payload|
 *
 * e) Fast rerouted BIER-TE packet
 * |Eth. - ETHERTYPE_BIER_TE|BIER - BIER_PROTO_BIER|BIER - BIER_PROTO_IPV4|IPv4|Payload|
 */

// Global entry point for the parser
parser start {
  return parse_ethernet;
}

// Instance for the Ethernet header
header ethernet_t ethernet;

parser parse_ethernet {
  extract(ethernet);
  return select(latest.etherType) {
    ETHERTYPE_IPV4 : parse_ipv4;
    ETHERTYPE_BIER : parse_bier;
    ETHERTYPE_BIER_TE : parse_bier;
    // Ignore unknown types and go to 'control ingress' in sdn-bfr.p4
    default: ingress;
  }
}

// Header instance for BIER. Allows for one BIER-in-BIER encapsulation
// access using bier (bier[0]), and bier[1]
// headers will be created using push(bier, 1) and pop(bier, 1)
header bier_t bier[2];

parser parse_bier {
  extract(bier[next]);
  return select(latest.Proto) {
    BIER_PROTO_BIER : parse_bier;
    BIER_PROTO_IPV4 : parse_ipv4;
 }
}

header ipv4_t ipv4;

parser parse_ipv4 {
  extract(ipv4);
  // Call 'control ingress' block in sdn-bfr.p4
  return ingress;
}
