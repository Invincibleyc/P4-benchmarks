/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

modify_field.p4: Carry out the various subtypes of the modify_field primitive,
                 where 'subtype' refers to a distinct combination of parameter
                 types.
*/

// standard parameter order:
// [leftshift] [rightshift] [dest mask] [src mask | src val]

// 1
action mod_meta_stdmeta_ingressport(leftshift, tmeta_mask) { 
  modify_field(tmeta.data, (tmeta.data & ~tmeta_mask) | ((meta_ctrl.virt_ingress_port << leftshift) & tmeta_mask)); // last "& mask" probably unnecessary
}

// 2
action mod_meta_stdmeta_packetlength(leftshift, tmeta_mask) {
  modify_field(tmeta.data, (tmeta.data & ~tmeta_mask) | ((standard_metadata.packet_length << leftshift) & tmeta_mask));
}

// 3
action mod_meta_stdmeta_egressspec(leftshift, tmeta_mask) {
  modify_field(tmeta.data, (tmeta.data & ~tmeta_mask) | ((meta_ctrl.virt_egress_spec << leftshift) & tmeta_mask));
}

// 4
action mod_meta_stdmeta_egressport(leftshift, tmeta_mask) {
  modify_field(tmeta.data, (tmeta.data & ~tmeta_mask) | ((standard_metadata.egress_port << leftshift) & tmeta_mask));
}

// 5
action mod_meta_stdmeta_egressinst(leftshift, tmeta_mask) {
  modify_field(tmeta.data, (tmeta.data & ~tmeta_mask) | ((standard_metadata.egress_instance << leftshift) & tmeta_mask));
}

// 6
action mod_meta_stdmeta_insttype(leftshift, tmeta_mask) {
  modify_field(tmeta.data, (tmeta.data & ~tmeta_mask) | ((standard_metadata.instance_type << leftshift) & tmeta_mask));
}

// 7
action mod_stdmeta_egressspec_meta(rightshift, tmask) {
  modify_field(meta_ctrl.virt_egress_spec, (tmeta.data >> rightshift) & tmask);
}

// 8
action mod_meta_const(leftshift, tmeta_mask, val) {
  modify_field(tmeta.data, (tmeta.data & ~tmeta_mask) | ((val << leftshift) & tmeta_mask));
}

// 9
action mod_stdmeta_egressspec_const(val) {
  modify_field(meta_ctrl.virt_egress_spec, val);
}

// 10
action mod_extracted_const(leftshift, emask, val) {
    modify_field(extracted.data, (extracted.data & ~emask) | ((val << leftshift) & emask));
}

// 11
action mod_stdmeta_egressspec_stdmeta_ingressport() {
  modify_field(meta_ctrl.virt_egress_spec, meta_ctrl.orig_virt_ingress_port);
}

// 12
action mod_extracted_extracted(leftshift, rightshift, msk) {
  modify_field(extracted.data, (extracted.data & ~msk) | (((extracted.data << leftshift) >> rightshift) & msk) );
}

// 13
action mod_meta_extracted(leftshift, rightshift, tmask, emask) {
  modify_field(tmeta.data, (tmeta.data & ~tmask) | (((extracted.data << leftshift) >> rightshift) & emask));
}

// 14
action mod_extracted_meta(leftshift, rightshift, emask, tmask) {
  modify_field(extracted.data, (extracted.data & ~emask) | ( ((tmeta.data << leftshift) >> rightshift) & tmask));
}

//15
action mod_extracted_stdmeta_ingressport(leftshift, msk) {
  modify_field(extracted.data, (extracted.data & ~msk) | (standard_metadata.ingress_port << leftshift));
}
// TODO: add rest of the modify_field actions

action _no_op() {
  no_op();
}

table t_mod_11 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_12 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_13 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_14 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_15 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_16 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_17 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_18 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_19 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_21 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_22 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_23 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_24 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_25 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_26 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_27 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_28 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_29 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_31 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_32 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_33 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_34 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_35 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_36 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_37 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_38 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_39 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_41 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_42 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_43 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_44 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_45 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_46 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_47 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_48 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_49 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_51 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_52 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_53 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_54 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_55 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_56 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_57 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_58 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

table t_mod_59 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_meta_stdmeta_ingressport;
    mod_meta_stdmeta_packetlength;
    mod_meta_stdmeta_egressspec;
    mod_meta_stdmeta_egressport;
    mod_meta_stdmeta_egressinst;
    mod_meta_stdmeta_insttype;
    mod_stdmeta_egressspec_meta;
    mod_meta_const;
    mod_stdmeta_egressspec_const;
    mod_extracted_const;
    mod_stdmeta_egressspec_stdmeta_ingressport;
    mod_extracted_extracted;
    mod_meta_extracted;
    mod_extracted_meta;
    mod_extracted_stdmeta_ingressport;
    _no_op;
  }
}

