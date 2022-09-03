type Ref;
type error=bv1;
type HeaderStack = [int]Ref;
var last:[HeaderStack]Ref;
var forward:bool;
var isValid:[Ref]bool;
var emit:[Ref]bool;
var stack.index:[HeaderStack]int;
var size:[HeaderStack]int;
var drop:bool;

// Struct standard_metadata_t
var standard_metadata.ingress_port:bv9;
var standard_metadata.egress_spec:bv9;
var standard_metadata.egress_port:bv9;
var standard_metadata.instance_type:bv32;
var standard_metadata.packet_length:bv32;
var standard_metadata.enq_timestamp:bv32;
var standard_metadata.enq_qdepth:bv19;
var standard_metadata.deq_timedelta:bv32;
var standard_metadata.deq_qdepth:bv19;
var standard_metadata.ingress_global_timestamp:bv48;
var standard_metadata.egress_global_timestamp:bv48;
var standard_metadata.mcast_grp:bv16;
var standard_metadata.egress_rid:bv16;
var standard_metadata.checksum_error:bv1;
var standard_metadata.parser_error:error;
var standard_metadata.priority:bv3;
type EthernetAddress = bv48;

// Struct headers

// Header ethernet_t
var hdr.ethernet:Ref;
var hdr.ethernet.dstAddr:EthernetAddress;
var hdr.ethernet.srcAddr:EthernetAddress;
var hdr.ethernet.etherType:bv16;

// Header ipv4_t
var hdr.ipv4:Ref;
var hdr.ipv4.version:bv4;
var hdr.ipv4.ihl:bv4;
var hdr.ipv4.diffserv:bv8;
var hdr.ipv4.totalLen:bv16;
var hdr.ipv4.identification:bv16;
var hdr.ipv4.flags:bv3;
var hdr.ipv4.fragOffset:bv13;
var hdr.ipv4.ttl:bv8;
var hdr.ipv4.protocol:bv8;
var hdr.ipv4.hdrChecksum:bv16;
var hdr.ipv4.srcAddr:bv32;
var hdr.ipv4.dstAddr:bv32;

// Header tcp_t
var hdr.tcp:Ref;
var hdr.tcp.srcPort:bv16;
var hdr.tcp.dstPort:bv16;
var hdr.tcp.seqNo:bv32;
var hdr.tcp.ackNo:bv32;
var hdr.tcp.dataOffset:bv4;
var hdr.tcp.res:bv3;
var hdr.tcp.ecn:bv3;
var hdr.tcp.urg:bv1;
var hdr.tcp.ack:bv1;
var hdr.tcp.psh:bv1;
var hdr.tcp.rst:bv1;
var hdr.tcp.syn:bv1;
var hdr.tcp.fin:bv1;
var hdr.tcp.window:bv16;
var hdr.tcp.checksum:bv16;
var hdr.tcp.urgentPtr:bv16;

// Header Tcp_option_nop_h
var hdr.nop1:Ref;
var hdr.nop1.kind:bv8;

// Header Tcp_option_nop_h
var hdr.nop2:Ref;
var hdr.nop2.kind:bv8;

// Header Tcp_option_ss_e
var hdr.ss:Ref;
var hdr.ss.length:bv8;
var hdr.ss.maxSegmentSize:bv16;

// Header Tcp_option_nop_h
var hdr.nop3:Ref;
var hdr.nop3.kind:bv8;

// Header Tcp_option_sz_h
var hdr.sackw:Ref;
var hdr.sackw.length:bv8;

// Header Tcp_option_sack_e
var hdr.sack:Ref;

// Header Tcp_option_nop_h
var hdr.nop4:Ref;
var hdr.nop4.kind:bv8;

// Header Tcp_option_timestamp_e
var hdr.timestamp:Ref;
var hdr.timestamp.length:bv8;
var hdr.timestamp.tsval_msb:bv16;
var hdr.timestamp.tsval_lsb:bv16;
var hdr.timestamp.tsecr_msb:bv16;
var hdr.timestamp.tsecr_lsb:bv16;

// Struct fwd_metadata_t

// Struct metadata
var meta.bucket_id:bv16;
var meta.packet_hash:bv16;
var meta.server_id:bv16;

// Struct Tcp_option_sack_top
var free_index_value_0:bv16;
var push_index_value_0:bv16;
var pop_index_value_0:bv16;
var server_id_0:bv16;
var stored_hash_0:bv16;
var offset_0:bv16;
var offset_unit_0:bv16;

