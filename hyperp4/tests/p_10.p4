header_type A_t {
    fields {
        f1 : 16;
        f2 : 304;
    }
}

header_type B_t {
    fields {
        f1 : 16;
        f2 : 88;
    }
}

header_type C_t {
  fields {
    f1 : 8;
    f2 : 8;
    f3 : 16;
    f4 : 32;
    f5 : 256;
  }
}

header_type D_t {
  fields {
    f1 : 64;
    f2 : 64;
  }
}

header A_t A;
header B_t B;
header C_t C;
header D_t D;

parser start {
  extract(A);
  return select(A.f1) {
    0x010203040507 : parse_B;
    0x010203040508 : parse_C;
    default : ingress;
  }
}

parser parse_B {
  extract(B);
  return select(B.f1) {
    0x2222 : parse_D;
    default : ingress;
  }
}

parser parse_C {
  extract(C);
  return select(C.f1) {
    0x67 : parse_D;
    default : ingress;
  }
}

parser parse_D {
  extract(D);
  return ingress;
}

action _no_op() {
}

table t {
  reads {
    A.f1 : exact;
  }
  actions {
    _no_op;
  }
}

control ingress {
  apply(t);
}
