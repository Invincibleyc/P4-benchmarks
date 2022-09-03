import sys
sys.path.append('/opt/bf-sde-8.9.1/install/lib/python2.7/site-packages/tofino')
sys.path.append('/opt/bf-sde-8.9.1/install/lib/python2.7/site-packages')


import importlib
import struct
import threading
from thrift.transport import TSocket
from thrift.transport import TTransport
from thrift.protocol import TBinaryProtocol, TMultiplexedProtocol

from scapy.all import *
from libs.packet_header.TopologyPacket import TopologyDiscovery
from ptf.thriftutils import *
from res_pd_rpc.ttypes import *
from pal_rpc.ttypes import *
from mirror_pd_rpc.ttypes import *
from conn_mgr_pd_rpc.ttypes import *
from libs.Configuration import Configuration
from libs.core.Log import Log
from libs.core.Event import Event
from libs.TopologyManager import TopologyManager


def set_port_map(indices):
    bit_map = [0] * ((288+7)/8)
    for i in indices:
        index = portToBitIdx(i)
        bit_map[index/8] = (bit_map[index/8] | (1 << (index%8))) & 0xFF

    return bytes_to_string(bit_map)

def portToBitIdx(port):
    pipe = port >> 7
    index = port & 0x7F

    return 72 * pipe + index

def set_lag_map(indices):
    bit_map = [0] * ((256 * 7)/8)

    for i in indices:
        bit_map[i/8] = (bit_map[i/8] | (1 << (i%8))) & 0xFF

    return bytes_to_string(bit_map)


class ThriftConnection:
    def __init__(self):
        self.transport = TTransport.TBufferedTransport(TSocket.TSocket("localhost", 9090))
        self.protocol = TBinaryProtocol.TBinaryProtocol(self.transport)
        self.conn_mgr_client_module = importlib.import_module(".".join(["conn_mgr_pd_rpc", "conn_mgr"]))
        self.conn_mgr_protocol = self.conn_mgr_protocol = TMultiplexedProtocol.TMultiplexedProtocol(self.protocol, "conn_mgr")
        self.conn_mgr = self.conn_mgr_client_module.Client(self.conn_mgr_protocol)

        self.transport.open()

        self.hdl = self.conn_mgr.client_init()

    def end(self):
        self.conn_mgr.client_cleanup(self.hdl)

class PortConfig():


    def __init__(self, thrift_con=None):
        self.pal_protocol = TMultiplexedProtocol.TMultiplexedProtocol(thrift_con.protocol, "pal")
        self.pal_client_module = importlib.import_module(".".join(["pal_rpc", "pal"]))
        self.pal = self.pal_client_module.Client(self.pal_protocol)


    def setPorts(self, data=None):
        for configuration in data[Configuration.get('name')]:
            p_id = self.pal.pal_port_front_panel_port_to_dev_port_get(0, configuration['port'], configuration['channel'])
            self.pal.pal_port_add(0, p_id, configuration['speed'], pal_fec_type_t.BF_FEC_TYP_NONE)
            self.pal.pal_port_an_set(0, p_id, 2)
            self.pal.pal_port_enable(0, p_id)


class McConfig():
    def __init__(self, thrift_con=None, pal=None):
        self.mc_protocol = TMultiplexedProtocol.TMultiplexedProtocol(thrift_con.protocol, "mc")
        self.mc_client_module = importlib.import_module(".".join(["mc_pd_rpc", "mc"]))
        self.mc = self.mc_client_module.Client(self.mc_protocol)
        self.mc_sess_hdl = self.mc.mc_create_session()
        self.pal = pal


    def setFlood(self, data=None):
        grp_id = self.mc.mc_mgrp_create(self.mc_sess_hdl, 0, 1)
        ports = []

        for configuration in data[Configuration.get('name')]:
            p_id = self.pal.pal_port_front_panel_port_to_dev_port_get(0, configuration['port'], configuration['channel'])

            if configuration['flood']:
                ports.append(p_id)

        node = self.mc.mc_node_create(self.mc_sess_hdl, 0, 0, set_port_map(ports), set_lag_map([]))
        self.mc.mc_associate_node(self.mc_sess_hdl, 0, grp_id, node, 0, 0)

    def end(self):
        self.mc.mc_destroy_session(self.mc_sess_hdl)


class PDSetup:

    def __init__(self):
        self.tc = ThriftConnection()
        self.pc = PortConfig(thrift_con=self.tc)
        self.mc = McConfig(thrift_con=self.tc, pal=self.pc.pal)

    def setPorts(self, config_file=None):
        Log.info("Set ports")
        self.pc.setPorts(Configuration.load(config_file))

    def setFlood(self, config_file=None):
        Log.info("Set flood mc group")
        self.mc.setFlood(Configuration.load(config_file))

    def end(self):
        Log.info("Close pd connection")
        self.mc.end()
        self.tc.end()
