#!/usr/bin/python3

from scapy.all import *
from scapy.layers.l2 import Ether


class Event(Packet):
    name = "EventValue "
    fields_desc = [
        XByteField("id", 0),
        IntField("value", 0)
    ]


class EventEnd(Packet):
    name = "EventEnded "
    fields_desc = [
        XByteField("id", 0),
    ]


class EventBuilderID:
    values = {}

    def add(self, aid, value):
        self.values[aid] = value

    def build(self):
        included = list(self.values.keys())
        # included.sort()

        if len(included) == 0:
            raise Exception("You need to specify at least one value.")

        ret = Ether(dst="ff:ff:ff:ff:ff:ff", type=0x9001)

        for aid in included:
            ret = ret / Event(id=aid, value=self.values[aid])

        return ret / EventEnd()


event = EventBuilderID()
event.add(1, 4294967295)
event.add(3, 30)

print("Sending...")

pkt = event.build() / "Payload"
pkt.show()
hexdump(pkt)
sendp(pkt)
