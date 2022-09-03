/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

const bit<16> TYPE_IPV6 = 0x86DD;
const bit<16> TYPE_IPV4 = 0x800;
register< bit<32> >(1)     count;
register< bit<8> >(256)    es_box;
register< bit<8> >(256)    ds_box;
register< bit<128> >(1)    unicom_ip;
register< bit<32> >(1)     mobile_ip;
register< bit<128> >(1)    telcom_ip;
register< bit<16> >(3)     udp_port;


/*
   
*/
/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;
typedef bit<128> ip6Addr_t;


header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   etherType;
}


header ipv6_t {
    bit<4>    version;
    bit<8>    trafclass;
    bit<20>   flowlabel;
    bit<16>   payloadlen;
    bit<8>    nextheader;
    bit<8>    hoplimit;
    ip6Addr_t srcAddr;
    ip6Addr_t dstAddr;
}
    


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


header tcp_t {
    bit<16> srcport;
    bit<16> dstport;
    bit<32> sequence;
    bit<32> ackseq;
    bit<4>  headerlength;
    bit<6>  reservation;
    bit<1>  URG;
    bit<1>  ACK;
    bit<1>  PSH;
    bit<1>  RST;
    bit<1>  SYN;
    bit<1>  FIN;
    bit<16> windowsize;
    bit<16> checksum;
    bit<16> pointer;
}

header udp_t {
    bit<16> srcport;
    bit<16> dstport;
    bit<16> userlength;
    bit<16> checksum;
}

struct metadata {
  
}

struct headers {
    ethernet_t   ethernet;
    ipv6_t       ipv6;
    ipv4_t       ipv4_tunnel;
    ipv4_t       ipv4;
    tcp_t        tcp;
    udp_t        udp_tunnel;
}

/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser MyParser(packet_in packet,
                out headers hdr,
				inout metadata meta,
                inout standard_metadata_t standard_metadata) {

    state start {
        transition parse_ethernet;
    }

    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            TYPE_IPV6: parse_ipv6;
            TYPE_IPV4: parse_select;
            default: accept;
        }
    }

    state parse_ipv6 {
        packet.extract(hdr.ipv6);
        transition select(hdr.ipv6.nextheader) {
            0x41: parse_ipv4;
            default: accept;
        }

    }

    state parse_select {
		transition select(standard_metadata.ingress_port) {
	            2: parse_myTunnel;
	    	    _: parse_ipv4;
		}
    }

    state parse_myTunnel {
		packet.extract(hdr.ipv4_tunnel);
		transition select(hdr.ipv4_tunnel.protocol) {
	    	0x11: parse_udp;
	    	default: accept;
		}
    }
    //only parse the udp tunnel
    state parse_udp {
    	packet.extract(hdr.udp_tunnel);
    	transition select(hdr.udp_tunnel.checksum) {
       	    0x0: parse_ipv4;
            default: reject;
        }
    }


    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        	transition select(hdr.ipv4.protocol){
			6: parse_tcp;
			_: accept;
		}
    }

    state parse_tcp {
		packet.extract(hdr.tcp);
		transition accept;
    }

}


/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr,inout metadata meta) {   
	apply { }
}


