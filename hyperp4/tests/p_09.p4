header_type a_t {
  fields {
    f1 : 16;  // bytes: 00-01
    f2 : 128; // bytes: 02-17
    f3 : 32;  // bytes: 18-21
    f4 : 144; // bytes: 22-39
  }
}

header_type b_t {
  fields {
    f1 : 64;
  }
}

header a_t a;
header b_t b;

parser start {
  extract(a);
  return select(a.f3, a.f1) {
    0xAABBCCDD, 0x01 : p_a2;
    0x55667788, 0x02 : p_b;
    default : ingress;
  }
}

parser p_a2 {
  return select(a.f3) {
    0x01 : p_b;
    default : ingress;
  }
}

parser p_b {
  extract(b);
  return ingress;
}

action _no_op() {
}

table t {
  actions {
    _no_op;
  }
}

control ingress {
  apply(t);
}

/*
PC_State
  self.hp4_bits_extracted
  self.p4_bits_extracted
  self.ps_path
  self.pcs_path
  self.pcs_id
  self.parse_state
  self.entry_table
  self.children = []
  self.header_offsets = {} # header name (str) : hp4 bit offset (int)
  self.select_criteria = []
  self.select_values = []
*/
