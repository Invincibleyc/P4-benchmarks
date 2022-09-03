header_type a_t {
  fields {
    f1 : 16;  // bytes: 00-01
    f2 : 144; // bytes: 02-19
    f3 : 16;  // bytes: 20-21
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
  return select(a.f1) {
    0x01 : p_a2;
    0x02 : p_b;
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
