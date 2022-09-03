control verifyChecksum(inout headers hdr, inout metadata meta) {
    apply {
        verify_checksum(
        hdr.ipv4.isValid(), { hdr.ipv4.version, 
        		 hdr.ipv4.ihl, 
        		 hdr.ipv4.diffserv, 
        		 hdr.ipv4.totalLen, 
        		 hdr.ipv4.identification, 
        		 hdr.ipv4.flags, 
        		 hdr.ipv4.fragOffset, 
        		 hdr.ipv4.ttl, 
        		 hdr.ipv4.protocol, 
        		 hdr.ipv4.srcAddr, 
        		 hdr.ipv4.dstAddr },
        hdr.ipv4.hdrChecksum,
        HashAlgorithm.csum16);
    }
}

/*************************************************************************
*************   C H E C K S U M    C O M P U T A T I O N   **************
*************************************************************************/

control createChecksum(inout headers  hdr, inout metadata meta) {
     apply {
	update_checksum(
	    hdr.ipv4.isValid(),
            { hdr.ipv4.version,
	      hdr.ipv4.ihl,
              hdr.ipv4.diffserv,
              hdr.ipv4.totalLen,
              hdr.ipv4.identification,
              hdr.ipv4.flags,
              hdr.ipv4.fragOffset,
              hdr.ipv4.ttl,
              hdr.ipv4.protocol,
              hdr.ipv4.srcAddr,
              hdr.ipv4.dstAddr },
            hdr.ipv4.hdrChecksum,
            HashAlgorithm.csum16);
    }
}