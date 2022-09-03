// ###############################################
// #** DDoS Collaborative Mitigation Mechanism **#
// ###############################################

/* -*- P4_16 -*- */
#include <core.p4>
#include <v1model.p4>

#define ETHERTYPE_IPV4 0x0800
#define PROTOCOL_DDOSD 0xFD /** 253 - Used for experimentation and testing (RFC 3692 - Chap. 2.1) */

#define CS_WIDTH 976
#define HHD 1400
#define TOP 8192 /* Number of IP address to share into alarm packet*/
#define SUSPECT_THRESH 82 /* Value to determine suspect IP address*/
#define DROP_PERCENT 30 /* Value of allowed suspect IP adreesses percent */

const bit<32> NORMAL = 0;
const bit<32> CLONE = 2; // PKT_INSTANCE_TYPE_EGRESS_CLONE 2
const bit<32> RECIRCULATED = 4; //PKT_INSTANCE_TYPE_INGRESS_RECIRC 4
const bit<32> RESUBMIT = 6; //PKT_INSTANCE_TYPE_RESUBMIT 6

/*************************************************************************
*********************** H E A D E R S  ***********************************
*************************************************************************/

typedef bit<9>  egressSpec_t;
typedef bit<48> macAddr_t;
typedef bit<32> ip4Addr_t;

header ethernet_t {
    macAddr_t dstAddr;
    macAddr_t srcAddr;
    bit<16>   ether_type;
}

header ipv4_t {
    bit<4>    version;
    bit<4>    ihl;
    bit<6>    dscp;
    bit<2>    ecn;
    bit<16>   total_len;
    bit<16>   identification;
    bit<3>    flags;
    bit<13>   frag_offset;
    bit<8>    ttl;
    bit<8>    protocol;
    bit<16>   hdr_checksum;
    ip4Addr_t srcAddr;
    ip4Addr_t dstAddr;
}

// EtherType 0xFD
header ddosd_t {
    bit<32> pkt_num;
    bit<32> src_entropy;
    bit<32> src_ewma;
    bit<32> src_ewmmd;
    bit<32> dst_entropy;
    bit<32> dst_ewma;
    bit<32> dst_ewmmd;
    bit<8> alarm;
    bit<8> protocol;
    bit<16> count_ip;
}

header alarm_t {
    ip4Addr_t ip_alarm;
}

struct metadata {
    bit<16> parser_count; /* Number of headers to parser */
    bit<16> parser_remaining; /* Number of packet remaining for parser */
    int<32> ip_count; /* Number of ip address into alarm packet */
    bit<32> entropy_term;
    bit<32> pkt_num; /* The packet number within the observation window (always equal to m) */
    bit<32> src_entropy; /* The last observation window entropy of source IP addresses (scaled by 2^4) */
    bit<32> src_ewma; /* The current EWMA for the entropy of source IP address (scaled by 2^18) */
    bit<32> src_ewmmd; /* The current EWMMD for the entropy of source IP address (scaled by 2^18) */
    bit<32> dst_entropy; /* The last observation window entropy of destination IP addresses (scaled by 2^4) */
    bit<32> dst_ewma;  /* The current EWMA for the entropy of destination IP address (scaled by 2^18) */
    bit<32> dst_ewmmd; /* The current EWMMD for the entropy of destination IP address (scaled by 2^18) */
    bit<8> alarm; /* It is set to 0x01 to indicate the detection of a DDoS attack */
    bit<8> key; /* Key for share alarm packet - session ID */
    bit<8> key_write_ip;
    bit<8> key_write_ip_notif;
    bit<8> mirror_session_id; /* Mirror session */
    bit<8> trigow; /* Status of observation window 1:Finished */
    bit<8> first_device; /* Network device identifier 0:Core, 1:Edge */
    bit<8> features; /* Indicates switch features */
    bit<8> attack; /* Network device status 0:Only Forwarding, 1:Mechanism running, 2:Mechanism running and k halved */
    bit<48> timestamp; /* Ingress timestamp to generate hash and filtering malicious traffic */
    bit<48> timestamp_hashed; /* Hash of timestamp for filtering */
    bit<32> hhd_key_carried; /* Key packet */
    bit<32> hhd_count_carried; /* Counter for packet key */
    bit<32> hhd_ow_carried; /* Observation window for packet key */
    bit<32> hhd_owing_carried; /* Ingress observation window for key*/
    bit<32> hhd_index; /* Table slot based on hash function */
    bit<32> hhd_key_table; /* IP address in table */
    bit<32> hhd_count_table; /* Counter value in table */
    bit<32> hhd_ow_table; /* Observation window value in table */
    bit<32> hhd_owing_table; /* Windows when key begins counting */
    bit<32> hhd_key_swap; /* Swap key carried and key in table */
    bit<32> hhd_count_swap; /* Swap counter carried and table */
    bit<32> hhd_ow_swap; /* Observation window carried and table */
    bit<32> hhd_owing_swap; /* Ingress observation window carried in table*/
    bit<32> hhd_swapped; /* Indicator if IP was swapped in previous stage */
    //bit<32> hhd_thresh; /* Heavy Hitter Threshold */
    bit<32> training_len; /*To know when training_len Finished*/
    bit<32> hhd_index_total; /* Position of Heavy Hitter global register */
    bit<32> hhd_aux_index_total; /* Position of Heavy Hitter global register when alarm detected */
    bit<32> hhd_write_key; /* Key readed from Heavy Hitter global register for write in alarm packet */
    bit<32> ow; /* Current observation Window*/
    bit<9> egress_port; /* Recirculated packet egrees port */
    bit<1> recirculated; /* Value to know in egress if packet from ingress is recirculated originally */
    bit<9> ack_port; /* Port wich switch is circulating ack responses, for non register as heavy hitter */
    bit<9> ingress_port; /* Port on which the packet arrived */
    bit<16> sl_position; /* Header stack position to read ip address in alarm packet */
    bit<32> trigsl; /* Trigger when alarm packet with ip addresses is received */
    bit<32> sl_address; /* Address to include into Suspect List */
    bit<32> sl_index; /* Suspect List index when write*/
    bit<32> alarm_pktin; /* Alarm packet received */
    bit<32> alarm_pktout; /* Alarm packet generated into switch */
    bit<32> sl_source; /* IP source address to verify in Suspect List*/
    bit<32> sl_ind; /* Suspect List index when read*/
    bit<32> sl_read; /* IP address readed from Suspect List*/
    bit<32> il_read; /* IP address readed from Inspection List*/

}

struct headers {
    ethernet_t   ethernet;
    ipv4_t       ipv4;
    ddosd_t      ddosd;
    alarm_t[TOP] alarm;
}

/*************************************************************************
*********************** P A R S E R  ***********************************
*************************************************************************/