control do_modify_field_11 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype1 != 7) and
        (meta_primitive_state.subtype1 != 9) and
        (meta_primitive_state.subtype1 != 11)) ) {
    apply(t_mod_11);
  }
}


control do_modify_field_12 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype2 != 7) and
        (meta_primitive_state.subtype2 != 9) and
        (meta_primitive_state.subtype2 != 11)) ) {
    apply(t_mod_12);
  }
}


control do_modify_field_13 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype3 != 7) and
        (meta_primitive_state.subtype3 != 9) and
        (meta_primitive_state.subtype3 != 11)) ) {
    apply(t_mod_13);
  }
}


control do_modify_field_14 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype4 != 7) and
        (meta_primitive_state.subtype4 != 9) and
        (meta_primitive_state.subtype4 != 11)) ) {
    apply(t_mod_14);
  }
}


control do_modify_field_15 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype5 != 7) and
        (meta_primitive_state.subtype5 != 9) and
        (meta_primitive_state.subtype5 != 11)) ) {
    apply(t_mod_15);
  }
}


control do_modify_field_16 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype6 != 7) and
        (meta_primitive_state.subtype6 != 9) and
        (meta_primitive_state.subtype6 != 11)) ) {
    apply(t_mod_16);
  }
}


control do_modify_field_17 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype7 != 7) and
        (meta_primitive_state.subtype7 != 9) and
        (meta_primitive_state.subtype7 != 11)) ) {
    apply(t_mod_17);
  }
}


control do_modify_field_18 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype8 != 7) and
        (meta_primitive_state.subtype8 != 9) and
        (meta_primitive_state.subtype8 != 11)) ) {
    apply(t_mod_18);
  }
}


control do_modify_field_19 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype9 != 7) and
        (meta_primitive_state.subtype9 != 9) and
        (meta_primitive_state.subtype9 != 11)) ) {
    apply(t_mod_19);
  }
}


control do_modify_field_21 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype1 != 7) and
        (meta_primitive_state.subtype1 != 9) and
        (meta_primitive_state.subtype1 != 11)) ) {
    apply(t_mod_21);
  }
}


control do_modify_field_22 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype2 != 7) and
        (meta_primitive_state.subtype2 != 9) and
        (meta_primitive_state.subtype2 != 11)) ) {
    apply(t_mod_22);
  }
}


control do_modify_field_23 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype3 != 7) and
        (meta_primitive_state.subtype3 != 9) and
        (meta_primitive_state.subtype3 != 11)) ) {
    apply(t_mod_23);
  }
}


control do_modify_field_24 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype4 != 7) and
        (meta_primitive_state.subtype4 != 9) and
        (meta_primitive_state.subtype4 != 11)) ) {
    apply(t_mod_24);
  }
}


control do_modify_field_25 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype5 != 7) and
        (meta_primitive_state.subtype5 != 9) and
        (meta_primitive_state.subtype5 != 11)) ) {
    apply(t_mod_25);
  }
}


control do_modify_field_26 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype6 != 7) and
        (meta_primitive_state.subtype6 != 9) and
        (meta_primitive_state.subtype6 != 11)) ) {
    apply(t_mod_26);
  }
}


control do_modify_field_27 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype7 != 7) and
        (meta_primitive_state.subtype7 != 9) and
        (meta_primitive_state.subtype7 != 11)) ) {
    apply(t_mod_27);
  }
}


control do_modify_field_28 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype8 != 7) and
        (meta_primitive_state.subtype8 != 9) and
        (meta_primitive_state.subtype8 != 11)) ) {
    apply(t_mod_28);
  }
}


control do_modify_field_29 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype9 != 7) and
        (meta_primitive_state.subtype9 != 9) and
        (meta_primitive_state.subtype9 != 11)) ) {
    apply(t_mod_29);
  }
}


control do_modify_field_31 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype1 != 7) and
        (meta_primitive_state.subtype1 != 9) and
        (meta_primitive_state.subtype1 != 11)) ) {
    apply(t_mod_31);
  }
}


control do_modify_field_32 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype2 != 7) and
        (meta_primitive_state.subtype2 != 9) and
        (meta_primitive_state.subtype2 != 11)) ) {
    apply(t_mod_32);
  }
}


control do_modify_field_33 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype3 != 7) and
        (meta_primitive_state.subtype3 != 9) and
        (meta_primitive_state.subtype3 != 11)) ) {
    apply(t_mod_33);
  }
}


control do_modify_field_34 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype4 != 7) and
        (meta_primitive_state.subtype4 != 9) and
        (meta_primitive_state.subtype4 != 11)) ) {
    apply(t_mod_34);
  }
}


control do_modify_field_35 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype5 != 7) and
        (meta_primitive_state.subtype5 != 9) and
        (meta_primitive_state.subtype5 != 11)) ) {
    apply(t_mod_35);
  }
}


