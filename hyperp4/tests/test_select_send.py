#!/usr/bin/python

from scapy.all import sniff, sendp
from scapy.all import Packet
from scapy.all import ShortField, IntField, XLongField, XBitField
from scapy.all import Ether, IP, TCP

import sys

def main():
  p = Ether(dst='00:04:00:00:00:02') / IP() / TCP() / "AAAA"
  print p.show()
  sendp(p, iface = "eth0")

if __name__ == '__main__':
  main()
