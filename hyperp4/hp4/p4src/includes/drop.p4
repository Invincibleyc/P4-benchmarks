/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

drop.p4: Implements the drop primitive.
*/

action a_drop() {
  drop();
  modify_field(meta_ctrl.dropped, 1);
}

table t_drop_11 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_12 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_13 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_14 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_15 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_16 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_17 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_18 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_19 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_21 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_22 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_23 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_24 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_25 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_26 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_27 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_28 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_29 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_31 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_32 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_33 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_34 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_35 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_36 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_37 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_38 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_39 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_41 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_42 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_43 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_44 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_45 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_46 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_47 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_48 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_49 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_51 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_52 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_53 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_54 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_55 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_56 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_57 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_58 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

table t_drop_59 {
  reads {
    meta_ctrl.vdev_ID : exact;
  }
  actions {
    a_drop;
  }
}

control do_drop_11 {
  apply(t_drop_11);
}

control do_drop_12 {
  apply(t_drop_12);
}

control do_drop_13 {
  apply(t_drop_13);
}

control do_drop_14 {
  apply(t_drop_14);
}

control do_drop_15 {
  apply(t_drop_15);
}

control do_drop_16 {
  apply(t_drop_16);
}

control do_drop_17 {
  apply(t_drop_17);
}

control do_drop_18 {
  apply(t_drop_18);
}

control do_drop_19 {
  apply(t_drop_19);
}

control do_drop_21 {
  apply(t_drop_21);
}

control do_drop_22 {
  apply(t_drop_22);
}

control do_drop_23 {
  apply(t_drop_23);
}

control do_drop_24 {
  apply(t_drop_24);
}

control do_drop_25 {
  apply(t_drop_25);
}

control do_drop_26 {
  apply(t_drop_26);
}

control do_drop_27 {
  apply(t_drop_27);
}

control do_drop_28 {
  apply(t_drop_28);
}

control do_drop_29 {
  apply(t_drop_29);
}

control do_drop_31 {
  apply(t_drop_31);
}

control do_drop_32 {
  apply(t_drop_32);
}

control do_drop_33 {
  apply(t_drop_33);
}

control do_drop_34 {
  apply(t_drop_34);
}

control do_drop_35 {
  apply(t_drop_35);
}

control do_drop_36 {
  apply(t_drop_36);
}

control do_drop_37 {
  apply(t_drop_37);
}

control do_drop_38 {
  apply(t_drop_38);
}

control do_drop_39 {
  apply(t_drop_39);
}

control do_drop_41 {
  apply(t_drop_41);
}

control do_drop_42 {
  apply(t_drop_42);
}

control do_drop_43 {
  apply(t_drop_43);
}

control do_drop_44 {
  apply(t_drop_44);
}

control do_drop_45 {
  apply(t_drop_45);
}

control do_drop_46 {
  apply(t_drop_46);
}

control do_drop_47 {
  apply(t_drop_47);
}

control do_drop_48 {
  apply(t_drop_48);
}

control do_drop_49 {
  apply(t_drop_49);
}

control do_drop_51 {
  apply(t_drop_51);
}

control do_drop_52 {
  apply(t_drop_52);
}

control do_drop_53 {
  apply(t_drop_53);
}

control do_drop_54 {
  apply(t_drop_54);
}

control do_drop_55 {
  apply(t_drop_55);
}

control do_drop_56 {
  apply(t_drop_56);
}

control do_drop_57 {
  apply(t_drop_57);
}

control do_drop_58 {
  apply(t_drop_58);
}

control do_drop_59 {
  apply(t_drop_59);
}
