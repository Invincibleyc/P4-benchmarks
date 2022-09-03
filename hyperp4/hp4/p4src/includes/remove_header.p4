/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

remove_header.p4: Carry out the remove_header primitive
*/

action a_removeh(sz, msk, vbits) {
  modify_field(extracted.data, (extracted.data & ~msk) | ( (extracted.data << (sz * 8)) & msk ));
  modify_field(parse_ctrl.numbytes, parse_ctrl.numbytes - sz);
  modify_field(extracted.validbits, extracted.validbits & vbits);
}

table t_removeh_11 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_12 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_13 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_14 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_15 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_16 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_17 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_18 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_19 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_21 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_22 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_23 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_24 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_25 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_26 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_27 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_28 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_29 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_31 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_32 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_33 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_34 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_35 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_36 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_37 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_38 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_39 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_41 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_42 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_43 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_44 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_45 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_46 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_47 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_48 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_49 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_51 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_52 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_53 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_54 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_55 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_56 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_57 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_58 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

table t_removeh_59 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_removeh;
  }
}

control do_remove_header_11 {
  apply(t_removeh_11);
}

control do_remove_header_12 {
  apply(t_removeh_12);
}

control do_remove_header_13 {
  apply(t_removeh_13);
}

control do_remove_header_14 {
  apply(t_removeh_14);
}

control do_remove_header_15 {
  apply(t_removeh_15);
}

control do_remove_header_16 {
  apply(t_removeh_16);
}

control do_remove_header_17 {
  apply(t_removeh_17);
}

control do_remove_header_18 {
  apply(t_removeh_18);
}

control do_remove_header_19 {
  apply(t_removeh_19);
}

control do_remove_header_21 {
  apply(t_removeh_21);
}

control do_remove_header_22 {
  apply(t_removeh_22);
}

control do_remove_header_23 {
  apply(t_removeh_23);
}

control do_remove_header_24 {
  apply(t_removeh_24);
}

control do_remove_header_25 {
  apply(t_removeh_25);
}

control do_remove_header_26 {
  apply(t_removeh_26);
}

control do_remove_header_27 {
  apply(t_removeh_27);
}

control do_remove_header_28 {
  apply(t_removeh_28);
}

control do_remove_header_29 {
  apply(t_removeh_29);
}

control do_remove_header_31 {
  apply(t_removeh_31);
}

control do_remove_header_32 {
  apply(t_removeh_32);
}

control do_remove_header_33 {
  apply(t_removeh_33);
}

control do_remove_header_34 {
  apply(t_removeh_34);
}

control do_remove_header_35 {
  apply(t_removeh_35);
}

control do_remove_header_36 {
  apply(t_removeh_36);
}

control do_remove_header_37 {
  apply(t_removeh_37);
}

control do_remove_header_38 {
  apply(t_removeh_38);
}

control do_remove_header_39 {
  apply(t_removeh_39);
}

control do_remove_header_41 {
  apply(t_removeh_41);
}

control do_remove_header_42 {
  apply(t_removeh_42);
}

control do_remove_header_43 {
  apply(t_removeh_43);
}

control do_remove_header_44 {
  apply(t_removeh_44);
}

control do_remove_header_45 {
  apply(t_removeh_45);
}

control do_remove_header_46 {
  apply(t_removeh_46);
}

control do_remove_header_47 {
  apply(t_removeh_47);
}

control do_remove_header_48 {
  apply(t_removeh_48);
}

control do_remove_header_49 {
  apply(t_removeh_49);
}

control do_remove_header_51 {
  apply(t_removeh_51);
}

control do_remove_header_52 {
  apply(t_removeh_52);
}

control do_remove_header_53 {
  apply(t_removeh_53);
}

control do_remove_header_54 {
  apply(t_removeh_54);
}

control do_remove_header_55 {
  apply(t_removeh_55);
}

control do_remove_header_56 {
  apply(t_removeh_56);
}

control do_remove_header_57 {
  apply(t_removeh_57);
}

control do_remove_header_58 {
  apply(t_removeh_58);
}

control do_remove_header_59 {
  apply(t_removeh_59);
}
