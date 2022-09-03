#ifndef _HEADERS_
#define _HEADERS_

typedef bit<48> mac_addr_t;
typedef bit<32> ipv4_addr_t;
typedef bit<16> bierBitmask;
typedef bit<16> ether_type_t;
const ether_type_t ETHERTYPE_IPV4 = 0x800;
const ether_type_t TYPE_ARP = 0x0806;
const ether_type_t ETHERTYPE_CPU = 0xEF32;
const ether_type_t ETHERTYPE_TOPOLOGY = 0xDD00;
const ether_type_t ETHERTYPE_PROTECTION = 0xDD01;
const ether_type_t ETHERTYPE_PROTECTION_RESET = 0xDD02;
const bit<8> TYPE_IP_TCP = 6;
const bit<8> TYPE_IP_UDP = 17;
const bit<8> TYPE_IP_IP = 0x04;
const bit<8> TYPE_IP_PROTECTION = 0x8F;
const bit<8> TYPE_IP_PROTECTION_REQUEST = 0x9A;
const PortId_t CPU_PORT = 192;

/* Protection */
typedef bit<16> protectionId_t;
typedef bit<16> mcastGrp_t;
typedef bit<32> protectionSeq_t;

#define PROTECTION_STORAGE 8192
#define SEQ_WINDOW 2147483648

header empty_t {}

header ethernet_h {
    mac_addr_t dst_addr;
    mac_addr_t src_addr;
    bit<16> ether_type;
}

header pkt_gen_t {
    bit<3> pad;
    bit<2> pipe;
    bit<3> app_id;
    bit<15> pad1;
    bit<9> port_num;
    bit<16> pkt_id;
}

header ipv4_t {
    bit<4> version;
    bit<4> ihl;
    bit<8> diffserv;
    bit<16> total_len;
    bit<16> identification;
    bit<3> flags;
    bit<13> frag_offset;
    bit<8> ttl;
    bit<8> protocol;
    bit<16> hdr_checksum;
    ipv4_addr_t srcAddr;
    ipv4_addr_t dstAddr;
}

header transport_t {
    bit<16>	src_port;
    bit<16>	dst_port;
}

header protection_t {
    protectionId_t 	conn_id;
    protectionSeq_t	seq;
    bit<8>		proto;
}

header protection_reset_t {
    bit<32>	conn_id;
    bit<32>	device_type; // used to distinguish ps from pe_node
}

header cpu_t {
    bit<16> egress_port;
    bit<16> ingress_port;
    bit<16> next_proto;
}

header topology_h {
    bit<32> identifier;
    bit<16> port;
    bit<32> prefix;
    bit<48> mac;
    bit<8> device_type;
}

struct header_t {
    ethernet_h 		ethernet;
    protection_t	protection;
    protection_reset_t  protection_reset;
    cpu_t 		cpu;
    ipv4_t 		ipv4;
    topology_h 		topology;
    transport_t 	transport;
    pkt_gen_t		pkt_gen;
    ipv4_t 		ipv4_inner;
}

struct port_metadata_t {
    bit<256> status;
}

struct ingress_metadata_t {
    bool checksum_err;
    bit<10> mirror_session;
    bit<2> mode;
    protectionId_t conn_id;
}

struct egress_metadata_t {
}


#endif /* _HEADERS_ */
