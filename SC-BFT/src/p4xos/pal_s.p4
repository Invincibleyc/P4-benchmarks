//header 
header_type ethernet_t {
    fields {
        dstAddr : 48;
        srcAddr : 48;
        etherType : 16;
    }
}

header_type css_t {
    fields {
        op : 8;
    }
}


header_type count_meta_t {
    fields {
        count : 8;
    }
}

metadata count_meta_t count_meta;

//parser

parser start {
    return parse_ethernet;
}

header ethernet_t ethernet;

parser parse_ethernet {
    extract(ethernet);
    return parse_css;
}

header css_t css;

parser parse_css {
    extract(css);
    return ingress;
}
//register

register history_count {
    width: 8;
    instance_count: 8192;
}

//MAtable
action _nop() {
}
action _drop() {
    drop();
}

action do_l2(port) {
    modify_field(standard_metadata.egress_spec, port);
    modify_field(css.op, css.op+1);
}

table forward_tbl {
    reads {
        css.op: exact;
    }
    actions {
        _nop;
        _drop;
        do_l2;
    }
}

action do_rl2(ref, port) {
    register_write(history_count, ref, 0);
    modify_field(standard_metadata.egress_spec, port);
    modify_field(css.op, css.op+1);
}

table reset_forward_tbl {
    reads {
        count_meta.count: exact;
    }
    actions {
        _nop;
        _drop;
        do_rl2;
    }
}


action do_count(ref) {
    register_read(count_meta.count, history_count, ref);
    modify_field(count_meta.count, count_meta.count+1);
    register_write(history_count, ref, count_meta.count);
}

table count_tbl {
    reads {
        css.op: exact;
    }
    actions {
        _nop;
        _drop;
        do_count;
    }
}


//control
control ingress{
    if(css.op != 6) {
        apply(forward_tbl);
    }
    if(css.op==6) {
        apply(count_tbl);
        apply(reset_forward_tbl);
    }
}

control egress{
/*    apply(egress_table); */
}
