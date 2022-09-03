header_type A_t {
    fields {
        f1 : 320;
    }
}
/*
header_type B_t {
    fields {
        f1 : 48;
        f2 : 48;
        f3 : 16;
    }
}
*/

header A_t A;
//header B_t B;

parser start {
  extract(A);
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
