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



action no_op() {
}

action _drop() {
    drop();
}

action do_forward(port) {
    modify_field(standard_metadata.egress_spec, port);
    modify_field(css.op, css.op+1);
    modify_field(css.rnd, css.rnd+1);
}

action do_mc() {
    modify_field(intrinsic_metadata.mcast_grp, 1);
    modify_field(css.op, css.op+1);    
    modify_field(css.rnd, css.rnd+1);
}

table egress_ta {
    reads{
        css.op : exact;
        css.rnd : exact;
    }
    actions {
        do_forward;
        do_mc;
        _drop;
    }
}
        


control ingress{
    apply(egress_ta);
}

control egress{
/*    apply(egress_table); */
}
