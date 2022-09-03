/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

switch_primitivetype.p4: Redirect execution to the control function appropriate
                         for the next primitive in the target P4 program
*/

#include "modify_field.p4"
#include "add_header.p4"
#include "copy_header.p4"
#include "remove_header.p4"
#include "push.p4"
#include "pop.p4"
#include "drop.p4"
#include "multicast.p4"
#include "math_on_field.p4"
#include "truncate.p4"
#include "modify_field_rng.p4"
#include "bit_xor.p4"

control switch_primitivetype_11 {
  if(meta_primitive_state.primitive1 == A_MODIFY_FIELD) {
    do_modify_field_11();
  }
  else if(meta_primitive_state.primitive1 == A_ADD_HEADER) {
    do_add_header_11();
  }
  else if(meta_primitive_state.primitive1 == A_REMOVE_HEADER) {
    do_remove_header_11();
  }
  else if(meta_primitive_state.primitive1 == A_TRUNCATE) {
    do_truncate_11();
  }
  else if(meta_primitive_state.primitive1 == A_DROP) {
    do_drop_11();
  }
  else if(meta_primitive_state.primitive1 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive1 == A_MULTICAST) {
    do_multicast_11();
  }
  else if(meta_primitive_state.primitive1 == A_MATH_ON_FIELD) {
    do_math_on_field_11();
  }
  else if(meta_primitive_state.primitive1 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_11();
  }
  else if(meta_primitive_state.primitive1 == A_BIT_XOR) {
    do_bit_xor_11();
  }
}

control switch_primitivetype_12 {
  if(meta_primitive_state.primitive2 == A_MODIFY_FIELD) {
    do_modify_field_12();
  }
  else if(meta_primitive_state.primitive2 == A_ADD_HEADER) {
    do_add_header_12();
  }
  else if(meta_primitive_state.primitive2 == A_REMOVE_HEADER) {
    do_remove_header_12();
  }
  else if(meta_primitive_state.primitive2 == A_TRUNCATE) {
    do_truncate_12();
  }
  else if(meta_primitive_state.primitive2 == A_DROP) {
    do_drop_12();
  }
  else if(meta_primitive_state.primitive2 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive2 == A_MULTICAST) {
    do_multicast_12();
  }
  else if(meta_primitive_state.primitive2 == A_MATH_ON_FIELD) {
    do_math_on_field_12();
  }
  else if(meta_primitive_state.primitive2 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_12();
  }
  else if(meta_primitive_state.primitive2 == A_BIT_XOR) {
    do_bit_xor_12();
  }
}

control switch_primitivetype_13 {
  if(meta_primitive_state.primitive3 == A_MODIFY_FIELD) {
    do_modify_field_13();
  }
  else if(meta_primitive_state.primitive3 == A_ADD_HEADER) {
    do_add_header_13();
  }
  else if(meta_primitive_state.primitive3 == A_REMOVE_HEADER) {
    do_remove_header_13();
  }
  else if(meta_primitive_state.primitive3 == A_TRUNCATE) {
    do_truncate_13();
  }
  else if(meta_primitive_state.primitive3 == A_DROP) {
    do_drop_13();
  }
  else if(meta_primitive_state.primitive3 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive3 == A_MULTICAST) {
    do_multicast_13();
  }
  else if(meta_primitive_state.primitive3 == A_MATH_ON_FIELD) {
    do_math_on_field_13();
  }
  else if(meta_primitive_state.primitive3 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_13();
  }
  else if(meta_primitive_state.primitive3 == A_BIT_XOR) {
    do_bit_xor_13();
  }
}

control switch_primitivetype_14 {
  if(meta_primitive_state.primitive4 == A_MODIFY_FIELD) {
    do_modify_field_14();
  }
  else if(meta_primitive_state.primitive4 == A_ADD_HEADER) {
    do_add_header_14();
  }
  else if(meta_primitive_state.primitive4 == A_REMOVE_HEADER) {
    do_remove_header_14();
  }
  else if(meta_primitive_state.primitive4 == A_TRUNCATE) {
    do_truncate_14();
  }
  else if(meta_primitive_state.primitive4 == A_DROP) {
    do_drop_14();
  }
  else if(meta_primitive_state.primitive4 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive4 == A_MULTICAST) {
    do_multicast_14();
  }
  else if(meta_primitive_state.primitive4 == A_MATH_ON_FIELD) {
    do_math_on_field_14();
  }
  else if(meta_primitive_state.primitive4 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_14();
  }
  else if(meta_primitive_state.primitive4 == A_BIT_XOR) {
    do_bit_xor_14();
  }
}

control switch_primitivetype_15 {
  if(meta_primitive_state.primitive5 == A_MODIFY_FIELD) {
    do_modify_field_15();
  }
  else if(meta_primitive_state.primitive5 == A_ADD_HEADER) {
    do_add_header_15();
  }
  else if(meta_primitive_state.primitive5 == A_REMOVE_HEADER) {
    do_remove_header_15();
  }
  else if(meta_primitive_state.primitive5 == A_TRUNCATE) {
    do_truncate_15();
  }
  else if(meta_primitive_state.primitive5 == A_DROP) {
    do_drop_15();
  }
  else if(meta_primitive_state.primitive5 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive5 == A_MULTICAST) {
    do_multicast_15();
  }
  else if(meta_primitive_state.primitive5 == A_MATH_ON_FIELD) {
    do_math_on_field_15();
  }
  else if(meta_primitive_state.primitive5 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_15();
  }
  else if(meta_primitive_state.primitive5 == A_BIT_XOR) {
    do_bit_xor_15();
  }
}

