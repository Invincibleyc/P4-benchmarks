#!/usr/bin/python

from scapy.all import sniff, sendp
from scapy.all import Packet
from scapy.all import ShortField, IntField, LongField, BitField

import sys
import struct

def printhex(s):
  return '0x' + "".join("{:02x}".format(ord(c)) for c in s)

def processEthernet(pkt):
  ethDst = pkt[:6]
  ethSrc = pkt[6:12]
  ethType = pkt[12:14]
  print("ethDst: " + printhex(ethDst))
  print("ethSrc: " + printhex(ethSrc))
  print("ethType: " + printhex(ethType))

def handle_pkt(pkt):
  pkt = str(pkt)
  if len(pkt) < 12:
    return
  processEthernet(pkt)
  sys.stdout.flush()

def main():
  sniff(iface = "eth0",
        prn = lambda x: handle_pkt(x))

if __name__ == '__main__':
  main()
