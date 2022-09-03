#!/usr/bin/env python
import argparse
import sys
import socket
import random
import struct
import time
import datetime
from scapy.all import sendp, send, get_if_list, get_if_hwaddr
from scapy.all import Packet
from scapy.all import Ether, IP, UDP, TCP
from scapy.all import hexdump, BitField, BitFieldLenField, ShortEnumField, X3BytesField, ByteField, XByteField

#def get_if():
#    ifs=get_if_list()
#    iface=None # "h1-eth0"
#    for i in get_if_list():
#        if "eth0" in i:
#            iface=i
#            break;
#    if not iface:
#        print "Cannot find eth0 interface"
#        exit(1)
#    return iface

class CSS(Packet):
    """CSS"""
       
    name = "CSS"

    fields_desc = [
        BitField('op',0, 8),
        BitField('rnd',0, 8)
   ]

def main():


#src addr
 #   addr = socket.gethostbyname(sys.argv[1])

#dst addr
 #   addr1 = socket.gethostbyname(sys.argv[2])

    iface = sys.argv[1]

   
    ether =  Ether(src='00:00:00:00:00:03', dst='00:00:00:00:00:01', type=0x800)

    pkt = ether / CSS() / "OxAAAAFFFFFFFFFFFFFFFF"
    pkt.show()
    hexdump(pkt)
    ms = time.time() * 1000
    dt = datetime.datetime.now()
    print(dt.microsecond)
    sendp(pkt, iface=iface, verbose=False)

    print "sending on interface %s to dmac=00:00:00:00:00:01 from 3" % (iface)




if __name__ == '__main__':
    main()
