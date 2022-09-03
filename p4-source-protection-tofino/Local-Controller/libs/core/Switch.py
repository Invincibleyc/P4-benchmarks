"""
This module represents a switch.
"""

from libs.core.Device import Device


class Switch(Device):
    def __init__(self, name=None, ip=None, mac=None, id=None):
        """
        Initialize switch with name, ip, mac and bfr_id
        :param name: name of the swithc
        :param ip: ip of the switch
        :param mac: mac of the switch
        :param bfr_id: bfr_id for domain 0, all other ids in different domains will be set automaticly
        """
        super(self.__class__, self).__init__(name=name, ip=ip, mac=mac)
        self.id = id

    def get_type(self):
        return "Switch"

    def __str__(self):
        return self.get_type() + "(" + self._name + ", " + self._ip + ", " + \
               str(self._mac) + ", " + \
               str(self._device_to_port) + ")"
