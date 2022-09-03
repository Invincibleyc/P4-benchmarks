#include "includes/headers.p4"

header_type ingress_metadata_t {
    fields {
        all_ports: 32;
	starting_port: 32;
	out_port_xor: 32;
	out_port: 8;
	mod_counter: 8;
    }
}

metadata ingress_metadata_t local_metadata;

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

parser start {
    extract(rotorTag);
    set_metadata(local_metadata.mod_counter, rotorTag.pkt_v1);
    return ingress;
}

register all_ports_status {
   width: 32;
   instance_count: 1;
}

action set_starting_port(port_start) {
   modify_field(local_metadata.starting_port, port_start);
   register_read(local_metadata.all_ports, all_ports_status, 0);
}


table set_egress_port {
  reads {
        local_metadata.out_port: exact;
  }
  actions {
        set_starting_port;
  }
}

action send_pkt(port_to_send) {
   modify_field(standard_metadata.egress_spec, port_to_send);
   modify_field(rotorTag.pkt_v1, port_to_send);
   add_to_field(rotorTag.path_length, 1);
}


table route_pkt {
  reads {
	local_metadata.starting_port: ternary;
	local_metadata.all_ports: ternary;
  }
  actions {
	send_pkt;
  }
}


action set_default_route(send_to) {
  modify_field(local_metadata.out_port, send_to);
  modify_field(local_metadata.mod_counter, send_to);
}

table default_route {
  reads {
	standard_metadata.ingress_port: exact;
  } 
  actions {
	set_default_route;
  }
}

action set_RR () {
  modify_field(local_metadata.out_port, (local_metadata.mod_counter % PORTS) + 1);
}

table rotor {
  actions {set_RR;}
}

action xor_outport(_all_ports) {
  register_read(local_metadata.all_ports, all_ports_status, 0);
  bit_xor(local_metadata.out_port_xor, local_metadata.all_ports, _all_ports);
}

table check_outport_status {
  actions{xor_outport;}
}

action set_if_status(_value) {
  modify_field(local_metadata.out_port, _value);
}

table if_status {
  reads {
        local_metadata.out_port_xor: ternary;
  }
  actions {
        set_if_status;
  }
}


control ingress {
   if(valid(rotorTag)) {
   	if(local_metadata.mod_counter == 0) {
		apply(default_route);
	}
	apply(check_outport_status);
        apply(if_status);
	if(local_metadata.out_port == 0 and local_metadata.mod_counter != 0) {
                apply(rotor);
        } 
	apply(set_egress_port);
	apply(route_pkt);
   }
}

control egress {}
