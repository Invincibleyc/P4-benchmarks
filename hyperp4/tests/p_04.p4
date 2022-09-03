header_type A_t {
    fields {
        f1 : 16;
        f2 : 304;
    }
}

header_type B_t {
    fields {
        f1 : 104;
    }
}

header A_t A;
header B_t B;

parser start {
  return select(current(0, 48)) {
    0x010203040506 : parse_A;
    0x010203040507 : parse_B;
    default : ingress;
  }
}

parser parse_A {
  extract(A);
  extract(B);
  return ingress;
}

parser parse_B {
  extract(B);
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
