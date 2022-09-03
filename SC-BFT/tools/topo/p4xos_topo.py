#!/usr/bin/python

# Copyright 2013-present Barefoot Networks, Inc. 
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import sys

sys.path.append("/home/sol/behavioral-model/mininet")
from mininet.net import Mininet
from mininet.topo import Topo
from mininet.log import setLogLevel, info
from mininet.cli import CLI
from mininet.link import TCLink

from p4_mininet import P4Switch, P4Host

import argparse
from time import sleep
import os
import subprocess
from subprocess import PIPE

_THIS_DIR = os.path.dirname(os.path.realpath(__file__))
_THRIFT_BASE_PORT = 9290

parser = argparse.ArgumentParser(description='Mininet demo')
parser.add_argument('--behavioral-exe', help='Path to behavioral executable',
                    type=str, action="store", required=True)
parser.add_argument('--acceptor', help='Path to acceptor JSON config file',
                    type=str, action="store", required=True)
parser.add_argument('--coordinator', help='Path to coordinator JSON config file',
                    type=str, action="store", required=True)
parser.add_argument('--pandl', help='Path to pandl JSON config file',
                    type=str, action="store", required=True)    
parser.add_argument('--client', help='Path to client JSON config file',
                    type=str, action="store", required=True)                 
parser.add_argument('--cli', help='Path to BM CLI',
                    type=str, action="store", required=True)

args = parser.parse_args()

class MyTopo(Topo):
    def __init__(self, sw_path, acceptor, coordinator, pandl, client, **opts):
        # Initialize topology and default options
        Topo.__init__(self, **opts)

        s1 = self.addSwitch('s1',
                      sw_path = args.behavioral_exe,
                      json_path = coordinator,
                      thrift_port = _THRIFT_BASE_PORT + 1,
                      pcap_dump = False,
                      device_id = 1)

        s9 = self.addSwitch('s9',
                      sw_path = sw_path,
                      json_path = client,
                      thrift_port = 9191,
                      pcap_dump = False,
                      device_id = 10)

        aswitches = []
        bswitches = []
        linkopts = dict(bw=1, delay='1ms', loss=0, use_htb=True)
        for i in [2, 3, 4]:
            aswitches.append(self.addSwitch('s%d' % (i),
                                    sw_path = sw_path,
                                    json_path = acceptor,
                                    thrift_port = _THRIFT_BASE_PORT + i,
                                    pcap_dump = False,
                                    device_id = i))

        for j in [5, 6, 7, 8]:
            bswitches.append(self.addSwitch('s%d' % (j),
                                    sw_path = sw_path,
                                    json_path = pandl,
                                    thrift_port = _THRIFT_BASE_PORT + j,
                                    pcap_dump = False,
                                    device_id = j))
        
        for i, s in enumerate(aswitches):
            print "switch----------"
            self.addLink(s, s1, **linkopts)
            
            for a, b in enumerate(bswitches):
                    self.addLink(s, b,**linkopts)


        self.addLink(s1, s9, **linkopts)
       # self.addLink(s3, s7)
       # self.addLink(s4, s8)
       # self.addLink(s5, s9)




def main():
    topo = MyTopo(args.behavioral_exe,
                  args.acceptor, args.coordinator, args.pandl, args.client)

    net = Mininet(topo = topo,
                  host = P4Host,
                  switch = P4Switch,
                  link=TCLink,
                  controller = None )

    net.start()

   # for n in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]: 
    #    h = net.get('h%d' % n)
    #    for off in ["rx", "tx", "sg"]:
      #      cmd = "/sbin/ethtool --offload eth0 %s off" % off
     #       print cmd
      #      h.cmd(cmd)
     #   print "disable ipv6"
      #  h.cmd("sysctl -w net.ipv6.conf.all.disable_ipv6=1")
      #  h.cmd("sysctl -w net.ipv6.conf.default.disable_ipv6=1")
      #  h.cmd("sysctl -w net.ipv6.conf.lo.disable_ipv6=1")
      #  h.cmd("sysctl -w net.ipv4.tcp_congestion_control=reno")
     #   h.cmd("iptables -I OUTPUT -p icmp --icmp-type destination-unreachable -j DROP")
    print "netstart end"
      #  h.cmd("route add -net 224.0.0.0 netmask 224.0.0.0 eth0")

    sleep(2)




    print "Ready !"

    CLI( net )
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )
    main()