// Register bucket_counter_0
var bucket_counter_0:[bv32]bv16;
const bucket_counter_0.size:bv32;
axiom bucket_counter_0.size == 1bv32;

// Register debug_hash_0
var debug_hash_0:[bv32]bv16;
const debug_hash_0.size:bv32;
axiom debug_hash_0.size == 1bv32;

// Register index_to_hash_0
var index_to_hash_0:[bv32]bv16;
const index_to_hash_0.size:bv32;
axiom index_to_hash_0.size == 20bv32;

// Register index_to_server_id_0
var index_to_server_id_0:[bv32]bv16;
const index_to_server_id_0.size:bv32;
axiom index_to_server_id_0.size == 20bv32;

// Register free_indices_0
var free_indices_0:[bv32]bv16;
const free_indices_0.size:bv32;
axiom free_indices_0.size == 20bv32;

// Register push_index_0
var push_index_0:[bv32]bv16;
const push_index_0.size:bv32;
axiom push_index_0.size == 2bv32;

// Register pop_index_0
var pop_index_0:[bv32]bv16;
const pop_index_0.size:bv32;
axiom pop_index_0.size == 2bv32;

function {:bvbuiltin "bvsge"} bsge.bv16(left:bv16, right:bv16) returns(bool);

// Table get_server_from_bucket_0 Actionlist Declaration
type get_server_from_bucket_0.action;
const unique get_server_from_bucket_0.action.fwd : get_server_from_bucket_0.action;
var get_server_from_bucket_0.action_run : get_server_from_bucket_0.action;
var get_server_from_bucket_0.hit : bool;

// Table get_server_from_id_0 Actionlist Declaration
type get_server_from_id_0.action;
const unique get_server_from_id_0.action.fwd_2 : get_server_from_id_0.action;
var get_server_from_id_0.action_run : get_server_from_id_0.action;
var get_server_from_id_0.hit : bool;

function {:bvbuiltin "bvadd"} add.bv16(left:bv16, right:bv16) returns(bv16);

// Control MyComputeChecksum
procedure {:inline 1} MyComputeChecksum()
{
}

// Control MyEgress
procedure {:inline 1} MyEgress()
{
}

