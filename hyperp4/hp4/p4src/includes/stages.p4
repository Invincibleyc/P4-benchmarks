/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

stages.p4: Each control function executes a single match-action stage of a
           target P4 program.

           The set_program_state tables guide execution from one primtive to
           the next.
*/

#include "match.p4"
#include "switch_primitivetype.p4"

/*
action update_state(primitive, primitive_subtype) {
  modify_field(meta_primitive_state.primitive_index, 
               meta_primitive_state.primitive_index + 1);
  modify_field(meta_primitive_state.primitive, primitive);
  modify_field(meta_primitive_state.subtype, primitive_subtype);
}

action finish_action() {
  modify_field(meta_primitive_state.action_ID, 0);
}

table tstg11_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg12_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg13_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg14_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg15_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg16_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg17_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg18_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg19_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg21_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg22_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg23_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg24_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg25_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg26_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg27_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg28_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg29_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg31_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg32_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg33_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg34_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg35_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg36_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg37_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg38_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg39_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg41_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg42_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg43_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg44_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg45_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg46_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg47_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg48_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg49_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg51_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg52_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg53_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg54_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg55_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg56_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg57_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg58_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}

table tstg59_update_state {
  reads {
    meta_ctrl.vdev_ID : exact;
    meta_primitive_state.action_ID : exact;
  }
  actions {
    update_state;
    finish_action;
  }
}
*/

