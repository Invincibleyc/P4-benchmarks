"""
Device class for Switch and Host
Contains name, ip and mac address
Contains mapping from neighbor to port
"""
from libs.TopologyManager import DeviceNotFound
from collections import defaultdict
class Device(object):

    def __init__(self, name=None, ip=None, mac=None):
        """
        Iitialize device with name, ip and mac
        No multi interface support yet
        :param name: name
        :param ip: ip
        :param mac: mac
        """
        self._name = name
        self._device_to_port = defaultdict(list)
        self._ip = ip
        self._mac = mac

    def add_device_to_port(self, device=None, port=None):
        """
        Device is reachable via port
        :param device: reachable device
        :param port: device is reachable using the specified port
        :return:
        """

        if port not in self._device_to_port[device]:
            self._device_to_port[device].append(port)

            return True

        return False

    def get_device_to_port(self, device):
        """
        Get port for given device
        :param device:
        :return:
        """
        dev = self._device_to_port.get(device)

        if dev is None:
            raise DeviceNotFound(device)

        return dev

    def get_ip(self):
        """
        Get device ip
        :return: ip
        """
        return self._ip

    def get_mac(self):
        """
        Get device mac
        :return: mac address of device
        """
        return self._mac

    def get_name(self):
        """
        Get device name
        :return: device name
        """
        return self._name

    def get_type(self):
        """
        Used for distinguish Switch and Host
        :return:
        """
        return "Device"

    def get_device_to_port_mapping(self):
        """
        Get device to port mapping
        :return: device to port dict
        """
        return self._device_to_port

    def __str__(self):
        """
        Describes the device
        :return:
        """
        return self.get_type() + "(" + self._name + ", " + self._ip + ", " + \
               str(self._mac) + ", " + \
               str(self._device_to_port) + ")"
