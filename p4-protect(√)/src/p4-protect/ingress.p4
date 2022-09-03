#include "controls/Ipv4.p4"
#include "controls/Topology-Discovery.p4"
#include "controls/Protect.p4"

/* Control unit for ingress
* First checks if its a normal ipv4 packet and applies ipv4 control unit
* Otherwise checks if its a BIER packet and applies bier control
*/
control ingress(inout headers hdr,
				inout metadata meta,
				inout standard_metadata_t standard_metadata) {

    IPv4() ipv4_c; // ipv4 control unit
    TopologyDiscovery() topology_c; // topology control unit
	Protect() protection_c;

    apply {
		
    	if(hdr.ethernet.etherType == TYPE_IPV4 || (hdr.protection_reset.isValid() && hdr.protection_reset.device_type == 0)) {
			ipv4_c.apply(hdr, meta, standard_metadata);  // apply ipv4 control
        }
        else if(hdr.ethernet.etherType == TYPE_TOP_DISCOVER) { // its a topology discovery packet
            topology_c.apply(hdr, meta, standard_metadata);
        }
		else if(hdr.ethernet.etherType == TYPE_PROTECTION || (hdr.protection_reset.isValid() && hdr.protection_reset.device_type == 1)) {
			protection_c.apply(hdr, meta, standard_metadata);
		}
    }
}
