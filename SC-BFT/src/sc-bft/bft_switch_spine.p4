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
        count : 16;
    }
}

metadata count_meta_t count_meta;

header_type intrinsic_metadata_t {
    fields {
        mcast_grp : 16;
        egress_rid : 16;
    }
}

metadata intrinsic_metadata_t intrinsic_metadata;

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

register css_compare {
    width: 16;
    instance_count: 8192;
}

action css_count(ref) {
    register_read(count_meta.count, css_compare, ref);
    modify_field(count_meta.count, count_meta.count+1);
    register_write(css_compare, ref, count_meta.count);
}

table compare_table {
    reads {
        css.op : exact;
    }
    actions {
        css_count;
    }
}

action do_multicast() {
    modify_field(intrinsic_metadata.mcast_grp, 1);
    modify_field(css.op, css.op+1);
}
action do_cmc(ref) {
    register_write(css_compare, ref, 0);
    modify_field(standard_metadata.egress_spec, 1);
    modify_field(css.op, css.op+1);
}

action no_op() {
}

action _drop() {
    drop();
}

table multicast_table {
    reads {
        css.op : exact;
    }
    actions {
        do_multicast;
        do_cmc;
        _drop;
        no_op;
    }
}

table mc_table {
    reads {
        css.op : exact;
    }
    actions {
        do_multicast;
        do_cmc;
        _drop;
        no_op;
    }
}



action do_forward(port) {
    modify_field(standard_metadata.egress_spec, port);
}

table egress_table {
    reads{
        css.op : exact;
    }
    actions {
        do_forward;
    }
}
        


control ingress{
    
    if(css.op==0) {
        apply(multicast_table);
    }
    if(css.op==2) {
        apply(compare_table);
        if(count_meta.count>3) {
            apply(mc_table);
        }
    }
}

control egress{
/*    apply(egress_table); */
}