// Control MyIngress
procedure {:inline 1} MyIngress()
	modifies bucket_counter_0, debug_hash_0, drop, forward, free_index_value_0, free_indices_0, get_server_from_bucket_0.action_run, get_server_from_id_0.action_run, hdr.ethernet.dstAddr, hdr.ipv4.dstAddr, hdr.ipv4.srcAddr, hdr.timestamp.tsecr_lsb, index_to_hash_0, index_to_server_id_0, meta.bucket_id, meta.packet_hash, meta.server_id, offset_0, offset_unit_0, pop_index_0, pop_index_value_0, push_index_0, push_index_value_0, server_id_0, standard_metadata.egress_spec, stored_hash_0;
{
    offset_0 := 0bv16;
    offset_unit_0 := 0bv16;
    server_id_0 := 0bv16;
    if(isValid[hdr.ipv4]){
        if((hdr.ipv4.dstAddr) == (167772414bv32)){
            if(isValid[hdr.tcp]){
                call compute_packet_hash(hdr.ipv4.srcAddr, hdr.tcp.dstPort, hdr.tcp.srcPort, hdr.ipv4.protocol);
                if((meta.packet_hash[1:0]) == (1bv1)){
                    offset_0 := 10bv16;
                    offset_unit_0 := 1bv16;
                }
                if((hdr.tcp.syn) == (0bv1)){
                    // read
                    stored_hash_0 := index_to_hash_0.read(index_to_hash_0, 0bv16++add.bv16(hdr.timestamp.tsecr_lsb, offset_0));
                    if((meta.packet_hash) != (stored_hash_0)){
                        call mark_to_drop();
                    }
                    else{
                        // read
                        meta.server_id := index_to_server_id_0.read(index_to_server_id_0, 0bv16++add.bv16(hdr.timestamp.tsecr_lsb, offset_0));
                        call get_server_from_id_0.apply();
                        if((hdr.tcp.fin) == (1bv1)){
                            // read
                            push_index_value_0 := push_index_0.read(push_index_0, 0bv16++offset_unit_0);
                            // write
                            call free_indices_0.write(0bv16++add.bv16(push_index_value_0, offset_0), hdr.timestamp.tsecr_lsb);
                            push_index_value_0 := add.bv16(push_index_value_0, 1bv16);
                            if((push_index_value_0) == (add.bv16(10bv16, offset_0))){
                                push_index_value_0 := offset_0;
                            }
                            // write
                            call push_index_0.write(0bv16++offset_unit_0, push_index_value_0);
                            // write
                            call index_to_hash_0.write(0bv16++add.bv16(hdr.timestamp.tsecr_lsb, offset_0), 65535bv16);
                            // write
                            call index_to_server_id_0.write(0bv16++add.bv16(hdr.timestamp.tsecr_lsb, offset_0), 65535bv16);
                        }
                    }
                }
                else{
                    // read
                    meta.bucket_id := bucket_counter_0.read(bucket_counter_0, 0bv32);
                    call get_server_from_bucket_0.apply();
                    meta.bucket_id := add.bv16(meta.bucket_id, 1bv16);
                    if((meta.bucket_id) == (6bv16)){
                        meta.bucket_id := 0bv16;
                    }
                    // write
                    call bucket_counter_0.write(0bv32, meta.bucket_id);
                    // read
                    pop_index_value_0 := pop_index_0.read(pop_index_0, 0bv16++offset_unit_0);
                    // read
                    free_index_value_0 := free_indices_0.read(free_indices_0, 0bv16++add.bv16(pop_index_value_0, offset_0));
                    // write
                    call free_indices_0.write(0bv16++add.bv16(pop_index_value_0, offset_0), 65535bv16);
                    pop_index_value_0 := add.bv16(pop_index_value_0, 1bv16);
                    if((pop_index_value_0) == (add.bv16(10bv16, offset_0))){
                        pop_index_value_0 := offset_0;
                    }
                    // write
                    call pop_index_0.write(0bv16++offset_unit_0, pop_index_value_0);
                    // write
                    call index_to_hash_0.write(0bv16++add.bv16(free_index_value_0, offset_0), meta.packet_hash);
                    // write
                    call index_to_server_id_0.write(0bv16++add.bv16(free_index_value_0, offset_0), server_id_0);
                    hdr.timestamp.tsecr_lsb := free_index_value_0;
                }
            }
        }
        else{
            if(isValid[hdr.tcp]){
                standard_metadata.egress_spec := 1bv9;
                forward := true;
                hdr.ethernet.dstAddr := 167772161bv48;
                hdr.ipv4.srcAddr := 167772414bv32;
            }
        }
    }
}