control switch_primitivetype_16 {
  if(meta_primitive_state.primitive6 == A_MODIFY_FIELD) {
    do_modify_field_16();
  }
  else if(meta_primitive_state.primitive6 == A_ADD_HEADER) {
    do_add_header_16();
  }
  else if(meta_primitive_state.primitive6 == A_REMOVE_HEADER) {
    do_remove_header_16();
  }
  else if(meta_primitive_state.primitive6 == A_TRUNCATE) {
    do_truncate_16();
  }
  else if(meta_primitive_state.primitive6 == A_DROP) {
    do_drop_16();
  }
  else if(meta_primitive_state.primitive6 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive6 == A_MULTICAST) {
    do_multicast_16();
  }
  else if(meta_primitive_state.primitive6 == A_MATH_ON_FIELD) {
    do_math_on_field_16();
  }
  else if(meta_primitive_state.primitive6 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_16();
  }
  else if(meta_primitive_state.primitive6 == A_BIT_XOR) {
    do_bit_xor_16();
  }
}

control switch_primitivetype_17 {
  if(meta_primitive_state.primitive7 == A_MODIFY_FIELD) {
    do_modify_field_17();
  }
  else if(meta_primitive_state.primitive7 == A_ADD_HEADER) {
    do_add_header_17();
  }
  else if(meta_primitive_state.primitive7 == A_REMOVE_HEADER) {
    do_remove_header_17();
  }
  else if(meta_primitive_state.primitive7 == A_TRUNCATE) {
    do_truncate_17();
  }
  else if(meta_primitive_state.primitive7 == A_DROP) {
    do_drop_17();
  }
  else if(meta_primitive_state.primitive7 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive7 == A_MULTICAST) {
    do_multicast_17();
  }
  else if(meta_primitive_state.primitive7 == A_MATH_ON_FIELD) {
    do_math_on_field_17();
  }
  else if(meta_primitive_state.primitive7 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_17();
  }
  else if(meta_primitive_state.primitive7 == A_BIT_XOR) {
    do_bit_xor_17();
  }
}

control switch_primitivetype_18 {
  if(meta_primitive_state.primitive8 == A_MODIFY_FIELD) {
    do_modify_field_18();
  }
  else if(meta_primitive_state.primitive8 == A_ADD_HEADER) {
    do_add_header_18();
  }
  else if(meta_primitive_state.primitive8 == A_REMOVE_HEADER) {
    do_remove_header_18();
  }
  else if(meta_primitive_state.primitive8 == A_TRUNCATE) {
    do_truncate_18();
  }
  else if(meta_primitive_state.primitive8 == A_DROP) {
    do_drop_18();
  }
  else if(meta_primitive_state.primitive8 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive8 == A_MULTICAST) {
    do_multicast_18();
  }
  else if(meta_primitive_state.primitive8 == A_MATH_ON_FIELD) {
    do_math_on_field_18();
  }
  else if(meta_primitive_state.primitive8 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_18();
  }
  else if(meta_primitive_state.primitive8 == A_BIT_XOR) {
    do_bit_xor_18();
  }
}

control switch_primitivetype_19 {
  if(meta_primitive_state.primitive9 == A_MODIFY_FIELD) {
    do_modify_field_19();
  }
  else if(meta_primitive_state.primitive9 == A_ADD_HEADER) {
    do_add_header_19();
  }
  else if(meta_primitive_state.primitive9 == A_REMOVE_HEADER) {
    do_remove_header_19();
  }
  else if(meta_primitive_state.primitive9 == A_TRUNCATE) {
    do_truncate_19();
  }
  else if(meta_primitive_state.primitive9 == A_DROP) {
    do_drop_19();
  }
  else if(meta_primitive_state.primitive9 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive9 == A_MULTICAST) {
    do_multicast_19();
  }
  else if(meta_primitive_state.primitive9 == A_MATH_ON_FIELD) {
    do_math_on_field_19();
  }
  else if(meta_primitive_state.primitive9 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_19();
  }
  else if(meta_primitive_state.primitive9 == A_BIT_XOR) {
    do_bit_xor_19();
  }
}

control switch_primitivetype_21 {
  if(meta_primitive_state.primitive1 == A_MODIFY_FIELD) {
    do_modify_field_21();
  }
  else if(meta_primitive_state.primitive1 == A_ADD_HEADER) {
    do_add_header_21();
  }
  else if(meta_primitive_state.primitive1 == A_REMOVE_HEADER) {
    do_remove_header_21();
  }
  else if(meta_primitive_state.primitive1 == A_TRUNCATE) {
    do_truncate_21();
  }
  else if(meta_primitive_state.primitive1 == A_DROP) {
    do_drop_21();
  }
  else if(meta_primitive_state.primitive1 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive1 == A_MULTICAST) {
    do_multicast_21();
  }
  else if(meta_primitive_state.primitive1 == A_MATH_ON_FIELD) {
    do_math_on_field_21();
  }
  else if(meta_primitive_state.primitive1 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_21();
  }
  else if(meta_primitive_state.primitive1 == A_BIT_XOR) {
    do_bit_xor_21();
  }
}

control switch_primitivetype_22 {
  if(meta_primitive_state.primitive2 == A_MODIFY_FIELD) {
    do_modify_field_22();
  }
  else if(meta_primitive_state.primitive2 == A_ADD_HEADER) {
    do_add_header_22();
  }
  else if(meta_primitive_state.primitive2 == A_REMOVE_HEADER) {
    do_remove_header_22();
  }
  else if(meta_primitive_state.primitive2 == A_TRUNCATE) {
    do_truncate_22();
  }
  else if(meta_primitive_state.primitive2 == A_DROP) {
    do_drop_22();
  }
  else if(meta_primitive_state.primitive2 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive2 == A_MULTICAST) {
    do_multicast_22();
  }
  else if(meta_primitive_state.primitive2 == A_MATH_ON_FIELD) {
    do_math_on_field_22();
  }
  else if(meta_primitive_state.primitive2 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_22();
  }
  else if(meta_primitive_state.primitive2 == A_BIT_XOR) {
    do_bit_xor_22();
  }
}