control do_modify_field_36 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype6 != 7) and
        (meta_primitive_state.subtype6 != 9) and
        (meta_primitive_state.subtype6 != 11)) ) {
    apply(t_mod_36);
  }
}


control do_modify_field_37 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype7 != 7) and
        (meta_primitive_state.subtype7 != 9) and
        (meta_primitive_state.subtype7 != 11)) ) {
    apply(t_mod_37);
  }
}


control do_modify_field_38 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype8 != 7) and
        (meta_primitive_state.subtype8 != 9) and
        (meta_primitive_state.subtype8 != 11)) ) {
    apply(t_mod_38);
  }
}


control do_modify_field_39 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype9 != 7) and
        (meta_primitive_state.subtype9 != 9) and
        (meta_primitive_state.subtype9 != 11)) ) {
    apply(t_mod_39);
  }
}


control do_modify_field_41 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype1 != 7) and
        (meta_primitive_state.subtype1 != 9) and
        (meta_primitive_state.subtype1 != 11)) ) {
    apply(t_mod_41);
  }
}


control do_modify_field_42 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype2 != 7) and
        (meta_primitive_state.subtype2 != 9) and
        (meta_primitive_state.subtype2 != 11)) ) {
    apply(t_mod_42);
  }
}


control do_modify_field_43 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype3 != 7) and
        (meta_primitive_state.subtype3 != 9) and
        (meta_primitive_state.subtype3 != 11)) ) {
    apply(t_mod_43);
  }
}


control do_modify_field_44 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype4 != 7) and
        (meta_primitive_state.subtype4 != 9) and
        (meta_primitive_state.subtype4 != 11)) ) {
    apply(t_mod_44);
  }
}


control do_modify_field_45 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype5 != 7) and
        (meta_primitive_state.subtype5 != 9) and
        (meta_primitive_state.subtype5 != 11)) ) {
    apply(t_mod_45);
  }
}


control do_modify_field_46 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype6 != 7) and
        (meta_primitive_state.subtype6 != 9) and
        (meta_primitive_state.subtype6 != 11)) ) {
    apply(t_mod_46);
  }
}


control do_modify_field_47 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype7 != 7) and
        (meta_primitive_state.subtype7 != 9) and
        (meta_primitive_state.subtype7 != 11)) ) {
    apply(t_mod_47);
  }
}


control do_modify_field_48 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype8 != 7) and
        (meta_primitive_state.subtype8 != 9) and
        (meta_primitive_state.subtype8 != 11)) ) {
    apply(t_mod_48);
  }
}


control do_modify_field_49 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype9 != 7) and
        (meta_primitive_state.subtype9 != 9) and
        (meta_primitive_state.subtype9 != 11)) ) {
    apply(t_mod_49);
  }
}


control do_modify_field_51 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype1 != 7) and
        (meta_primitive_state.subtype1 != 9) and
        (meta_primitive_state.subtype1 != 11)) ) {
    apply(t_mod_51);
  }
}


control do_modify_field_52 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype2 != 7) and
        (meta_primitive_state.subtype2 != 9) and
        (meta_primitive_state.subtype2 != 11)) ) {
    apply(t_mod_52);
  }
}


control do_modify_field_53 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype3 != 7) and
        (meta_primitive_state.subtype3 != 9) and
        (meta_primitive_state.subtype3 != 11)) ) {
    apply(t_mod_53);
  }
}


control do_modify_field_54 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype4 != 7) and
        (meta_primitive_state.subtype4 != 9) and
        (meta_primitive_state.subtype4 != 11)) ) {
    apply(t_mod_54);
  }
}


control do_modify_field_55 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype5 != 7) and
        (meta_primitive_state.subtype5 != 9) and
        (meta_primitive_state.subtype5 != 11)) ) {
    apply(t_mod_55);
  }
}


control do_modify_field_56 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype6 != 7) and
        (meta_primitive_state.subtype6 != 9) and
        (meta_primitive_state.subtype6 != 11)) ) {
    apply(t_mod_56);
  }
}


control do_modify_field_57 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype7 != 7) and
        (meta_primitive_state.subtype7 != 9) and
        (meta_primitive_state.subtype7 != 11)) ) {
    apply(t_mod_57);
  }
}


control do_modify_field_58 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype8 != 7) and
        (meta_primitive_state.subtype8 != 9) and
        (meta_primitive_state.subtype8 != 11)) ) {
    apply(t_mod_58);
  }
}


control do_modify_field_59 {
  // subtypes 7, 9, 11 all write to stdmeta.egress_spec
  if ( (meta_ctrl.econd == 0) or
       (meta_ctrl.virt_egress_spec == 0) or
       ((meta_primitive_state.subtype9 != 7) and
        (meta_primitive_state.subtype9 != 9) and
        (meta_primitive_state.subtype9 != 11)) ) {
    apply(t_mod_59);
  }
}

