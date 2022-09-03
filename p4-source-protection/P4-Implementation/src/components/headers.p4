#define PKT_INSTANCE_TYPE_NORMAL 0
#define PKT_INSTANCE_TYPE_INGRESS_CLONE 1
#define PKT_INSTANCE_TYPE_EGRESS_CLONE 2
#define PKT_INSTANCE_TYPE_COALESCED 3
#define PKT_INSTANCE_TYPE_INGRESS_RECIRC 4
#define PKT_INSTANCE_TYPE_REPLICATION 5
#define PKT_INSTANCE_TYPE_RESUBMIT 6
#define CONTROLLER_PORT 16
#define SEGMENT_WIDTH 8


// adress specification
typedef bit<9> egressSpec_t;
typedef bit<48> macAddr_t;

// proto numbers
const bit<16> TYPE_TOP_DISCOVER = 0xDD00;
const bit<16> ETHERTYPE_PROTECT = 0xDD01;

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

// header naming
struct headers {
    ethernet_t          ethernet;
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
    bit<1> accepted;
    bit<48> period;
    egressSpec_t primary;
    egressSpec_t secondary;
}
