#include "includes/headers.p4"

header_type ingress_metadata_t {	
   fields {
	starting_port: 32;
	all_ports: 32;
	out_port_xor: 32;
  	pkt_curr: 8;
        pkt_par: 8;
	out_port: 8;
	if_out_failed: 8;
	pkt_start: 1;
        is_dest: 1;
	is_completed: 1;
  }
}

header  header_dfs_t dfsTag;
metadata ingress_metadata_t local_metadata;

parser start {
    extract(ff_tags);
    extract(dfsTag);
    set_metadata(local_metadata.pkt_curr, dfsTag.pkt_v1_curr);
    set_metadata(local_metadata.pkt_par, dfsTag.pkt_v1_par);
    set_metadata(local_metadata.pkt_start, ff_tags.dfs_start);
    return ingress;
}

header_type intrinsic_metadata_t {
    fields {
        ingress_global_timestamp : 48;
        lf_field_list : 8;
        mcast_grp : 16;
        egress_rid : 16;
        resubmit_flag : 8;
        recirculate_flag : 8;
    }
}
metadata intrinsic_metadata_t intrinsic_metadata;

#define PORTS 4

register all_ports_status {
   width: 32;
   instance_count: 1;
}

action set_parent() {
   modify_field(local_metadata.pkt_par, standard_metadata.ingress_port); 
   modify_field(dfsTag.pkt_v1_par, local_metadata.pkt_par);
}

table curr_eq_zero {
  actions{set_parent;}
}

action set_next_port() {
  add_to_field(local_metadata.pkt_curr, 1);
  modify_field(local_metadata.out_port, local_metadata.pkt_curr);
}

table curr_eq_ingress {
  actions {set_next_port;}
}

action send_on_parent() {
  modify_field(local_metadata.out_port, local_metadata.pkt_par);
  modify_field(local_metadata.is_completed, 1);
}

table hit_depth {
  actions {send_on_parent;}
}

action skip_parent() {
  add_to_field(local_metadata.out_port, 1);
}

table jump_to_next {
  actions {skip_parent;}
}

action send_to_parent() {
  modify_field(local_metadata.out_port, local_metadata.pkt_par);
  modify_field(local_metadata.is_completed, 1);
}

table set_parent_out {
  actions {send_to_parent;}
}

action outport_to_parent() {
  modify_field(local_metadata.out_port, local_metadata.pkt_par);
  modify_field(local_metadata.is_completed, 1);
}

table to_parent {
  actions {outport_to_parent;}
}

action next_outport() {
  add_to_field(local_metadata.out_port, 1);
}

table try_next {
  actions {next_outport;}
}

action start_from_one() {
  modify_field(local_metadata.out_port, 1);
  modify_field(local_metadata.is_completed, 0);
}

table out_eq_zero {
  actions {start_from_one;}
}

action set_dfs_tags() {
  modify_field(local_metadata.pkt_start, 1);
  modify_field(ff_tags.dfs_start, local_metadata.pkt_start);
  modify_field(local_metadata.out_port, 1);
}

table start_dfs {
  actions {set_dfs_tags;}
}

action towards_parent() {
  modify_field(standard_metadata.egress_spec, local_metadata.out_port);
  add_to_field(ff_tags.path_length, 1);
}

table fwd_parent {
  actions {towards_parent;}
}

action set_out_meta(meta_state) {
  modify_field(local_metadata.starting_port, meta_state);
  register_read(local_metadata.all_ports, all_ports_status, 0);
}

table set_out_port {
  reads {
        local_metadata.out_port: exact;
  }
  actions {
        set_out_meta;
  }
}

action fwd(_port) {
  modify_field(standard_metadata.egress_spec, _port);
  modify_field(dfsTag.pkt_v1_curr, _port);
  add_to_field(ff_tags.path_length, 1);
}

table fwd_pkt {
  reads {
        local_metadata.starting_port: ternary;
        local_metadata.all_ports: ternary;
  }
  actions {
	fwd;
  }
}

action skip_failures(_working) {
   modify_field(local_metadata.out_port, _working);
}

table check_out_failed {
  reads {
	local_metadata.starting_port: ternary;
	local_metadata.all_ports: ternary;
  }
  actions {
	skip_failures;
  }
}


action starting_port_meta(port_state) {
  modify_field(local_metadata.starting_port, port_state);
  register_read(local_metadata.all_ports, all_ports_status, 0);
}

table set_egress_port {
  reads {
        local_metadata.out_port: exact;
  }
  actions {
        starting_port_meta;
  }
}

action set_default_route(send_to) {
  modify_field(local_metadata.out_port, send_to);
}

table default_route {
  reads {
	standard_metadata.ingress_port: exact;
  } 
  actions {
	set_default_route;
  }
}

action xor_outport(_all_ports) {
  register_read(local_metadata.all_ports, all_ports_status, 0);
  bit_xor(local_metadata.out_port_xor, local_metadata.all_ports, _all_ports);
}

table check_outport_status {
  actions{xor_outport;}
}

action set_if_status(_value) {
  modify_field(local_metadata.if_out_failed, _value);
}

table if_status {
  reads {
	local_metadata.starting_port: ternary;
        local_metadata.out_port_xor: ternary;
  }
  actions {
        set_if_status;
  }
}

control ctrl_dfs_routing {
        if(local_metadata.pkt_curr == 0) {//start of dfs
                apply(curr_eq_zero);
	}
	apply(curr_eq_ingress);
	if(local_metadata.out_port == PORTS + 1) {
	        apply(hit_depth);
        }
	if(local_metadata.is_completed == 0) {
		apply(set_egress_port);
		if(local_metadata.out_port != PORTS) {
	               	apply(check_out_failed);
		} else {
			apply(check_outport_status);
                       	apply(if_status);
			if(local_metadata.if_out_failed == local_metadata.out_port) {
                               	apply(try_next);
                               	if(local_metadata.out_port == PORTS+1) {
                                       	apply(to_parent);
                               	}
			}
                }
                if(local_metadata.is_completed == 0 and local_metadata.out_port == local_metadata.pkt_par) {
                        apply(jump_to_next);
                        if(local_metadata.out_port == PORTS+1) {
                               apply(set_parent_out);
                        }
                }
	}
	if(local_metadata.is_completed == 1) {
              if(local_metadata.out_port == 0) {
                     apply(out_eq_zero);
               }
        }
}

control ingress {
   if(valid(dfsTag)) {
	if(local_metadata.pkt_start == 0) {
		apply(default_route);
		if(local_metadata.out_port == 0) {//default port failed
			apply(start_dfs);
		}
	} else {
       		ctrl_dfs_routing();
	}
	if(local_metadata.is_completed == 1) {
		apply(fwd_parent);
	} else {
		apply(set_out_port);
		apply(fwd_pkt);	
	}
    }
}

control egress {}
