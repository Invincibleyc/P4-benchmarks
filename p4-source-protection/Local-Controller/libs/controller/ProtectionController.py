from libs.core.Log import Log
from libs.TableEntryManager import TableEntryManager, TableEntry
from libs.core.Event import Event
from libs.TopologyManager import TopologyManager
from libs.Configuration import Configuration


class ProtectionController(object):
    """
    This module implements an ProtectionController
    """

    def __init__(self, base):
        """
        Init ProtectionController

        Args:
            base (libs.core.BaseController): Base controller
        """

        # table manager
        self.table_manager = TableEntryManager(controller=base, name="ProtectionController")
        self.table_manager.init_table("ingress.protect_c.period")
        self.table_manager.init_table("ingress.protect_c.port_config")

        self.data = Configuration.load(Configuration.get('config'))


    def loadPeriod(self):
        entry = TableEntry(action_name="ingress.protect_c.set_period",
                           action_params={"period": self.data['period']},
                           priority=1)

        TableEntryManager.handle_table_entry(manager=self.table_manager,
                                            table_name="ingress.protect_c.period",
                                            table_entry=entry)

    def writeInfo(self): 
        primary = self.data['primary']
        secondary = self.data['secondary']

        entry = TableEntry(action_name="ingress.protect_c.set_ports",
                           action_params={"primary": primary, "secondary": secondary},
                           priority=1)

        TableEntryManager.handle_table_entry(manager=self.table_manager,
                                             table_name="ingress.protect_c.port_config",
                                             table_entry=entry)
