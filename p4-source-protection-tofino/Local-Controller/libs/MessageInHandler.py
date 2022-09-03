"""
This module handles all packet in messages from the switches
It triggers the corresponding actions based on the type of in message
"""
from scapy.all import *
from scapy.contrib.igmp import IGMP
from libs.core.Event import Event
from libs.Configuration import Configuration
from libs.core.Log import Log


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


            if pkt.type == 0xDD00:  # its an topology packet
                Event.trigger("topology_packet_in", packet=pkt, switch=switch)

        except Exception as e:  # it's not an ethernet frame
            pass
