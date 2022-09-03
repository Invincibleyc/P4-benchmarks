import argparse
import pexpect
import sys
import time
import timeit
import zmq

def run_table_insert(dstSwitch):
    context = zmq.Context()
    socket = context.socket(zmq.REQ)
    socket.connect("tcp://localhost:5555")
    message = {'dstIsland': dstSwitch, 'dstMac': "AA:00:00:00:05:01", 'egressPort': 1}
    socket.send_pyobj(message)
    resp = socket.recv_pyobj()
    print resp
    print "Done with table insert"
    return

parser = argparse.ArgumentParser('Run a range of tests and write the results to a file')
parser.add_argument('runs', type=int, help='The number of runs for each approach')
parser.add_argument('min_number', type=int, help='The starting number of switches to run')
parser.add_argument('max_number', type=int, help='The maximum number of switches to run')
parser.add_argument('steps', type=int, help='Steps between starting and max number of switches')
args = parser.parse_args()

for num_switches in range(args.min_number, args.max_number + 1, args.steps):
    fout = open("results-%d-%dswitches.txt" % (time.time(), num_switches), 'w')
    for run in range(0, args.runs):
        "Run %d" % run
        command = "python start_switches.py %d ../p4src/tiered.json ../p4src/tiered.p4info" % num_switches
        child = pexpect.spawn(command, timeout=300)
        child.logfile = sys.stdout
        child.expect("Everything should be running by now...")
        print "Switches should have started for run %d. Sleeping for 30 seconds for everything to settle" % run
        time.sleep(30)
        t = timeit.Timer(lambda: run_table_insert(num_switches))
        fout.write(str(t.timeit(1)) + '\n')
        print "Run %d complete" % run
        child.send('\003')
        child.expect(pexpect.EOF)
        print "Done with this run"