control stage1 {
  match_1(); // match.p4
  if(meta_primitive_state.primitive1 != 0) { // 27|128|...
    switch_primitivetype_11(); // switch_primitivetype.p4
    // apply(tstg11_update_state);
    if(meta_primitive_state.primitive2 != 0) { // 27|128|...
      switch_primitivetype_12(); // switch_primitivetype.p4
      // apply(tstg12_update_state);
      if(meta_primitive_state.primitive3 != 0) { // 27|128|...
        switch_primitivetype_13(); // switch_primitivetype.p4
        // apply(tstg13_update_state);
        if(meta_primitive_state.primitive4 != 0) { // 27|128|...
          switch_primitivetype_14(); // switch_primitivetype.p4
          // apply(tstg14_update_state);
          if(meta_primitive_state.primitive5 != 0) { // 27|128|...
            switch_primitivetype_15(); // switch_primitivetype.p4
            // apply(tstg15_update_state);
            if(meta_primitive_state.primitive6 != 0) { // 27|128|...
              switch_primitivetype_16(); // switch_primitivetype.p4
              // apply(tstg16_update_state);
              if(meta_primitive_state.primitive7 != 0) { // 27|128|...
                switch_primitivetype_17(); // switch_primitivetype.p4
                // apply(tstg17_update_state);
                if(meta_primitive_state.primitive8 != 0) { // 27|128|...
                  switch_primitivetype_18(); // switch_primitivetype.p4
                  // apply(tstg18_update_state);
                  if(meta_primitive_state.primitive9 != 0) { // 27|128|...
                    switch_primitivetype_19(); // switch_primitivetype.p4
                    // apply(tstg19_update_state);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

control stage2 {
  match_2(); // match.p4
  if(meta_primitive_state.primitive1 != 0) { // 27|128|...
    switch_primitivetype_21(); // switch_primitivetype.p4
    // apply(tstg21_update_state);
    if(meta_primitive_state.primitive2 != 0) { // 27|128|...
      switch_primitivetype_22(); // switch_primitivetype.p4
      // apply(tstg22_update_state);
      if(meta_primitive_state.primitive3 != 0) { // 27|128|...
        switch_primitivetype_23(); // switch_primitivetype.p4
        // apply(tstg23_update_state);
        if(meta_primitive_state.primitive4 != 0) { // 27|128|...
          switch_primitivetype_24(); // switch_primitivetype.p4
          // apply(tstg24_update_state);
          if(meta_primitive_state.primitive5 != 0) { // 27|128|...
            switch_primitivetype_25(); // switch_primitivetype.p4
            // apply(tstg25_update_state);
            if(meta_primitive_state.primitive6 != 0) { // 27|128|...
              switch_primitivetype_26(); // switch_primitivetype.p4
              // apply(tstg26_update_state);
              if(meta_primitive_state.primitive7 != 0) { // 27|128|...
                switch_primitivetype_27(); // switch_primitivetype.p4
                // apply(tstg27_update_state);
                if(meta_primitive_state.primitive8 != 0) { // 27|128|...
                  switch_primitivetype_28(); // switch_primitivetype.p4
                  // apply(tstg28_update_state);
                  if(meta_primitive_state.primitive9 != 0) { // 27|128|...
                    switch_primitivetype_29(); // switch_primitivetype.p4
                    // apply(tstg29_update_state);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

control stage3 {
  match_3(); // match.p4
  if(meta_primitive_state.primitive1 != 0) { // 27|128|...
    switch_primitivetype_31(); // switch_primitivetype.p4
    // apply(tstg31_update_state);
    if(meta_primitive_state.primitive2 != 0) { // 27|128|...
      switch_primitivetype_32(); // switch_primitivetype.p4
      // apply(tstg32_update_state);
      if(meta_primitive_state.primitive3 != 0) { // 27|128|...
        switch_primitivetype_33(); // switch_primitivetype.p4
        // apply(tstg33_update_state);
        if(meta_primitive_state.primitive4 != 0) { // 27|128|...
          switch_primitivetype_34(); // switch_primitivetype.p4
          // apply(tstg34_update_state);
          if(meta_primitive_state.primitive5 != 0) { // 27|128|...
            switch_primitivetype_35(); // switch_primitivetype.p4
            // apply(tstg35_update_state);
            if(meta_primitive_state.primitive6 != 0) { // 27|128|...
              switch_primitivetype_36(); // switch_primitivetype.p4
              // apply(tstg36_update_state);
              if(meta_primitive_state.primitive7 != 0) { // 27|128|...
                switch_primitivetype_37(); // switch_primitivetype.p4
                // apply(tstg37_update_state);
                if(meta_primitive_state.primitive8 != 0) { // 27|128|...
                  switch_primitivetype_38(); // switch_primitivetype.p4
                  // apply(tstg38_update_state);
                  if(meta_primitive_state.primitive9 != 0) { // 27|128|...
                    switch_primitivetype_39(); // switch_primitivetype.p4
                    // apply(tstg39_update_state);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

control stage4 {
  match_4(); // match.p4
  if(meta_primitive_state.primitive1 != 0) { // 27|128|...
    switch_primitivetype_41(); // switch_primitivetype.p4
    // apply(tstg41_update_state);
    if(meta_primitive_state.primitive2 != 0) { // 27|128|...
      switch_primitivetype_42(); // switch_primitivetype.p4
      // apply(tstg42_update_state);
      if(meta_primitive_state.primitive3 != 0) { // 27|128|...
        switch_primitivetype_43(); // switch_primitivetype.p4
        // apply(tstg43_update_state);
        if(meta_primitive_state.primitive4 != 0) { // 27|128|...
          switch_primitivetype_44(); // switch_primitivetype.p4
          // apply(tstg44_update_state);
          if(meta_primitive_state.primitive5 != 0) { // 27|128|...
            switch_primitivetype_45(); // switch_primitivetype.p4
            // apply(tstg45_update_state);
            if(meta_primitive_state.primitive6 != 0) { // 27|128|...
              switch_primitivetype_46(); // switch_primitivetype.p4
              // apply(tstg46_update_state);
              if(meta_primitive_state.primitive7 != 0) { // 27|128|...
                switch_primitivetype_47(); // switch_primitivetype.p4
                // apply(tstg47_update_state);
                if(meta_primitive_state.primitive8 != 0) { // 27|128|...
                  switch_primitivetype_48(); // switch_primitivetype.p4
                  // apply(tstg48_update_state);
                  if(meta_primitive_state.primitive9 != 0) { // 27|128|...
                    switch_primitivetype_49(); // switch_primitivetype.p4
                    // apply(tstg49_update_state);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

control stage5 {
  match_5(); // match.p4
  if(meta_primitive_state.primitive1 != 0) { // 27|128|...
    switch_primitivetype_51(); // switch_primitivetype.p4
    // apply(tstg51_update_state);
    if(meta_primitive_state.primitive2 != 0) { // 27|128|...
      switch_primitivetype_52(); // switch_primitivetype.p4
      // apply(tstg52_update_state);
      if(meta_primitive_state.primitive3 != 0) { // 27|128|...
        switch_primitivetype_53(); // switch_primitivetype.p4
        // apply(tstg53_update_state);
        if(meta_primitive_state.primitive4 != 0) { // 27|128|...
          switch_primitivetype_54(); // switch_primitivetype.p4
          // apply(tstg54_update_state);
          if(meta_primitive_state.primitive5 != 0) { // 27|128|...
            switch_primitivetype_55(); // switch_primitivetype.p4
            // apply(tstg55_update_state);
            if(meta_primitive_state.primitive6 != 0) { // 27|128|...
              switch_primitivetype_56(); // switch_primitivetype.p4
              // apply(tstg56_update_state);
              if(meta_primitive_state.primitive7 != 0) { // 27|128|...
                switch_primitivetype_57(); // switch_primitivetype.p4
                // apply(tstg57_update_state);
                if(meta_primitive_state.primitive8 != 0) { // 27|128|...
                  switch_primitivetype_58(); // switch_primitivetype.p4
                  // apply(tstg58_update_state);
                  if(meta_primitive_state.primitive9 != 0) { // 27|128|...
                    switch_primitivetype_59(); // switch_primitivetype.p4
                    // apply(tstg59_update_state);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

