#!/usr/bin/python
from scapy.all import sniff, sendp
from scapy.all import Packet
from scapy.all import ShortField, IntField, LongField, BitField
from scapy.all import Ether, IP, ICMP

import time
import networkx as nx

import sys

def main():
    while(1):
        time.sleep(4)
        #raw =  raw_input("What do you want to send: ")
        #if raw=="q":
        #    exit()
        now = time.time()
        msg = "send_time: " + "%.6f" % float(now) + " msg: "
        #msg = str(now) + " " + raw

        p = Ether() / IP(src="10.0.0.1", dst="10.0.0.2") / ICMP() / msg
        sendp(p, iface = "eth0")
        # print msg

if __name__ == '__main__':
    main()
