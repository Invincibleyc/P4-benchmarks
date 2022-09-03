#include <core.p4>
#include <v1model.p4>

#define MAC_LEN 48
#define IPV4_ADD_LEN 32
#define MAX_NUM_REPLICAS 3
#define STATE_WIDTH 64
#define MAX_WIN_SIZE 7
#define TIME_BIT_SIZE 48

#define NA 0
#define HIT 1
#define UPDATE_NEEDED 2

const bit<16> LODGE_ETHTYPE = 0x1234;
const bit<16> IPV4_ETHTYPE = 0x0800;
const bit<TIME_BIT_SIZE> UPDATE_INTERVAL = /*1000000000000;*/ 125000;
const bit<8> PKT_COUNTED = 0x01;
const bit<8> PKT_UNCOUNTED = 0x00;


typedef bit<9> port_t;
const port_t CPU_PORT = 255;

typedef bit<9>  egressSpec_t;
typedef bit<64> pktCount_t;

header ethernet_t {
    bit<MAC_LEN> dstAddr;
    bit<MAC_LEN> srcAddr;
    bit<16> etherType;
}

header ipv4_t {
    bit<4>  version;
    bit<4>  ihl;
    bit<8>  diffserv;
    bit<16> totalLen;
    bit<16> identification;
    bit<3>  flags;
    bit<13> fragOffset;
    bit<8>  ttl;
    bit<8>  protocol;
    bit<16> hdrChecksum;
    bit<IPV4_ADD_LEN> srcAddr;
    bit<IPV4_ADD_LEN> dstAddr;
}

header tcp_t {
    bit<16> srcPort;
    bit<16> dstPort;
    bit<32> seqNo;
    bit<32> ackNo;
    bit<4>  dataOffset;
    bit<3>  res;
    bit<3>  ecn;
    bit<6>  ctrl;
    bit<16> window;
    bit<16> checksum;
    bit<16> urgentPtr;
}

header lodge_t {
    bit<16> stateID;
    bit<32> srcSwID;
    bit<32> dstSwID; // FF if the destinbation is broadcast
    bit <STATE_WIDTH> stateVal;
    bit<16> nextHeaderType; // 0 if there is no next header
}

@controller_header("packet_in")
header packet_in_header_t {
    bit<9> ingress_port;
}

@controller_header("packet_out")
header packet_out_header_t {
    bit<9> egress_port;
}

header lodge_meta_t {
    bit<TIME_BIT_SIZE> nextUpdateTime;
    bit<32> isRemote;
}

struct headers {
    ethernet_t   ethernet;
    lodge_t     lodge;
    ipv4_t     ipv4;
    tcp_t   tcp;
    packet_out_header_t packet_out;
    packet_in_header_t packet_in;
}

/*
 * All metadata, globally used in the program, also  needs to be assembled 
 * into a single struct. As in the case of the headers, we only need to 
 * declare the type, but there is no need to instantiate it,
 * because it is done "by the architecture", i.e. outside of P4 functions
 */
 
struct metadata {
    lodge_meta_t lodge_meta;
}

/*************************************************************************
 ***********************  P A R S E R  ***********************************
 *************************************************************************/
parser Par(packet_in packet, out headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    state start {
        transition select(standard_metadata.ingress_port) {
            CPU_PORT: parse_packet_out;
            default: parse_ethernet;
        }
    }
    state parse_packet_out {
        packet.extract(hdr.packet_out);
        transition parse_ethernet;
    }
    state parse_ethernet {
        packet.extract(hdr.ethernet);
        transition select(hdr.ethernet.etherType) {
            LODGE_ETHTYPE : parse_lodge;
            IPV4_ETHTYPE : parse_ipv4;
            default      : accept;
        }
    }
    
    state parse_lodge {
        packet.extract(hdr.lodge);
        /*transition select(hdr.lodge.nextHeaderType){
            IPV4_ETHTYPE : parse_ipv4;
            default : accept;
        }*/
        transition accept;

    }
    
    state parse_ipv4 {
        packet.extract(hdr.ipv4);
        transition accept;
    }
}