/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,
				  inout metadata meta,
				  inout standard_metadata_t standard_metadata) {
	
    action creatipv6(){
		hdr.ipv6.setValid();
		hdr.ipv6.version = 6;
		hdr.ipv6.payloadlen = hdr.ipv4.totalLen;
		hdr.ipv6.nextheader = 0x41;
		hdr.ipv6.hoplimit = 0x40;
		hdr.ethernet.etherType = TYPE_IPV6;

    }

    action creatmytunnel() {
		hdr.ipv4_tunnel.setValid();
		hdr.ipv4_tunnel.version = hdr.ipv4.version;
		hdr.ipv4_tunnel.ihl = 5;
		hdr.ipv4_tunnel.diffserv = hdr.ipv4.diffserv;
		hdr.ipv4_tunnel.totalLen = hdr.ipv4.totalLen+28;
		hdr.ipv4_tunnel.identification = hdr.ipv4.identification;
		hdr.ipv4_tunnel.flags = hdr.ipv4.flags;
		hdr.ipv4_tunnel.fragOffset = hdr.ipv4.fragOffset;
		hdr.ipv4_tunnel.ttl = hdr.ipv4.ttl;
		hdr.ipv4_tunnel.protocol = 0x11;
                hdr.udp_tunnel.setValid();
		hdr.udp_tunnel.srcport = 0x0050;
                hdr.udp_tunnel.userlength = hdr.ipv4.totalLen;
		hdr.udp_tunnel.checksum = 0x0000;            
    }

	
	action rewrite_ipv4(){
		mobile_ip.read(hdr.ipv4_tunnel.dstAddr,(bit<32>)0);
		hdr.ipv4_tunnel.srcAddr = 0xdbf270fb;//the ipv4 address of enp8s0f1
		hdr.ethernet.dstAddr = 0xdcda8025e301;//the mac of gw	
		hdr.ethernet.srcAddr = 0x6cb311222985;//the mac of enp8s0f1
		udp_port.read(hdr.udp_tunnel.dstport,(bit<32>)1);
	}
	action rewrite_ipv6_1(){
		unicom_ip.read(hdr.ipv6.dstAddr,(bit<32>)0);
	//	hdr.ipv6.dstAddr = 0x240884e100c8dfb2f4ffa8fffea4508d;
		hdr.ipv6.srcAddr = 0x20010da8020520606eb311fffe222984;//the ipv6 address of enp8s0f0
		hdr.ethernet.dstAddr = 0xdcda8025e301;//the mac of gw
		hdr.ethernet.srcAddr = 0x6cb311222984;//the mac of enp8s0f0
	}
	action rewrite_ipv6_2(){
		telcom_ip.read(hdr.ipv6.dstAddr,(bit<32>)0);
	//	hdr.ipv6.dstAddr = 0x240e0082f04a7c67003410fffe2df90f;
		hdr.ipv6.srcAddr = 0x20010da8020520606eb311fffe222986;//the ipv6 address of enp8s0f2
		hdr.ethernet.dstAddr = 0xdcda8025e301;//the mac of gw
		hdr.ethernet.srcAddr = 0x6cb311222986;//the mac of enp8s0f2
	}

	action read_esbox() {
		es_box.read(hdr.tcp.sequence[7:0],(bit<32>)hdr.tcp.sequence[7:0]);
		es_box.read(hdr.tcp.sequence[15:8],(bit<32>)hdr.tcp.sequence[15:8]);
		es_box.read(hdr.tcp.sequence[23:16],(bit<32>)hdr.tcp.sequence[23:16]);
		es_box.read(hdr.tcp.sequence[31:24],(bit<32>)hdr.tcp.sequence[31:24]);
		es_box.read(hdr.tcp.ackseq[7:0],(bit<32>)hdr.tcp.ackseq[7:0]);
		es_box.read(hdr.tcp.ackseq[15:8],(bit<32>)hdr.tcp.ackseq[15:8]);
		es_box.read(hdr.tcp.ackseq[23:16],(bit<32>)hdr.tcp.ackseq[23:16]);
		es_box.read(hdr.tcp.ackseq[31:24],(bit<32>)hdr.tcp.ackseq[31:24]);
    }

	bit<32> temp = 0;
	action do_read_count() {
		count.read(temp,(bit<32>)0);
	}

	apply {
		//for the user 
		// ingress_port ==0 means the packages come from web
		if(standard_metadata.ingress_port == 0){
			//processing the user packages 
			if((hdr.ethernet.dstAddr != 0xffffffffffff) && (hdr.ethernet.srcAddr != 0x0)){
				//processing the user packages
				if(hdr.tcp.isValid()){
					read_esbox();
				}
				do_read_count();
				if(temp == 0){
					creatipv6();
					rewrite_ipv6_1();
					count.write((bit<32>)0, (bit<32>)1);
					standard_metadata.egress_spec = 1;
				}
				// send the packages to egress 2
				if(temp == 1){
					creatmytunnel();
					rewrite_ipv4();
					count.write((bit<32>)0, (bit<32>)2);
					standard_metadata.egress_spec = 2;
				}
				// send the packages to egress 3
				if(temp == 2){
					creatipv6();
					rewrite_ipv6_2();
					count.write((bit<32>)0, (bit<32>)0);
					standard_metadata.egress_spec = 3;
				}
			}
		}
		// the packages come from tunnel
		else {
			if(standard_metadata.ingress_port == 1 && hdr.ipv6.nextheader == 0x41 && hdr.ipv6.srcAddr[63:0] == 0xf4ffa8fffea4508d){
				unicom_ip.write((bit<32>)0, hdr.ipv6.srcAddr);
			}else if(standard_metadata.ingress_port == 2 && hdr.udp_tunnel.isValid() && hdr.udp_tunnel.checksum == 0x0){
                                mobile_ip.write((bit<32>)0, hdr.ipv4_tunnel.srcAddr);
                                udp_port.write((bit<32>)1,hdr.udp_tunnel.srcport);	
			}else if(standard_metadata.ingress_port == 3 && hdr.ipv6.nextheader == 0x41 && hdr.ipv6.srcAddr[63:0]  == 0x003410fffe2df90f){
				telcom_ip.write((bit<32>)0, hdr.ipv6.srcAddr);
			}
		/*	if(standard_metadata.ingress_port == 2 && hdr.udp_tunnel.isValid() && hdr.udp_tunnel.checksum == 0x0){
				mobile_ip.write((bit<32>)0, hdr.ipv4_tunnel.srcAddr);
				udp_port.write((bit<32>)1,hdr.udp_tunnel.srcport);
			}*/
	    		hdr.ethernet.etherType = TYPE_IPV4;
	    		hdr.ethernet.dstAddr = 0x7a76233598a0;//the mac address of veth1
            		if(hdr.ipv4_tunnel.isValid()){
	                	hdr.ipv4_tunnel.setInvalid();
	                	hdr.udp_tunnel.setInvalid();
            		}else if(hdr.ipv6.isValid()){
                		hdr.ipv6.setInvalid();
            		}
            	standard_metadata.egress_spec = 0;
        	}
	}
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,
				 inout metadata meta,
				 inout standard_metadata_t standard_metadata) {
    action read_dsbox() {
		ds_box.read(hdr.tcp.sequence[7:0],(bit<32>)hdr.tcp.sequence[7:0]);
		ds_box.read(hdr.tcp.sequence[15:8],(bit<32>)hdr.tcp.sequence[15:8]);
		ds_box.read(hdr.tcp.sequence[23:16],(bit<32>)hdr.tcp.sequence[23:16]);
		ds_box.read(hdr.tcp.sequence[31:24],(bit<32>)hdr.tcp.sequence[31:24]);
		ds_box.read(hdr.tcp.ackseq[7:0],(bit<32>)hdr.tcp.ackseq[7:0]);
		ds_box.read(hdr.tcp.ackseq[15:8],(bit<32>)hdr.tcp.ackseq[15:8]);
		ds_box.read(hdr.tcp.ackseq[23:16],(bit<32>)hdr.tcp.ackseq[23:16]);
		ds_box.read(hdr.tcp.ackseq[31:24],(bit<32>)hdr.tcp.ackseq[31:24]);
    }
    apply {
		if(standard_metadata.egress_port == 0 && hdr.tcp.isValid()) {
			read_dsbox();
		}
	}
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers  hdr,inout metadata meta) {
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

	update_checksum(
	    hdr.ipv4_tunnel.isValid(),
            { hdr.ipv4_tunnel.version,
	      hdr.ipv4_tunnel.ihl,
              hdr.ipv4_tunnel.diffserv,
              hdr.ipv4_tunnel.totalLen,
              hdr.ipv4_tunnel.identification,
              hdr.ipv4_tunnel.flags,
              hdr.ipv4_tunnel.fragOffset,
              hdr.ipv4_tunnel.ttl,
              hdr.ipv4_tunnel.protocol,
              hdr.ipv4_tunnel.srcAddr,
              hdr.ipv4_tunnel.dstAddr },
            hdr.ipv4_tunnel.hdrChecksum,
            HashAlgorithm.csum16);		
	}
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out packet, in headers hdr) {
	apply {
        	packet.emit(hdr.ethernet);
        	packet.emit(hdr.ipv6);
		packet.emit(hdr.ipv4_tunnel);
		packet.emit(hdr.udp_tunnel);
        	packet.emit(hdr.ipv4);
		packet.emit(hdr.tcp);
	}
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
MyParser(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
