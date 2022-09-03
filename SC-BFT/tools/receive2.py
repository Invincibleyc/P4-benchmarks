#!/usr/bin/env python
import sys
import struct
import os
import datetime
from scapy.all import sniff, sendp, hexdump, get_if_list, get_if_hwaddr, Packet, srp1
#from scapy.all import Packet
from scapy.all import hexdump, BitField, BitFieldLenField, ShortEnumField, X3BytesField, ByteField, XByteField, IntField, bind_layers
#ShortField, IntField, LongField, BitField, FieldListField, FieldLenField
from scapy.all import Ether
#IP, TCP, UDP, Raw
#from scapy.layers.inet import _IPOption_HDR
import time

class CSS(Packet):
    """CSS"""
       
    name = "CSS"

    fields_desc = [
        BitField('op',0, 8),
        BitField('rnd',0, 8)
   ]
bind_layers(Ether, CSS)

def get_if():
    ifs=get_if_list()
    iface=None
    for i in get_if_list():
        if "s9-eth1" in i:
            iface=i
            break;
    if not iface:
        print "Cannot find veth2 interface"
        exit(1)
    return iface


def handle_pkt(pkt):
    print "got a packet"

    pkt.show()
    #    hexdump(pkt)
    sys.stdout.flush()
    ms = time.time() * 1000
    dt = datetime.datetime.now()
    print(dt.microsecond)


def main():
    iface = "s9-eth1"
    print "sniffing on %s" % iface
    sys.stdout.flush()
    sniff(iface = iface, filter="ether dst 00:00:00:00:00:01",
          prn = lambda x: handle_pkt(x))



if __name__ == '__main__':
    main()
