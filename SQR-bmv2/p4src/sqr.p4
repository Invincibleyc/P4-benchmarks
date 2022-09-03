#include "includes/headers.p4"
#include "includes/parser.p4"
#include "includes/defines.p4"
#include "includes/metadata.p4"
#include "table_definitions/egress_tables.p4"
#include "table_definitions/ingress_tables.p4"

control ingress {
    apply(add_test_hdr);
    apply(add_test_hdr_opp);
    apply(forward); 
}

control egress {
    if(queueing_metadata.deq_qdepth < queue_threshold){ //read queue length first, enable sqr only when there exists enough buffer.
        apply(sqr_apply);
        apply(sqr_apply_opp);        
    }

    if(ipv4.protocol == IP_PROTOCOLS_TEST){ 
        if(meta.sqr_apply == YES) {
            apply(pkt_tag);
        }   
    }

    if(meta.etherType == ETHERTYPE_PKTGEN){  //maybe we can just set reg from control plan, no need special pkt
        apply(set_port_state);
    }

    if(valid(test)){
        apply(remove_test_hdr);
    }

    apply(get_min_uport); // get meta.delay_port from reg_min_uport

    

    if(eg_intr_md.pkt_length != 0 and pkt_is_not_mirrored){ 
        apply(read_port_state); //meta.port_state
        apply(calc_current_utilization); 
        if(meta.delay_port == eg_intr_md.egress_port){ 
            if(meta.current_utilization > meta.min_uport_value){
                apply(update_min_uport_value); 
            }
        }
        if( meta.sqr_apply == Enabled ) { 
            if( meta.port_state == DOWN ) {                  
                apply(delay_mirror); // to delay port             
            }
            else { // port is down
                apply(mirror); // to_backup_port
            }
        }           
    } 
    else{ // Process mirrored packets
        apply(read_initial_port_state);
        if(meta.sqr_apply == 1 )
        {
            apply(read_min_pkt_tag); //meta.min_pkt_tag

            if(meta.port_state == UP ) //port is up
            { 
                apply(get_delay_time); // meta.different_time

                if(meta.config == 1 ) //Delay a configuration time. For example, sharebakcup: 730us.
                { 
                    if(meta.different_time >= ConfigTime ){
                        apply(config_done); 
                    }
                }
                else{ //Only a delay time
	                if(meta.different_time >= DelayTime){                         
                        if(meta.min_pkt_tag <= test.pkt_tag){
                            apply(record_min_pkt_tag); // record the min pkt_tag for mirror pkt                              
                        }
                    }       
                }  
                if(meta.config == YES or (meta.config == NO and meta.different_time < DelayTime) or meta.linkstate == YES ){
                    apply(more_delay_mirror); //to_delay port 
                    apply(drop_initial_pkt); 
                }
            } 
            else{ //port is down                              
                if(eg_intr_md.egress_port != BackupPort or (eg_intr_md.egress_port == BackupPort and meta.min_pkt_tag < test.pkt_tag) ){
                    apply(more_mirror);
                } 

                if(eg_intr_md.egress_port != BackupPort or (eg_intr_md.egress_port == BackupPort and meta.min_pkt_tag != test.pkt_tag) ){
                    apply(drop_pkt);
                }              
            }
        }
    } 
}

