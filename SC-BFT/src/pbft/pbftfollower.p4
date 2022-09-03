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
        rnd: 8;
    }
}

header_type count_meta_t {
    fields {
        count : 16;
    }
}

metadata count_meta_t count_meta;

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

action init_s() {
    modify_field(count_meta.count, 0);
}

table compare_table {
    reads {
        css.op : exact;
    }
    actions {
        css_count;
        init_s;
        no_op;
    }
}


action no_op() {
}

action _drop() {
    drop();
}

action do_forward(port) {
    modify_field(standard_metadata.egress_spec, port);
    modify_field(css.op, css.op+1);
    modify_field(css.rnd, 0);
}


table egress_ta {
    reads{
        css.op : exact;
        css.rnd : exact;
        count_meta.count : exact;
    }
    actions {
        do_forward;
        _drop;
    }
}
        


control ingress{
    apply(compare_table);
    apply(egress_ta);
}

control egress{
/*    apply(egress_table); */
}
