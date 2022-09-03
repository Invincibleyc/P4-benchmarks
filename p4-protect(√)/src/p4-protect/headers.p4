#define PKT_INSTANCE_TYPE_NORMAL 0
#define PKT_INSTANCE_TYPE_INGRESS_CLONE 1
#define PKT_INSTANCE_TYPE_EGRESS_CLONE 2
#define PKT_INSTANCE_TYPE_COALESCED 3
#define PKT_INSTANCE_TYPE_INGRESS_RECIRC 4
#define PKT_INSTANCE_TYPE_REPLICATION 5
#define PKT_INSTANCE_TYPE_RESUBMIT 6
#define CONTROLLER_PORT 16

#define PROTECTION_STORAGE 8192
#define SEQ_MAX 255

// adress specification
typedef bit<9> egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
typedef bit<16> protectionId_t;
typedef bit<16> mcastGrp_t;
typedef bit<8> protectionSeq_t;

// proto numbers
const bit<16> TYPE_IPV4 = 0x800;
const bit<16> TYPE_PROTECTION = 0xDD01;
const bit<16> TYPE_PROTECTION_RESET = 0xDD02;
const bit<16> TYPE_TOP_DISCOVER = 0xDD00;
const bit<8> TYPE_IP_IP = 0x04;
const bit<8> TYPE_IP_TCP = 6;
const bit<8> TYPE_IP_UDP = 17;
const bit<8> TYPE_IP_PROTECTION = 0x8F;



// Topology discovery header, proprietary
header topology_discover_t {
    bit<32> identifier;
    bit<16> port;
    bit<32> prefix;
    bit<48> mac;
}

// Ethernet header
header ethernet_t {
	macAddr_t dstAddr;
	macAddr_t srcAddr;
	bit<16> etherType;
}

// IP header
header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>   totalLen;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdrChecksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

// short header for tcp and udp relevant data
// omit other fields
// they are treated as payload and can be ignored
header transport_t {
    bit<16>     src_port;
    bit<16>     dst_port;
}


header protection_t {
    protectionId_t  conn_id;
    protectionSeq_t seq;
    bit<8>          proto;
}

header protection_reset_t {
    bit<32>         conn_id;
    bit<32>         device_type; // used to distinguish ps from pe_node
}

// header naming
struct headers {
    ethernet_t          ethernet;
    protection_t        protection;
    protection_reset_t  protection_reset;
    ipv4_t              ipv4;
    transport_t         transport;
    ipv4_t              ipv4_inner;
    topology_discover_t topology;
}


struct intrinsic_metadata_t {
    bit<48> ingress_global_timestamp;
    bit<48> egress_global_timestamp;
    bit<32> lf_field_list;
    bit<16> mcast_grp;
    bit<32> resubmit_flag;
    bit<16> egress_rid;
    bit<32> recirculate_flag;
}

// meta data instances
struct metadata {
    intrinsic_metadata_t intrinsic_metadata;
}
