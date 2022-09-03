/*******************************************************************************
 * BAREFOOT NETWORKS CONFIDENTIAL & PROPRIETARY
 *
 * Copyright (c) 2018-2019 Barefoot Networks, Inc.
 * All Rights Reserved.
 *
 * NOTICE: All information contained herein is, and remains the property of
 * Barefoot Networks, Inc. and its suppliers, if any. The intellectual and
 * technical concepts contained herein are proprietary to Barefoot Networks,
 * Inc.
 * and its suppliers and may be covered by U.S. and Foreign Patents, patents in
 * process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material is
 * strictly forbidden unless prior written permission is obtained from
 * Barefoot Networks, Inc.
 *
 * No warranty, explicit or implicit is provided, unless granted under a
 * written agreement with Barefoot Networks, Inc.
 *
 *
 ******************************************************************************/

parser TofinoIngressParser(
        packet_in pkt,
        out ingress_intrinsic_metadata_t ig_intr_md) {
    state start {
        pkt.extract(ig_intr_md);
        transition select(ig_intr_md.resubmit_flag) {
            1 : parse_resubmit;
            0 : parse_port_metadata;
        }
    }

    state parse_resubmit {
        // Parse resubmitted packet here.
        transition accept;
    }
state parse_port_metadata {
#if __TARGET_TOFINO__ == 2
        pkt.advance(192);
#else
        pkt.advance(64);
#endif
        transition accept;
    }
}

parser TofinoEgressParser(
        packet_in pkt,
        out egress_intrinsic_metadata_t eg_intr_md) {

    state start {
        pkt.extract(eg_intr_md);
        transition accept;
    }
}


// ---------------------------------------------------------------------------
// Ingress parser
// ---------------------------------------------------------------------------
parser SwitchIngressParser(
        packet_in pkt,
        out header_t hdr,
        out ingress_metadata_t ig_md,
        out ingress_intrinsic_metadata_t ig_intr_md) {

    //Checksum<bit<16>>(HashAlgorithm_t.CSUM16) ipv4_checksum;
    TofinoIngressParser() tofino_parser;

    state start {
        tofino_parser.apply(pkt, ig_intr_md);
        transition select(ig_intr_md.ingress_port) {
            68: 	parse_pkt_gen;
            196: 	parse_pkt_gen;
            default: 	parse_ethernet;
        }
    }

    state parse_pkt_gen {
        pkt.extract(hdr.pkt_gen);
        transition parse_ethernet;
    }
    state parse_ethernet {
        pkt.extract(hdr.ethernet);
        transition select(hdr.ethernet.ether_type) {
            ETHERTYPE_IPV4 : parse_ipv4;
            ETHERTYPE_CPU : parse_cpu;
            ETHERTYPE_TOPOLOGY: parse_topology;
            ETHERTYPE_PROTECTION: parse_protection;
            ETHERTYPE_PROTECTION_RESET: parse_protection_reset;
            default : accept;
        }
    }

    state parse_ipv4 {
        pkt.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            TYPE_IP_PROTECTION: parse_protection;
            TYPE_IP_TCP: 	parse_transport;
            TYPE_IP_UDP: 	parse_transport;
            default: accept;
        }
    }

    state parse_ipv4_inner {
        pkt.extract(hdr.ipv4_inner);
        transition select(hdr.ipv4_inner.protocol) {
            TYPE_IP_TCP:     parse_transport;
            TYPE_IP_UDP:     parse_transport;
            default: accept;
        }
    }

    state parse_cpu {
        pkt.extract(hdr.cpu);
        transition accept;
    }

    state parse_topology {
        pkt.extract(hdr.topology);
        transition accept;
    }

    state parse_transport {
        pkt.extract(hdr.transport);
        transition accept;
    }

    state parse_protection {
        pkt.extract(hdr.protection);
        transition select(hdr.protection.proto) {
            TYPE_IP_IP: parse_ipv4_inner;
            default: accept;
        }
    }

    state parse_protection_reset {
        pkt.extract(hdr.protection_reset);
        transition accept;
    }

}

