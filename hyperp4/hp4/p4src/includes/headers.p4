/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

headers.p4: Define the headers required by HP4.
*/

header_type csum_t {
  fields {
    sum : 32;
    rshift : 16;
    div : 8;
    final : 16;
    csmask : 768;
  }
}

//  bmv2 simple switch requires this intrinsic metadata structure
header_type intrinsic_metadata_t {
  fields {
        ingress_global_timestamp : 48;
        lf_field_list : 8;
        mcast_grp : 16;
        egress_rid : 16;
        resubmit_flag : 8;
        recirculate_flag : 8;
  }
}

header_type parse_ctrl_t {
  fields {
    numbytes : 8;
    state : 12;
    next_action : 4;
    small_packet : 8;
  }
}

// meta_ctrl: stores control stage (e.g. INIT, NORM), next table, stage
// state (e.g. CONTINUE, COMPLETE… to track whether a sequence of primitives
// is complete)
header_type meta_ctrl_t {
  fields {
    vdev_ID : 8; // identifies which program to run
    next_vdev_ID : 8;
    stage : 2; // INIT, NORM, VFWD
    next_table : 8;
    mcast_current_egress : 8;
    mcast_grp_id : 8;
    vmcast_grp_id : 8;
    stdmeta_ID : 3;
    next_stage : 5;
    mc_flag : 1;
    virt_egress_spec : 8;
    virt_ingress_port : 8;
    orig_virt_ingress_port : 8;
    virt_fwd_flag : 8;
    econd : 1; // whether egress handling mode is 'conditional'
    efilter : 1; // whether we filter if sm.egress_port == sm.ingress_port and
                 // virt_fwd_flag == FALSE
    dropped : 1; // mark packet as dropped (0 = not dropped, 1 = dropped)
  }
}

// meta_primitive_state: information about a specific target primitive
header_type meta_primitive_state_t {
  fields {
    action_ID : 7; // identifies the compound action being executed
    match_ID : 23; // identifies the match entry
    //primitive_index : 6; // place within compound action
    primitive1 : 6; // e.g. modify_field, add_header, etc.
    subtype1 : 6; // maps to a set identifying the parameters' types
    primitive2 : 6; // e.g. modify_field, add_header, etc.
    subtype2 : 6; // maps to a set identifying the parameters' types
    primitive3 : 6; // e.g. modify_field, add_header, etc.
    subtype3 : 6; // maps to a set identifying the parameters' types
    primitive4 : 6; // e.g. modify_field, add_header, etc.
    subtype4 : 6; // maps to a set identifying the parameters' types
    primitive5 : 6; // e.g. modify_field, add_header, etc.
    subtype5 : 6; // maps to a set identifying the parameters' types
    primitive6 : 6; // e.g. modify_field, add_header, etc.
    subtype6 : 6; // maps to a set identifying the parameters' types
    primitive7 : 6; // e.g. modify_field, add_header, etc.
    subtype7 : 6; // maps to a set identifying the parameters' types
    primitive8 : 6; // e.g. modify_field, add_header, etc.
    subtype8 : 6; // maps to a set identifying the parameters' types
    primitive9 : 6; // e.g. modify_field, add_header, etc.
    subtype9 : 6; // maps to a set identifying the parameters' types
  }
}

header_type temp_t {
  fields {
    data : 64;
  }
}

// tmeta: HyPer4's representation of the target's metadata
header_type tmeta_t {
  fields {
    data : 256;
  }
}

header_type ext_first_t {
  fields {
    data : 320;
  }
}

header_type ext_t {
  fields {
    data : 8;
  }
}

// extracted: stores extracted data in a standard width field
header_type extracted_t {
  fields {
    data : 800;
    validbits : 80;
  }
}
