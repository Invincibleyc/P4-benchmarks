from libs.core.Log import Log
from libs.TableEntryManager import TableEntryManager, TableEntry
from libs.core.Event import Event
from libs.TopologyManager import TopologyManager
from libs.Configuration import Configuration


class L2Controller(object):
    """
    This module implements an L2Controlelr and
    sets forwarding rules for L2 switching
    """

    def __init__(self, base):
        """
        Init L2 Controller with base

        Args:
            base (libs.core.BaseController): Base controller
        """

        # table manager
        self.table_manager = TableEntryManager(controller=base, name="L2Controller")
        self.table_manager.init_table("ingress.l2_c.l2_forwarding")

        Event.on("topology_change", self.update)

    def update_l2_entry(self):
        """
        Add mac rewriting rule for switch->dst_dev via port

        Args:
            switch (str): switch where rule will be installed
        """
        valid_entries = []

        device = TopologyManager.get_device(Configuration.get('name'))

        for device_name in device.get_device_to_port_mapping():
            dev = TopologyManager.get_device(device_name)
            ports = device.get_device_to_port(device_name)

            entry = TableEntry(match_fields={"hdr.ethernet.dstAddr": dev.get_mac()},
                               action_name="ingress.l2_c.l2_forward",
                               action_params={"e_port": int(ports)})

            TableEntryManager.handle_table_entry(manager=self.table_manager,
                                                 table_name="ingress.l2_c.l2_forwarding",
                                                 table_entry=entry)

            valid_entries.append(entry.match_fields)


        # remove possible old entries
        self.table_manager.remove_invalid_entries(table_name="ingress.l2_c.l2_forwarding", valid_entries=valid_entries)

    #############################################################
    #                   Event Listener                          #
    #############################################################

    def update(self, *args, **kwargs):
        """
        Update mac entries
        triggered by event
        """

        self.update_l2_entry()
