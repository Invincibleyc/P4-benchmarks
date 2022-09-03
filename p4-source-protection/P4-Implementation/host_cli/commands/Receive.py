from scapy.all import *
import sys,os
from core.Log import Log
from core.Network import Network
import time
import datetime

class Receive(object):
    ifaces = filter(lambda i: 'eth' in i, os.listdir('/sys/class/net/'))

    @staticmethod
    def handle_pkt(pkt):
        iface = Receive.ifaces[0]

        if pkt[Ether].dst != Network.get_mac_address():
            return

        if pkt[Ether].type != 0xDD01:
            return

            
        Log.async_info("[" + str(datetime.datetime.now()) +"]", str(pkt[Ether].src))

    @staticmethod
    def main():
        ifaces = filter(lambda i: 'eth' in i, os.listdir('/sys/class/net/'))
        iface = ifaces[0]
        sys.stdout.flush()
        sniff(iface = iface,
              prn = lambda x: Receive.handle_pkt(x))
