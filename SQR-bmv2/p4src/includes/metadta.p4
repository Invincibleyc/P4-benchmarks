header_type meta_t {
    fields {
        ipv4_protocol: 8;
        pkt_tag_not_inorder: 4;
        switch_id: 4;
        countbyte: 32;
        initial_egr_port: 9;
        port_state: 1;
        sqr_apply: 1;
        clone_delay_is_enough: 1;
        additional_delay_is_enough:1;
        delaystate:1;
        _pad4: 2;
        etherType: 16;  
        initial_egr_timestamp : 48;
        different_time: 48;
        uport: 9;
        port_flip_cmd: 32;
        current_utilization:32;
        previous_utilization:32;
        port_to_flip: 16;
        tcp_flow_port:16;
        delay_port:9;
        min_uport: 9;
        min_uport_value:32;
        special_port: 9;
        realport_state: 1;
        realport_state_temporary: 1;
        linkstate: 1;
        flag_min_uport_value: 1;
        flag_min_uport: 1;
    }
}
metadata meta_t meta;