/* Control unit for ingress
* First checks if its a normal ipv4 packet and applies ipv4 control unit
* Otherwise checks if its a BIER packet and applies bier control
*/
control ingress(inout headers hdr,
				inout metadata meta,
				inout standard_metadata_t standard_metadata) {
  L2() l2_c;
  Protect() protect_c;
  TopologyDiscovery() topology_c;

    apply {
      if(hdr.ethernet.etherType == TYPE_TOP_DISCOVER) { // its a topology discovery packet
          topology_c.apply(hdr, meta, standard_metadata);
      }
      else {
          meta.accepted = 1;

          if(hdr.ethernet.etherType == ETHERTYPE_PROTECT) {
            protect_c.apply(hdr, meta, standard_metadata);
          }
          
          if(meta.accepted == 1) {
            l2_c.apply(hdr, meta, standard_metadata);
          }
      }
    }
}
