/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

truncate.p4: Implements the truncate primitive
*/

action a_truncate(val) {
  truncate(val);
}

table t_truncate_11 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_12 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_13 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_14 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_15 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_16 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_17 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_18 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_19 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_21 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_22 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_23 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_24 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_25 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_26 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_27 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_28 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_29 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_31 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_32 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_33 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_34 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_35 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_36 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_37 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_38 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_39 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_41 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_42 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_43 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_44 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_45 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_46 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_47 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_48 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_49 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_51 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_52 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_53 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_54 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_55 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_56 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_57 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_58 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

table t_truncate_59 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    a_truncate;
  }
}

control do_truncate_11 {
  apply(t_truncate_11);
}

control do_truncate_12 {
  apply(t_truncate_12);
}

control do_truncate_13 {
  apply(t_truncate_13);
}

control do_truncate_14 {
  apply(t_truncate_14);
}

control do_truncate_15 {
  apply(t_truncate_15);
}

control do_truncate_16 {
  apply(t_truncate_16);
}

control do_truncate_17 {
  apply(t_truncate_17);
}

control do_truncate_18 {
  apply(t_truncate_18);
}

control do_truncate_19 {
  apply(t_truncate_19);
}

control do_truncate_21 {
  apply(t_truncate_21);
}

control do_truncate_22 {
  apply(t_truncate_22);
}

control do_truncate_23 {
  apply(t_truncate_23);
}

control do_truncate_24 {
  apply(t_truncate_24);
}

control do_truncate_25 {
  apply(t_truncate_25);
}

control do_truncate_26 {
  apply(t_truncate_26);
}

control do_truncate_27 {
  apply(t_truncate_27);
}

control do_truncate_28 {
  apply(t_truncate_28);
}

control do_truncate_29 {
  apply(t_truncate_29);
}

control do_truncate_31 {
  apply(t_truncate_31);
}

control do_truncate_32 {
  apply(t_truncate_32);
}

control do_truncate_33 {
  apply(t_truncate_33);
}

control do_truncate_34 {
  apply(t_truncate_34);
}

control do_truncate_35 {
  apply(t_truncate_35);
}

control do_truncate_36 {
  apply(t_truncate_36);
}

control do_truncate_37 {
  apply(t_truncate_37);
}

control do_truncate_38 {
  apply(t_truncate_38);
}

control do_truncate_39 {
  apply(t_truncate_39);
}

control do_truncate_41 {
  apply(t_truncate_41);
}

control do_truncate_42 {
  apply(t_truncate_42);
}

control do_truncate_43 {
  apply(t_truncate_43);
}

control do_truncate_44 {
  apply(t_truncate_44);
}

control do_truncate_45 {
  apply(t_truncate_45);
}

control do_truncate_46 {
  apply(t_truncate_46);
}

control do_truncate_47 {
  apply(t_truncate_47);
}

control do_truncate_48 {
  apply(t_truncate_48);
}

control do_truncate_49 {
  apply(t_truncate_49);
}

control do_truncate_51 {
  apply(t_truncate_51);
}

control do_truncate_52 {
  apply(t_truncate_52);
}

control do_truncate_53 {
  apply(t_truncate_53);
}

control do_truncate_54 {
  apply(t_truncate_54);
}

control do_truncate_55 {
  apply(t_truncate_55);
}

control do_truncate_56 {
  apply(t_truncate_56);
}

control do_truncate_57 {
  apply(t_truncate_57);
}

control do_truncate_58 {
  apply(t_truncate_58);
}

control do_truncate_59 {
  apply(t_truncate_59);
}
