#include "controls/ProtectForward.p4"
#include "controls/Decaps_IP.p4"
#include "controls/ARP.p4"
#include "controls/CPU.p4"
#include "controls/Topology.p4"
#include "controls/Decaps_P.p4"

control ingress(
        inout header_t hdr,
        inout ingress_metadata_t ig_md,
        in ingress_intrinsic_metadata_t ig_intr_md,
        in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,
        inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
        inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {

    ProtectForward() ipv4_c;
    Decaps_IP() decaps_ip;
    ARP() arp_c;
    CPU() cpu_c;
    Topology() topology_c;
    Decaps_P() protection_c;

    apply {

        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4 && hdr.ipv4.isValid() && hdr.protection.isValid()) { // only possibility is tunnel
            decaps_ip.apply(hdr, ig_md, ig_tm_md, ig_intr_md, ig_dprsr_md);
        }
        
        if((hdr.protection.isValid() && hdr.ethernet.ether_type == ETHERTYPE_PROTECTION) || (hdr.protection_reset.isValid() && hdr.protection_reset.device_type == 1)) {
            protection_c.apply(hdr, ig_intr_md, ig_tm_md, ig_md);
        }
        
        if(hdr.ethernet.ether_type == ETHERTYPE_IPV4 || (hdr.protection_reset.isValid() && hdr.protection_reset.device_type == 0)) {
	    ipv4_c.apply(hdr, ig_md, ig_tm_md, ig_intr_md, ig_dprsr_md);
        }
        else if(hdr.ethernet.ether_type == TYPE_ARP && ig_intr_md.ingress_port != CPU_PORT) {
           arp_c.apply(hdr, ig_intr_md, ig_tm_md);
        }
        else if(hdr.ethernet.ether_type == ETHERTYPE_CPU) {
           cpu_c.apply(hdr, ig_intr_md, ig_tm_md);
        }
        else if(hdr.ethernet.ether_type == ETHERTYPE_TOPOLOGY) {
           topology_c.apply(hdr, ig_intr_md, ig_tm_md);
        }        
    }
}