/*************************************************************************
 **************  I N G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/
control c_ingress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
    register< bit<STATE_WIDTH> >(MAX_NUM_REPLICAS) remoteEstimation;
    register< bit<STATE_WIDTH> >(1) currentEstimation;
    register< bit<STATE_WIDTH> >(1) localEstimation;
    register< bit<STATE_WIDTH> >(1) globalEstimation;

    register< bit<STATE_WIDTH> >(MAX_WIN_SIZE) windowRegister;
    register< bit<TIME_BIT_SIZE> >(1) nextUpdateTimeRegister;

    action no_action(){

    }

    action set_egress(egressSpec_t newEgress) {
        standard_metadata.egress_spec = newEgress;
    }

    action set_multicast_egress(bit<16> newEgress, bit<32> thisReplicaId) {
        standard_metadata.mcast_grp = newEgress;
        bit<16> paddingBits = 0;
        hdr.ethernet.srcAddr = paddingBits++thisReplicaId;
    }

    action operation_drop() {
        mark_to_drop();
    }

    action clone_update_pkt_to_egress(port_t newEgress){
        bit<23> paddingBits = 0;
        clone(CloneType.I2E, paddingBits++newEgress);
    }

    action read_remote_lodge() {
        remoteEstimation.write(hdr.lodge.srcSwID, hdr.lodge.stateVal);
    }

    action update_local_state(){
        bit <STATE_WIDTH> currentValue;

        currentEstimation.read(currentValue, 0);
        currentEstimation.write(0, currentValue + 1);

        localEstimation.read(currentValue, 0);
        localEstimation.write(0, currentValue + 1);

        hdr.ipv4.diffserv = PKT_COUNTED;
    }

    action load_lodge_meta() {
        nextUpdateTimeRegister.read(meta.lodge_meta.nextUpdateTime, 0);
    }

    action update_estimation_window() {
        bit<STATE_WIDTH> auxiliaryVariable = 0;
        bit<STATE_WIDTH> aggregateValue = 0;

        windowRegister.read(auxiliaryVariable, 6);
        aggregateValue = aggregateValue + auxiliaryVariable;

        windowRegister.read(auxiliaryVariable, 5);
        windowRegister.write(6, auxiliaryVariable);
        aggregateValue = aggregateValue + auxiliaryVariable;

        windowRegister.read(auxiliaryVariable, 4);
        windowRegister.write(5, auxiliaryVariable);
        aggregateValue = aggregateValue + auxiliaryVariable;
        
        windowRegister.read(auxiliaryVariable, 3);
        windowRegister.write(4, auxiliaryVariable);
        aggregateValue = aggregateValue + auxiliaryVariable;

        windowRegister.read(auxiliaryVariable, 2);
        windowRegister.write(3, auxiliaryVariable);
        aggregateValue = aggregateValue + auxiliaryVariable;

        windowRegister.read(auxiliaryVariable, 1);
        windowRegister.write(2, auxiliaryVariable);
        aggregateValue = aggregateValue + auxiliaryVariable;

        windowRegister.read(auxiliaryVariable, 0);
        windowRegister.write(1, auxiliaryVariable);
        aggregateValue = aggregateValue + auxiliaryVariable;

        currentEstimation.read(auxiliaryVariable, 0);
        windowRegister.write(0, auxiliaryVariable);
        aggregateValue = aggregateValue + auxiliaryVariable;

        localEstimation.write(0, aggregateValue);

        nextUpdateTimeRegister.write(0, standard_metadata.ingress_global_timestamp + UPDATE_INTERVAL);
        currentEstimation.write(0, 0);

        remoteEstimation.read(auxiliaryVariable, 0);
        aggregateValue = aggregateValue + auxiliaryVariable;
        remoteEstimation.read(auxiliaryVariable, 1);
        aggregateValue = aggregateValue + auxiliaryVariable;
        remoteEstimation.read(auxiliaryVariable, 2);

        aggregateValue = aggregateValue + auxiliaryVariable;
        /*remoteEstimation.read(auxiliaryVariable, 3);
        aggregateValue = aggregateValue + auxiliaryVariable;
        remoteEstimation.read(auxiliaryVariable, 4);
        aggregateValue = aggregateValue + auxiliaryVariable;
        remoteEstimation.read(auxiliaryVariable, 5);
        aggregateValue = aggregateValue + auxiliaryVariable;
        */
        globalEstimation.write(0, aggregateValue);
    }

    action send_to_cpu() {
        standard_metadata.egress_spec = CPU_PORT;
        hdr.packet_in.setValid();
        hdr.packet_in.ingress_port = standard_metadata.ingress_port;
    }

    action fillLodgeHeader(bit<32> thisReplicaId){
        bit<16> paddingBits = 0;
        hdr.ipv4.setInvalid();
        hdr.lodge.setValid();
        hdr.ethernet.etherType = LODGE_ETHTYPE;
        hdr.ethernet.srcAddr = paddingBits++thisReplicaId;
        localEstimation.read(hdr.lodge.stateVal, 0);
        hdr.lodge.srcSwID = thisReplicaId;
        hdr.lodge.stateID = 1;
    }

    table lldpForwardingTable {
        key = {
            hdr.ethernet.etherType         : ternary;
        }
        actions = {
            send_to_cpu;
            operation_drop;
            no_action;
            set_egress;
        }
        default_action = no_action();
    }

    table ipv4ForwardingTable {
        key = {
            hdr.ipv4.dstAddr : lpm;
        }
        actions = {
            operation_drop;
            set_egress;
        }
        //const default_action = operation_drop();
    }

    table monitorHH {
        key = {
            hdr.ipv4.dstAddr : lpm;       
        }

        actions = {
            update_local_state;
        }
    }

    table forwardLodgeTable {
        key = {
            hdr.lodge.stateID : exact;
        }

        actions = {
            set_multicast_egress;
        }
    }

    table fillLodgeHeaderTable {
        key = {

        }

        actions = {
            fillLodgeHeader;
        }
    }

    table forwardToNearestReplica {
        key = {
        }

        actions = {
            set_egress;
        }
    }


    apply {
        int<32> lodgeState = NA;

        if (standard_metadata.ingress_port == CPU_PORT) { //PKT-OUT
            standard_metadata.egress_spec = hdr.packet_out.egress_port;
            hdr.packet_out.setInvalid();
            return;
        }
        lldpForwardingTable.apply(); // PKT-IN


        if(hdr.ipv4.isValid()){
            ipv4ForwardingTable.apply(); // Default ipv4 routing
            if( hdr.ipv4.diffserv == PKT_UNCOUNTED){ //Count uncounted packets
                if(monitorHH.apply().hit)
                    lodgeState = HIT;
                else
                    forwardToNearestReplica.apply();
            }
        }

        if(lodgeState == HIT){
            load_lodge_meta();
            if( meta.lodge_meta.nextUpdateTime < standard_metadata.ingress_global_timestamp){
                update_estimation_window();
                lodgeState = UPDATE_NEEDED;
            }
        }

        if( hdr.lodge.isValid() ){ // Read external lodge packet
            meta.lodge_meta.isRemote = 1;
            read_remote_lodge();
        }


        // Local lodge packet needs to be generated
        if( lodgeState == UPDATE_NEEDED ){
            meta.lodge_meta.isRemote = 0;
            clone_update_pkt_to_egress(standard_metadata.egress_spec); // send original packet to output
            fillLodgeHeaderTable.apply();
        }

        if( hdr.lodge.isValid() ){
            forwardLodgeTable.apply();
        }
    }
}

/*************************************************************************
 ****************  E G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/
control c_egress(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {

    action restore_diffserv() {
        hdr.ipv4.diffserv = 0x00;
    }

    table restoreDiffserv {
        key = {
            standard_metadata.egress_port : exact;
        }

        actions = {
            restore_diffserv();
        }
    }

    apply { 
        restoreDiffserv.apply();

        if(standard_metadata.ingress_port == standard_metadata.egress_port)
            mark_to_drop();
    }
}

/*************************************************************************
 *************   C H E C K S U M    C O M P U T A T I O N   **************
 *************************************************************************/

control CCheck(inout headers hdr, inout metadata meta) {
    apply { }
}

control VCheck(inout headers hdr, inout metadata meta) {
    apply { }
}

/*************************************************************************
 ***********************  D E P A R S E R  *******************************
 *************************************************************************/
control Depar(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.packet_in);
        packet.emit(hdr.ethernet);
        packet.emit(hdr.lodge);
        packet.emit(hdr.ipv4);
    }
}

/*************************************************************************
 ***********************  S W I T T C H **********************************
 *************************************************************************/

V1Switch(
Par(),
VCheck(),
c_ingress(),
c_egress(),
CCheck(),
Depar()
) main;