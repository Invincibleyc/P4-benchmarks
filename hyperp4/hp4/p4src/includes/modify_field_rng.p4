/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

modify_field_rng.p4: Random number generation.
*/

action mod_extracted_rng(leftshift, emask, lowerbound, upperbound) {
  modify_field_rng_uniform(temp.data, lowerbound, upperbound);
  modify_field(extracted.data, (extracted.data & ~emask) | ((temp.data << leftshift) & emask));
}

table t_mod_rng_11 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_12 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_13 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_14 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_15 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_16 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_17 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_18 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_19 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_21 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_22 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_23 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_24 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_25 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_26 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_27 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_28 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_29 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_31 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_32 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_33 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_34 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_35 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_36 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_37 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_38 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_39 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_41 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_42 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_43 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_44 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_45 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_46 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_47 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_48 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_49 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_51 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_52 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_53 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_54 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_55 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_56 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_57 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_58 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

table t_mod_rng_59 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    mod_extracted_rng;
    _no_op;
  }
}

control do_modify_field_rng_11 {
  apply(t_mod_rng_11);
}


control do_modify_field_rng_12 {
  apply(t_mod_rng_12);
}


control do_modify_field_rng_13 {
  apply(t_mod_rng_13);
}


control do_modify_field_rng_14 {
  apply(t_mod_rng_14);
}


control do_modify_field_rng_15 {
  apply(t_mod_rng_15);
}


control do_modify_field_rng_16 {
  apply(t_mod_rng_16);
}


control do_modify_field_rng_17 {
  apply(t_mod_rng_17);
}


control do_modify_field_rng_18 {
  apply(t_mod_rng_18);
}


control do_modify_field_rng_19 {
  apply(t_mod_rng_19);
}


control do_modify_field_rng_21 {
  apply(t_mod_rng_21);
}


control do_modify_field_rng_22 {
  apply(t_mod_rng_22);
}


control do_modify_field_rng_23 {
  apply(t_mod_rng_23);
}


control do_modify_field_rng_24 {
  apply(t_mod_rng_24);
}


control do_modify_field_rng_25 {
  apply(t_mod_rng_25);
}


control do_modify_field_rng_26 {
  apply(t_mod_rng_26);
}


control do_modify_field_rng_27 {
  apply(t_mod_rng_27);
}


control do_modify_field_rng_28 {
  apply(t_mod_rng_28);
}


control do_modify_field_rng_29 {
  apply(t_mod_rng_29);
}


control do_modify_field_rng_31 {
  apply(t_mod_rng_31);
}


control do_modify_field_rng_32 {
  apply(t_mod_rng_32);
}


control do_modify_field_rng_33 {
  apply(t_mod_rng_33);
}


control do_modify_field_rng_34 {
  apply(t_mod_rng_34);
}


control do_modify_field_rng_35 {
  apply(t_mod_rng_35);
}


control do_modify_field_rng_36 {
  apply(t_mod_rng_36);
}


control do_modify_field_rng_37 {
  apply(t_mod_rng_37);
}


control do_modify_field_rng_38 {
  apply(t_mod_rng_38);
}


control do_modify_field_rng_39 {
  apply(t_mod_rng_39);
}


control do_modify_field_rng_41 {
  apply(t_mod_rng_41);
}


control do_modify_field_rng_42 {
  apply(t_mod_rng_42);
}


control do_modify_field_rng_43 {
  apply(t_mod_rng_43);
}


control do_modify_field_rng_44 {
  apply(t_mod_rng_44);
}


control do_modify_field_rng_45 {
  apply(t_mod_rng_45);
}


control do_modify_field_rng_46 {
  apply(t_mod_rng_46);
}


control do_modify_field_rng_47 {
  apply(t_mod_rng_47);
}


control do_modify_field_rng_48 {
  apply(t_mod_rng_48);
}


control do_modify_field_rng_49 {
  apply(t_mod_rng_49);
}


control do_modify_field_rng_51 {
  apply(t_mod_rng_51);
}


control do_modify_field_rng_52 {
  apply(t_mod_rng_52);
}


control do_modify_field_rng_53 {
  apply(t_mod_rng_53);
}


control do_modify_field_rng_54 {
  apply(t_mod_rng_54);
}


control do_modify_field_rng_55 {
  apply(t_mod_rng_55);
}


control do_modify_field_rng_56 {
  apply(t_mod_rng_56);
}


control do_modify_field_rng_57 {
  apply(t_mod_rng_57);
}


control do_modify_field_rng_58 {
  apply(t_mod_rng_58);
}


control do_modify_field_rng_59 {
  apply(t_mod_rng_59);
}

