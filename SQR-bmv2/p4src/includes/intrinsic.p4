header_type intrinsic_metadata_t {
    fields {
        ingress_global_timestamp : 48;
        egress_global_timestamp : 48;
        mcast_grp : 16;
        egress_rid : 16;
    }
}

metadata intrinsic_metadata_t intrinsic_metadata;

header_type queueing_metadata_t {
    fields {
        enq_timestamp : 48;
        enq_qdepth : 24;
        deq_timedelta : 32;
        deq_qdepth : 24;
        qid : 8;
    }
}

metadata queueing_metadata_t queueing_metadata;