parser ParserImpl(packet_in pkt,out headers hdr,inout metadata meta,inout standard_metadata_t standard_metadata) {

    state start {
	    pkt.extract(hdr.ethernet);
	    transition select(hdr.ethernet.ether_type){
            ETHERTYPE_IPV4: parse_ipv4;
	        default: accept;
        }
    }

    state parse_ipv4 {
        pkt.extract(hdr.ipv4);
        transition select(hdr.ipv4.protocol){
            PROTOCOL_DDOSD: parse_ddosd;
            default: accept;
        }
    }

    state parse_ddosd {
        pkt.extract(hdr.ddosd);
        meta.parser_remaining = hdr.ddosd.count_ip;
        transition select(meta.parser_remaining) {
            0: accept;
            default: parse_alarm;
        }
    }

    state parse_alarm {
        pkt.extract(hdr.alarm.next);
        meta.parser_remaining = meta.parser_remaining - 1;
        transition select(meta.parser_remaining) {
            0: accept;
            default: parse_alarm;
        }
    }
}

/*************************************************************************
************   C H E C K S U M    V E R I F I C A T I O N   *************
*************************************************************************/

control MyVerifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
          verify_checksum(true, {hdr.ipv4.version, hdr.ipv4.ihl, hdr.ipv4.dscp, hdr.ipv4.ecn, hdr.ipv4.total_len, hdr.ipv4.identification, hdr.ipv4.flags, hdr.ipv4.frag_offset, hdr.ipv4.ttl, hdr.ipv4.protocol, hdr.ipv4.srcAddr, hdr.ipv4.dstAddr}, hdr.ipv4.hdr_checksum, HashAlgorithm.csum16);
    }
}

