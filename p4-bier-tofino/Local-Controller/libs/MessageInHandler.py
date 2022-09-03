"""
This module handles all packet in messages from the switches
It triggers the corresponding actions based on the type of in message
"""
from scapy.all import *
from scapy.contrib.igmp import IGMP
from libs.core.Event import Event
from libs.Configuration import Configuration
from libs.core.Log import Log
from libs.packet_header.PortDown import PortDown
import proto.connection_pb2

class MessageInHandler:

    @staticmethod
    def message_in(*args, **kwargs):
        """
        Generic message_in handle function
        Triggers corresponding event
        :param kwargs:
        :return:
        """
        packet = kwargs.get('packet')
        switch = kwargs.get('switch')
        try:
            pkt = Ether(packet.packet.payload)
            try:
                Configuration.get('system_done')
            except ConfigurationNotFound:
                return
            if pkt.type == 0xEE00: # its an port down packet
		Log.info("Port:", pkt[PortDown].port_num, "down", "on ingress", pkt[PortDown].pad1, "on pipe")
                Event.trigger("port_down", pkt=pkt)


            if pkt.type == 0xDD00:  # its an topology packet
                Event.trigger("topology_packet_in", packet=pkt, switch=switch)

            if pkt.type == 0x800 and pkt[IP].proto == 2:  # its an igmp packet
                igmp = pkt.payload
                pkt = proto.connection_pb2.GroupPacket(type=int(igmp.type), mc_address=str(igmp.gaddr), src_ip=str(igmp.src), switch=Configuration.get('name'))
                Event.trigger("igmp_packet_to_controller", pkt=pkt)
                Log.debug("Send igmp packet to controller")

        except Exception as e:  # it's not an ethernet frame
            pass
