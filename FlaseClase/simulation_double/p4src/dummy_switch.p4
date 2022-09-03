#include "includes/headers.p4"
#include "includes/parser.p4"
#include "includes/intrinsic.p4"

metadata ingress_intrinsic_metadata_t intrinsic_metadata;

register prev_color_reg {
    width: 8;
    instance_count: 2;
}

register ts_sent_reg {
    width: 64;
    instance_count: 2;
}

register ts_recv_reg {
    width: 64;
    instance_count: 2;
}

counter sent_counter {
    type: packets;
    static: modify_flags;
    instance_count: 2;
}

/* Added counter for the use of switch 4
 * in order to count incoming packets. */
counter recv_counter {
    type: packets;
    static: read_flags;
    instance_count: 2;
}

/* Timestamp counter added for debug. */
counter ts_counter {
    type: packets;
    static: read_ts_flag;
    instance_count: 2;
}

action _drop() {
    drop();
}

action _set_port(dst) {
    modify_field(standard_metadata.egress_spec,dst);
}

action _modify_flags(val) {
    count(sent_counter,val);
    modify_field(ipv4.flag_a, val); /* Change */
    register_read(intrinsic_metadata.prev_color, prev_color_reg, 0);//insert previous color to intrinsic metadata
    //modify_field(intrinsic_metadata.prev_color, val);
    modify_field(intrinsic_metadata.cur_color, val);
    register_write(prev_color_reg, 0, val);
    modify_field(ipv4.flag_b, 0);
}

/* _modify_ts_flag action should be called when 
 * there is a change in previous color metadata.
 * Then an update of previous register will accur
 * and time stamp bit (flag_b) will be marked as '1' */
action _modify_ts_flag(val) {
    modify_field(ipv4.flag_b, val);
    register_write(ts_sent_reg, 0, intrinsic_metadata.time_of_day);
}

/* Read the color bit (flag_a) from the ipv4 header and count. */
action _read_flags(val) {
    count(recv_counter,val);
    modify_field(ipv4.flag_a, 0);
}

/* Read the ts bit (flag_b) from the ipv4 header.
 * Shold be taken only iff flag_b = '1'.
 * For now just counts, TODO: measure timestamp. */
action _detect_ts_flag_on(val) {
    count(ts_counter,val);
    register_write(ts_recv_reg, 0, intrinsic_metadata.time_of_day);
    modify_field(ipv4.flag_b, 1);
}

table set_port {
    reads {
        intrinsic_metadata.time_of_day : ternary;
	standard_metadata.ingress_port : exact;		
    }
    actions {
        _set_port;
        _drop;
    }
    size: 256;
}

/* assign_ts_bit table will read both prev_color and
 * cur_color metadata fields at package egress.
 * If both fields won't match _modify_ts_flag action
 * will be taken.
*/
table assign_ts_bit {
    reads {
        intrinsic_metadata.prev_color : exact;
	intrinsic_metadata.cur_color : exact;		
    }
    actions {
        _modify_ts_flag;
        _drop;
    }
    size: 256;
}

table modify_flags {
    reads {
        intrinsic_metadata.time_of_day : ternary;
	ipv4.dstAddr : exact;	
	/* ipv4.flag_a : exact;	*/
    }
    actions {
        _modify_flags;
        _drop;
    }
    size: 256;
}

/* Added a table for switch 4 to use. */
table read_flags {
    reads {	
	ipv4.flag_a : exact;
	ipv4.srcAddr : exact;
    }
    actions {
        _read_flags;
        _drop;
    }
    size: 256;
}

/* Added a table for switch 4 to use. */
table read_ts_flag {
    reads {	
	ipv4.flag_b : exact;
    }
    actions {
        _detect_ts_flag_on;
        _drop;
    }
    size: 256;
}

control ingress {
	apply(modify_flags);
	apply(read_flags);
	apply(set_port);
	apply(read_ts_flag);
}

control egress {
	apply(assign_ts_bit);
}
