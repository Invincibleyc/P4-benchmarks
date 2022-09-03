/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

bit_xor.p4: Carry out the bit_xor primitive
*/

/*
  TODO: expand because there are three parameters in a bit_xor:
  - dst
  - fld/val 1
  - fld/val 2
  Combinatorics say that if we consider [meta|extracted] as
  options for dst, and [meta|extracted|const] for fld/val 1
  and fld/val 2, there would be 18 actions to cover all
  cases
*/

action bit_xor_meta_meta_const(mlshift, mrshift, vlshift,
                               dest_mask, src_mask,
                               val) {
  modify_field(tmeta.data,
    (tmeta.data & ~dest_mask) | 
      ( (((val << vlshift) ^ (tmeta.data & (src_mask << vlshift)))
        << mlshift) >> mrshift )
  );
}

action bit_xor_extracted_extracted_const(elshift, ershift, vlshift,
                                         dest_mask, src_mask,
                                         val) {
  modify_field(extracted.data,
    (extracted.data & ~dest_mask) | 
      ( (((val << vlshift) ^ (extracted.data & (src_mask << vlshift)))
        << elshift) >> ershift )
  );
}

action bit_xor_meta_extracted_const(elshift, ershift, vlshift,
                                    dest_mask, src_mask,
                                    val) {
  modify_field(tmeta.data,
    (tmeta.data & ~dest_mask) |
      ( (((val << vlshift) ^ (extracted.data & (src_mask << vlshift)))
        << elshift) >> ershift )
  );
}


table t_bit_xor_11 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_12 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_13 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_14 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_15 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_16 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_17 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_18 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_19 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_21 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_22 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_23 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_24 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_25 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_26 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_27 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_28 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_29 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_31 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_32 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_33 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_34 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_35 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_36 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_37 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_38 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_39 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_41 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_42 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_43 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_44 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_45 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_46 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_47 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_48 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_49 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_51 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype1 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_52 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype2 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_53 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype3 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_54 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype4 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_55 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype5 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_56 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype6 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_57 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype7 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_58 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype8 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

table t_bit_xor_59 {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.subtype9 : exact;
    meta_primitive_state.action_ID : exact;
    meta_primitive_state.match_ID : ternary;
  }
  actions {
    bit_xor_meta_meta_const;
    bit_xor_extracted_extracted_const;
    bit_xor_meta_extracted_const;
    _no_op;
  }
}

control do_bit_xor_11 {
  apply(t_bit_xor_11);
}


control do_bit_xor_12 {
  apply(t_bit_xor_12);
}


control do_bit_xor_13 {
  apply(t_bit_xor_13);
}


control do_bit_xor_14 {
  apply(t_bit_xor_14);
}


control do_bit_xor_15 {
  apply(t_bit_xor_15);
}


control do_bit_xor_16 {
  apply(t_bit_xor_16);
}


control do_bit_xor_17 {
  apply(t_bit_xor_17);
}


control do_bit_xor_18 {
  apply(t_bit_xor_18);
}


control do_bit_xor_19 {
  apply(t_bit_xor_19);
}


control do_bit_xor_21 {
  apply(t_bit_xor_21);
}


control do_bit_xor_22 {
  apply(t_bit_xor_22);
}


control do_bit_xor_23 {
  apply(t_bit_xor_23);
}


control do_bit_xor_24 {
  apply(t_bit_xor_24);
}


control do_bit_xor_25 {
  apply(t_bit_xor_25);
}


control do_bit_xor_26 {
  apply(t_bit_xor_26);
}


control do_bit_xor_27 {
  apply(t_bit_xor_27);
}


control do_bit_xor_28 {
  apply(t_bit_xor_28);
}


control do_bit_xor_29 {
  apply(t_bit_xor_29);
}


control do_bit_xor_31 {
  apply(t_bit_xor_31);
}


control do_bit_xor_32 {
  apply(t_bit_xor_32);
}


control do_bit_xor_33 {
  apply(t_bit_xor_33);
}


control do_bit_xor_34 {
  apply(t_bit_xor_34);
}


control do_bit_xor_35 {
  apply(t_bit_xor_35);
}


control do_bit_xor_36 {
  apply(t_bit_xor_36);
}


control do_bit_xor_37 {
  apply(t_bit_xor_37);
}


control do_bit_xor_38 {
  apply(t_bit_xor_38);
}


control do_bit_xor_39 {
  apply(t_bit_xor_39);
}


control do_bit_xor_41 {
  apply(t_bit_xor_41);
}


control do_bit_xor_42 {
  apply(t_bit_xor_42);
}


control do_bit_xor_43 {
  apply(t_bit_xor_43);
}


control do_bit_xor_44 {
  apply(t_bit_xor_44);
}


control do_bit_xor_45 {
  apply(t_bit_xor_45);
}


control do_bit_xor_46 {
  apply(t_bit_xor_46);
}


control do_bit_xor_47 {
  apply(t_bit_xor_47);
}


control do_bit_xor_48 {
  apply(t_bit_xor_48);
}


control do_bit_xor_49 {
  apply(t_bit_xor_49);
}


control do_bit_xor_51 {
  apply(t_bit_xor_51);
}


control do_bit_xor_52 {
  apply(t_bit_xor_52);
}


control do_bit_xor_53 {
  apply(t_bit_xor_53);
}


control do_bit_xor_54 {
  apply(t_bit_xor_54);
}


control do_bit_xor_55 {
  apply(t_bit_xor_55);
}


control do_bit_xor_56 {
  apply(t_bit_xor_56);
}


control do_bit_xor_57 {
  apply(t_bit_xor_57);
}


control do_bit_xor_58 {
  apply(t_bit_xor_58);
}


control do_bit_xor_59 {
  apply(t_bit_xor_59);
}

