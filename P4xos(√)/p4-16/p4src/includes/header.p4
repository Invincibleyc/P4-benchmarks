#ifndef _HEADERS_P4_
#define _HEADERS_P4_

typedef bit<48> EthernetAddress;
typedef bit<32> IPv4Address;
typedef bit<4> PortId;

// Physical Ports
const PortId DROP_PORT = 0xF;
// UDP Ports
const bit<16> ACCEPTOR_PORT = 0x8889;
const bit<16> LEARNER_PORT = 0x8890;
const bit<16> APPLICATION_PORT = 56789;
// standard headers
header ethernet_t {
    EthernetAddress dstAddr;
    EthernetAddress srcAddr;
    bit<16> etherType;
}

header arp_t {
    bit<16> hrd;
    bit<16> pro;
    bit<8> hln;
    bit<8> pln;
    bit<16> op;
    bit<48> sha;
    bit<32> spa;
    bit<48> tha;
    bit<32> tpa;
}

header ipv4_t {
    bit<4> version;
    bit<4> ihl;
    bit<8> diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3> flags;
    bit<13> fragOffset;
    bit<8> ttl;
    bit<8> protocol;
    bit<16> hdrChecksum;
    IPv4Address srcAddr;
    IPv4Address dstAddr;
}

header icmp_t {
    bit<8> icmpType;
    bit<8> icmpCode;
    bit<16> hdrChecksum;
    bit<16> identifier;
    bit<16> seqNumber;
    bit<256> payload;
}

header udp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<16> length_;
    bit<16> checksum;
}

// Headers for Paxos
#define PAXOS_1A 0 
#define PAXOS_1B 1 
#define PAXOS_2A 2
#define PAXOS_2B 3 

#define MSGTYPE_SIZE    16
#define INSTANCE_SIZE   32
#define ROUND_SIZE      16
#define DATAPATH_SIZE   16
#define VALUELEN_SIZE   32
#define VALUE_SIZE      256
#define INSTANCE_COUNT  65536


header paxos_t {
    bit<MSGTYPE_SIZE>   msgtype;    // indicates the message type e.g., 1A, 1B, etc.
    bit<INSTANCE_SIZE>  inst;       // instance number
    bit<ROUND_SIZE>     rnd;        // round number
    bit<ROUND_SIZE>     vrnd;       // round in which an acceptor casted a vote
    bit<DATAPATH_SIZE>  acptid;     // Switch ID
    bit<VALUELEN_SIZE>  paxoslen;   // the length of paxos_value
    bit<VALUE_SIZE>     paxosval;   // the value the acceptor voted for
}

struct headers {
    ethernet_t ethernet;
    arp_t arp;
    ipv4_t ipv4;
    icmp_t icmp;
    udp_t udp;
    paxos_t paxos;
}

struct paxos_metadata_t {
    bit<ROUND_SIZE> round;
    bit<1> set_drop;
    bit<8> ack_count;
    bit<8> ack_acceptors;
}

struct metadata {
    paxos_metadata_t   paxos_metadata;
}

#endif