control switch_primitivetype_23 {
  if(meta_primitive_state.primitive3 == A_MODIFY_FIELD) {
    do_modify_field_23();
  }
  else if(meta_primitive_state.primitive3 == A_ADD_HEADER) {
    do_add_header_23();
  }
  else if(meta_primitive_state.primitive3 == A_REMOVE_HEADER) {
    do_remove_header_23();
  }
  else if(meta_primitive_state.primitive3 == A_TRUNCATE) {
    do_truncate_23();
  }
  else if(meta_primitive_state.primitive3 == A_DROP) {
    do_drop_23();
  }
  else if(meta_primitive_state.primitive3 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive3 == A_MULTICAST) {
    do_multicast_23();
  }
  else if(meta_primitive_state.primitive3 == A_MATH_ON_FIELD) {
    do_math_on_field_23();
  }
  else if(meta_primitive_state.primitive3 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_23();
  }
  else if(meta_primitive_state.primitive3 == A_BIT_XOR) {
    do_bit_xor_23();
  }
}

control switch_primitivetype_24 {
  if(meta_primitive_state.primitive4 == A_MODIFY_FIELD) {
    do_modify_field_24();
  }
  else if(meta_primitive_state.primitive4 == A_ADD_HEADER) {
    do_add_header_24();
  }
  else if(meta_primitive_state.primitive4 == A_REMOVE_HEADER) {
    do_remove_header_24();
  }
  else if(meta_primitive_state.primitive4 == A_TRUNCATE) {
    do_truncate_24();
  }
  else if(meta_primitive_state.primitive4 == A_DROP) {
    do_drop_24();
  }
  else if(meta_primitive_state.primitive4 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive4 == A_MULTICAST) {
    do_multicast_24();
  }
  else if(meta_primitive_state.primitive4 == A_MATH_ON_FIELD) {
    do_math_on_field_24();
  }
  else if(meta_primitive_state.primitive4 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_24();
  }
  else if(meta_primitive_state.primitive4 == A_BIT_XOR) {
    do_bit_xor_24();
  }
}

control switch_primitivetype_25 {
  if(meta_primitive_state.primitive5 == A_MODIFY_FIELD) {
    do_modify_field_25();
  }
  else if(meta_primitive_state.primitive5 == A_ADD_HEADER) {
    do_add_header_25();
  }
  else if(meta_primitive_state.primitive5 == A_REMOVE_HEADER) {
    do_remove_header_25();
  }
  else if(meta_primitive_state.primitive5 == A_TRUNCATE) {
    do_truncate_25();
  }
  else if(meta_primitive_state.primitive5 == A_DROP) {
    do_drop_25();
  }
  else if(meta_primitive_state.primitive5 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive5 == A_MULTICAST) {
    do_multicast_25();
  }
  else if(meta_primitive_state.primitive5 == A_MATH_ON_FIELD) {
    do_math_on_field_25();
  }
  else if(meta_primitive_state.primitive5 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_25();
  }
  else if(meta_primitive_state.primitive5 == A_BIT_XOR) {
    do_bit_xor_25();
  }
}

control switch_primitivetype_26 {
  if(meta_primitive_state.primitive6 == A_MODIFY_FIELD) {
    do_modify_field_26();
  }
  else if(meta_primitive_state.primitive6 == A_ADD_HEADER) {
    do_add_header_26();
  }
  else if(meta_primitive_state.primitive6 == A_REMOVE_HEADER) {
    do_remove_header_26();
  }
  else if(meta_primitive_state.primitive6 == A_TRUNCATE) {
    do_truncate_26();
  }
  else if(meta_primitive_state.primitive6 == A_DROP) {
    do_drop_26();
  }
  else if(meta_primitive_state.primitive6 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive6 == A_MULTICAST) {
    do_multicast_26();
  }
  else if(meta_primitive_state.primitive6 == A_MATH_ON_FIELD) {
    do_math_on_field_26();
  }
  else if(meta_primitive_state.primitive6 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_26();
  }
  else if(meta_primitive_state.primitive6 == A_BIT_XOR) {
    do_bit_xor_26();
  }
}

control switch_primitivetype_27 {
  if(meta_primitive_state.primitive7 == A_MODIFY_FIELD) {
    do_modify_field_27();
  }
  else if(meta_primitive_state.primitive7 == A_ADD_HEADER) {
    do_add_header_27();
  }
  else if(meta_primitive_state.primitive7 == A_REMOVE_HEADER) {
    do_remove_header_27();
  }
  else if(meta_primitive_state.primitive7 == A_TRUNCATE) {
    do_truncate_27();
  }
  else if(meta_primitive_state.primitive7 == A_DROP) {
    do_drop_27();
  }
  else if(meta_primitive_state.primitive7 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive7 == A_MULTICAST) {
    do_multicast_27();
  }
  else if(meta_primitive_state.primitive7 == A_MATH_ON_FIELD) {
    do_math_on_field_27();
  }
  else if(meta_primitive_state.primitive7 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_27();
  }
  else if(meta_primitive_state.primitive7 == A_BIT_XOR) {
    do_bit_xor_27();
  }
}

control switch_primitivetype_28 {
  if(meta_primitive_state.primitive8 == A_MODIFY_FIELD) {
    do_modify_field_28();
  }
  else if(meta_primitive_state.primitive8 == A_ADD_HEADER) {
    do_add_header_28();
  }
  else if(meta_primitive_state.primitive8 == A_REMOVE_HEADER) {
    do_remove_header_28();
  }
  else if(meta_primitive_state.primitive8 == A_TRUNCATE) {
    do_truncate_28();
  }
  else if(meta_primitive_state.primitive8 == A_DROP) {
    do_drop_28();
  }
  else if(meta_primitive_state.primitive8 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive8 == A_MULTICAST) {
    do_multicast_28();
  }
  else if(meta_primitive_state.primitive8 == A_MATH_ON_FIELD) {
    do_math_on_field_28();
  }
  else if(meta_primitive_state.primitive8 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_28();
  }
  else if(meta_primitive_state.primitive8 == A_BIT_XOR) {
    do_bit_xor_28();
  }
}