/*************************************************************************
**************  I N G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyIngress(inout headers hdr,inout metadata meta,inout standard_metadata_t standard_metadata) {

    // Observation Window Parameters
    register<bit<5>>(1) log2_m;
    register<bit<32>>(1) training_len;

    // Observation Window Control
    register<bit<32>>(1) ow_counter;
    register<bit<32>>(1) pkt_counter;

    // Count Sketch Counters
    register<int<32>>(CS_WIDTH) src_cs1;
    register<int<32>>(CS_WIDTH) src_cs2;
    register<int<32>>(CS_WIDTH) src_cs3;
    register<int<32>>(CS_WIDTH) src_cs4;
    register<int<32>>(CS_WIDTH) dst_cs1;
    register<int<32>>(CS_WIDTH) dst_cs2;
    register<int<32>>(CS_WIDTH) dst_cs3;
    register<int<32>>(CS_WIDTH) dst_cs4;

    // Count Sketch Observation Window Annotation
    register<bit<8>>(CS_WIDTH) src_cs1_ow;
    register<bit<8>>(CS_WIDTH) src_cs2_ow;
    register<bit<8>>(CS_WIDTH) src_cs3_ow;
    register<bit<8>>(CS_WIDTH) src_cs4_ow;
    register<bit<8>>(CS_WIDTH) dst_cs1_ow;
    register<bit<8>>(CS_WIDTH) dst_cs2_ow;
    register<bit<8>>(CS_WIDTH) dst_cs3_ow;
    register<bit<8>>(CS_WIDTH) dst_cs4_ow;

    // Entropy Norms - Fixed point representation: 28 integer bits, 4 fractional bits.
    register<bit<32>>(1) src_S;
    register<bit<32>>(1) dst_S;

    // Entropy EWMA and EWMMD - Fixed point representation: 14 integer bits, 18 fractional bits.
    register<bit<32>>(1) src_ewma;
    register<bit<32>>(1) src_ewmmd;
    register<bit<32>>(1) dst_ewma;
    register<bit<32>>(1) dst_ewmmd;

    // Smoothing and Sensitivity Coefficients
    register<bit<8>>(1) alpha;    // Fixed point representation: 0 integer bits, 8 fractional bits.
    register<bit<8>>(1) k;        // Fixed point representation: 5 integer bits, 3 fractional bits.
    register<bit<8>>(1) k_noattack; /* k value when switch is under attack */
    register<bit<8>>(1) k_attack; /* k value when switch is NOT under attack */

    // Network device status and features
    //register<bit<8>>(1) features;
    register<bit<8>>(1) device_status;
    register<bit<9>>(1) ack_port;

    //register<bit<32>>(HHD) suspectlist; // Register with IP Address to blocking


    action drop() {
        mark_to_drop(standard_metadata);
    }

    action ipv4_forward(egressSpec_t port) {
        standard_metadata.egress_spec = port;
        hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
    }

    table ipv4_lpm {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }
        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }
        size = 1024;
        default_action = drop();
    }

    action get_entropy_term(bit<32> entropy_term) {
        meta.entropy_term = entropy_term;
    }

    // The two tables below are supposed to be implemented as a single one,
    // but our target (i.e., the simple_switch) does not support two table lookups within the the same control flow.

    table src_entropy_term {
        key = {
            meta.ip_count: lpm;
        }
        actions = {
            get_entropy_term;
        }
        default_action = get_entropy_term(0);
    }

    table dst_entropy_term {
        key = {
            meta.ip_count: lpm;
        }
        actions = {
            get_entropy_term;
        }
        default_action = get_entropy_term(0);
    }

    action cs_hash(in bit<32> ipv4_addr, out bit<32> h1, out bit<32> h2, out bit<32> h3, out bit<32> h4) {
        hash(h1, HashAlgorithm.h1, 32w0, {ipv4_addr}, 32w0xffffffff);
        hash(h2, HashAlgorithm.h2, 32w0, {ipv4_addr}, 32w0xffffffff);
        hash(h3, HashAlgorithm.h3, 32w0, {ipv4_addr}, 32w0xffffffff);
        hash(h4, HashAlgorithm.h4, 32w0, {ipv4_addr}, 32w0xffffffff);
    }

    action cs_ghash(in bit<32> ipv4_addr, out int<32> g1, out int<32> g2, out int<32> g3, out int<32> g4) {
        hash(g1, HashAlgorithm.g1, 32w0, {ipv4_addr}, 32w0xffffffff);
        hash(g2, HashAlgorithm.g2, 32w0, {ipv4_addr}, 32w0xffffffff);
        hash(g3, HashAlgorithm.g3, 32w0, {ipv4_addr}, 32w0xffffffff);
        hash(g4, HashAlgorithm.g4, 32w0, {ipv4_addr}, 32w0xffffffff);

    // As ghash outputs 0 or 1, we must map 0 to -1.
        g1 = 2*g1 - 1;
        g2 = 2*g2 - 1;
        g3 = 2*g3 - 1;
        g4 = 2*g4 - 1;
    }

    action median(in int<32> x1, in int<32> x2, in int<32> x3, in int<32> x4, out int<32> y) {
      // This is why we should minimize the sketch depth: the median operator is hardcoded.
        if ((x1 <= x2 && x1 <= x3 && x1 <= x4 && x2 >= x3 && x2 >= x4) || (x2 <= x1 && x2 <= x3 && x2 <= x4 && x1 >= x3 && x1 >= x4))
            y = (x3 + x4) >> 1;
        else if ((x1 <= x2 && x1 <= x3 && x1 <= x4 && x3 >= x2 && x3 >= x4) || (x3 <= x1 && x3 <= x2 && x3 <= x4 && x1 >= x2 && x1 >= x4))
            y = (x2 + x4) >> 1;
        else if ((x1 <= x2 && x1 <= x3 && x1 <= x4 && x4 >= x2 && x4 >= x3) || (x4 <= x1 && x4 <= x2 && x4 <= x3 && x1 >= x2 && x1 >= x3))
            y = (x2 + x3) >> 1;
        else if ((x2 <= x1 && x2 <= x3 && x2 <= x4 && x3 >= x1 && x3 >= x4) || (x3 <= x1 && x3 <= x2 && x3 <= x4 && x2 >= x1 && x2 >= x4))
            y = (x1 + x4) >> 1;
        else if ((x2 <= x1 && x2 <= x3 && x2 <= x4 && x4 >= x1 && x4 >= x3) || (x4 <= x1 && x4 <= x2 && x4 <= x3 && x2 >= x1 && x2 >= x3))
            y = (x1 + x3) >> 1;
        else
            y = (x1 + x2) >> 1;
    }


    apply {

        ack_port.read(meta.ack_port, 0);
        device_status.read(meta.attack,0);
        meta.ingress_port = standard_metadata.ingress_port;
        meta.timestamp = standard_metadata.ingress_global_timestamp;

        training_len.read(meta.training_len, 0);
        ow_counter.read(meta.ow, 0);

        //To run mechanism only when alarm packet is received
        if (hdr.ipv4.isValid()){
            if (standard_metadata.instance_type == NORMAL && hdr.ipv4.protocol == 0xFD){
                // if (meta.attack == 0){
                //     device_status.write(0,1);
                // } else
                if (meta.attack == 0){
                //To adjust entropy threshold when is received alarm packet more than one time
                    bit<8> new_k;
                    k_attack.read(new_k,0);
                    k.write(0,new_k);
                    device_status.write(0,2);
                }

                if (hdr.ddosd.count_ip != 0) {
                    meta.alarm_pktin = 1;
                }
            }
        }

        if (standard_metadata.instance_type == NORMAL){
            //Initialize trigger observation window
            meta.trigow = 0;

            if (hdr.ipv4.isValid()) {
                meta.key = 0;

                // Current Observation Window
                bit<32> current_ow;
                ow_counter.read(current_ow, 0);

                // Source IP Address Frequency Estimation

                bit<32> src_h1;
                bit<32> src_h2;
                bit<32> src_h3;
                bit<32> src_h4;
                cs_hash(hdr.ipv4.srcAddr, src_h1, src_h2, src_h3, src_h4);

                int<32> src_g1;
                int<32> src_g2;
                int<32> src_g3;
                int<32> src_g4;
                cs_ghash(hdr.ipv4.srcAddr, src_g1, src_g2, src_g3, src_g4);

                bit<8> src_cs1_ow_aux;
                src_cs1_ow.read(src_cs1_ow_aux, src_h1);

                int<32> src_c1;
                if (src_cs1_ow_aux != current_ow[7:0]) {
                    src_c1 = 0;
                    src_cs1_ow.write(src_h1, current_ow[7:0]);
                } else {
                    src_cs1.read(src_c1, src_h1);
                }
                // anno_yc: src_cs1_ow[src_h1] == current_ow[7:0]

                src_c1 = src_c1 + src_g1;
                src_cs1.write(src_h1, src_c1);
                // anno_yc: src_cs1[src_h1] == src_g1 or old(src_cs1[src_h1])+src_g1

                src_c1 = src_g1*src_c1;

                // Row 2 Estimate

                bit<8> src_cs2_ow_aux;
                src_cs2_ow.read(src_cs2_ow_aux, src_h2);

                int<32> src_c2;
                if (src_cs2_ow_aux != current_ow[7:0]) {
                    src_c2 = 0;
                    src_cs2_ow.write(src_h2, current_ow[7:0]);
                } else {
                    src_cs2.read(src_c2, src_h2);
                }

                src_c2 = src_c2 + src_g2;
                src_cs2.write(src_h2, src_c2);

                src_c2 = src_g2*src_c2;

                // Row 3 Estimate

                bit<8> src_cs3_ow_aux;
                src_cs3_ow.read(src_cs3_ow_aux, src_h3);

                int<32> src_c3;
                if (src_cs3_ow_aux != current_ow[7:0]) {
                    src_c3 = 0;
                    src_cs3_ow.write(src_h3, current_ow[7:0]);
                } else {
                    src_cs3.read(src_c3, src_h3);
                }

                src_c3 = src_c3 + src_g3;
                src_cs3.write(src_h3, src_c3);

                src_c3 = src_g3*src_c3;

                // Row 4 Estimate

                bit<8> src_cs4_ow_aux;
                src_cs4_ow.read(src_cs4_ow_aux, src_h4);

                int<32> src_c4;
                if (src_cs4_ow_aux != current_ow[7:0]) {
                    src_c4 = 0;
                    src_cs4_ow.write(src_h4, current_ow[7:0]);
                } else {
                    src_cs4.read(src_c4, src_h4);
                }

                src_c4 = src_c4 + src_g4;
                src_cs4.write(src_h4, src_c4);
                src_c4 = src_g4*src_c4;

                // Count Sketch Source IP Frequency Estimate
                median(src_c1, src_c2, src_c3, src_c4, meta.ip_count);

                // LPM Table Lookup
                if (meta.ip_count > 0)
                    src_entropy_term.apply();
                else
                    meta.entropy_term = 0;

                // Source Entropy Norm Update
                bit<32> src_S_aux;
                src_S.read(src_S_aux, 0);
                src_S_aux = src_S_aux + meta.entropy_term;
                src_S.write(0, src_S_aux);


                // Destination IP Address Frequency Estimation

                bit<32> dst_h1;
                bit<32> dst_h2;
                bit<32> dst_h3;
                bit<32> dst_h4;
                cs_hash(hdr.ipv4.dstAddr, dst_h1, dst_h2, dst_h3, dst_h4);

                int<32> dst_g1;
                int<32> dst_g2;
                int<32> dst_g3;
                int<32> dst_g4;
                cs_ghash(hdr.ipv4.dstAddr, dst_g1, dst_g2, dst_g3, dst_g4);

                // Row 1 Estimate

                bit<8> dst_cs1_ow_aux;
                dst_cs1_ow.read(dst_cs1_ow_aux, dst_h1);

                int<32> dst_c1;
                if (dst_cs1_ow_aux != current_ow[7:0]) {
                  dst_c1 = 0;
                  dst_cs1_ow.write(dst_h1, current_ow[7:0]);
                } else {
                    dst_cs1.read(dst_c1, dst_h1);
                }
                dst_c1 = dst_c1 + dst_g1;
                dst_cs1.write(dst_h1, dst_c1);

                dst_c1 = dst_g1*dst_c1;

                // Row 2 Estimate

                bit<8> dst_cs2_ow_aux;
                dst_cs2_ow.read(dst_cs2_ow_aux, dst_h2);

                int<32> dst_c2;
                if (dst_cs2_ow_aux != current_ow[7:0]) {
                  dst_c2 = 0;
                  dst_cs2_ow.write(dst_h2, current_ow[7:0]);
                } else {
                  dst_cs2.read(dst_c2, dst_h2);
                }
                dst_c2 = dst_c2 + dst_g2;
                dst_cs2.write(dst_h2, dst_c2);

                dst_c2 = dst_g2*dst_c2;

                // Row 3 Estimate

                bit<8> dst_cs3_ow_aux;
                dst_cs3_ow.read(dst_cs3_ow_aux, dst_h3);

                int<32> dst_c3;
                if (dst_cs3_ow_aux != current_ow[7:0]) {
                  dst_c3 = 0;
                  dst_cs3_ow.write(dst_h3, current_ow[7:0]);
                } else {
                    dst_cs3.read(dst_c3, dst_h3);
                }
                dst_c3 = dst_c3 + dst_g3;
                dst_cs3.write(dst_h3, dst_c3);

                dst_c3 = dst_g3*dst_c3;

                // Row 4 Estimate

                bit<8> dst_cs4_ow_aux;
                dst_cs4_ow.read(dst_cs4_ow_aux, dst_h4);

                int<32> dst_c4;
                if (dst_cs4_ow_aux != current_ow[7:0]) {
                  dst_c4 = 0;
                  dst_cs4_ow.write(dst_h4, current_ow[7:0]);
                } else {
                    dst_cs4.read(dst_c4, dst_h4);
                }
                dst_c4 = dst_c4 + dst_g4;
                dst_cs4.write(dst_h4, dst_c4);

                dst_c4 = dst_g4*dst_c4;

                // Count Sketch Destination IP Frequency Estimate
                median(dst_c1, dst_c2, dst_c3, dst_c4, meta.ip_count);

                // LPM Table Lookup
                if (meta.ip_count > 0)
                  dst_entropy_term.apply();
                else
                  meta.entropy_term = 0;

                // Destination Entropy Norm Update
                bit<32> dst_S_aux;
                dst_S.read(dst_S_aux, 0);
                dst_S_aux = dst_S_aux + meta.entropy_term;
                dst_S.write(0, dst_S_aux);


                // Observation Window Size
                bit<32> m;
                bit<5> log2_m_aux;
                log2_m.read(log2_m_aux, 0);
                m = 32w1 << log2_m_aux;

                // Packet Count
                pkt_counter.read(meta.pkt_num, 0);
                meta.pkt_num = meta.pkt_num + 1;

                if (meta.pkt_num != m) {
                  pkt_counter.write(0, meta.pkt_num);
                } else {  // end of observation window
                    current_ow = current_ow + 1;
                    ow_counter.write(0, current_ow);

                    meta.src_entropy = ((bit<32>)log2_m_aux << 4) - (src_S_aux >> log2_m_aux);
                    meta.dst_entropy = ((bit<32>)log2_m_aux << 4) - (dst_S_aux >> log2_m_aux);

                    src_ewma.read(meta.src_ewma, 0);
                    src_ewmmd.read(meta.src_ewmmd, 0);
                    dst_ewma.read(meta.dst_ewma, 0);
                    dst_ewmmd.read(meta.dst_ewmmd, 0);

                    if (current_ow == 1) {
                        meta.src_ewma = meta.src_entropy << 14;
                        meta.src_ewmmd = 0;
                        meta.dst_ewma = meta.dst_entropy << 14;
                        meta.dst_ewmmd = 0;
                    } else {
                        meta.alarm = 0;
                        bit<32> training_len_aux;
                        training_len.read(training_len_aux, 0);

                        if (current_ow > training_len_aux) {
                            bit<8> k_aux;
                            k.read(k_aux, 0);

                            bit<32> src_thresh;
                            src_thresh = meta.src_ewma + ((bit<32>)k_aux*meta.src_ewmmd >> 3);

                            bit<32> dst_thresh;
                            dst_thresh = meta.dst_ewma - ((bit<32>)k_aux*meta.dst_ewmmd >> 3);

                            if ((meta.src_entropy << 14) > src_thresh || (meta.dst_entropy << 14) < dst_thresh){
                                meta.alarm = 1;
                            }

                        }

                        if (meta.alarm == 0) {
                            bit<8> alpha_aux;
                            alpha.read(alpha_aux, 0);
                            meta.src_ewma = (((bit<32>)alpha_aux*meta.src_entropy) << 6) + (((0x00000100 - (bit<32>)alpha_aux)*meta.src_ewma) >> 8);
                            if ((meta.src_entropy << 14) >= meta.src_ewma)
                                meta.src_ewmmd = (((bit<32>)alpha_aux*((meta.src_entropy << 14) - meta.src_ewma)) >> 8) + (((0x00000100 - (bit<32>)alpha_aux)*meta.src_ewmmd) >> 8);
                            else
                                meta.src_ewmmd = (((bit<32>)alpha_aux*(meta.src_ewma - (meta.src_entropy << 14))) >> 8) + (((0x00000100 - (bit<32>)alpha_aux)*meta.src_ewmmd) >> 8);

                            meta.dst_ewma = (((bit<32>)alpha_aux*meta.dst_entropy) << 6) + (((0x00000100 - (bit<32>)alpha_aux)*meta.dst_ewma) >> 8);
                            if ((meta.dst_entropy << 14) >= meta.dst_ewma)
                                meta.dst_ewmmd = (((bit<32>)alpha_aux*((meta.dst_entropy << 14) - meta.dst_ewma)) >> 8) + (((0x00000100 - (bit<32>)alpha_aux)*meta.dst_ewmmd) >> 8);
                            else
                                meta.dst_ewmmd = (((bit<32>)alpha_aux*(meta.dst_ewma - (meta.dst_entropy << 14))) >> 8) + (((0x00000100 - (bit<32>)alpha_aux)*meta.dst_ewmmd) >> 8);
                        }
                    }

                    src_ewma.write(0, meta.src_ewma);
                    src_ewmmd.write(0, meta.src_ewmmd);
                    dst_ewma.write(0, meta.dst_ewma);
                    dst_ewmmd.write(0, meta.dst_ewmmd);

                    meta.trigow = 1;

                    // Reset
                    pkt_counter.write(0, 0);
                    src_S.write(0, 0);
                    dst_S.write(0, 0);
                }
                ipv4_lpm.apply();
            } else {
                drop();
            }
        } else if (standard_metadata.instance_type == RECIRCULATED && meta.alarm_pktout == 1){
            standard_metadata.egress_spec = meta.egress_port;
            meta.recirculated = 1;
        }
    }
}

