# Project description

This is a short description of the refactored BIER implementation.

**host_scripts**: contains the receive/send scripts for the hosts in order to test packet delivery

**src**: contains the pipeline control sources

**utils**: contains the build process given by the p4lang tutorial 

**src/controls**: contains the additional control units, e.g. ipv4, mac, protect, ...

***sdn-bfr.p4*** contains the V1Switch pipeline definition.

```p4
// V1Switch pipeline
V1Switch(
	packetParser(),
	verifyChecksum(),
	ingress(),
	egress(),
	createChecksum(),
	deparser()
	) main;
```
