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

header_type E_t {
  fields {
    f1 : 8;
  }
}

header A_t A;
header B_t B;
header C_t C;
header D_t D;
header E_t E;

parser start {
  return select(current(0, 48)) {
    0x010203040506 : parse_A;
    0x010203040507 : parse_B;
    0x010203040508 : parse_C;
    default : ingress;
  }
}

parser parse_A {
  extract(A);
  return select(A.f1) {
    0x0000 : parse_D;
    default : ingress;
  }
}

parser parse_B {
  extract(B);
  return parse_D;
}

parser parse_C {
  extract(C);
  return select(current(0, 16)) {
    0x0000 : parse_E;
    default : ingress;
  }
}

parser parse_D {
  extract(D);
  return ingress;
}

parser parse_E {
  extract(E);
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
