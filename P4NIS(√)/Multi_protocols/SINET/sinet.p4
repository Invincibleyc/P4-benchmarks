/* -*- P4_16 -*- */

#include <core.p4>
#include <v1model.p4>

//the ether_type of SINET
const bit<16> TYPE_SINET = 0x9999;
const bit<16> TYPE_IPv4 = 0x0800;

/*************************************************************************
 *********************** H E A D E R S ***********************************
*************************************************************************/
//definitions of some global type.
typedef bit<9> egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<8> sinetAddrLength_t;
typedef bit<256> sinetAddr_t;


//the template of ethernet header.
header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16> etherType;
}

//the template of sinet header.
header sinet_t {
    bit<4> version;
    bit<8> slicing_id;
    bit<20> flow_label;
    bit<16> payload_length;
    bit<8> next_header;
    bit<8> srcAddr_length;
    bit<8> dstAddr_length;
    bit<8> hop_limit;
    bit<16> extra_state_info;
    bit<32> srcAddr;
    bit<32> dstAddr;
}

//the template of sinet extend header --- srcAddr graft 0x80
header sinet_extend_src_graft_t {
    bit<8> next_header;
    bit<24> srcAddr;
}

//the template of sinet extend header --- dstAddr graft 0x90
header sinet_extend_dst_graft_t {
    bit<8> next_header;
    bit<24> dstAddr;
}

//the template of ipv4 header
header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<8>    diffserv;
    bit<16>  totalLen;
    bit<16>  identification;
    bit<3>    flags;
    bit<13>  fragOffset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>  hdrChecksum;
    bit<32> srcAddr;
    bit<32> dstAddr;
}

struct metadata {
    /* empty */
    bit<256> sinetAddr_src;
    bit<256> sinetAddr_dst;
}

//instantiate the headers.
struct headers {
    ethernet_t ethernet;
    ipv4_t ipv4;
    //ipv6_t ipv6;
    sinet_t sinet;
    sinet_extend_src_graft_t sinet_extend_src_graft0; 
    sinet_extend_src_graft_t sinet_extend_src_graft1;
    sinet_extend_src_graft_t sinet_extend_src_graft2;
    sinet_extend_src_graft_t sinet_extend_src_graft3;
    sinet_extend_src_graft_t sinet_extend_src_graft4;
    sinet_extend_src_graft_t sinet_extend_src_graft5;
    sinet_extend_src_graft_t sinet_extend_src_graft6;
    sinet_extend_src_graft_t sinet_extend_src_graft7;
    sinet_extend_src_graft_t sinet_extend_src_graft8;
    sinet_extend_src_graft_t sinet_extend_src_graft9;
    sinet_extend_dst_graft_t sinet_extend_dst_graft0;
    sinet_extend_dst_graft_t sinet_extend_dst_graft1;
    sinet_extend_dst_graft_t sinet_extend_dst_graft2;
    sinet_extend_dst_graft_t sinet_extend_dst_graft3;
    sinet_extend_dst_graft_t sinet_extend_dst_graft4;
    sinet_extend_dst_graft_t sinet_extend_dst_graft5;
    sinet_extend_dst_graft_t sinet_extend_dst_graft6;
    sinet_extend_dst_graft_t sinet_extend_dst_graft7;
    sinet_extend_dst_graft_t sinet_extend_dst_graft8;
    sinet_extend_dst_graft_t sinet_extend_dst_graft9;
}


/*************************************************************************
************************** P A R S E R ***********************************
*************************************************************************/