/*************************************************************************
****************  E G R E S S   P R O C E S S I N G   *******************
*************************************************************************/

control MyEgress(inout headers hdr,inout metadata meta,inout standard_metadata_t standard_metadata) {

    // Heavy Hitter Detection Index, Key and Counter for each stage
    register<bit<32>>(HHD) key_1;
    register<bit<32>>(HHD) count_1;
    register<bit<32>>(HHD) ow_ing1;
    register<bit<32>>(HHD) ow_1;
    register<bit<32>>(HHD) key_2;
    register<bit<32>>(HHD) count_2;
    register<bit<32>>(HHD) ow_ing2;
    register<bit<32>>(HHD) ow_2;
    register<bit<32>>(HHD) key_3;
    register<bit<32>>(HHD) count_3;
    register<bit<32>>(HHD) ow_ing3;
    register<bit<32>>(HHD) ow_3;
    register<bit<32>>(HHD) key_4;
    register<bit<32>>(HHD) count_4;
    register<bit<32>>(HHD) ow_ing4;
    register<bit<32>>(HHD) ow_4;
    register<bit<32>>(HHD) key_5;
    register<bit<32>>(HHD) count_5;
    register<bit<32>>(HHD) ow_ing5;
    register<bit<32>>(HHD) ow_5;
    register<bit<32>>(HHD) key_6;
    register<bit<32>>(HHD) count_6;
    register<bit<32>>(HHD) ow_ing6;
    register<bit<32>>(HHD) ow_6;
    register<bit<32>>(TOP) key_total;
    register<bit<32>>(1) index_total;

    register<bit<32>>(HHD) suspectlist; // Register with IP Address to blocking
    register<bit<32>>(HHD) inspectionlist; // Register with IP Address received into Alarm PacketIn
    register<bit<8>>(1) features; //Register indicates features of switch (1: FlowStatistics/Suspect Identificaction)

    action drop() {
        mark_to_drop(standard_metadata);
    }

    action set_session(bit<8> session_id) {
        meta.mirror_session_id = session_id;
    }

    table share_alarm {
        key = {
            meta.key: exact;
        }
        actions = {
            set_session;
        }
        default_action = set_session(0);
    }

    table share_notification {
        key = {
            meta.key: exact;
        }
        actions = {
            set_session;
        }
        default_action = set_session(0);
    }

    action write_mac_addr (macAddr_t srcAddr, macAddr_t dstAddr) {
        hdr.ethernet.srcAddr = srcAddr;
        hdr.ethernet.dstAddr = dstAddr;
    }

    table write_mac {
        key = {
            standard_metadata.egress_port: exact;
        }
        actions = {
            write_mac_addr;
            drop;
        }
        default_action = drop();
    }

    action write_ip_addr (ip4Addr_t srcAddr, ip4Addr_t dstAddr) {
        hdr.ipv4.srcAddr = srcAddr;
        hdr.ipv4.dstAddr = dstAddr;
    }

    table write_ip {
        key = {
            meta.key_write_ip: exact;
        }
        actions = {
            write_ip_addr;
            drop;
        }
        default_action = drop();
    }

    apply {

        meta.sl_source = hdr.ipv4.srcAddr;
        hash(meta.sl_ind, HashAlgorithm.d1, 32w0, {meta.sl_source}, 32w0xffffffff);
        suspectlist.read(meta.sl_read,meta.sl_ind);
        inspectionlist.read(meta.il_read,meta.sl_ind);
        features.read(meta.features,0);

        index_total.read(meta.hhd_index_total,0);

        if (meta.trigow == 1 && meta.alarm == 1){
            meta.key = meta.key + 1;
            if (meta.mirror_session_id > 0) {
                clone3(CloneType.E2E, (bit<32>) meta.mirror_session_id, { meta });
            }
        }else if (meta.trigow == 1 && meta.alarm == 0){
                        index_total.write(0,0);
        }

        if(meta.sl_source == meta.sl_read){
            hash(meta.timestamp_hashed, HashAlgorithm.crc16, 32w0, {meta.timestamp}, 32w64); /*This generates a number between 0-100 based on packet timestamp */
            if (meta.timestamp_hashed > DROP_PERCENT){
                drop(); /* Block 70% of packet if IP Address match in IP Suspect List */
            }
        }else if(meta.sl_source == meta.il_read){
            suspectlist.write(meta.sl_ind,meta.sl_source);
            key_total.write(meta.hhd_index_total,meta.sl_source);
            meta.hhd_index_total = meta.hhd_index_total + 1;
            index_total.write(0,meta.hhd_index_total);
        } else {
            if (hdr.ipv4.isValid() && meta.alarm_pktin != 1  && meta.ow > meta.training_len) {
            //if (hdr.ipv4.isValid() && meta.alarm_pktin != 1) {
                write_mac.apply();
                if (meta.trigow == 1 && meta.alarm == 1){
                    share_alarm.apply();
                    share_notification.apply();
                }

                if (standard_metadata.instance_type == NORMAL && meta.recirculated != 1 && meta.features == 1){

                    //######################################################################
                    //######################################################################
                    //         ***** FLOW STATISTICS / SUSPECT IDENTIFICATION ******
                    //######################################################################
                    //######################################################################

                    meta.hhd_key_carried = hdr.ipv4.srcAddr;
                    meta.hhd_count_carried = 1;
                    //meta.hhd_ow_carried = 0;
                    //meta.hhd_thresh = SUSPECT_THRESH;

                    hash(meta.hhd_index, HashAlgorithm.d1, 32w0, {meta.hhd_key_carried}, 32w0xffffffff);

                    // Read key and counter in slot
                    key_1.read(meta.hhd_key_table,meta.hhd_index);
                    count_1.read(meta.hhd_count_table,meta.hhd_index);
                    ow_1.read(meta.hhd_ow_table,meta.hhd_index);
                    ow_ing1.read(meta.hhd_owing_table,meta.hhd_index);

                    meta.hhd_swapped = 0;

                    

                    if (meta.hhd_owing_table != meta.ow){
                        meta.hhd_key_table = meta.hhd_key_carried;
                        meta.hhd_count_table = meta.hhd_count_carried;
                        meta.hhd_ow_table = meta.hhd_ow_carried;
                        meta.hhd_owing_table = meta.ow;
                    } else if (meta.hhd_owing_table == meta.ow){
                        if (meta.hhd_key_table == meta.hhd_key_carried){
                            meta.hhd_count_table = meta.hhd_count_table + 1;
                            if (meta.hhd_count_table > SUSPECT_THRESH && meta.hhd_index_total < TOP && meta.ack_port != meta.ingress_port && meta

                                .hhd_ow_table != meta.ow){
                                key_total.write(meta.hhd_index_total,meta.hhd_key_carried);
                                meta.hhd_index_total = meta.hhd_index_total + 1;
                                meta.hhd_ow_table = meta.ow;
                                suspectlist.write(meta.hhd_index,meta.hhd_key_carried);
                            }
                        } else {
                            meta.hhd_key_swap = meta.hhd_key_table;
                            meta.hhd_count_swap = meta.hhd_count_table;
                            meta.hhd_ow_swap = meta.hhd_ow_table;
                            meta.hhd_owing_swap = meta.hhd_owing_table;
                            meta.hhd_key_table = meta.hhd_key_carried;
                            meta.hhd_count_table = meta.hhd_count_carried;
                            meta.hhd_ow_table = meta.hhd_ow_carried;
                            meta.hhd_owing_table = meta.ow;
                            meta.hhd_key_carried = meta.hhd_key_swap;
                            meta.hhd_count_carried = meta.hhd_count_swap;
                            meta.hhd_ow_carried = meta.hhd_ow_swap;
                            meta.hhd_owing_carried = meta.hhd_owing_swap;
                            meta.hhd_swapped = 1;
                        }
                    }
                    // anno_yc: meta.hhd_owing_table == meta.ow

                    key_1.write(meta.hhd_index,meta.hhd_key_table);
                    count_1.write(meta.hhd_index,meta.hhd_count_table);
                    ow_1.write(meta.hhd_index,meta.hhd_ow_table);
                    ow_ing1.write(meta.hhd_index,meta.hhd_owing_table);

                    /* Stage 2 */
                    if (meta.hhd_swapped == 1){

                        hash(meta.hhd_index, HashAlgorithm.d2, 32w0, {meta.hhd_key_carried}, 32w0xffffffff);

                        key_2.read(meta.hhd_key_table,meta.hhd_index);
                        count_2.read(meta.hhd_count_table,meta.hhd_index);
                        ow_2.read(meta.hhd_ow_table,meta.hhd_index);
                        ow_ing2.read(meta.hhd_owing_table,meta.hhd_index);

                        meta.hhd_swapped = 1;
                        if (meta.hhd_owing_table != meta.ow){
                            meta.hhd_key_table = meta.hhd_key_carried;
                            meta.hhd_count_table = meta.hhd_count_carried;
                            meta.hhd_ow_table = meta.hhd_ow_carried;
                            meta.hhd_owing_table = meta.ow;
                        } else if (meta.hhd_owing_table == meta.ow){
                            if (meta.hhd_key_table == meta.hhd_key_carried){
                                meta.hhd_count_table = meta.hhd_count_table + 1;
                                meta.hhd_swapped = 0;
                                if (meta.hhd_count_table > SUSPECT_THRESH && meta.hhd_index_total < TOP && meta.hhd_ow_table != meta.ow && meta.ack_port != meta.ingress_port){
                                    key_total.write(meta.hhd_index_total,meta.hhd_key_carried);
                                    meta.hhd_index_total = meta.hhd_index_total + 1;
                                    meta.hhd_ow_table = meta.ow;
                                    suspec

                                    tlist.write(meta.hhd_index,meta.hhd_key_c
                                        arried);
                                }
                            } else if (meta.hhd_count_table < meta.hhd_count_carried){
                                meta.hhd_key_swap = meta.hhd_key_table;
                                meta.hhd_count_swap = meta.hhd_count_table;
                                meta.hhd_ow_swap = meta.hhd_ow_table;
                                meta.hhd_owing_swap = meta.hhd_owing_table;
                                meta.hhd_key_table = meta.hhd_key_carried;
                                meta.hhd_count_table = meta.hhd_count_carried;
                                meta.hhd_ow_table = meta.hhd_ow_carried;
                                meta.hhd_owing_table = meta.ow;
                                meta.hhd_key_carried = meta.hhd_key_swap;
                                meta.hhd_count_carried = meta.hhd_count_swap;
                                meta.hhd_ow_carried = meta.hhd_ow_swap;
                                meta.hhd_owing_carried = meta.hhd_owing_swap;
                                meta.hhd_swapped = 1;
                            }
                        }

                        key_2.write(meta.hhd_index,meta.hhd_key_table);
                        count_2.write(meta.hhd_index,meta.hhd_count_table);
                        ow_2.write(meta.hhd_index,meta.hhd_ow_table);
                        ow_ing2.write(meta.hhd_index,meta.hhd_owing_table);
                    }

                    /* Stage 3 */
                    if (meta.hhd_swapped == 1){

                        hash(meta.hhd_index, HashAlgorithm.d3, 32w0, {meta.hhd_key_carried}, 32w0xffffffff);

                        key_3.read(meta.hhd_key_table,meta.hhd_index);
                        count_3.read(meta.hhd_count_table,meta.hhd_index);
                        ow_3.read(meta.hhd_ow_table,meta.hhd_index);
                        ow_ing3.read(meta.hhd_owing_table,meta.hhd_index);

                        meta.hhd_swapped = 1;
                        if (meta.hhd_owing_table != meta.ow){
                            meta.hhd_key_table = meta.hhd_key_carried;
                            meta.hhd_count_table = meta.hhd_count_carried;
                            meta.hhd_ow_table = meta.hhd_ow_carried;
                            meta.hhd_owing_table = meta.ow;
                        } else if (meta.hhd_owing_table == meta.ow){
                            if (meta.hhd_key_table == meta.hhd_key_carried){
                                meta.hhd_count_table = meta.hhd_count_table + 1;
                                meta.hhd_swapped = 0;
                                if (meta.hhd_count_table > SUSPECT_THRESH && meta.hhd_index_total < TOP && meta.hhd_ow_table != meta.ow && meta.ack_port != meta.ingress_port){
                                    key_total.write(meta.hhd_index_total,meta.hhd_key_carried);
                                    meta.hhd_index_total = meta.hhd_index_total + 1;
                                    meta.hhd_ow_table = meta.ow;
                                    suspectlist.write(meta.hhd_index,meta.hhd_key_carried);
                                }
                            } else if (meta.hhd_count_table < meta.hhd_count_carried){
                                meta.hhd_key_swap = meta.hhd_key_table;
                                meta.hhd_count_swap = meta.hhd_count_table;
                                meta.hhd_ow_swap = meta.hhd_ow_table;
                                meta.hhd_owing_swap = meta.hhd_owing_table;
                                meta.hhd_key_table = meta.hhd_key_carried;
                                meta.hhd_count_table = meta.hhd_count_carried;
                                meta.hhd_ow_table = meta.hhd_ow_carried;
                                meta.hhd_owing_table = meta.ow;
                                meta.hhd_key_carried = meta.hhd_key_swap;
                                meta.hhd_count_carried = meta.hhd_count_swap;
                                meta.hhd_ow_carried = meta.hhd_ow_swap;
                                meta.hhd_owing_carried = meta.hhd_owing_swap;
                                meta.hhd_swapped = 1;
                            }
                        }

                        key_3.write(meta.hhd_index,meta.hhd_key_table);
                        count_3.write(meta.hhd_index,meta.hhd_count_table);
                        ow_3.write(meta.hhd_index,meta.hhd_ow_table);
                        ow_ing3.write(meta.hhd_index,meta.hhd_owing_table);
                    }

                    /* Stage 4 */
                    if (meta.hhd_swapped == 1){

                        hash(meta.hhd_index, HashAlgorithm.d4, 32w0, {meta.hhd_key_carried}, 32w0xffffffff);

                        key_4.read(meta.hhd_key_table,meta.hhd_index);
                        count_4.read(meta.hhd_count_table,meta.hhd_index);
                        ow_4.read(meta.hhd_ow_table,meta.hhd_index);
                        ow_ing4.read(meta.hhd_owing_table,meta.hhd_index);

                        meta.hhd_swapped = 1;
                        if (meta.hhd_owing_table != meta.ow){
                            meta.hhd_key_table = meta.hhd_key_carried;
                            meta.hhd_count_table = meta.hhd_count_carried;
                            meta.hhd_ow_table = meta.hhd_ow_carried;
                            meta.hhd_owing_table = meta.ow;
                        } else if (meta.hhd_owing_table == meta.ow){
                            if (meta.hhd_key_table == meta.hhd_key_carried){
                                meta.hhd_count_table = meta.hhd_count_table + 1;
                                meta.hhd_swapped = 0;
                                if (meta.hhd_count_table > SUSPECT_THRESH && meta.hhd_index_total < TOP && meta.hhd_ow_table != meta.ow && meta.ack_port != meta.ingress_port){
                                    key_total.write(meta.hhd_index_total,meta.hhd_key_carried);
                                    meta.hhd_index_total = meta.hhd_index_total + 1;
                                    meta.hhd_ow_table = meta.ow;
                                    suspectlist.write(meta.hhd_index,meta.hhd_key_carried);
                                }
                            } else if (meta.hhd_count_table < meta.hhd_count_carried){
                                meta.hhd_key_swap = meta.hhd_key_table;
                                meta.hhd_count_swap = meta.hhd_count_table;
                                meta.hhd_ow_swap = meta.hhd_ow_table;
                                meta.hhd_owing_swap = meta.hhd_owing_table;
                                meta.hhd_key_table = meta.hhd_key_carried;
                                meta.hhd_count_table = meta.hhd_count_carried;
                                meta.hhd_ow_table = meta.hhd_ow_carried;
                                meta.hhd_owing_table = meta.ow;
                                meta.hhd_key_carried = meta.hhd_key_swap;
                                meta.hhd_count_carried = meta.hhd_count_swap;
                                meta.hhd_ow_carried = meta.hhd_ow_swap;
                                meta.hhd_owing_carried = meta.hhd_owing_swap;
                                meta.hhd_swapped = 1;
                            }
                        }

                        key_4.write(meta.hhd_index,meta.hhd_key_table);
                        count_4.write(meta.hhd_index,meta.hhd_count_table);
                        ow_4.write(meta.hhd_index,meta.hhd_ow_table);
                        ow_ing4.write(meta.hhd_index,meta.hhd_owing_table);
                    }

                    /* Stage 5 */
                    if (meta.hhd_swapped == 1){

                        hash(meta.hhd_index, HashAlgorithm.d5, 32w0, {meta.hhd_key_carried}, 32w0xffffffff);

                        key_5.read(meta.hhd_key_table,meta.hhd_index);
                        count_5.read(meta.hhd_count_table,meta.hhd_index);
                        ow_5.read(meta.hhd_ow_table,meta.hhd_index);
                        ow_ing5.read(meta.hhd_owing_table,meta.hhd_index);

                        meta.hhd_swapped = 1;
                        if (meta.hhd_owing_table != meta.ow){
                            meta.hhd_key_table = meta.hhd_key_carried;
                            meta.hhd_count_table = meta.hhd_count_carried;
                            meta.hhd_ow_table = meta.hhd_ow_carried;
                            meta.hhd_owing_table = meta.ow;
                        } else if (meta.hhd_owing_table == meta.ow){
                            if (meta.hhd_key_table == meta.hhd_key_carried){
                                meta.hhd_count_table = meta.hhd_count_table + 1;
                                meta.hhd_swapped = 0;
                                if (meta.hhd_count_table > SUSPECT_THRESH && meta.hhd_index_total < TOP && meta.hhd_ow_table != meta.ow && meta.ack_port != meta.ingress_port){
                                    key_total.write(meta.hhd_index_total,meta.hhd_key_carried);
                                    meta.hhd_index_total = meta.hhd_index_total + 1;
                                    meta.hhd_ow_table= meta.ow;
                                    suspectlist.write(meta.hhd_index,meta.hhd_key_carried);
                                }
                            } else if (meta.hhd_count_table < meta.hhd_count_carried){
                                meta.hhd_key_swap = meta.hhd_key_table;
                                meta.hhd_count_swap = meta.hhd_count_table;
                                meta.hhd_ow_swap = meta.hhd_ow_table;
                                meta.hhd_owing_swap = meta.hhd_owing_table;
                                meta.hhd_key_table = meta.hhd_key_carried;
                                meta.hhd_count_table = meta.hhd_count_carried;
                                meta.hhd_ow_table = meta.hhd_ow_carried;
                                meta.hhd_owing_table = meta.ow;
                                meta.hhd_key_carried = meta.hhd_key_swap;
                                meta.hhd_count_carried = meta.hhd_count_swap;
                                meta.hhd_ow_carried = meta.hhd_ow_swap;
                                meta.hhd_owing_carried = meta.hhd_owing_swap;
                                meta.hhd_swapped = 1;
                            }
                        }

                        key_5.write(meta.hhd_index,meta.hhd_key_table);
                        count_5.write(meta.hhd_index,meta.hhd_count_table);
                        ow_5.write(meta.hhd_index,meta.hhd_ow_table);
                        ow_ing5.write(meta.hhd_index,meta.hhd_owing_table);
                    }

                    /* Stage 6 */
                    if (meta.hhd_swapped == 1){

                        hash(meta.hhd_index, HashAlgorithm.d6, 32w0, {meta.hhd_key_carried}, 32w0xffffffff);

                        key_6.read(meta.hhd_key_table,meta.hhd_index);
                        count_6.read(meta.hhd_count_table,meta.hhd_index);
                        ow_6.read(meta.hhd_ow_table,meta.hhd_index);
                        ow_ing6.read(meta.hhd_owing_table,meta.hhd_index);

                        meta.hhd_swapped = 1;
                        if (meta.hhd_owing_table != meta.ow){
                            meta.hhd_key_table = meta.hhd_key_carried;
                            meta.hhd_count_table = meta.hhd_count_carried;
                            meta.hhd_ow_table = meta.hhd_ow_carried;
                            meta.hhd_owing_table = meta.ow;
                        } else if (meta.hhd_owing_table == meta.ow){
                            if (meta.hhd_key_table == meta.hhd_key_carried){
                                meta.hhd_count_table = meta.hhd_count_table + 1;
                                meta.hhd_swapped = 0;
                                if (meta.hhd_count_table > SUSPECT_THRESH && meta.hhd_index_total < TOP && meta.hhd_ow_table != meta.ow && meta.ack_port != meta.ingress_port){
                                    key_total.write(meta.hhd_index_total,meta.hhd_key_carried);
                                    meta.hhd_index_total = meta.hhd_index_total + 1;
                                    meta.hhd_ow_table= meta.ow;
                                    suspectlist.write(meta.hhd_index,meta.hhd_key_carried);
                                }
                            } else if (meta.hhd_count_table < meta.hhd_count_carried){
                                meta.hhd_key_swap = meta.hhd_key_table;
                                meta.hhd_count_swap = meta.hhd_count_table;
                                meta.hhd_ow_swap = meta.hhd_ow_table;
                                meta.hhd_owing_swap = meta.hhd_owing_table;
                                meta.hhd_key_table = meta.hhd_key_carried;
                                meta.hhd_count_table = meta.hhd_count_carried;
                                meta.hhd_ow_table = meta.hhd_ow_carried;
                                meta.hhd_owing_table = meta.ow;
                                meta.hhd_key_carried = meta.hhd_key_swap;
                                meta.hhd_count_carried = meta.hhd_count_swap;
                                meta.hhd_ow_carried = meta.hhd_ow_swap;
                                meta.hhd_owing_carried = meta.hhd_owing_swap;
                                meta.hhd_swapped = 1;
                            }
                        }

                        key_6.write(meta.hhd_index,meta.hhd_key_table);
                        count_6.write(meta.hhd_index,meta.hhd_count_table);
                        ow_6.write(meta.hhd_index,meta.hhd_ow_table);
                        ow_ing6.write(meta.hhd_index,meta.hhd_owing_table);
                    }

                    index_total.write(0,meta.hhd_index_total);

                    //######################################################################
                    //######################################################################
                    //       ***** END FLOW STATISTICS / SUSPECT IDENTIFICATION ******
                    //######################################################################
                    //######################################################################

                } else if (standard_metadata.instance_type == CLONE) {
                    meta.key_write_ip = meta.key - 1;
                    write_ip.apply();
                    if (!hdr.ddosd.isValid()) {
                        hdr.ddosd.setValid();
                        hdr.ddosd.pkt_num = meta.pkt_num;
                        hdr.ddosd.src_entropy = meta.src_entropy;
                        hdr.ddosd.src_ewma = meta.src_ewma;
                        hdr.ddosd.src_ewmmd = meta.src_ewmmd;
                        hdr.ddosd.dst_entropy = meta.dst_entropy;
                        hdr.ddosd.dst_ewma = meta.dst_ewma;
                        hdr.ddosd.dst_ewmmd = meta.dst_ewmmd;
                        hdr.ddosd.alarm = meta.alarm;
                        hdr.ddosd.protocol = hdr.ipv4.protocol;
                        hdr.ddosd.count_ip = 0;
                        hdr.ipv4.total_len = hdr.ipv4.total_len + 32;
                        hdr.ipv4.protocol = PROTOCOL_DDOSD;
                        meta.egress_port = standard_metadata.egress_port;
                        index_total.read(meta.hhd_aux_index_total,0);
                        index_total.write(0,0);
                        meta.alarm_pktout = 1;
                        recirculate(meta);
                    } else {
                        meta.key = meta.key + 1;
                        if (meta.mirror_session_id > 0) {
                            clone3(CloneType.E2E, (bit<32>) meta.mirror_session_id, { meta });
                        }
                    }
                } else if (meta.recirculated == 1 && meta.alarm_pktout == 1){

                    if (meta.hhd_aux_index_total > 0){
                        meta.hhd_aux_index_total = meta.hhd_aux_index_total - 1;
                        key_total.read(meta.hhd_write_key,meta.hhd_aux_index_total);
                        if (meta.hhd_write_key != 0){
                            key_total.write(meta.hhd_aux_index_total,0);
                            hdr.ddosd.count_ip = hdr.ddosd.count_ip + 1;
                            hdr.alarm.push_front(1);
                            hdr.alarm[0].setValid();
                            hdr.alarm[0].ip_alarm = meta.hhd_write_key;
                            hdr.ipv4.total_len = hdr.ipv4.total_len + 4;
                            meta.egress_port = standard_metadata.egress_port;
                        }

                        recirculate(meta);
                    } else {
                        meta.key = meta.key + 1;
                        if (meta.mirror_session_id > 0) {
                            clone3(CloneType.E2E, (bit<32>) meta.mirror_session_id, { meta });
                        }
                    }
                }
            } else if (hdr.ipv4.isValid() && meta.alarm_pktin == 1){
                //Adding IP address received into inspection list
                if (hdr.ddosd.isValid()){
                    if (hdr.ipv4.protocol == 0xFD && hdr.ddosd.count_ip != 0){
                        meta.sl_address = hdr.alarm[0].ip_alarm;
                        hash(meta.sl_index, HashAlgorithm.d1, 32w0, {meta.sl_address}, 32w0xffffffff);
                        inspectionlist.write(meta.sl_index, meta.sl_address);
                        hdr.ddosd.count_ip = hdr.ddosd.count_ip - 1;
                        hdr.alarm.pop_front(1);
                        recirculate(meta);
                    }
                }
            }
        }
    }
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control MyComputeChecksum(inout headers  hdr, inout metadata meta) {
    apply {
	    update_checksum(
	        hdr.ipv4.isValid(),
                {   hdr.ipv4.version,
	                hdr.ipv4.ihl,
                    hdr.ipv4.dscp,
                    hdr.ipv4.ecn,
                    hdr.ipv4.total_len,
                    hdr.ipv4.identification,
                    hdr.ipv4.flags,
                    hdr.ipv4.frag_offset,
                    hdr.ipv4.ttl,
                    hdr.ipv4.protocol,
                    hdr.ipv4.srcAddr,
                    hdr.ipv4.dstAddr },
            hdr.ipv4.hdr_checksum,
        HashAlgorithm.csum16);
    }
}

/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control MyDeparser(packet_out pkt, in headers hdr) {
    apply {
        pkt.emit(hdr.ethernet);
        pkt.emit(hdr.ipv4);
        pkt.emit(hdr.ddosd);
        pkt.emit(hdr.alarm);
    }
}

/*************************************************************************
***********************  S W I T C H  *******************************
*************************************************************************/

V1Switch(
ParserImpl(),
MyVerifyChecksum(),
MyIngress(),
MyEgress(),
MyComputeChecksum(),
MyDeparser()
) main;
