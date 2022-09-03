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
  extract(A);
  return select(A.f1) {
    0x0001 : parse_B;
    default : ingress;
  }
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