// ---------------------------------------------------------------------------
// Ingress Deparser
// ---------------------------------------------------------------------------
control SwitchIngressDeparser(
        packet_out pkt,
        inout header_t hdr,
        in ingress_metadata_t ig_md,
        in ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md) {
    Mirror() mirror;

    apply {
        pkt.emit(hdr.ethernet);
        pkt.emit(hdr.topology);
        pkt.emit(hdr.cpu);
        pkt.emit(hdr.ipv4);
        pkt.emit(hdr.protection);
        pkt.emit(hdr.ipv4_inner);
        pkt.emit(hdr.transport);

        if(ig_dprsr_md.mirror_type == 1) {
          mirror.emit<empty_t>(ig_md.mirror_session, {});
        }

    }
}

// ---------------------------------------------------------------------------
// Egress parser
// ---------------------------------------------------------------------------
parser SwitchEgressParser(
        packet_in pkt,
        out header_t hdr,
        out egress_metadata_t eg_md,
        out egress_intrinsic_metadata_t eg_intr_md) {

    TofinoEgressParser() tofino_parser;

    state start {
        tofino_parser.apply(pkt, eg_intr_md);
        transition parse_ethernet;
    }

    state parse_ethernet {
        pkt.extract(hdr.ethernet);
        transition select(hdr.ethernet.ether_type) {
            ETHERTYPE_IPV4 : parse_ipv4;
            default : accept;
        }
    }

    state parse_ipv4 {
        pkt.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            TYPE_IP_PROTECTION: parse_protection;
            TYPE_IP_TCP: 	parse_transport;
            TYPE_IP_UDP: 	parse_transport;
            default: accept;
        }
    }

    state parse_ipv4_inner {
        pkt.extract(hdr.ipv4_inner);
        transition select(hdr.ipv4.protocol) {
            TYPE_IP_TCP: 	parse_transport;
            TYPE_IP_UDP: 	parse_transport;
            default: 		accept;
        }
    }

    state parse_cpu {
        pkt.extract(hdr.cpu);
        transition accept;
    }

    state parse_topology {
        pkt.extract(hdr.topology);
        transition accept;
    }

    state parse_transport {
        pkt.extract(hdr.transport);
        transition accept;
    }

    state parse_protection {
        pkt.extract(hdr.protection);
        transition select(hdr.protection.proto) {
            TYPE_IP_IP: parse_ipv4_inner;
            default: accept;
        }
    }

    state parse_protection_reset {
        pkt.extract(hdr.protection_reset);
        transition accept;
    }

}

// ---------------------------------------------------------------------------
// Egress Deparser
// ---------------------------------------------------------------------------
control SwitchEgressDeparser(
        packet_out pkt,
        inout header_t hdr,
        in egress_metadata_t eg_md,
        in egress_intrinsic_metadata_for_deparser_t eg_dprsr_md) {
    Checksum<bit<16>>(HashAlgorithm_t.CSUM16) ipv4_checksum;
    apply {
        hdr.ipv4.hdr_checksum = ipv4_checksum.update(
                {hdr.ipv4.version,
                 hdr.ipv4.ihl,
                 hdr.ipv4.diffserv,
                 hdr.ipv4.total_len,
                 hdr.ipv4.identification,
                 hdr.ipv4.flags,
                 hdr.ipv4.frag_offset,
                 hdr.ipv4.ttl,
                 hdr.ipv4.protocol,
                 hdr.ipv4.srcAddr,
                 hdr.ipv4.dstAddr});

        pkt.emit(hdr.ethernet);
        pkt.emit(hdr.topology);
        pkt.emit(hdr.cpu);
        pkt.emit(hdr.ipv4);
        pkt.emit(hdr.protection);
        pkt.emit(hdr.ipv4_inner);
        pkt.emit(hdr.transport);
    }
}