// Parser MyParser
procedure {:inline 1} MyParser()
	modifies drop, isValid;
{
    goto State$start;

        State$start:
    call packet_in.extract(hdr.ethernet);
    goto State$start$parse_ipv4_2, State$start$DEFAULT;
    
State$start$parse_ipv4_2:
    assume (hdr.ethernet.etherType == 2048bv16);
    goto State$parse_ipv4;

    State$start$DEFAULT:
    assume(!(hdr.ethernet.etherType == 2048bv16));
    goto State$accept;

        State$parse_ipv4:
    call packet_in.extract(hdr.ipv4);
    goto State$parse_ipv4$parse_tcp_2, State$parse_ipv4$DEFAULT;
    
State$parse_ipv4$parse_tcp_2:
    assume (hdr.ipv4.protocol == 6bv8);
    goto State$parse_tcp;

    State$parse_ipv4$DEFAULT:
    assume(!(hdr.ipv4.protocol == 6bv8));
    goto State$accept;

        State$parse_tcp:
    call packet_in.extract(hdr.tcp);
    call packet_in.extract(hdr.nop1);
    goto State$parse_tcp$parse_nop_5, State$parse_tcp$parse_ss_4, State$parse_tcp$parse_sack_3, State$parse_tcp$parse_ts_2, State$parse_tcp$DEFAULT;
    
State$parse_tcp$parse_nop_5:
    assume (hdr.nop1.kind == 1bv8);
    goto State$parse_nop;
    
State$parse_tcp$parse_ss_4:
    assume (hdr.nop1.kind == 2bv8);
    goto State$parse_ss;
    
State$parse_tcp$parse_sack_3:
    assume (hdr.nop1.kind == 4bv8);
    goto State$parse_sack;
    
State$parse_tcp$parse_ts_2:
    assume (hdr.nop1.kind == 8bv8);
    goto State$parse_ts;

    State$parse_tcp$DEFAULT:
    assume(!(hdr.nop1.kind == 1bv8)&&!(hdr.nop1.kind == 2bv8)&&!(hdr.nop1.kind == 4bv8)&&!(hdr.nop1.kind == 8bv8));
    goto State$accept;

        State$parse_nop:
    call packet_in.extract(hdr.nop2);
    goto State$parse_nop$parse_nop2_3, State$parse_nop$parse_ts_2, State$parse_nop$DEFAULT;
    
State$parse_nop$parse_nop2_3:
    assume (hdr.nop2.kind == 1bv8);
    goto State$parse_nop2;
    
State$parse_nop$parse_ts_2:
    assume (hdr.nop2.kind == 8bv8);
    goto State$parse_ts;

    State$parse_nop$DEFAULT:
    assume(!(hdr.nop2.kind == 1bv8)&&!(hdr.nop2.kind == 8bv8));
    goto State$accept;

        State$parse_nop2:
    call packet_in.extract(hdr.nop3);
    goto State$parse_nop2$parse_ts_2, State$parse_nop2$DEFAULT;
    
State$parse_nop2$parse_ts_2:
    assume (hdr.nop3.kind == 8bv8);
    goto State$parse_ts;

    State$parse_nop2$DEFAULT:
    assume(!(hdr.nop3.kind == 8bv8));
    goto State$accept;

        State$parse_ss:
    call packet_in.extract(hdr.ss);
    call packet_in.extract(hdr.nop3);
    goto State$parse_ss$parse_sack_3, State$parse_ss$parse_ts_2, State$parse_ss$DEFAULT;
    
State$parse_ss$parse_sack_3:
    assume (hdr.nop3.kind == 4bv8);
    goto State$parse_sack;
    
State$parse_ss$parse_ts_2:
    assume (hdr.nop3.kind == 8bv8);
    goto State$parse_ts;

    State$parse_ss$DEFAULT:
    assume(!(hdr.nop3.kind == 4bv8)&&!(hdr.nop3.kind == 8bv8));
    goto State$accept;

        State$parse_sack:
    call packet_in.extract(hdr.sackw);
    call packet_in.extract(hdr.sack);
    call packet_in.extract(hdr.nop4);
    goto State$parse_sack$parse_ts_2, State$parse_sack$DEFAULT;
    
State$parse_sack$parse_ts_2:
    assume (hdr.nop4.kind == 8bv8);
    goto State$parse_ts;

    State$parse_sack$DEFAULT:
    assume(!(hdr.nop4.kind == 8bv8));
    goto State$accept;

        State$parse_ts:
    call packet_in.extract(hdr.timestamp);
    goto State$accept;

    State$accept:
    call accept();
    goto Exit;

    State$reject:
    call reject();
    goto Exit;

    Exit:
}

// Control MyVerifyChecksum
procedure {:inline 1} MyVerifyChecksum()
{
}

// Action NoAction_0
procedure {:inline 1} NoAction_0()
{
}

// Action NoAction_3
procedure {:inline 1} NoAction_3()
{
}
procedure {:inline 1} accept()
{
}
procedure {:inline 1} bucket_counter_0.init();
    ensures(forall idx:bv32:: bucket_counter_0[idx]==0bv16);
	modifies bucket_counter_0;
function bucket_counter_0.read(reg:[bv32]bv16, index:bv32)returns (bv16) {reg[index]}
procedure {:inline 1} bucket_counter_0.write(index:bv32, value:bv16)
	modifies bucket_counter_0;
{
    bucket_counter_0[index] := value;
}
procedure clear_drop();
    ensures drop==false;
	modifies drop;
procedure clear_emit();
    ensures (forall header:Ref:: emit[header]==false);
	modifies emit;
procedure clear_forward();
    ensures forward==false;
	modifies forward;
procedure clear_valid();
    ensures (forall header:Ref:: isValid[header]==false);
	modifies isValid;

// Action compute_packet_hash
procedure {:inline 1} compute_packet_hash(ip_addr_one:bv32, tcp_port_one:bv16, tcp_port_two:bv16, ip_protocol:bv8)
	modifies debug_hash_0, meta.packet_hash;
{
    // hash
    assume(bsge.bv16(meta.packet_hash, 0bv16) && bsge.bv16(65535bv16, meta.packet_hash));
    havoc meta.packet_hash;
    // write
    call debug_hash_0.write(0bv32, meta.packet_hash);
}
procedure {:inline 1} debug_hash_0.init();
    ensures(forall idx:bv32:: debug_hash_0[idx]==0bv16);
	modifies debug_hash_0;
