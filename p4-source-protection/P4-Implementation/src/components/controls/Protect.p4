control Protect(inout headers hdr, 
                inout metadata meta, 
                inout standard_metadata_t standard_metadata) {
  register<bit<48>>(48) last_primary;

  action set_period(bit<48> period) {
    meta.period = period;
  }

  table period {
    key = {
      hdr.ethernet.srcAddr: ternary;
    }
    actions = {
      set_period;
    }
  }

  action set_ports(egressSpec_t primary, egressSpec_t secondary) {
    meta.primary = primary;
    meta.secondary = secondary;
  }

  table port_config {
    key = {
      hdr.ethernet.dstAddr: ternary;
    }
    actions = {
      set_ports;
    }
  }

  apply {
    
    period.apply();
    port_config.apply();
    bit<1> accepted = 0;

    bit<48> time = standard_metadata.ingress_global_timestamp;

    if(standard_metadata.ingress_port == meta.primary) {
      last_primary.write(0, time);
      accepted = 1;
    }
    else if(standard_metadata.ingress_port == meta.secondary) {
      bit<48> last;

      last_primary.read(last, 0);

      if((time - last) > meta.period) {
        accepted = 1;
      }
    }

      meta.accepted = accepted;
    }
}