control switch_primitivetype_29 {
  if(meta_primitive_state.primitive9 == A_MODIFY_FIELD) {
    do_modify_field_29();
  }
  else if(meta_primitive_state.primitive9 == A_ADD_HEADER) {
    do_add_header_29();
  }
  else if(meta_primitive_state.primitive9 == A_REMOVE_HEADER) {
    do_remove_header_29();
  }
  else if(meta_primitive_state.primitive9 == A_TRUNCATE) {
    do_truncate_29();
  }
  else if(meta_primitive_state.primitive9 == A_DROP) {
    do_drop_29();
  }
  else if(meta_primitive_state.primitive9 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive9 == A_MULTICAST) {
    do_multicast_29();
  }
  else if(meta_primitive_state.primitive9 == A_MATH_ON_FIELD) {
    do_math_on_field_29();
  }
  else if(meta_primitive_state.primitive9 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_29();
  }
  else if(meta_primitive_state.primitive9 == A_BIT_XOR) {
    do_bit_xor_29();
  }
}

control switch_primitivetype_31 {
  if(meta_primitive_state.primitive1 == A_MODIFY_FIELD) {
    do_modify_field_31();
  }
  else if(meta_primitive_state.primitive1 == A_ADD_HEADER) {
    do_add_header_31();
  }
  else if(meta_primitive_state.primitive1 == A_REMOVE_HEADER) {
    do_remove_header_31();
  }
  else if(meta_primitive_state.primitive1 == A_TRUNCATE) {
    do_truncate_31();
  }
  else if(meta_primitive_state.primitive1 == A_DROP) {
    do_drop_31();
  }
  else if(meta_primitive_state.primitive1 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive1 == A_MULTICAST) {
    do_multicast_31();
  }
  else if(meta_primitive_state.primitive1 == A_MATH_ON_FIELD) {
    do_math_on_field_31();
  }
  else if(meta_primitive_state.primitive1 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_31();
  }
  else if(meta_primitive_state.primitive1 == A_BIT_XOR) {
    do_bit_xor_31();
  }
}

control switch_primitivetype_32 {
  if(meta_primitive_state.primitive2 == A_MODIFY_FIELD) {
    do_modify_field_32();
  }
  else if(meta_primitive_state.primitive2 == A_ADD_HEADER) {
    do_add_header_32();
  }
  else if(meta_primitive_state.primitive2 == A_REMOVE_HEADER) {
    do_remove_header_32();
  }
  else if(meta_primitive_state.primitive2 == A_TRUNCATE) {
    do_truncate_32();
  }
  else if(meta_primitive_state.primitive2 == A_DROP) {
    do_drop_32();
  }
  else if(meta_primitive_state.primitive2 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive2 == A_MULTICAST) {
    do_multicast_32();
  }
  else if(meta_primitive_state.primitive2 == A_MATH_ON_FIELD) {
    do_math_on_field_32();
  }
  else if(meta_primitive_state.primitive2 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_32();
  }
  else if(meta_primitive_state.primitive2 == A_BIT_XOR) {
    do_bit_xor_32();
  }
}

control switch_primitivetype_33 {
  if(meta_primitive_state.primitive3 == A_MODIFY_FIELD) {
    do_modify_field_33();
  }
  else if(meta_primitive_state.primitive3 == A_ADD_HEADER) {
    do_add_header_33();
  }
  else if(meta_primitive_state.primitive3 == A_REMOVE_HEADER) {
    do_remove_header_33();
  }
  else if(meta_primitive_state.primitive3 == A_TRUNCATE) {
    do_truncate_33();
  }
  else if(meta_primitive_state.primitive3 == A_DROP) {
    do_drop_33();
  }
  else if(meta_primitive_state.primitive3 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive3 == A_MULTICAST) {
    do_multicast_33();
  }
  else if(meta_primitive_state.primitive3 == A_MATH_ON_FIELD) {
    do_math_on_field_33();
  }
  else if(meta_primitive_state.primitive3 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_33();
  }
  else if(meta_primitive_state.primitive3 == A_BIT_XOR) {
    do_bit_xor_33();
  }
}

control switch_primitivetype_34 {
  if(meta_primitive_state.primitive4 == A_MODIFY_FIELD) {
    do_modify_field_34();
  }
  else if(meta_primitive_state.primitive4 == A_ADD_HEADER) {
    do_add_header_34();
  }
  else if(meta_primitive_state.primitive4 == A_REMOVE_HEADER) {
    do_remove_header_34();
  }
  else if(meta_primitive_state.primitive4 == A_TRUNCATE) {
    do_truncate_34();
  }
  else if(meta_primitive_state.primitive4 == A_DROP) {
    do_drop_34();
  }
  else if(meta_primitive_state.primitive4 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive4 == A_MULTICAST) {
    do_multicast_34();
  }
  else if(meta_primitive_state.primitive4 == A_MATH_ON_FIELD) {
    do_math_on_field_34();
  }
  else if(meta_primitive_state.primitive4 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_34();
  }
  else if(meta_primitive_state.primitive4 == A_BIT_XOR) {
    do_bit_xor_34();
  }
}