function debug_hash_0.read(reg:[bv32]bv16, index:bv32)returns (bv16) {reg[index]}
procedure {:inline 1} debug_hash_0.write(index:bv32, value:bv16)
	modifies debug_hash_0;
{
    debug_hash_0[index] := value;
}
procedure {:inline 1} free_indices_0.init();
    ensures(forall idx:bv32:: free_indices_0[idx]==0bv16);
	modifies free_indices_0;
function free_indices_0.read(reg:[bv32]bv16, index:bv32)returns (bv16) {reg[index]}
procedure {:inline 1} free_indices_0.write(index:bv32, value:bv16)
	modifies free_indices_0;
{
    free_indices_0[index] := value;
}

// Action fwd
procedure {:inline 1} fwd(egress_port:bv16, dip:bv32, mac_server:bv48, server_id_input:bv16)
	modifies forward, hdr.ethernet.dstAddr, hdr.ipv4.dstAddr, server_id_0, standard_metadata.egress_spec;
{
    hdr.ipv4.dstAddr := dip;
    hdr.ethernet.dstAddr := mac_server;
    standard_metadata.egress_spec := egress_port[9:0];
    forward := true;
    server_id_0 := server_id_input;
}

// Action fwd_2
procedure {:inline 1} fwd_2(egress_port:bv16, dip:bv32, mac_server:bv48)
	modifies forward, hdr.ethernet.dstAddr, hdr.ipv4.dstAddr, standard_metadata.egress_spec;
{
    hdr.ipv4.dstAddr := dip;
    hdr.ethernet.dstAddr := mac_server;
    standard_metadata.egress_spec := egress_port[9:0];
    forward := true;
}

procedure get_server_from_bucket_0.action_run.limit();
    ensures(get_server_from_bucket_0.action_run==get_server_from_bucket_0.action.fwd);
	modifies get_server_from_bucket_0.action_run;

// Table get_server_from_bucket_0
procedure {:inline 1} get_server_from_bucket_0.apply()
	modifies forward, get_server_from_bucket_0.action_run, hdr.ethernet.dstAddr, hdr.ipv4.dstAddr, meta.bucket_id, server_id_0, standard_metadata.egress_spec;
{
    var fwd.server_id_input:bv16;
    var fwd.mac_server:bv48;
    var fwd.dip:bv32;
    var fwd.egress_port:bv16;
    meta.bucket_id := meta.bucket_id;

    call get_server_from_bucket_0.apply_table_entry();
    goto action_fwd;

    action_fwd:
    assume get_server_from_bucket_0.action_run == get_server_from_bucket_0.action.fwd;
    call fwd(fwd.egress_port, fwd.dip, fwd.mac_server, fwd.server_id_input);
    goto Exit;

    Exit:
        call get_server_from_bucket_0.apply_table_exit();
}

// Table Entry get_server_from_bucket_0.apply_table_entry
procedure get_server_from_bucket_0.apply_table_entry();

// Table Exit get_server_from_bucket_0.apply_table_exit
procedure get_server_from_bucket_0.apply_table_exit();

procedure get_server_from_id_0.action_run.limit();
    ensures(get_server_from_id_0.action_run==get_server_from_id_0.action.fwd_2);
	modifies get_server_from_id_0.action_run;

// Table get_server_from_id_0
procedure {:inline 1} get_server_from_id_0.apply()
	modifies forward, get_server_from_id_0.action_run, hdr.ethernet.dstAddr, hdr.ipv4.dstAddr, meta.server_id, standard_metadata.egress_spec;
{
    var fwd_2.mac_server:bv48;
    var fwd_2.dip:bv32;
    var fwd_2.egress_port:bv16;
    meta.server_id := meta.server_id;

    call get_server_from_id_0.apply_table_entry();
    goto action_fwd_2;

    action_fwd_2:
    assume get_server_from_id_0.action_run == get_server_from_id_0.action.fwd_2;
    call fwd_2(fwd_2.egress_port, fwd_2.dip, fwd_2.mac_server);
    goto Exit;

    Exit:
        call get_server_from_id_0.apply_table_exit();
}

// Table Entry get_server_from_id_0.apply_table_entry
procedure get_server_from_id_0.apply_table_entry();

