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
            TYPE_TOP_DISCOVER: parse_topology_discover;
            default: accept;
        }
    }

    state parse_topology_discover {
        packet.extract(hdr.topology);
        transition accept;
    }

}