control switch_primitivetype_35 {
  if(meta_primitive_state.primitive5 == A_MODIFY_FIELD) {
    do_modify_field_35();
  }
  else if(meta_primitive_state.primitive5 == A_ADD_HEADER) {
    do_add_header_35();
  }
  else if(meta_primitive_state.primitive5 == A_REMOVE_HEADER) {
    do_remove_header_35();
  }
  else if(meta_primitive_state.primitive5 == A_TRUNCATE) {
    do_truncate_35();
  }
  else if(meta_primitive_state.primitive5 == A_DROP) {
    do_drop_35();
  }
  else if(meta_primitive_state.primitive5 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive5 == A_MULTICAST) {
    do_multicast_35();
  }
  else if(meta_primitive_state.primitive5 == A_MATH_ON_FIELD) {
    do_math_on_field_35();
  }
  else if(meta_primitive_state.primitive5 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_35();
  }
  else if(meta_primitive_state.primitive5 == A_BIT_XOR) {
    do_bit_xor_35();
  }
}

control switch_primitivetype_36 {
  if(meta_primitive_state.primitive6 == A_MODIFY_FIELD) {
    do_modify_field_36();
  }
  else if(meta_primitive_state.primitive6 == A_ADD_HEADER) {
    do_add_header_36();
  }
  else if(meta_primitive_state.primitive6 == A_REMOVE_HEADER) {
    do_remove_header_36();
  }
  else if(meta_primitive_state.primitive6 == A_TRUNCATE) {
    do_truncate_36();
  }
  else if(meta_primitive_state.primitive6 == A_DROP) {
    do_drop_36();
  }
  else if(meta_primitive_state.primitive6 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive6 == A_MULTICAST) {
    do_multicast_36();
  }
  else if(meta_primitive_state.primitive6 == A_MATH_ON_FIELD) {
    do_math_on_field_36();
  }
  else if(meta_primitive_state.primitive6 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_36();
  }
  else if(meta_primitive_state.primitive6 == A_BIT_XOR) {
    do_bit_xor_36();
  }
}

control switch_primitivetype_37 {
  if(meta_primitive_state.primitive7 == A_MODIFY_FIELD) {
    do_modify_field_37();
  }
  else if(meta_primitive_state.primitive7 == A_ADD_HEADER) {
    do_add_header_37();
  }
  else if(meta_primitive_state.primitive7 == A_REMOVE_HEADER) {
    do_remove_header_37();
  }
  else if(meta_primitive_state.primitive7 == A_TRUNCATE) {
    do_truncate_37();
  }
  else if(meta_primitive_state.primitive7 == A_DROP) {
    do_drop_37();
  }
  else if(meta_primitive_state.primitive7 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive7 == A_MULTICAST) {
    do_multicast_37();
  }
  else if(meta_primitive_state.primitive7 == A_MATH_ON_FIELD) {
    do_math_on_field_37();
  }
  else if(meta_primitive_state.primitive7 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_37();
  }
  else if(meta_primitive_state.primitive7 == A_BIT_XOR) {
    do_bit_xor_37();
  }
}

control switch_primitivetype_38 {
  if(meta_primitive_state.primitive8 == A_MODIFY_FIELD) {
    do_modify_field_38();
  }
  else if(meta_primitive_state.primitive8 == A_ADD_HEADER) {
    do_add_header_38();
  }
  else if(meta_primitive_state.primitive8 == A_REMOVE_HEADER) {
    do_remove_header_38();
  }
  else if(meta_primitive_state.primitive8 == A_TRUNCATE) {
    do_truncate_38();
  }
  else if(meta_primitive_state.primitive8 == A_DROP) {
    do_drop_38();
  }
  else if(meta_primitive_state.primitive8 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive8 == A_MULTICAST) {
    do_multicast_38();
  }
  else if(meta_primitive_state.primitive8 == A_MATH_ON_FIELD) {
    do_math_on_field_38();
  }
  else if(meta_primitive_state.primitive8 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_38();
  }
  else if(meta_primitive_state.primitive8 == A_BIT_XOR) {
    do_bit_xor_38();
  }
}

control switch_primitivetype_39 {
  if(meta_primitive_state.primitive9 == A_MODIFY_FIELD) {
    do_modify_field_39();
  }
  else if(meta_primitive_state.primitive9 == A_ADD_HEADER) {
    do_add_header_39();
  }
  else if(meta_primitive_state.primitive9 == A_REMOVE_HEADER) {
    do_remove_header_39();
  }
  else if(meta_primitive_state.primitive9 == A_TRUNCATE) {
    do_truncate_39();
  }
  else if(meta_primitive_state.primitive9 == A_DROP) {
    do_drop_39();
  }
  else if(meta_primitive_state.primitive9 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive9 == A_MULTICAST) {
    do_multicast_39();
  }
  else if(meta_primitive_state.primitive9 == A_MATH_ON_FIELD) {
    do_math_on_field_39();
  }
  else if(meta_primitive_state.primitive9 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_39();
  }
  else if(meta_primitive_state.primitive9 == A_BIT_XOR) {
    do_bit_xor_39();
  }
}

control switch_primitivetype_41 {
  if(meta_primitive_state.primitive1 == A_MODIFY_FIELD) {
    do_modify_field_41();
  }
  else if(meta_primitive_state.primitive1 == A_ADD_HEADER) {
    do_add_header_41();
  }
  else if(meta_primitive_state.primitive1 == A_REMOVE_HEADER) {
    do_remove_header_41();
  }
  else if(meta_primitive_state.primitive1 == A_TRUNCATE) {
    do_truncate_41();
  }
  else if(meta_primitive_state.primitive1 == A_DROP) {
    do_drop_41();
  }
  else if(meta_primitive_state.primitive1 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive1 == A_MULTICAST) {
    do_multicast_41();
  }
  else if(meta_primitive_state.primitive1 == A_MATH_ON_FIELD) {
    do_math_on_field_41();
  }
  else if(meta_primitive_state.primitive1 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_41();
  }
  else if(meta_primitive_state.primitive1 == A_BIT_XOR) {
    do_bit_xor_41();
  }
}

