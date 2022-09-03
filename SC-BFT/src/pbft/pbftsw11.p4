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



action do_forward(port) {
    modify_field(standard_metadata.egress_spec, port);
    modify_field(css.op, 3);
}

table egress_ta {
    reads{
        css.op : exact;
        standard_metadata.ingress_port : exact;
    }
    actions {
        do_forward;
    }
}
        


control ingress{
    apply(egress_ta);
}

control egress{
/*    apply(egress_table); */
}
