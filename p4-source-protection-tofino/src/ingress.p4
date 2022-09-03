#include "controls/L2.p4"
#include "controls/Topology.p4"
#include "controls/Protect.p4"

control ingress(
        inout header_t hdr,
        inout ingress_metadata_t ig_md,
        in ingress_intrinsic_metadata_t ig_intr_md,
        in ingress_intrinsic_metadata_from_parser_t ig_prsr_md,
        inout ingress_intrinsic_metadata_for_deparser_t ig_dprsr_md,
        inout ingress_intrinsic_metadata_for_tm_t ig_tm_md) {

    L2() l2_c;
    Topology() topology_c;
    Protect() protect_c;

    apply {
        
        ig_tm_md.bypass_egress = true; // bypass egress
 
        if(hdr.ethernet.ether_type == ETHERTYPE_TOPOLOGY) {
           topology_c.apply(hdr, ig_intr_md, ig_tm_md);
        }        
        else {
            ig_md.accepted = 1;
            
            if(hdr.ethernet.ether_type == ETHERTYPE_PROTECT) {
                protect_c.apply(hdr, ig_intr_md, ig_md);             
            }
            
            if(ig_md.accepted == 1) {
                l2_c.apply(hdr, ig_tm_md);
            }
        }
    }
}
