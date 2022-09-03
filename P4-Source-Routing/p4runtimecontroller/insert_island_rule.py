import zmq
import argparse
parser = argparse.ArgumentParser()

if __name__ == "__main__":
    context = zmq.Context()

    socket = context.socket(zmq.REQ)
    socket.connect("tcp://localhost:5555")
    message = {'dstIsland': 5, 'dstMac': "AA:00:00:00:05:01", 'egressPort': 1}
    socket.send_pyobj(message)
    resp = socket.recv_pyobj()
    print resp
    exit(0)