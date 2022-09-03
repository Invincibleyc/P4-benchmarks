typedef bit<48> mac_addr_t;
typedef bit<8> protect_counter;
const bit<16> ETHERTYPE_TOPOLOGY = 0xDD00;
const bit<16> ETHERTYPE_PROTECT = 0xDD01;
const PortId_t CPU_PORT = 192;


header ethernet_h {
    mac_addr_t dst_addr;
    mac_addr_t src_addr;
    bit<16> ether_type;
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
    topology_h 		topology;
}

struct ingress_metadata_t {
    bool checksum_err;
    bit<1> accepted;
    protect_counter period;
    PortId_t primary;
    PortId_t secondary;
}

struct egress_metadata_t {
}


