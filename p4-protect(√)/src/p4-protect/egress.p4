#include "controls/Mac.p4"

control egress(inout headers hdr,
			   inout metadata meta,
			   inout standard_metadata_t standard_metadata) {

	Mac() mac_c;

	apply {
		mac_c.apply(hdr, meta, standard_metadata); // set layer 2 addresses if rules are set
	}
}