parser BlackBoxParser(packet_in packet,
                      out headers hdr,
                      inout metadata meta,
                      inout standard_metadata_t standard_metadata) {

    state start {
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            TYPE_SINET: parse_sinet;
            TYPE_IPv4: parse_ipv4;
            default: accept;
        }
    }

    state parse_sinet {
        packet.extract(hdr.sinet);
        //32 bits
        meta.sinetAddr_src[255:224] = hdr.sinet.srcAddr;
        meta.sinetAddr_dst[255:224] = hdr.sinet.dstAddr;
        transition select(hdr.sinet.next_header) {
            0x80: parse_sinet_extend_src_graft0;
            0x90: parse_sinet_extend_dst_graft0;
            0x88: parse_ipv4;
            default: accept;
        }
    }
    
    state parse_sinet_extend_src_graft0 {
        packet.extract(hdr.sinet_extend_src_graft0);
        //24 bits
        meta.sinetAddr_src[223:200] = hdr.sinet_extend_src_graft0.srcAddr;
        transition select(hdr.sinet_extend_src_graft0.next_header) {
            0x80: parse_sinet_extend_src_graft1;
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_src_graft1 {
        packet.extract(hdr.sinet_extend_src_graft1);
        //24 bits 
        meta.sinetAddr_src[199:176] = hdr.sinet_extend_src_graft1.srcAddr;
        transition select(hdr.sinet_extend_src_graft1.next_header) {
            0x80: parse_sinet_extend_src_graft2;
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_src_graft2 {
        packet.extract(hdr.sinet_extend_src_graft2);
        //24 bits
        meta.sinetAddr_src[175:152] = hdr.sinet_extend_src_graft2.srcAddr;
        transition select(hdr.sinet_extend_src_graft2.next_header) {
            0x80: parse_sinet_extend_src_graft3;
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_src_graft3 {
        packet.extract(hdr.sinet_extend_src_graft3);
        //24 bits
        meta.sinetAddr_src[151:128] = hdr.sinet_extend_src_graft3.srcAddr;
        transition select(hdr.sinet_extend_src_graft3.next_header) {
            0x80: parse_sinet_extend_src_graft4;
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_src_graft4 {
        packet.extract(hdr.sinet_extend_src_graft4);
        //24 bits
        meta.sinetAddr_src[127:104] = hdr.sinet_extend_src_graft4.srcAddr;
        transition select(hdr.sinet_extend_src_graft4.next_header) {
            0x80: parse_sinet_extend_src_graft5;
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_src_graft5 {
        packet.extract(hdr.sinet_extend_src_graft5);
        //24 bits
        meta.sinetAddr_src[103:80] = hdr.sinet_extend_src_graft5.srcAddr;
        transition select(hdr.sinet_extend_src_graft5.next_header) {
            0x80: parse_sinet_extend_src_graft6;
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_src_graft6 {
        packet.extract(hdr.sinet_extend_src_graft6);
        //24 bits
        meta.sinetAddr_src[79:56] = hdr.sinet_extend_src_graft6.srcAddr;
        transition select(hdr.sinet_extend_src_graft6.next_header) {
            0x80: parse_sinet_extend_src_graft7;
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_src_graft7 {
        packet.extract(hdr.sinet_extend_src_graft7);
        //24 bits
        meta.sinetAddr_src[55:32] = hdr.sinet_extend_src_graft7.srcAddr;
        transition select(hdr.sinet_extend_src_graft7.next_header) {
            0x80: parse_sinet_extend_src_graft8;
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_src_graft8 {
        packet.extract(hdr.sinet_extend_src_graft8);
        //24 bits
        meta.sinetAddr_src[31:8] = hdr.sinet_extend_src_graft8.srcAddr;
        transition select(hdr.sinet_extend_src_graft8.next_header) {
            0x80: parse_sinet_extend_src_graft9;
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_src_graft9 {
        packet.extract(hdr.sinet_extend_src_graft9);
        //24 bits
        meta.sinetAddr_src[7:0] = hdr.sinet_extend_src_graft9.srcAddr[23:16];
        transition select(hdr.sinet_extend_src_graft9.next_header) {
            0x90: parse_sinet_extend_dst_graft0;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft0 {
        packet.extract(hdr.sinet_extend_dst_graft0);
        //24 bits
        meta.sinetAddr_dst[223:200] = hdr.sinet_extend_dst_graft0.dstAddr;
        transition select(hdr.sinet_extend_dst_graft0.next_header) {
            0x90: parse_sinet_extend_dst_graft1;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft1 {
        packet.extract(hdr.sinet_extend_dst_graft1);
        //24 bits 
        meta.sinetAddr_dst[199:176] = hdr.sinet_extend_dst_graft1.dstAddr;
        transition select(hdr.sinet_extend_dst_graft1.next_header) {
            0x90: parse_sinet_extend_dst_graft2;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft2 {
        packet.extract(hdr.sinet_extend_dst_graft2);
        //24 bits
        meta.sinetAddr_dst[175:152] = hdr.sinet_extend_dst_graft2.dstAddr;
        transition select(hdr.sinet_extend_dst_graft2.next_header) {
            0x90: parse_sinet_extend_dst_graft3;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft3 {
        packet.extract(hdr.sinet_extend_dst_graft3);
        //24 bits
        meta.sinetAddr_dst[151:128] = hdr.sinet_extend_dst_graft3.dstAddr;
        transition select(hdr.sinet_extend_dst_graft3.next_header) {
            0x90: parse_sinet_extend_dst_graft4;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft4 {
        packet.extract(hdr.sinet_extend_dst_graft4);
        //24 bits
        meta.sinetAddr_dst[127:104] = hdr.sinet_extend_dst_graft4.dstAddr;
        transition select(hdr.sinet_extend_dst_graft4.next_header) {
            0x90: parse_sinet_extend_dst_graft5;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft5 {
        packet.extract(hdr.sinet_extend_dst_graft5);
        //24 bits
        meta.sinetAddr_dst[103:80] = hdr.sinet_extend_dst_graft5.dstAddr;
        transition select(hdr.sinet_extend_dst_graft5.next_header) {
            0x90: parse_sinet_extend_dst_graft6;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft6 {
        packet.extract(hdr.sinet_extend_dst_graft6);
        //24 bits
        meta.sinetAddr_dst[79:56] = hdr.sinet_extend_dst_graft6.dstAddr;
        transition select(hdr.sinet_extend_dst_graft6.next_header) {
            0x90: parse_sinet_extend_dst_graft7;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft7 {
        packet.extract(hdr.sinet_extend_dst_graft7);
        //24 bits
        meta.sinetAddr_dst[55:32] = hdr.sinet_extend_dst_graft7.dstAddr;
        transition select(hdr.sinet_extend_dst_graft7.next_header) {
            0x90: parse_sinet_extend_dst_graft8;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft8 {
        packet.extract(hdr.sinet_extend_dst_graft8);
        //24 bits
        meta.sinetAddr_dst[31:8] = hdr.sinet_extend_dst_graft8.dstAddr;
        transition select(hdr.sinet_extend_dst_graft8.next_header) {
            0x90: parse_sinet_extend_dst_graft9;
            default: accept;
        }
    }

    state parse_sinet_extend_dst_graft9 {
        packet.extract(hdr.sinet_extend_dst_graft9);
        //24 bits
        meta.sinetAddr_dst[7:0] = hdr.sinet_extend_dst_graft9.dstAddr[23:16];
        transition select(hdr.sinet_extend_dst_graft9.next_header) {
            default: accept;
        }
    }

    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition accept;
    }
}

/*************************************************************************
**************** C H E C K S U M V E R I F I C A T I O N *****************
*************************************************************************/
control BlackBoxVerifyChecksum(inout headers hdr, inout metadata meta) {   
    apply { }
}


/*************************************************************************
******************* I N G R E S S P R O C E S S I N G ********************
*************************************************************************/
control BlackBoxIngress(inout headers hdr,
                  inout metadata meta,
                  inout standard_metadata_t standard_metadata) {
    
    action drop() {
        mark_to_drop();
    }
    
    //para: dst_mac_addr, src_sinet_length, src_sinet_addr, dst_sinet_length, dst_sinet_addr, port(output)
    action ipv4_sinet_forward(macAddr_t dst_mac_addr, sinetAddrLength_t src_sinet_length, sinetAddr_t src_sinet_addr, sinetAddrLength_t dst_sinet_length, sinetAddr_t dst_sinet_addr, egressSpec_t port) {
        standard_metadata.egress_spec = port;
        hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = dst_mac_addr;
        hdr.sinet.srcAddr_length = src_sinet_length;
        meta.sinetAddr_src = src_sinet_addr;
        hdr.sinet.dstAddr_length = dst_sinet_length;
        meta.sinetAddr_dst = dst_sinet_addr;
        hdr.sinet.hop_limit = hdr.ipv4.ttl - 1;
    }

    //para:
    action sinet_ipv4_forward(macAddr_t dstAddr, egressSpec_t port) {
        standard_metadata.egress_spec = port;
        hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
        hdr.ethernet.dstAddr = dstAddr;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }

    table ipv4_sinet {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            ipv4_sinet_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }

   table sinet_ipv4 {
        key = {
            meta.sinetAddr_dst: lpm;
        }
        actions = {
            sinet_ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }

    apply{
        //ipv4 or sinet
        if(!hdr.sinet.isValid()) {
            hdr.sinet.setValid();
            //set nextheader: ipv4
            //hdr.sinet.next_header = 0x88;
            hdr.ethernet.etherType = TYPE_SINET;
            ipv4_sinet.apply();
        }
        else{
            hdr.sinet.setInvalid();
            if(hdr.sinet_extend_src_graft0.isValid()) {
                hdr.sinet_extend_src_graft0.setInvalid();
            }
            if(hdr.sinet_extend_src_graft1.isValid()) {
                hdr.sinet_extend_src_graft1.setInvalid();
            }
            if(hdr.sinet_extend_src_graft2.isValid()) {
                hdr.sinet_extend_src_graft2.setInvalid();
            }
            if(hdr.sinet_extend_src_graft3.isValid()) {
                hdr.sinet_extend_src_graft3.setInvalid();
            }
            if(hdr.sinet_extend_src_graft4.isValid()) {
                hdr.sinet_extend_src_graft4.setInvalid();
            }
            if(hdr.sinet_extend_src_graft5.isValid()) {
                hdr.sinet_extend_src_graft5.setInvalid();
            }
            if(hdr.sinet_extend_src_graft6.isValid()) {
                hdr.sinet_extend_src_graft6.setInvalid();
            }
            if(hdr.sinet_extend_src_graft7.isValid()) {
                hdr.sinet_extend_src_graft7.setInvalid();
            }
            if(hdr.sinet_extend_src_graft8.isValid()) {
                hdr.sinet_extend_src_graft8.setInvalid();
            }
            if(hdr.sinet_extend_src_graft9.isValid()) {
                hdr.sinet_extend_src_graft9.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft0.isValid()) {
                hdr.sinet_extend_dst_graft0.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft1.isValid()) {
                hdr.sinet_extend_dst_graft1.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft2.isValid()) {
                hdr.sinet_extend_dst_graft2.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft3.isValid()) {
                hdr.sinet_extend_dst_graft3.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft4.isValid()) {
                hdr.sinet_extend_dst_graft4.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft5.isValid()) {
                hdr.sinet_extend_dst_graft5.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft6.isValid()) {
                hdr.sinet_extend_dst_graft6.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft7.isValid()) {
                hdr.sinet_extend_dst_graft7.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft8.isValid()) {
                hdr.sinet_extend_dst_graft8.setInvalid();
            }
            if(hdr.sinet_extend_dst_graft9.isValid()) {
                hdr.sinet_extend_dst_graft9.setInvalid();
            }
            hdr.ethernet.etherType = TYPE_IPv4;
            sinet_ipv4.apply();
        }
    }
}

/*************************************************************************
******************* E G R E S S P R O C E S S I N G **********************
*************************************************************************/

control BlackBoxEgress(inout headers hdr,
                 inout metadata meta,
                 inout standard_metadata_t standard_metadata) {
    apply {
        if(hdr.sinet.isValid()) {
	    // modify the variable srcAddr length
	    if(hdr.sinet.srcAddr_length >= 239) {
	       hdr.sinet_extend_src_graft9.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft9.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft9.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft9.srcAddr[23:16] = meta.sinetAddr_src[7:0]; 
	       hdr.sinet_extend_src_graft8.setValid();
	       hdr.sinet_extend_src_graft8.next_header = 0x80;
	       hdr.sinet_extend_src_graft8.srcAddr = meta.sinetAddr_src[31:8];
	       hdr.sinet_extend_src_graft7.setValid();
	       hdr.sinet_extend_src_graft7.next_header = 0x80;
	       hdr.sinet_extend_src_graft7.srcAddr = meta.sinetAddr_src[55:32];
	       hdr.sinet_extend_src_graft6.setValid();
	       hdr.sinet_extend_src_graft6.next_header = 0x80;
	       hdr.sinet_extend_src_graft6.srcAddr = meta.sinetAddr_src[79:56];
	       hdr.sinet_extend_src_graft5.setValid();
	       hdr.sinet_extend_src_graft5.next_header = 0x80;
	       hdr.sinet_extend_src_graft5.srcAddr = meta.sinetAddr_src[103:80];
	       hdr.sinet_extend_src_graft4.setValid();
	       hdr.sinet_extend_src_graft4.next_header = 0x80;
	       hdr.sinet_extend_src_graft4.srcAddr = meta.sinetAddr_src[127:104];
	       hdr.sinet_extend_src_graft3.setValid();
	       hdr.sinet_extend_src_graft3.next_header = 0x80;
	       hdr.sinet_extend_src_graft3.srcAddr = meta.sinetAddr_src[151:128];
	       hdr.sinet_extend_src_graft2.setValid();
	       hdr.sinet_extend_src_graft2.next_header = 0x80;
	       hdr.sinet_extend_src_graft2.srcAddr = meta.sinetAddr_src[175:152];
	       hdr.sinet_extend_src_graft1.setValid();
	       hdr.sinet_extend_src_graft1.next_header = 0x80;
	       hdr.sinet_extend_src_graft1.srcAddr = meta.sinetAddr_src[199:176];
	       hdr.sinet_extend_src_graft0.setValid();
	       hdr.sinet_extend_src_graft0.next_header = 0x80;
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else if(hdr.sinet.srcAddr_length >= 216) {
	       hdr.sinet_extend_src_graft8.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft8.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft8.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft8.srcAddr = meta.sinetAddr_src[31:8];
	       hdr.sinet_extend_src_graft7.setValid();
	       hdr.sinet_extend_src_graft7.next_header = 0x80;
	       hdr.sinet_extend_src_graft7.srcAddr = meta.sinetAddr_src[55:32];
	       hdr.sinet_extend_src_graft6.setValid();
	       hdr.sinet_extend_src_graft6.next_header = 0x80;
	       hdr.sinet_extend_src_graft6.srcAddr = meta.sinetAddr_src[79:56];
	       hdr.sinet_extend_src_graft5.setValid();
	       hdr.sinet_extend_src_graft5.next_header = 0x80;
	       hdr.sinet_extend_src_graft5.srcAddr = meta.sinetAddr_src[103:80];
	       hdr.sinet_extend_src_graft4.setValid();
	       hdr.sinet_extend_src_graft4.next_header = 0x80;
	       hdr.sinet_extend_src_graft4.srcAddr = meta.sinetAddr_src[127:104];
	       hdr.sinet_extend_src_graft3.setValid();
	       hdr.sinet_extend_src_graft3.next_header = 0x80;
	       hdr.sinet_extend_src_graft3.srcAddr = meta.sinetAddr_src[151:128];
	       hdr.sinet_extend_src_graft2.setValid();
	       hdr.sinet_extend_src_graft2.next_header = 0x80;
	       hdr.sinet_extend_src_graft2.srcAddr = meta.sinetAddr_src[175:152];
	       hdr.sinet_extend_src_graft1.setValid();
	       hdr.sinet_extend_src_graft1.next_header = 0x80;
	       hdr.sinet_extend_src_graft1.srcAddr = meta.sinetAddr_src[199:176];
	       hdr.sinet_extend_src_graft0.setValid();
	       hdr.sinet_extend_src_graft0.next_header = 0x80;
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else if(hdr.sinet.srcAddr_length >= 193) {
	       hdr.sinet_extend_src_graft7.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft7.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft7.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft7.srcAddr = meta.sinetAddr_src[55:32];
	       hdr.sinet_extend_src_graft6.setValid();
	       hdr.sinet_extend_src_graft6.next_header = 0x80;
	       hdr.sinet_extend_src_graft6.srcAddr = meta.sinetAddr_src[79:56];
	       hdr.sinet_extend_src_graft5.setValid();
	       hdr.sinet_extend_src_graft5.next_header = 0x80;
	       hdr.sinet_extend_src_graft5.srcAddr = meta.sinetAddr_src[103:80];
	       hdr.sinet_extend_src_graft4.setValid();
	       hdr.sinet_extend_src_graft4.next_header = 0x80;
	       hdr.sinet_extend_src_graft4.srcAddr = meta.sinetAddr_src[127:104];
	       hdr.sinet_extend_src_graft3.setValid();
	       hdr.sinet_extend_src_graft3.next_header = 0x80;
	       hdr.sinet_extend_src_graft3.srcAddr = meta.sinetAddr_src[151:128];
	       hdr.sinet_extend_src_graft2.setValid();
	       hdr.sinet_extend_src_graft2.next_header = 0x80;
	       hdr.sinet_extend_src_graft2.srcAddr = meta.sinetAddr_src[175:152];
	       hdr.sinet_extend_src_graft1.setValid();
	       hdr.sinet_extend_src_graft1.next_header = 0x80;
	       hdr.sinet_extend_src_graft1.srcAddr = meta.sinetAddr_src[199:176];
	       hdr.sinet_extend_src_graft0.setValid();
	       hdr.sinet_extend_src_graft0.next_header = 0x80;
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else if(hdr.sinet.srcAddr_length >= 170) {
	       hdr.sinet_extend_src_graft6.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft6.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft6.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft6.srcAddr = meta.sinetAddr_src[79:56];
	       hdr.sinet_extend_src_graft5.setValid();
	       hdr.sinet_extend_src_graft5.next_header = 0x80;
	       hdr.sinet_extend_src_graft5.srcAddr = meta.sinetAddr_src[103:80];
	       hdr.sinet_extend_src_graft4.setValid();
	       hdr.sinet_extend_src_graft4.next_header = 0x80;
	       hdr.sinet_extend_src_graft4.srcAddr = meta.sinetAddr_src[127:104];
	       hdr.sinet_extend_src_graft3.setValid();
	       hdr.sinet_extend_src_graft3.next_header = 0x80;
	       hdr.sinet_extend_src_graft3.srcAddr = meta.sinetAddr_src[151:128];
	       hdr.sinet_extend_src_graft2.setValid();
	       hdr.sinet_extend_src_graft2.next_header = 0x80;
	       hdr.sinet_extend_src_graft2.srcAddr = meta.sinetAddr_src[175:152];
	       hdr.sinet_extend_src_graft1.setValid();
	       hdr.sinet_extend_src_graft1.next_header = 0x80;
	       hdr.sinet_extend_src_graft1.srcAddr = meta.sinetAddr_src[199:176];
	       hdr.sinet_extend_src_graft0.setValid();
	       hdr.sinet_extend_src_graft0.next_header = 0x80;
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else if(hdr.sinet.srcAddr_length >= 147) {
	       hdr.sinet_extend_src_graft5.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft5.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft5.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft5.srcAddr = meta.sinetAddr_src[103:80];
	       hdr.sinet_extend_src_graft4.setValid();
	       hdr.sinet_extend_src_graft4.next_header = 0x80;
	       hdr.sinet_extend_src_graft4.srcAddr = meta.sinetAddr_src[127:104];
	       hdr.sinet_extend_src_graft3.setValid();
	       hdr.sinet_extend_src_graft3.next_header = 0x80;
	       hdr.sinet_extend_src_graft3.srcAddr = meta.sinetAddr_src[151:128];
	       hdr.sinet_extend_src_graft2.setValid();
	       hdr.sinet_extend_src_graft2.next_header = 0x80;
	       hdr.sinet_extend_src_graft2.srcAddr = meta.sinetAddr_src[175:152];
	       hdr.sinet_extend_src_graft1.setValid();
	       hdr.sinet_extend_src_graft1.next_header = 0x80;
	       hdr.sinet_extend_src_graft1.srcAddr = meta.sinetAddr_src[199:176];
	       hdr.sinet_extend_src_graft0.setValid();
	       hdr.sinet_extend_src_graft0.next_header = 0x80;
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else if(hdr.sinet.srcAddr_length >= 124) {
	       hdr.sinet_extend_src_graft4.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft4.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft4.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft4.srcAddr = meta.sinetAddr_src[127:104];
	       hdr.sinet_extend_src_graft3.setValid();
	       hdr.sinet_extend_src_graft3.next_header = 0x80;
	       hdr.sinet_extend_src_graft3.srcAddr = meta.sinetAddr_src[151:128];
	       hdr.sinet_extend_src_graft2.setValid();
	       hdr.sinet_extend_src_graft2.next_header = 0x80;
	       hdr.sinet_extend_src_graft2.srcAddr = meta.sinetAddr_src[175:152];
	       hdr.sinet_extend_src_graft1.setValid();
	       hdr.sinet_extend_src_graft1.next_header = 0x80;
	       hdr.sinet_extend_src_graft1.srcAddr = meta.sinetAddr_src[199:176];
	       hdr.sinet_extend_src_graft0.setValid();
	       hdr.sinet_extend_src_graft0.next_header = 0x80;
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else if(hdr.sinet.srcAddr_length >= 101) {
	       hdr.sinet_extend_src_graft3.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft3.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft3.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft3.srcAddr = meta.sinetAddr_src[151:128];
	       hdr.sinet_extend_src_graft2.setValid();
	       hdr.sinet_extend_src_graft2.next_header = 0x80;
	       hdr.sinet_extend_src_graft2.srcAddr = meta.sinetAddr_src[175:152];
	       hdr.sinet_extend_src_graft1.setValid();
	       hdr.sinet_extend_src_graft1.next_header = 0x80;
	       hdr.sinet_extend_src_graft1.srcAddr = meta.sinetAddr_src[199:176];
	       hdr.sinet_extend_src_graft0.setValid();
	       hdr.sinet_extend_src_graft0.next_header = 0x80;
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else if(hdr.sinet.srcAddr_length >= 78) {
	       hdr.sinet_extend_src_graft2.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft2.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft2.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft2.srcAddr = meta.sinetAddr_src[175:152];
	       hdr.sinet_extend_src_graft1.setValid();
	       hdr.sinet_extend_src_graft1.next_header = 0x80;
	       hdr.sinet_extend_src_graft1.srcAddr = meta.sinetAddr_src[199:176];
	       hdr.sinet_extend_src_graft0.setValid();
	       hdr.sinet_extend_src_graft0.next_header = 0x80;
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else if(hdr.sinet.srcAddr_length >= 55) {
	       hdr.sinet_extend_src_graft1.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft1.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft1.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft1.srcAddr = meta.sinetAddr_src[199:176];
	       hdr.sinet_extend_src_graft0.setValid();
	       hdr.sinet_extend_src_graft0.next_header = 0x80;
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else if(hdr.sinet.srcAddr_length >= 32) {
	       hdr.sinet_extend_src_graft0.setValid();
	       if(hdr.sinet.dstAddr_length >= 32) {
		   hdr.sinet_extend_src_graft0.next_header = 0x90;
	       }
	       else {
		   hdr.sinet_extend_src_graft0.next_header = 0x88;
	       }
	       hdr.sinet_extend_src_graft0.srcAddr = meta.sinetAddr_src[223:200];
	       hdr.sinet.next_header = 0x80;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }
	    else {
	       hdr.sinet.next_header = 0x88;
	       hdr.sinet.srcAddr = meta.sinetAddr_src[255:224];
	    }

	    // modify the variable srcAddr length
	    if(hdr.sinet.dstAddr_length >= 239) {
	       hdr.sinet_extend_dst_graft9.setValid();
	       hdr.sinet_extend_dst_graft9.next_header = 0x88;
	       hdr.sinet_extend_dst_graft9.dstAddr[23:16] = meta.sinetAddr_dst[7:0]; 
	       hdr.sinet_extend_dst_graft8.setValid();
	       hdr.sinet_extend_dst_graft8.next_header = 0x90;
	       hdr.sinet_extend_dst_graft8.dstAddr = meta.sinetAddr_dst[31:8];
	       hdr.sinet_extend_dst_graft7.setValid();
	       hdr.sinet_extend_dst_graft7.next_header = 0x90;
	       hdr.sinet_extend_dst_graft7.dstAddr = meta.sinetAddr_dst[55:32];
	       hdr.sinet_extend_dst_graft6.setValid();
	       hdr.sinet_extend_dst_graft6.next_header = 0x90;
	       hdr.sinet_extend_dst_graft6.dstAddr = meta.sinetAddr_dst[79:56];
	       hdr.sinet_extend_dst_graft5.setValid();
	       hdr.sinet_extend_dst_graft5.next_header = 0x90;
	       hdr.sinet_extend_dst_graft5.dstAddr = meta.sinetAddr_dst[103:80];
	       hdr.sinet_extend_dst_graft4.setValid();
	       hdr.sinet_extend_dst_graft4.next_header = 0x90;
	       hdr.sinet_extend_dst_graft4.dstAddr = meta.sinetAddr_dst[127:104];
	       hdr.sinet_extend_dst_graft3.setValid();
	       hdr.sinet_extend_dst_graft3.next_header = 0x90;
	       hdr.sinet_extend_dst_graft3.dstAddr = meta.sinetAddr_dst[151:128];
	       hdr.sinet_extend_dst_graft2.setValid();
	       hdr.sinet_extend_dst_graft2.next_header = 0x90;
	       hdr.sinet_extend_dst_graft2.dstAddr = meta.sinetAddr_dst[175:152];
	       hdr.sinet_extend_dst_graft1.setValid();
	       hdr.sinet_extend_dst_graft1.next_header = 0x90;
	       hdr.sinet_extend_dst_graft1.dstAddr = meta.sinetAddr_dst[199:176];
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x90;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else if(hdr.sinet.dstAddr_length >= 216) {
	       hdr.sinet_extend_dst_graft8.setValid();
	       hdr.sinet_extend_dst_graft8.next_header = 0x88;
	       hdr.sinet_extend_dst_graft8.dstAddr = meta.sinetAddr_dst[31:8];
	       hdr.sinet_extend_dst_graft7.setValid();
	       hdr.sinet_extend_dst_graft7.next_header = 0x90;
	       hdr.sinet_extend_dst_graft7.dstAddr = meta.sinetAddr_dst[55:32];
	       hdr.sinet_extend_dst_graft6.setValid();
	       hdr.sinet_extend_dst_graft6.next_header = 0x90;
	       hdr.sinet_extend_dst_graft6.dstAddr = meta.sinetAddr_dst[79:56];
	       hdr.sinet_extend_dst_graft5.setValid();
	       hdr.sinet_extend_dst_graft5.next_header = 0x90;
	       hdr.sinet_extend_dst_graft5.dstAddr = meta.sinetAddr_dst[103:80];
	       hdr.sinet_extend_dst_graft4.setValid();
	       hdr.sinet_extend_dst_graft4.next_header = 0x90;
	       hdr.sinet_extend_dst_graft4.dstAddr = meta.sinetAddr_dst[127:104];
	       hdr.sinet_extend_dst_graft3.setValid();
	       hdr.sinet_extend_dst_graft3.next_header = 0x90;
	       hdr.sinet_extend_dst_graft3.dstAddr = meta.sinetAddr_dst[151:128];
	       hdr.sinet_extend_dst_graft2.setValid();
	       hdr.sinet_extend_dst_graft2.next_header = 0x90;
	       hdr.sinet_extend_dst_graft2.dstAddr = meta.sinetAddr_dst[175:152];
	       hdr.sinet_extend_dst_graft1.setValid();
	       hdr.sinet_extend_dst_graft1.next_header = 0x90;
	       hdr.sinet_extend_dst_graft1.dstAddr = meta.sinetAddr_dst[199:176];
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x90;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else if(hdr.sinet.dstAddr_length >= 193) {
	       hdr.sinet_extend_dst_graft7.setValid();
	       hdr.sinet_extend_dst_graft7.next_header = 0x88;
	       hdr.sinet_extend_dst_graft7.dstAddr = meta.sinetAddr_dst[55:32];
	       hdr.sinet_extend_dst_graft6.setValid();
	       hdr.sinet_extend_dst_graft6.next_header = 0x90;
	       hdr.sinet_extend_dst_graft6.dstAddr = meta.sinetAddr_dst[79:56];
	       hdr.sinet_extend_dst_graft5.setValid();
	       hdr.sinet_extend_dst_graft5.next_header = 0x90;
	       hdr.sinet_extend_dst_graft5.dstAddr = meta.sinetAddr_dst[103:80];
	       hdr.sinet_extend_dst_graft4.setValid();
	       hdr.sinet_extend_dst_graft4.next_header = 0x90;
	       hdr.sinet_extend_dst_graft4.dstAddr = meta.sinetAddr_dst[127:104];
	       hdr.sinet_extend_dst_graft3.setValid();
	       hdr.sinet_extend_dst_graft3.next_header = 0x90;
	       hdr.sinet_extend_dst_graft3.dstAddr = meta.sinetAddr_dst[151:128];
	       hdr.sinet_extend_dst_graft2.setValid();
	       hdr.sinet_extend_dst_graft2.next_header = 0x90;
	       hdr.sinet_extend_dst_graft2.dstAddr = meta.sinetAddr_dst[175:152];
	       hdr.sinet_extend_dst_graft1.setValid();
	       hdr.sinet_extend_dst_graft1.next_header = 0x90;
	       hdr.sinet_extend_dst_graft1.dstAddr = meta.sinetAddr_dst[199:176];
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x90;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else if(hdr.sinet.dstAddr_length >= 170) {
	       hdr.sinet_extend_dst_graft6.setValid();
	       hdr.sinet_extend_dst_graft6.next_header = 0x88;
	       hdr.sinet_extend_dst_graft6.dstAddr = meta.sinetAddr_dst[79:56];
	       hdr.sinet_extend_dst_graft5.setValid();
	       hdr.sinet_extend_dst_graft5.next_header = 0x90;
	       hdr.sinet_extend_dst_graft5.dstAddr = meta.sinetAddr_dst[103:80];
	       hdr.sinet_extend_dst_graft4.setValid();
	       hdr.sinet_extend_dst_graft4.next_header = 0x90;
	       hdr.sinet_extend_dst_graft4.dstAddr = meta.sinetAddr_dst[127:104];
	       hdr.sinet_extend_dst_graft3.setValid();
	       hdr.sinet_extend_dst_graft3.next_header = 0x90;
	       hdr.sinet_extend_dst_graft3.dstAddr = meta.sinetAddr_dst[151:128];
	       hdr.sinet_extend_dst_graft2.setValid();
	       hdr.sinet_extend_dst_graft2.next_header = 0x90;
	       hdr.sinet_extend_dst_graft2.dstAddr = meta.sinetAddr_dst[175:152];
	       hdr.sinet_extend_dst_graft1.setValid();
	       hdr.sinet_extend_dst_graft1.next_header = 0x90;
	       hdr.sinet_extend_dst_graft1.dstAddr = meta.sinetAddr_dst[199:176];
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x90;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else if(hdr.sinet.dstAddr_length >= 147) {
	       hdr.sinet_extend_dst_graft5.setValid();
	       hdr.sinet_extend_dst_graft5.next_header = 0x88;
	       hdr.sinet_extend_dst_graft5.dstAddr = meta.sinetAddr_dst[103:80];
	       hdr.sinet_extend_dst_graft4.setValid();
	       hdr.sinet_extend_dst_graft4.next_header = 0x90;
	       hdr.sinet_extend_dst_graft4.dstAddr = meta.sinetAddr_dst[127:104];
	       hdr.sinet_extend_dst_graft3.setValid();
	       hdr.sinet_extend_dst_graft3.next_header = 0x90;
	       hdr.sinet_extend_dst_graft3.dstAddr = meta.sinetAddr_dst[151:128];
	       hdr.sinet_extend_dst_graft2.setValid();
	       hdr.sinet_extend_dst_graft2.next_header = 0x90;
	       hdr.sinet_extend_dst_graft2.dstAddr = meta.sinetAddr_dst[175:152];
	       hdr.sinet_extend_dst_graft1.setValid();
	       hdr.sinet_extend_dst_graft1.next_header = 0x90;
	       hdr.sinet_extend_dst_graft1.dstAddr = meta.sinetAddr_dst[199:176];
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x90;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else if(hdr.sinet.dstAddr_length >= 124) {
	       hdr.sinet_extend_dst_graft4.setValid();
	       hdr.sinet_extend_dst_graft4.next_header = 0x88;
	       hdr.sinet_extend_dst_graft4.dstAddr = meta.sinetAddr_dst[127:104];
	       hdr.sinet_extend_dst_graft3.setValid();
	       hdr.sinet_extend_dst_graft3.next_header = 0x90;
	       hdr.sinet_extend_dst_graft3.dstAddr = meta.sinetAddr_dst[151:128];
	       hdr.sinet_extend_dst_graft2.setValid();
	       hdr.sinet_extend_dst_graft2.next_header = 0x90;
	       hdr.sinet_extend_dst_graft2.dstAddr = meta.sinetAddr_dst[175:152];
	       hdr.sinet_extend_dst_graft1.setValid();
	       hdr.sinet_extend_dst_graft1.next_header = 0x90;
	       hdr.sinet_extend_dst_graft1.dstAddr = meta.sinetAddr_dst[199:176];
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x90;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else if(hdr.sinet.dstAddr_length >= 101) {
	       hdr.sinet_extend_dst_graft3.setValid();
	       hdr.sinet_extend_dst_graft3.next_header = 0x88;
	       hdr.sinet_extend_dst_graft3.dstAddr = meta.sinetAddr_dst[151:128];
	       hdr.sinet_extend_dst_graft2.setValid();
	       hdr.sinet_extend_dst_graft2.next_header = 0x90;
	       hdr.sinet_extend_dst_graft2.dstAddr = meta.sinetAddr_dst[175:152];
	       hdr.sinet_extend_dst_graft1.setValid();
	       hdr.sinet_extend_dst_graft1.next_header = 0x90;
	       hdr.sinet_extend_dst_graft1.dstAddr = meta.sinetAddr_dst[199:176];
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x90;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else if(hdr.sinet.dstAddr_length >= 78) {
	       hdr.sinet_extend_dst_graft2.setValid();
	       hdr.sinet_extend_dst_graft2.next_header = 0x88;
	       hdr.sinet_extend_dst_graft2.dstAddr = meta.sinetAddr_dst[175:152];
	       hdr.sinet_extend_dst_graft1.setValid();
	       hdr.sinet_extend_dst_graft1.next_header = 0x90;
	       hdr.sinet_extend_dst_graft1.dstAddr = meta.sinetAddr_dst[199:176];
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x90;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else if(hdr.sinet.dstAddr_length >= 55) {
	       hdr.sinet_extend_dst_graft1.setValid();
	       hdr.sinet_extend_dst_graft1.next_header = 0x88;
	       hdr.sinet_extend_dst_graft1.dstAddr = meta.sinetAddr_dst[199:176];
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x90;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else if(hdr.sinet.dstAddr_length >= 32) {
	       hdr.sinet_extend_dst_graft0.setValid();
	       hdr.sinet_extend_dst_graft0.next_header = 0x88;
	       hdr.sinet_extend_dst_graft0.dstAddr = meta.sinetAddr_dst[223:200];
	       //hdr.sinet.next_header = 0x90;
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
	    else {
	       hdr.sinet.dstAddr = meta.sinetAddr_dst[255:224];
	    }
        }
    }
}

/*************************************************************************
***************** C H E C K S U M C O M P U T A T I O N ******************
*************************************************************************/

control BlackBoxComputeChecksum(inout headers hdr, inout metadata meta) {
    apply {
        update_checksum(
            hdr.ipv4.isValid(),
                { hdr.ipv4.version,
                  hdr.ipv4.ihl,
                  hdr.ipv4.diffserv,
                  hdr.ipv4.totalLen,
                  hdr.ipv4.identification,
                  hdr.ipv4.flags,
                  hdr.ipv4.fragOffset,
                  hdr.ipv4.ttl,
                  hdr.ipv4.protocol,
                  hdr.ipv4.srcAddr,
                  hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
    }
}

/*************************************************************************
*********************** D E P A R S E R *******************************
*************************************************************************/

control BlackBoxDeparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.sinet);
        packet.emit(hdr.sinet_extend_src_graft0);
        packet.emit(hdr.sinet_extend_src_graft1);
        packet.emit(hdr.sinet_extend_src_graft2);
        packet.emit(hdr.sinet_extend_src_graft3);
        packet.emit(hdr.sinet_extend_src_graft4);
        packet.emit(hdr.sinet_extend_src_graft5);
        packet.emit(hdr.sinet_extend_src_graft6);
        packet.emit(hdr.sinet_extend_src_graft7);
        packet.emit(hdr.sinet_extend_src_graft8);
        packet.emit(hdr.sinet_extend_src_graft9);
        packet.emit(hdr.sinet_extend_dst_graft0);
        packet.emit(hdr.sinet_extend_dst_graft1);
        packet.emit(hdr.sinet_extend_dst_graft2);
        packet.emit(hdr.sinet_extend_dst_graft3);
        packet.emit(hdr.sinet_extend_dst_graft4);
        packet.emit(hdr.sinet_extend_dst_graft5);
        packet.emit(hdr.sinet_extend_dst_graft6);
        packet.emit(hdr.sinet_extend_dst_graft7);
        packet.emit(hdr.sinet_extend_dst_graft8);
        packet.emit(hdr.sinet_extend_dst_graft9);
        packet.emit(hdr.ipv4);
    }
}

/*************************************************************************
*********************** S W I T C H *******************************
*************************************************************************/
V1Switch(
BlackBoxParser(),
BlackBoxVerifyChecksum(),
BlackBoxIngress(),
BlackBoxEgress(),
BlackBoxComputeChecksum(),
BlackBoxDeparser()
) main;
