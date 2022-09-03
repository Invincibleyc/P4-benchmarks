parser packetParser(packet_in packet,
                out headers hdr,
                inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    // entry point
    state start {
        transition parse_ethernet;
    }

    // parse ethernet packet
    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            TYPE_IPV4 :         parse_ipv4;
            TYPE_TOP_DISCOVER:  parse_topology_discover;
            TYPE_PROTECTION: parse_protection;
            TYPE_PROTECTION_RESET: parse_protection_reset;
            default :           accept;
        }
    }

    // parse ipv4 packet
    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol) {
            TYPE_IP_PROTECTION: parse_protection;
            TYPE_IP_TCP:        parse_transport;
            TYPE_IP_UDP:        parse_transport;
            default:            accept;
        }
    }

    // parse ipv4 packet
    state parse_ipv4_inner {
        packet.extract(hdr.ipv4_inner);
        transition accept;
    }

    // parse protection packet
    state parse_protection {
        packet.extract(hdr.protection);
        transition select(hdr.protection.proto) {
            TYPE_IP_IP: parse_ipv4_inner;
            default: accept;
        }

    }

    state parse_transport {
        packet.extract(hdr.transport);
        transition accept;
    }

    // parse protection reset packet
    state parse_protection_reset {
        packet.extract(hdr.protection_reset);
        transition accept;
    }

    // parse topology disover
    state parse_topology_discover {
        packet.extract(hdr.topology);
        transition accept;
    }
}