// Table Exit get_server_from_id_0.apply_table_exit
procedure get_server_from_id_0.apply_table_exit();
procedure {:inline 1} index_to_hash_0.init();
    ensures(forall idx:bv32:: index_to_hash_0[idx]==0bv16);
	modifies index_to_hash_0;
function index_to_hash_0.read(reg:[bv32]bv16, index:bv32)returns (bv16) {reg[index]}
procedure {:inline 1} index_to_hash_0.write(index:bv32, value:bv16)
	modifies index_to_hash_0;
{
    index_to_hash_0[index] := value;
}
procedure {:inline 1} index_to_server_id_0.init();
    ensures(forall idx:bv32:: index_to_server_id_0[idx]==0bv16);
	modifies index_to_server_id_0;
function index_to_server_id_0.read(reg:[bv32]bv16, index:bv32)returns (bv16) {reg[index]}
procedure {:inline 1} index_to_server_id_0.write(index:bv32, value:bv16)
	modifies index_to_server_id_0;
{
    index_to_server_id_0[index] := value;
}
procedure init.stack.index();
    ensures (forall s:HeaderStack::stack.index[s]==0);
	modifies stack.index;
procedure {:inline 1} main()
	modifies bucket_counter_0, debug_hash_0, drop, forward, free_index_value_0, free_indices_0, get_server_from_bucket_0.action_run, get_server_from_id_0.action_run, hdr.ethernet.dstAddr, hdr.ipv4.dstAddr, hdr.ipv4.srcAddr, hdr.timestamp.tsecr_lsb, index_to_hash_0, index_to_server_id_0, isValid, meta.bucket_id, meta.packet_hash, meta.server_id, offset_0, offset_unit_0, pop_index_0, pop_index_value_0, push_index_0, push_index_value_0, server_id_0, standard_metadata.egress_spec, stored_hash_0;
{
    call MyParser();
    call MyVerifyChecksum();
    call MyIngress();
    call MyEgress();
    call MyComputeChecksum();
}
procedure mainProcedure()
	modifies bucket_counter_0, debug_hash_0, drop, emit, forward, free_index_value_0, free_indices_0, get_server_from_bucket_0.action_run, get_server_from_id_0.action_run, hdr.ethernet.dstAddr, hdr.ipv4.dstAddr, hdr.ipv4.srcAddr, hdr.timestamp.tsecr_lsb, index_to_hash_0, index_to_server_id_0, isValid, meta.bucket_id, meta.packet_hash, meta.server_id, offset_0, offset_unit_0, pop_index_0, pop_index_value_0, push_index_0, push_index_value_0, server_id_0, stack.index, standard_metadata.egress_spec, stored_hash_0;
{
    call get_server_from_id_0.action_run.limit();
    call get_server_from_bucket_0.action_run.limit();
    call pop_index_0.init();
    call push_index_0.init();
    call free_indices_0.init();
    call index_to_server_id_0.init();
    call index_to_hash_0.init();
    call debug_hash_0.init();
    call bucket_counter_0.init();
    call clear_forward();
    call clear_drop();
    call clear_valid();
    call clear_emit();
    call init.stack.index();
    call main();
    assert(forward || drop);
}
procedure mark_to_drop();
    ensures drop==true;
	modifies drop;
procedure packet_in.extract(header:Ref);
    ensures (isValid[header] == true);
	modifies isValid;
procedure {:inline 1} pop_index_0.init();
    ensures(forall idx:bv32:: pop_index_0[idx]==0bv16);
	modifies pop_index_0;
function pop_index_0.read(reg:[bv32]bv16, index:bv32)returns (bv16) {reg[index]}
procedure {:inline 1} pop_index_0.write(index:bv32, value:bv16)
	modifies pop_index_0;
{
    pop_index_0[index] := value;
}
procedure {:inline 1} push_index_0.init();
    ensures(forall idx:bv32:: push_index_0[idx]==0bv16);
	modifies push_index_0;
function push_index_0.read(reg:[bv32]bv16, index:bv32)returns (bv16) {reg[index]}
procedure {:inline 1} push_index_0.write(index:bv32, value:bv16)
	modifies push_index_0;
{
    push_index_0[index] := value;
}
procedure reject();
    ensures drop==true;
	modifies drop;
procedure {:inline 1} setInvalid(header:Ref);
    ensures (isValid[header] == false);
	modifies isValid;
procedure {:inline 1} setValid(header:Ref);
