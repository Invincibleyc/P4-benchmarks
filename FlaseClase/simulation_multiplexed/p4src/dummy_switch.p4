#include "includes/headers.p4"
#include "includes/parser.p4"
#include "includes/intrinsic.p4"

metadata ingress_intrinsic_metadata_t intrinsic_metadata;

/* Used for the sender to know if he already updated the time stamp.
 * Set to zero on the first qurter and set to 1 when on the first third
 * qurter match - when updating the timestamp. */ 
register ts_flag_reg {
    width: 8;
    instance_count: 1;
}

/* The two following registers are used to store the timestamp. The sender
 * and receiver switches update it and the C wrapper measure it. */
register ts_sent_reg {
    width: 64;
    instance_count: 2;
}
register ts_recv_reg {
    width: 64;
    instance_count: 2;
}

/* Added counter for the use of switch 1
 * in order to count incoming packets. */
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

/* Timestamp counter added as dummy when syntax requires val usage. */
counter ts_counter_recv {
    type: packets;
    static: look_for_flag;
    instance_count: 2;
}

/* -------------  ACTIONS -------------------------------------------------- */

action _drop() {
    drop();
}

action _set_port(dst) {
    modify_field(standard_metadata.egress_spec,dst);
}

/* Used only for sending (switch 1) for counting sent packets and updating
 * color history. */
action _modify_flags(val) {

    /* This take effect in the loss calculation sending (switch 1) part. */
    count(sent_counter,val);
    modify_field(ipv4.flag_a, val);

    /* Putting the history register in to metadata. */
    register_read(intrinsic_metadata.ts_flag, ts_flag_reg, 0);
}

/* Change the bit i.e. signal the time stamp. */
action _note_flag(val) {
    modify_field(ipv4.flag_a, val);
    register_write(ts_flag_reg, 0, 1);
    register_write(ts_sent_reg, 0, intrinsic_metadata.time_of_day);
}

/* This action reset to zero the history ts register in every first qurter. */
action _reset_ts_reg(val) {
    register_write(ts_flag_reg, 0, val);
}

/* Used only by receiving side. Read the color bit (flag_a) from the ipv4
 * header and count. Increase counter accordingly and update history. */
action _read_flags(val) {
    count(recv_counter,val);
}

/* Used by receiver. Update time Stamp. The count part is dummy to use val. */
action _look_for_flag(val) {
    count(ts_counter_recv, val);
    register_write(ts_recv_reg, 0, intrinsic_metadata.time_of_day);
    modify_field(ipv4.flag_a, 0);
}

/* ------------- TABLES ----------------------------------------------------- */

/* Routing table - has nothing to do with the algorithm, simply get the packets
 * from switch 1 to switch 4 and later on to the receiver. May choose from 
 * which inner switch (2 or 3) to go by. */
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

/* Change the flag (single bit used for the algorithm) to fit the time. One may
 * change the digit that decides in power of 2 range in the switch 4
 * commands.txt file. */
table modify_flags {
    reads {
        intrinsic_metadata.time_of_day : ternary;
	ipv4.dstAddr : exact;	
    }
    actions {
        _modify_flags;
        _drop;
    }
    size: 256;
}

/* Used to reset the ts flag when needed. */
table reset_ts_reg {
    reads {
        intrinsic_metadata.time_of_day : ternary;
    }
    actions {
        _reset_ts_reg;
        _drop;
    }
    size: 256;
}

/* Used by sender. Set the special time stamp single change in third qurter. */
table note_flag {
    reads {
        intrinsic_metadata.time_of_day : ternary;
        intrinsic_metadata.ts_flag : exact;
    }
    actions {
	_note_flag;
        _drop;
    }
    size: 256;
}

/* Used by receiver. Check if flag is different then flag color of cycle. */
table look_for_flag {
    reads {
        intrinsic_metadata.time_of_day : ternary;
	ipv4.flag_a : exact;
    }
    actions {
	_look_for_flag;
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

/* -------------- CONTROLS ------------------------------------------------- */

control ingress {
	apply(modify_flags);
	apply(reset_ts_reg);
	apply(read_flags);
	apply(look_for_flag);
	apply(set_port);
}

control egress {
	apply(note_flag);
}
