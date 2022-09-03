header_type eth1_t {
    fields {
        dst : 48;
        src : 48;
        ethtype : 16;
    }
}

header_type eth2_t {
    fields {
        dst : 48;
        src : 48;
        ethtype : 16;
    }
}

header eth1_t eth1;
header eth2_t eth2;

parser start {
  return select(current(0, 48)) {
    0x000400000000 : parse_eth1;
    0x000400000001 : parse_eth2;
    default : ingress;
  }
}

parser parse_eth1 {
  extract(eth1);
  return ingress;
}

parser parse_eth2 {
  extract(eth2);
  return ingress;
}

action fwd_p1() {
  modify_field(standard_metadata.egress_spec, 1);
}

action inv_eth1() {
}

action fwd_p2() {
  modify_field(standard_metadata.egress_spec, 2);
}

action fwd_p3() {
  modify_field(standard_metadata.egress_spec, 3);
}

table check_eth1 {
    reads {
        eth1 : valid;
    }
    actions {
        fwd_p1;
        inv_eth1;
    }
}

table check_eth2 {
  reads {
    eth2 : valid;
  }
  actions {
    fwd_p2;
    fwd_p3;
  }
}

control ingress {
  apply(check_eth1) {
    inv_eth1 {
      apply(check_eth2);
    }
  }
}
