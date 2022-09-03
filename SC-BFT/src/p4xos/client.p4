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


//MAtable
action _nop() {
}
action _drop() {
    drop();
}

action do_l2(port) {
    modify_field(standard_metadata.egress_spec, port);
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

 
//control
control ingress{
    apply(forward_tbl);
}

control egress{
/*    apply(egress_table); */
}