control switch_primitivetype_42 {
  if(meta_primitive_state.primitive2 == A_MODIFY_FIELD) {
    do_modify_field_42();
  }
  else if(meta_primitive_state.primitive2 == A_ADD_HEADER) {
    do_add_header_42();
  }
  else if(meta_primitive_state.primitive2 == A_REMOVE_HEADER) {
    do_remove_header_42();
  }
  else if(meta_primitive_state.primitive2 == A_TRUNCATE) {
    do_truncate_42();
  }
  else if(meta_primitive_state.primitive2 == A_DROP) {
    do_drop_42();
  }
  else if(meta_primitive_state.primitive2 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive2 == A_MULTICAST) {
    do_multicast_42();
  }
  else if(meta_primitive_state.primitive2 == A_MATH_ON_FIELD) {
    do_math_on_field_42();
  }
  else if(meta_primitive_state.primitive2 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_42();
  }
  else if(meta_primitive_state.primitive2 == A_BIT_XOR) {
    do_bit_xor_42();
  }
}

control switch_primitivetype_43 {
  if(meta_primitive_state.primitive3 == A_MODIFY_FIELD) {
    do_modify_field_43();
  }
  else if(meta_primitive_state.primitive3 == A_ADD_HEADER) {
    do_add_header_43();
  }
  else if(meta_primitive_state.primitive3 == A_REMOVE_HEADER) {
    do_remove_header_43();
  }
  else if(meta_primitive_state.primitive3 == A_TRUNCATE) {
    do_truncate_43();
  }
  else if(meta_primitive_state.primitive3 == A_DROP) {
    do_drop_43();
  }
  else if(meta_primitive_state.primitive3 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive3 == A_MULTICAST) {
    do_multicast_43();
  }
  else if(meta_primitive_state.primitive3 == A_MATH_ON_FIELD) {
    do_math_on_field_43();
  }
  else if(meta_primitive_state.primitive3 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_43();
  }
  else if(meta_primitive_state.primitive3 == A_BIT_XOR) {
    do_bit_xor_43();
  }
}

control switch_primitivetype_44 {
  if(meta_primitive_state.primitive4 == A_MODIFY_FIELD) {
    do_modify_field_44();
  }
  else if(meta_primitive_state.primitive4 == A_ADD_HEADER) {
    do_add_header_44();
  }
  else if(meta_primitive_state.primitive4 == A_REMOVE_HEADER) {
    do_remove_header_44();
  }
  else if(meta_primitive_state.primitive4 == A_TRUNCATE) {
    do_truncate_44();
  }
  else if(meta_primitive_state.primitive4 == A_DROP) {
    do_drop_44();
  }
  else if(meta_primitive_state.primitive4 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive4 == A_MULTICAST) {
    do_multicast_44();
  }
  else if(meta_primitive_state.primitive4 == A_MATH_ON_FIELD) {
    do_math_on_field_44();
  }
  else if(meta_primitive_state.primitive4 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_44();
  }
  else if(meta_primitive_state.primitive4 == A_BIT_XOR) {
    do_bit_xor_44();
  }
}

control switch_primitivetype_45 {
  if(meta_primitive_state.primitive5 == A_MODIFY_FIELD) {
    do_modify_field_45();
  }
  else if(meta_primitive_state.primitive5 == A_ADD_HEADER) {
    do_add_header_45();
  }
  else if(meta_primitive_state.primitive5 == A_REMOVE_HEADER) {
    do_remove_header_45();
  }
  else if(meta_primitive_state.primitive5 == A_TRUNCATE) {
    do_truncate_45();
  }
  else if(meta_primitive_state.primitive5 == A_DROP) {
    do_drop_45();
  }
  else if(meta_primitive_state.primitive5 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive5 == A_MULTICAST) {
    do_multicast_45();
  }
  else if(meta_primitive_state.primitive5 == A_MATH_ON_FIELD) {
    do_math_on_field_45();
  }
  else if(meta_primitive_state.primitive5 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_45();
  }
  else if(meta_primitive_state.primitive5 == A_BIT_XOR) {
    do_bit_xor_45();
  }
}

control switch_primitivetype_46 {
  if(meta_primitive_state.primitive6 == A_MODIFY_FIELD) {
    do_modify_field_46();
  }
  else if(meta_primitive_state.primitive6 == A_ADD_HEADER) {
    do_add_header_46();
  }
  else if(meta_primitive_state.primitive6 == A_REMOVE_HEADER) {
    do_remove_header_46();
  }
  else if(meta_primitive_state.primitive6 == A_TRUNCATE) {
    do_truncate_46();
  }
  else if(meta_primitive_state.primitive6 == A_DROP) {
    do_drop_46();
  }
  else if(meta_primitive_state.primitive6 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive6 == A_MULTICAST) {
    do_multicast_46();
  }
  else if(meta_primitive_state.primitive6 == A_MATH_ON_FIELD) {
    do_math_on_field_46();
  }
  else if(meta_primitive_state.primitive6 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_46();
  }
  else if(meta_primitive_state.primitive6 == A_BIT_XOR) {
    do_bit_xor_46();
  }
}

control switch_primitivetype_47 {
  if(meta_primitive_state.primitive7 == A_MODIFY_FIELD) {
    do_modify_field_47();
  }
  else if(meta_primitive_state.primitive7 == A_ADD_HEADER) {
    do_add_header_47();
  }
  else if(meta_primitive_state.primitive7 == A_REMOVE_HEADER) {
    do_remove_header_47();
  }
  else if(meta_primitive_state.primitive7 == A_TRUNCATE) {
    do_truncate_47();
  }
  else if(meta_primitive_state.primitive7 == A_DROP) {
    do_drop_47();
  }
  else if(meta_primitive_state.primitive7 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive7 == A_MULTICAST) {
    do_multicast_47();
  }
  else if(meta_primitive_state.primitive7 == A_MATH_ON_FIELD) {
    do_math_on_field_47();
  }
  else if(meta_primitive_state.primitive7 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_47();
  }
  else if(meta_primitive_state.primitive7 == A_BIT_XOR) {
    do_bit_xor_47();
  }
}

