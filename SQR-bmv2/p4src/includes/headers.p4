/*********START : headersfor normal pkts********/
header_type ethernet_t {  // 14 bytes
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}
header ethernet_t ethernet;

/*header_type portdown_t {
    fields{
        pipe: 5;
        app_id:3;
        _pad0: 8; //always zero
        _pad1: 7;
        port: 9;
        pkt_number: 16;
        srcEthAddr: 48;
        etherType: 16;
    }
}
header portdown_t portdown;*/

header_type pktgen_t { //19bytes
    fields{
        pipe: 5;
        app_id:3;
        _pad0: 8; //always zero
        _pad1: 7;
        port: 9;
        pkt_number: 16;
        srcEthAddr: 48;
        etherType: 16;
        flag:1; // distinguish pkt and recirculated pkt
        _pad3:7;
        countbyte: 32; // count bytes 
    }
}
header pktgen_t pktgen;

header_type ipv4_t {  // 20 bytes
    fields {
        version : 4;
        ihl : 4;
        diffserv : 8;
        totalLen : 16;
        identification : 16;
        flags : 3;
        fragOffset : 13;
        ttl : 8;
        protocol : 8;
        hdrChecksum : 16;
        srcAddr : 32;
        dstAddr: 32;
    }
}
header ipv4_t ipv4;



field_list ipv4_field_list {
    ipv4.version;
    ipv4.ihl;
    ipv4.diffserv;
    ipv4.totalLen;
    ipv4.identification;
    ipv4.flags;
    ipv4.fragOffset;
    ipv4.ttl;
    ipv4.protocol;
    ipv4.srcAddr;
    ipv4.dstAddr;
}

field_list_calculation ipv4_chksum_calc {
    input {
        ipv4_field_list;
    }
    algorithm : csum16;
    output_width: 16;
}

calculated_field ipv4.hdrChecksum {
    verify ipv4_checksum;
    update ipv4_chksum_calc;
}



header_type udp_t { // 8 bytes
    fields {
        srcPort : 16;
        dstPort : 16;
        hdr_length : 16;
        checksum : 16;
    }
}
header udp_t udp;

header_type tcp_t { // 20 bytes
    fields {
        srcPort     : 16;
        dstPort     : 16;
        seqNo       : 32;
        ackNo       : 32;
        dataOffset  : 4;
        res         : 4;
        flag_cwr    : 1;
        flag_ece    : 1;
        flag_urg    : 1;
        flag_ack    : 1;
        flag_psh    : 1;
        flag_rst    : 1;
        flag_syn    : 1;
        flag_fin    : 1;
//        flags       : 8;
        window      : 16;
        checksum    : 16;
        urgentPtr   : 16;
    }
}
header tcp_t tcp;

header_type test_t {  // 5 bytes
    fields {
        protocol : 8;
        pkt_tag:32;
    }
}
header test_t test;

header_type icmp_t {
    fields {
        typecode    : 16;
        checksum    : 16;
    }
}
header icmp_t icmp;


header_type latency_t {
    fields {
        sw1_ingress_time: 48;
        sw2_ingress_time: 48;
    }
}
header latency_t latency;

/*********END : headersfor normal pkts********/





