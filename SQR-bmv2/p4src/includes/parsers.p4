#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_PKTGEN 0x0666
#define IP_PROTOCOLS_UDP 17
#define IP_PROTOCOLS_TCP 6
#define IP_PROTOCOLS_TEST 253
#define IP_PROTOCOLS_LATENCY 63
#define IP_PROTOCOLS_ICMP 1

parser start {
    return select(current(96,16)){
        ETHERTYPE_PKTGEN: parse_pktgen;
        default: parse_ethernet;
    }
}

parser parse_pktgen{
    extract(pktgen);
    set_metadata(meta.etherType, ETHERTYPE_PKTGEN);
    return parse_ipv4;
}

parser parse_ethernet {
    extract(ethernet);
    return select(ethernet.etherType) {
        ETHERTYPE_IPV4 : parse_ipv4;
        default: ingress;
    }
}


parser parse_ipv4 {
    extract(ipv4);
    set_metadata(meta.ipv4_protocol,ipv4.protocol);
    return select(ipv4.protocol) {
        IP_PROTOCOLS_TCP: parse_tcp;
        IP_PROTOCOLS_UDP: parse_udp;
        IP_PROTOCOLS_ICMP: parse_icmp;
        IP_PROTOCOLS_LATENCY: parse_latency;
        IP_PROTOCOLS_TEST: parse_test;
        default: ingress;
    }    
}


parser parse_test{
    extract(test);
    return select(test.protocol) {
        IP_PROTOCOLS_TCP: parse_tcp;
        IP_PROTOCOLS_UDP: parse_udp;
        IP_PROTOCOLS_ICMP: parse_icmp;
        IP_PROTOCOLS_LATENCY: parse_latency;
        default: ingress;
    }
}


parser parse_udp{
    extract(udp);
    return ingress;
}

parser parse_tcp{
    extract(tcp);
    return ingress;
}


parser parse_icmp{
    extract(icmp);
    return ingress;
}

parser parse_latency{
    extract(latency);
    return ingress;
}