control switch_primitivetype_48 {
  if(meta_primitive_state.primitive8 == A_MODIFY_FIELD) {
    do_modify_field_48();
  }
  else if(meta_primitive_state.primitive8 == A_ADD_HEADER) {
    do_add_header_48();
  }
  else if(meta_primitive_state.primitive8 == A_REMOVE_HEADER) {
    do_remove_header_48();
  }
  else if(meta_primitive_state.primitive8 == A_TRUNCATE) {
    do_truncate_48();
  }
  else if(meta_primitive_state.primitive8 == A_DROP) {
    do_drop_48();
  }
  else if(meta_primitive_state.primitive8 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive8 == A_MULTICAST) {
    do_multicast_48();
  }
  else if(meta_primitive_state.primitive8 == A_MATH_ON_FIELD) {
    do_math_on_field_48();
  }
  else if(meta_primitive_state.primitive8 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_48();
  }
  else if(meta_primitive_state.primitive8 == A_BIT_XOR) {
    do_bit_xor_48();
  }
}

control switch_primitivetype_49 {
  if(meta_primitive_state.primitive9 == A_MODIFY_FIELD) {
    do_modify_field_49();
  }
  else if(meta_primitive_state.primitive9 == A_ADD_HEADER) {
    do_add_header_49();
  }
  else if(meta_primitive_state.primitive9 == A_REMOVE_HEADER) {
    do_remove_header_49();
  }
  else if(meta_primitive_state.primitive9 == A_TRUNCATE) {
    do_truncate_49();
  }
  else if(meta_primitive_state.primitive9 == A_DROP) {
    do_drop_49();
  }
  else if(meta_primitive_state.primitive9 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive9 == A_MULTICAST) {
    do_multicast_49();
  }
  else if(meta_primitive_state.primitive9 == A_MATH_ON_FIELD) {
    do_math_on_field_49();
  }
  else if(meta_primitive_state.primitive9 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_49();
  }
  else if(meta_primitive_state.primitive9 == A_BIT_XOR) {
    do_bit_xor_49();
  }
}

control switch_primitivetype_51 {
  if(meta_primitive_state.primitive1 == A_MODIFY_FIELD) {
    do_modify_field_51();
  }
  else if(meta_primitive_state.primitive1 == A_ADD_HEADER) {
    do_add_header_51();
  }
  else if(meta_primitive_state.primitive1 == A_REMOVE_HEADER) {
    do_remove_header_51();
  }
  else if(meta_primitive_state.primitive1 == A_TRUNCATE) {
    do_truncate_51();
  }
  else if(meta_primitive_state.primitive1 == A_DROP) {
    do_drop_51();
  }
  else if(meta_primitive_state.primitive1 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive1 == A_MULTICAST) {
    do_multicast_51();
  }
  else if(meta_primitive_state.primitive1 == A_MATH_ON_FIELD) {
    do_math_on_field_51();
  }
  else if(meta_primitive_state.primitive1 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_51();
  }
  else if(meta_primitive_state.primitive1 == A_BIT_XOR) {
    do_bit_xor_51();
  }
}

control switch_primitivetype_52 {
  if(meta_primitive_state.primitive2 == A_MODIFY_FIELD) {
    do_modify_field_52();
  }
  else if(meta_primitive_state.primitive2 == A_ADD_HEADER) {
    do_add_header_52();
  }
  else if(meta_primitive_state.primitive2 == A_REMOVE_HEADER) {
    do_remove_header_52();
  }
  else if(meta_primitive_state.primitive2 == A_TRUNCATE) {
    do_truncate_52();
  }
  else if(meta_primitive_state.primitive2 == A_DROP) {
    do_drop_52();
  }
  else if(meta_primitive_state.primitive2 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive2 == A_MULTICAST) {
    do_multicast_52();
  }
  else if(meta_primitive_state.primitive2 == A_MATH_ON_FIELD) {
    do_math_on_field_52();
  }
  else if(meta_primitive_state.primitive2 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_52();
  }
  else if(meta_primitive_state.primitive2 == A_BIT_XOR) {
    do_bit_xor_52();
  }
}

control switch_primitivetype_53 {
  if(meta_primitive_state.primitive3 == A_MODIFY_FIELD) {
    do_modify_field_53();
  }
  else if(meta_primitive_state.primitive3 == A_ADD_HEADER) {
    do_add_header_53();
  }
  else if(meta_primitive_state.primitive3 == A_REMOVE_HEADER) {
    do_remove_header_53();
  }
  else if(meta_primitive_state.primitive3 == A_TRUNCATE) {
    do_truncate_53();
  }
  else if(meta_primitive_state.primitive3 == A_DROP) {
    do_drop_53();
  }
  else if(meta_primitive_state.primitive3 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive3 == A_MULTICAST) {
    do_multicast_53();
  }
  else if(meta_primitive_state.primitive3 == A_MATH_ON_FIELD) {
    do_math_on_field_53();
  }
  else if(meta_primitive_state.primitive3 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_53();
  }
  else if(meta_primitive_state.primitive3 == A_BIT_XOR) {
    do_bit_xor_53();
  }
}

