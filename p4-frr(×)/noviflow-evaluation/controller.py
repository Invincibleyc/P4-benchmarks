from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller import dpset
from ryu.controller.handler import MAIN_DISPATCHER
from ryu.controller.handler import CONFIG_DISPATCHER
from ryu.controller.handler import set_ev_cls
from ryu.ofproto import ofproto_v1_4

NO_COOKIE = 0

RECIRCULATION = False

class L2Switch(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_4.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super(L2Switch, self).__init__(*args, **kwargs)

    @set_ev_cls(dpset.EventDP, MAIN_DISPATCHER)
    def from_here(self,ev):
        if RECIRCULATION:
            pass
        else:
            self.test(ev)

    def test(self,ev):
        print "datapath  connected: " + str(ev.dp)
        dp = ev.dp
        match = dp.ofproto_parser.OFPMatch()
        actions = [dp.ofproto_parser.OFPActionOutput(dp.ofproto.OFPP_CONTROLLER, dp.ofproto.OFPCML_NO_BUFFER)]
        instructions = [dp.ofproto_parser.OFPInstructionActions(dp.ofproto.OFPIT_APPLY_ACTIONS, actions)]
  
        mod = dp.ofproto_parser.OFPFlowMod(dp,
                                                cookie=NO_COOKIE, cookie_mask=1,
                                                table_id=1,
                                                command=dp.ofproto.OFPFC_ADD,
                                                priority=0,
                                                match=match, instructions=instructions)

        dp.send_msg(mod)                           

        self.send_features_request(dp)

        match = dp.ofproto_parser.OFPMatch(metadata=(132,132))
        actions = [dp.ofproto_parser.OFPActionOutput(4)]
        instructions = [dp.ofproto_parser.OFPInstructionActions(dp.ofproto.OFPIT_APPLY_ACTIONS, actions)]

        mod = dp.ofproto_parser.OFPFlowMod(dp,
                                                cookie=NO_COOKIE, cookie_mask=1,
                                                table_id=2,
                                                command=dp.ofproto.OFPFC_ADD,
                                                priority=1,
                                                match=match, instructions=instructions)

        match = dp.ofproto_parser.OFPMatch(metadata=(66,66))
        actions = [dp.ofproto_parser.OFPActionOutput(6)]
        instructions = [dp.ofproto_parser.OFPInstructionActions(dp.ofproto.OFPIT_APPLY_ACTIONS, actions)]

        mod = dp.ofproto_parser.OFPFlowMod(dp,
                                                cookie=NO_COOKIE, cookie_mask=1,
                                                table_id=2,
                                                command=dp.ofproto.OFPFC_ADD,
                                                priority=0,
                                                match=match, instructions=instructions)

        dp.send_msg(mod)

        match = dp.ofproto_parser.OFPMatch(in_port=4)
        actions = [dp.ofproto_parser.OFPActionOutput(2)]
        instructions = [dp.ofproto_parser.OFPInstructionActions(dp.ofproto.OFPIT_APPLY_ACTIONS, actions)]

        mod = dp.ofproto_parser.OFPFlowMod(dp,
                                                cookie=NO_COOKIE, cookie_mask=1,
                                                table_id=1,
                                                command=dp.ofproto.OFPFC_ADD,
                                                priority=1,
                                                match=match, instructions=instructions)

        dp.send_msg(mod)

        match = dp.ofproto_parser.OFPMatch(in_port=6)
        actions = [dp.ofproto_parser.OFPActionOutput(2)]
        instructions = [dp.ofproto_parser.OFPInstructionActions(dp.ofproto.OFPIT_APPLY_ACTIONS, actions)]
    
        mod = dp.ofproto_parser.OFPFlowMod(dp,
                                                cookie=NO_COOKIE, cookie_mask=1,
                                                table_id=1,
                                                command=dp.ofproto.OFPFC_ADD,
                                                priority=1,
                                                match=match, instructions=instructions)

        dp.send_msg(mod)

        # goto table 1 in table 0
        match = dp.ofproto_parser.OFPMatch()
        goto_actions = dp.ofproto_parser.OFPInstructionGotoTable(1)
        instructions = [goto_actions]


        mod = dp.ofproto_parser.OFPFlowMod(dp,
                                                cookie=1, cookie_mask=1,
                                                table_id=0,
                                                command=dp.ofproto.OFPFC_ADD,
                                                priority=1,
                                                match=match, instructions=instructions)

        dp.send_msg(mod)

        # port status
        match = dp.ofproto_parser.OFPMatch(in_port=2)
        goto_actions = dp.ofproto_parser.OFPInstructionGotoTable(2)
        write_meta_action = dp.ofproto_parser.OFPInstructionWriteMetadata(231,231)
        instructions = [write_meta_action,goto_actions]


        mod = dp.ofproto_parser.OFPFlowMod(dp,
                                                cookie=1, cookie_mask=1,
                                                table_id=1,
                                                command=dp.ofproto.OFPFC_ADD,
                                                priority=1,
                                                match=match, instructions=instructions)

        dp.send_msg(mod)

        # match metadata
        metadatas=[(132,132),(66,66),(33,33),(20,20),(10,10)]
        ports=[4,6,2,4,6]
        eth_dsts=["00:1b:21:54:b3:bc","ec:f4:bb:d5:fe:d0","00:1b:21:4a:fe:68","00:1b:21:54:b3:bc","ec:f4:bb:d5:fe:d0"]
        ip_dsts=["192.168.30.6","192.168.30.9","192.168.30.5","192.168.30.6","192.168.30.9"]
        counter=0
        for metamatch in metadatas:
            match = dp.ofproto_parser.OFPMatch(eth_type=0x0800, metadata=metamatch)
            actions = [dp.ofproto_parser.OFPActionSetField(eth_dst=eth_dsts[counter]),dp.ofproto_parser.OFPActionSetField(ipv4_dst=ip_dsts[counter])]
            actions.extend([dp.ofproto_parser.OFPActionOutput(ports[counter])])
            instructions = [dp.ofproto_parser.OFPInstructionActions(dp.ofproto.OFPIT_APPLY_ACTIONS, actions)]


            mod = dp.ofproto_parser.OFPFlowMod(dp,
                                                cookie=NO_COOKIE, cookie_mask=1,
                                                table_id=2,
                                                command=dp.ofproto.OFPFC_ADD,
                                                priority=metamatch[1],
                                                match=match, instructions=instructions)

            dp.send_msg(mod)
            counter+=1

    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def packet_in_handler(self, ev):

        msg = ev.msg
        dp = msg.datapath
        ofp = dp.ofproto
        ofp_parser = dp.ofproto_parser

        actions = [ofp_parser.OFPActionOutput(ofp.OFPP_FLOOD, 0)]
        out = ofp_parser.OFPPacketOut(dp, msg.buffer_id, 2, actions)

        dp.send_msg(out)

    def send_features_request(self, datapath):
        ofp_parser = datapath.ofproto_parser

        req = ofp_parser.OFPFeaturesRequest(datapath)
        datapath.send_msg(req)


    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features_handler(self, ev):
        msg = ev.msg

        print "datapath_id= "+ str(msg.datapath_id)
