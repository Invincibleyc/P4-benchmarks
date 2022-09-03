control L2(inout headers hdr, inout metadata meta, inout standard_metadata_t standard_metadata) {
  action l2_forward(egressSpec_t e_port) {
    standard_metadata.egress_spec = e_port;
  }

  action l2_broadcast() {
    standard_metadata.mcast_grp = 1; // flooding
  }

  table l2_forwarding {
    key = {
      hdr.ethernet.dstAddr: exact;
    }
    actions = {
      l2_forward;
      l2_broadcast;
    }
    default_action = l2_broadcast();
  }

  apply {
    l2_forwarding.apply();
  }
}
