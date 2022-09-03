import argparse
import libtmux
import time
from pyroute2 import IPRoute

parser = argparse.ArgumentParser(description='Run n grpc switches')
parser.add_argument('num_of_switches', type=int, help='The number of switches to launch')
parser.add_argument('bmv2_json_path', help="Path to the BMV2 JSON config")
parser.add_argument('p4info_path', help='Path to the compiled bmv2 file')
args = parser.parse_args()

server = libtmux.Server()
session = server.new_session('tiered_switch_session')
try:
    windows = []
    for i in range(1, args.num_of_switches + 1):
        window = session.new_window('switch %d window' % i)
        if i is 0 and args.num_of_switches > 1:
            prev_switch_interface = ""
            interfaces = "-i 0@sw{0}veth0a -i 1@sw{0}veth1a -i 2@sw{0}veth2a -i 3@sw{0}veth3a".format(i)  # i- n@vethn
        else:
            interfaces = "-i 1@sw{0}veth1a -i 2@sw{0}veth2a -i 3@sw{0}veth3a".format(i)
            prev_switch_interface = " -i 0@sw{0}veth{1}b".format(i-1, 1)
            print prev_switch_interface
        interfaces = interfaces + prev_switch_interface
        device_id = i
        json_file = args.bmv2_json_path
        thrift_port = 9091 + i
        grpc_port = 50051 + i
        command = "sudo simple_switch_grpc %s --log-console --device-id %d --thrift-port %d %s -- --grpc-server-addr 0.0.0.0:%d" % (interfaces, device_id, thrift_port, json_file, grpc_port)
        print command
        pane = window.attached_pane
        pane.send_keys(command)

    print "Sleeping for 10 seconds for switches to start"
    time.sleep(10)
    print "Starting controllers..."
    controller_session = server.new_session('controller_session')
    controller_windows = []
    for i in range(1, args.num_of_switches + 1):
        window = controller_session.new_window('controller %d window' % i)
        ipc_addr = "ipc:///tmp/bmv2-%d-notifications.ipc" % i
        grpc_port = 50051 + i
        thrift_port = 9091 + i
        command = "cd ../p4runtimecontroller && sudo python main.py %d %d \"%s\" %s %d %s --switches %d" % (grpc_port, thrift_port, ipc_addr, args.p4info_path, i, args.bmv2_json_path, args.num_of_switches)
        print command
        pane = window.attached_pane
        pane.send_keys(command)

    print "Waiting 10 seconds for controllers to start..."

    time.sleep(10)
    print "Everything should be running by now..."
    while True:
        pass

except KeyboardInterrupt as e:
    session.kill_session()
    if controller_session is not None:
        controller_session.kill_session()
    print("Killed")