control switch_primitivetype_54 {
  if(meta_primitive_state.primitive4 == A_MODIFY_FIELD) {
    do_modify_field_54();
  }
  else if(meta_primitive_state.primitive4 == A_ADD_HEADER) {
    do_add_header_54();
  }
  else if(meta_primitive_state.primitive4 == A_REMOVE_HEADER) {
    do_remove_header_54();
  }
  else if(meta_primitive_state.primitive4 == A_TRUNCATE) {
    do_truncate_54();
  }
  else if(meta_primitive_state.primitive4 == A_DROP) {
    do_drop_54();
  }
  else if(meta_primitive_state.primitive4 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive4 == A_MULTICAST) {
    do_multicast_54();
  }
  else if(meta_primitive_state.primitive4 == A_MATH_ON_FIELD) {
    do_math_on_field_54();
  }
  else if(meta_primitive_state.primitive4 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_54();
  }
  else if(meta_primitive_state.primitive4 == A_BIT_XOR) {
    do_bit_xor_54();
  }
}

control switch_primitivetype_55 {
  if(meta_primitive_state.primitive5 == A_MODIFY_FIELD) {
    do_modify_field_55();
  }
  else if(meta_primitive_state.primitive5 == A_ADD_HEADER) {
    do_add_header_55();
  }
  else if(meta_primitive_state.primitive5 == A_REMOVE_HEADER) {
    do_remove_header_55();
  }
  else if(meta_primitive_state.primitive5 == A_TRUNCATE) {
    do_truncate_55();
  }
  else if(meta_primitive_state.primitive5 == A_DROP) {
    do_drop_55();
  }
  else if(meta_primitive_state.primitive5 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive5 == A_MULTICAST) {
    do_multicast_55();
  }
  else if(meta_primitive_state.primitive5 == A_MATH_ON_FIELD) {
    do_math_on_field_55();
  }
  else if(meta_primitive_state.primitive5 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_55();
  }
  else if(meta_primitive_state.primitive5 == A_BIT_XOR) {
    do_bit_xor_55();
  }
}

control switch_primitivetype_56 {
  if(meta_primitive_state.primitive6 == A_MODIFY_FIELD) {
    do_modify_field_56();
  }
  else if(meta_primitive_state.primitive6 == A_ADD_HEADER) {
    do_add_header_56();
  }
  else if(meta_primitive_state.primitive6 == A_REMOVE_HEADER) {
    do_remove_header_56();
  }
  else if(meta_primitive_state.primitive6 == A_TRUNCATE) {
    do_truncate_56();
  }
  else if(meta_primitive_state.primitive6 == A_DROP) {
    do_drop_56();
  }
  else if(meta_primitive_state.primitive6 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive6 == A_MULTICAST) {
    do_multicast_56();
  }
  else if(meta_primitive_state.primitive6 == A_MATH_ON_FIELD) {
    do_math_on_field_56();
  }
  else if(meta_primitive_state.primitive6 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_56();
  }
  else if(meta_primitive_state.primitive6 == A_BIT_XOR) {
    do_bit_xor_56();
  }
}

control switch_primitivetype_57 {
  if(meta_primitive_state.primitive7 == A_MODIFY_FIELD) {
    do_modify_field_57();
  }
  else if(meta_primitive_state.primitive7 == A_ADD_HEADER) {
    do_add_header_57();
  }
  else if(meta_primitive_state.primitive7 == A_REMOVE_HEADER) {
    do_remove_header_57();
  }
  else if(meta_primitive_state.primitive7 == A_TRUNCATE) {
    do_truncate_57();
  }
  else if(meta_primitive_state.primitive7 == A_DROP) {
    do_drop_57();
  }
  else if(meta_primitive_state.primitive7 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive7 == A_MULTICAST) {
    do_multicast_57();
  }
  else if(meta_primitive_state.primitive7 == A_MATH_ON_FIELD) {
    do_math_on_field_57();
  }
  else if(meta_primitive_state.primitive7 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_57();
  }
  else if(meta_primitive_state.primitive7 == A_BIT_XOR) {
    do_bit_xor_57();
  }
}

control switch_primitivetype_58 {
  if(meta_primitive_state.primitive8 == A_MODIFY_FIELD) {
    do_modify_field_58();
  }
  else if(meta_primitive_state.primitive8 == A_ADD_HEADER) {
    do_add_header_58();
  }
  else if(meta_primitive_state.primitive8 == A_REMOVE_HEADER) {
    do_remove_header_58();
  }
  else if(meta_primitive_state.primitive8 == A_TRUNCATE) {
    do_truncate_58();
  }
  else if(meta_primitive_state.primitive8 == A_DROP) {
    do_drop_58();
  }
  else if(meta_primitive_state.primitive8 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive8 == A_MULTICAST) {
    do_multicast_58();
  }
  else if(meta_primitive_state.primitive8 == A_MATH_ON_FIELD) {
    do_math_on_field_58();
  }
  else if(meta_primitive_state.primitive8 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_58();
  }
  else if(meta_primitive_state.primitive8 == A_BIT_XOR) {
    do_bit_xor_58();
  }
}

control switch_primitivetype_59 {
  if(meta_primitive_state.primitive9 == A_MODIFY_FIELD) {
    do_modify_field_59();
  }
  else if(meta_primitive_state.primitive9 == A_ADD_HEADER) {
    do_add_header_59();
  }
  else if(meta_primitive_state.primitive9 == A_REMOVE_HEADER) {
    do_remove_header_59();
  }
  else if(meta_primitive_state.primitive9 == A_TRUNCATE) {
    do_truncate_59();
  }
  else if(meta_primitive_state.primitive9 == A_DROP) {
    do_drop_59();
  }
  else if(meta_primitive_state.primitive9 == A_NO_OP) {
  }
  else if(meta_primitive_state.primitive9 == A_MULTICAST) {
    do_multicast_59();
  }
  else if(meta_primitive_state.primitive9 == A_MATH_ON_FIELD) {
    do_math_on_field_59();
  }
  else if(meta_primitive_state.primitive9 == A_MODIFY_FIELD_RNG_U) {
    do_modify_field_rng_59();
  }
  else if(meta_primitive_state.primitive9 == A_BIT_XOR) {
    do_bit_xor_59();
  }
}
