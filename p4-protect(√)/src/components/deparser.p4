/*************************************************************************
***********************  D E P A R S E R  *******************************
*************************************************************************/

control deparser(packet_out packet, in headers hdr) {
    apply {
        packet.emit(hdr.ethernet);
        packet.emit(hdr.topology);
        packet.emit(hdr.ipv4);
        packet.emit(hdr.protection);
        packet.emit(hdr.ipv4_inner);
        packet.emit(hdr.transport);
    }
}
