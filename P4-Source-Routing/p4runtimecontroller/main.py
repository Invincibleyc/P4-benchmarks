from switch_connection import SwitchConnection
from p4.config import p4info_pb2
import google.protobuf.text_format
import argparse
from p4 import p4runtime_pb2
from p4runtime_lib import helper, convert
import zmq
import cPickle as pickle

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("grpc_port", type=int)
    parser.add_argument("thrift_port", type=int)
    parser.add_argument("ipc_addr")
    parser.add_argument("p4info", help="Path to the p4info file")
    parser.add_argument("device_id", type=int)
    parser.add_argument("switch_json_path", help="Path to BMV2 JSON file")
    parser.add_argument("--switches", type=int)
    args = parser.parse_args()

    p4info_helper = helper.P4InfoHelper(args.p4info)

    # ipc_addr = "ipc:///tmp/bmv2-%d-notifications.ipc" % i
    switch = SwitchConnection.SwitchConnection("localhost", str(args.grpc_port), args.ipc_addr, args.thrift_port, args.device_id, p4info_helper.p4info, args.switch_json_path)
    switch.start()

    # Populate the islandTable for lower and higher IDs if --switches argument is set
    # For i in range < device_id, add routes out of port 0
    # For i in range > device_id add routes out of port 1
    if args.__contains__('switches'):
        if args.device_id is not 1:
            print("Setting up inter-island tables")
            port = 0
            for i in range(1, args.device_id + 1):
                print "Value for i is %d, Value for device_id is %d" % (i, args.device_id)
                print "Adding table entry for island %d from port 0" % i
                table_entry = p4info_helper.buildTableEntry(
                    table_name="islandTable",
                    match_fields={
                        "island_hop.dstIsland": i
                    },
                    action_name="forward_to_island",
                    action_params={
                        "port": 0
                    })
                switch.add_table_entry(table_entry)
                print "Added table entry %s" % table_entry
        if args.device_id is not args.switches:
            print "Setting routes to higher-numbered switches"
            for i in range(args.device_id, args.switches + 1):
                print "Value for i is %d, Value for device_id is %d" % (i, args.device_id)
                if i is not args.device_id:
                    print "Adding table entry for island %d from port 1" % i
                    table_entry = p4info_helper.buildTableEntry(
                        table_name="islandTable",
                        match_fields={
                            "island_hop.dstIsland": i
                        },
                        action_name="forward_to_island",
                        action_params={
                            "port": 1
                        })
                    switch.add_table_entry(table_entry)
                    print "Added table entry %s" % table_entry

        # We need to set the isThisIsland entry for each switch, otherwise the packet will never get to it's destination
        print "Setting isThisIsland entry"
        table_entry = p4info_helper.buildTableEntry(
            table_name="isThisIsland",
            match_fields={
                "island_hop.dstIsland": args.device_id
            },
            action_name="strip_island_header")
        resp = switch.add_table_entry(table_entry)
        print resp
        print "Added Table Entry %s" % table_entry
        # # Messy workaround for setting up a default MAC route to the switch on the other end
        # if args.device_id is 1:
        #     print("Adding table entry for 00::05:01")
        #     table_entry = p4info_helper.buildTableEntry(
        #         table_name="dmacTable",
        #         match_fields={
        #             "ethernet.dstAddr": 'AA:00:00:00:05:01'
        #         },
        #         action_name="add_island_header",
        #         action_params={
        #             "srcIsland": 0,
        #             "dstIsland": 5,
        #             "egressPort": 1
        #         })
        #     switch.add_table_entry(table_entry)
        #     pass

        # if args.device_id is 5:
        #     print("Adding table entry for 00::05:01")
        #     table_entry = p4info_helper.buildTableEntry(
        #         table_name="dmacTable",
        #         match_fields={
        #             "ethernet.dstAddr": 'AA:00:00:00:05:01'
        #         },
        #         action_name="l2_forward",
        #         action_params={
        #             "port": 3
        #         })
        #     switch.add_table_entry(table_entry)

    #Set up ZMQ to listen for table entry adds
    context = zmq.Context()
    socket = context.socket(zmq.REP)
    zmq_port = 5554 + args.device_id
    socket.bind("tcp://*:%d" % zmq_port)
    print "Listening for ZMQs"
    while True:
        message = socket.recv_pyobj()
        print("Received request: %s" % message)
        print message.keys()
        # unpickledEntry = pickle.loads(message)
        table_entry = p4info_helper.buildTableEntry(
            table_name="dmacTable",
            match_fields={
                "ethernet.dstAddr": message['dstMac']
            },
            action_name="add_island_header",
            action_params={
                "srcIsland": args.device_id,
                "dstIsland": message['dstIsland'],
                "egressPort": message['egressPort']
            })
        resp = switch.add_table_entry(table_entry)
        socket.send_pyobj(resp)

