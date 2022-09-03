#include "includes/defines.p4"
#include "includes/existing_actions.p4"
#include "includes/intrinsic.p4"
#include "includes/metadata.p4"

action do_sqr_apply(decision_sqr_apply) {
    modify_field(meta.sqr_apply, decision_sqr_apply);
}
table sqr_apply {
    reads {
        ig_intr_md.ingress_port: exact;
        tcp.srcPort: exact;
    }
    actions {
        do_sqr_apply; nop;
    }
    size: 256;
}

action do_sqr_apply_opp(decision_sqr_apply) {
    modify_field(meta.sqr_apply, decision_sqr_apply);
}
table sqr_apply_opp {
    reads {
        ig_intr_md.ingress_port: exact;
        tcp.dstPort: exact;
    }
    actions {
        do_sqr_apply_opp; nop;
    }
    size: 256;
}

register reg_pkt_tag{
    width:32;
    instance_count: 65535;
}                                                                     
action do_pkt_tag() {
    register_read(test.pkt_tag,reg_pkt_tag,0);
}
table pkt_tag{
    reads {
        ipv4.dstAddr : exact; 
        ipv4.srcAddr : exact;
    }
    actions {
        do_pkt_tag; nop;
    }
    size: 256;
}

action do_set_port_state() {
	register_write(reg_port_state, eg_intr_md.egress_port, DOWN);
}
table set_port_state{
	actions{
		do_set_port_state;
	}
}

register app_pool_congest_stat{
    width: 16;
    instance_count: 1;
}
blackbox stateful_alu set_app_pool_congest_stat{
    reg: app_pool_congest_stat;

    update_lo_1_value: eg_intr_md.app_pool_congest_stat;
}
action do_record_app_pool_congest_stat(){
    set_app_pool_congest_stat.execute_stateful_alu(0);
}
table record_app_pool_congest_stat{
    actions{
        do_record_app_pool_congest_stat;
    }
    default_action: do_record_app_pool_congest_stat;
}

action do_remove_test_hdr(){
    remove_header(test);
    modify_field(ipv4.protocol, test.protocol);
}
//@pragma stage 8
table remove_test_hdr {
    reads {
        eg_intr_md.egress_port: exact;
    }
    actions {
        do_remove_test_hdr; nop;
    }
    size: 256;
}

register reg_current_utilization {
    width : 32;
    instance_count : 255;
}
action do_calc_current_utilization (outport) {
    register_read(meta.previous_utilization, reg_current_utilization, eg_intr_md.egress_port);
    add_to_field(meta.current_utilization, meta.previous_utilization, standard_metadata.packet_length);
    register_write(reg_current_utilization, eg_intr_md.egress_port, meta.previous_utilization);
}
table calc_current_utilization {
    reads {
        eg_intr_md.egress_port : exact;
    }
    actions {
        do_calc_current_utilization;
    }
    default_action: do_calc_current_utilization;
}

register reg_min_uport{
    width: 9;
    instance_count: 256;
}
action do_get_min_uport() {  
    register_read(meta.delay_port,reg_min_uport,0);
}
table get_min_uport{
    actions{
        do_get_min_uport;
    }
}

register reg_min_uport_value {
    width: 32;
    instance_count: 256;
}
action do_get_min_uport() {  
	register_read(meta.min_uport_value, reg_min_uport_value, meta.delay_port);
    register_write(reg_min_uport_value, 0, meta.current_utilization);
}
table update_min_uport_value{
	actions{
		do_update_min_uport_value;
	}
}

action do_read_from_port_state_to_meta() {
    register_read(meta.port_state, reg_port_state, meta.initial_egr_port);
}
table read_from_port_state_to_meta{
    actions {
        do_read_from_port_state_to_meta;
    }
    default_action: do_read_from_port_state_to_meta;
}

register reg_port_state {
    width : 1;
    instance_count: 256;
}
action do_read_port_state() {
    register_read(meta.port_state, reg_port_state, eg_intr_md.egress_port);
    modify_field(meta.initial_egr_port, eg_intr_md.egress_port);
}
table read_port_state {
    actions {
        do_read_port_state;
    }
    default_action: do_read_port_state;
}

field_list delay_mirror_meta_list{
    meta.initial_egr_timestamp;
    meta.initial_egr_port;
    meta.sqr_apply;
    meta.config;
    meta.linkstate;
    //meta.delaystate;
}
action do_delay_mirror(session_id){
    clone_egress_pkt_to_egress(session_id,delay_mirror_meta_list);
}

table delay_mirror{
    reads{
        meta.delay_port: exact;
    }
    actions {
         do_delay_mirror; nop;
    }
    size : 256; 
}

field_list mirror_meta_list{
    meta.initial_egr_timestamp;
	meta.initial_egr_port;
    meta.sqr_apply;
    meta.config;
    meta.linkstate;
}
action do_mirror(session_id){
    clone_egress_pkt_to_egress(session_id,mirror_meta_list);
}
table mirror{
    reads{
        eg_intr_md.egress_port : exact;
        ipv4.dstAddr : exact; 
    }
    actions {
         do_mirror; nop;
    }
    size : 256;
}

action do_drop_initial_pkt() {
	actions{
		_drop;
	}
	default_action: _drop;
}
table drop_initial_pkt{
	actions{
		do_drop_initial_pkt;
	}
}

action do_read_initial_port_state() {
    register_read(meta.port_state, reg_port_state, meta.initial_egr_port);
}
table read_initial_port_state {
    actions {
        do_read_initial_port_state;
    }
    default_action: do_read_initial_port_state;
}

action get_delay_time() {
	subtract(meta.different_time, eg_intr_md_from_parser_aux.egress_global_tstamp, meta.initial_egr_timestamp);
}
table get_delay_time{
	actions{
		do_get_delay_time;
	}
}

register reg_min_pkt_tag {
    width : 32;
    instance_count: 256;
}
action do_read_min_pkt_tag() {
	register_read(meta.min_pkt_tag, reg_min_pkt_tag, 0);
}
table read_min_pkt_tag{
	actions{
		do_read_min_pkt_tag;
	}
}

action do_record_min_pkt_tag() {
    add_to_field(test.pkt_tag, 1);
    register_write(reg_min_pkt_tag, 0, test.pkt_tag);
}
//@pragma stage 6
table record_min_pkt_tag {
    reads {
        ipv4.dstAddr : exact; 
        ipv4.srcAddr : exact;
    }
    actions {
        do_record_min_pkt_tag; nop;
    } 
}

action do_config_done() {
    modify_field(meta.config, 0 );
}
table config_done{
    actions{
        do_config_done;
    }
    default_action: do_config_done;
}

action do_drop_pkt() {
	actions{
		_drop;
	}
	default_action: _drop;
}
table drop_pkt{
	actions{
		do_drop_pkt;
	}
}

action do_more_mirror(session_id){
    clone_egress_pkt_to_egress(session_id,mirror_meta_list);
}
table more_mirror{
    reads{
        eg_intr_md.egress_port : exact;
        ipv4.dstAddr : exact; 
    }
    actions {
         do_more_mirror; nop;
    }
    size : 256;
}