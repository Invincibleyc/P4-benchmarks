#!/usr/bin/python
from scapy.all import sniff, sendp
from scapy.all import Packet
from scapy.all import ShortField, IntField, LongField, BitField

import sys
import struct
import time

def handle_pkt(pkt):
    print pkt.sprintf("Raw: %Raw.load%")
    now = time.time()
    print "receive_time: " + "%.6f" % float(now) + "\n"
    sys.stdout.flush()

def main():
    sniff(iface = "eth0", filter="icmp",
          prn = lambda x: handle_pkt(x))

if __name__ == '__main__':
    main()
