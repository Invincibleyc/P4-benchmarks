import time
import Queue
import threading
import grpc
from p4 import p4runtime_pb2
import nnpy
from p4.tmp import p4config_pb2
import pdb

class SwitchConnection:

    def __init__(self, ip, port, ipc_addr, thrift_port, device_id, p4info, bmv2_json):
        self.ip = ip
        self.port = port
        self.ipc_addr = ipc_addr
        self.thrift_port = thrift_port
        self.stream_in_queue = Queue.Queue()
        self.stream_out_queue = Queue.Queue()
        self.ipc_queue = Queue.Queue()
        self.device_id = device_id
        self.bmv2_json = bmv2_json
        self.p4info = p4info
        self.stream = None
        self.ipcThread = None

        self.stream_recv_thread = None
        self.started = False
        self.channel = None
        self.client_stub = None
        self.runFlag = False

        self.election_id = None



    # Start the connection to sockets and start the threads etc.
    def start(self):
        self.runFlag = True
        self.channel = grpc.insecure_channel(self.ip + ':' + self.port)
        self.client_stub = p4runtime_pb2.P4RuntimeStub(self.channel)

        stream = self.client_stub.StreamChannel(self.__stream_req_iterator())
        self.stream_recv_thread = threading.Thread(target=self.__stream_recv, args=(stream,))
        self.stream_recv_thread.start()
        self.ipcThread = threading.Thread(target=self._runIpcListener)
        self.ipcThread.start()
        stream_message_request = p4runtime_pb2.StreamMessageRequest()
        arb = stream_message_request.arbitration
        arb.device_id = self.device_id

        self.election_id = arb.election_id
        self.election_id.high = 0
        self.election_id.low = 1

        self.stream_out_queue.put(stream_message_request)
        rep = self.get_stream_packet("arbitration", timeout=100)
        if rep is None:
            print("Failed to handshake with switch")
            self.stream_out_queue.put(None)
            self.stream_recv_thread.join(1)
            exit(1)
        else:
            print("####Handshake with switch complete, now master")
            print("####Setting Forwarding Config")
            self.set_forwarding_pipeline()

        self.started = True
        return

    def set_forwarding_pipeline(self):
        device_config = p4config_pb2.P4DeviceConfig()
        device_config.reassign = True
        with open(self.bmv2_json) as f:
            device_config.device_data = f.read()
        request = p4runtime_pb2.SetForwardingPipelineConfigRequest()
        request.election_id.CopyFrom(self.election_id)
        request.device_id = self.device_id
        config = request.config
        config.p4info.CopyFrom(self.p4info)
        config.p4_device_config = device_config.SerializeToString()
        request.action = p4runtime_pb2.SetForwardingPipelineConfigRequest.VERIFY_AND_COMMIT
        self.client_stub.SetForwardingPipelineConfig(request)
        return

    # Cleanly stop the threads
    def stop(self):
        print "Switch connection object received shutdown request"
        self.started = False
        self.stream_in_queue.put(None)
        self.stream_out_queue.put(None)
        return


    def add_table_entry(self, table_entry):
        request = p4runtime_pb2.WriteRequest()
        request.device_id = self.device_id
        update = request.updates.add()
        update.type = p4runtime_pb2.Update.INSERT
        update.entity.table_entry.CopyFrom(table_entry)
        request.election_id.CopyFrom(self.election_id)
        # pdb.set_trace()
        self.client_stub.Write(request)
        #
        # print "Got response %s" + str(resp)

        # resps = []
        # for response in self.read_table_entries(table_entry.table_id):
        #     print response.entity
        # return resps

    def remove_table_entry(self):
        pass

    def read_table_entries(self, table_id):
        print "Entered read table entries function"
        request = p4runtime_pb2.ReadRequest()
        request.device_id = self.device_id
        entity = request.entities.add()
        table_entry = entity.table_entry
        table_entry.table_id = table_id
        # request.election_id.CopyFrom(self.election_id)
        print "Read request is "
        print request
        for response in self.client_stub.Read(request):
            yield response

    #Listen for ipc events and handle them appropriately
    def _runIpcListener(self):
        sub = nnpy.Socket(nnpy.AF_SP, nnpy.SUB)
        sub.connect(self.ipc_addr)
        sub.setsockopt(nnpy.SUB, nnpy.SUB_SUBSCRIBE, '')
        while self.runFlag:
            msg = sub.recv()
            print msg
            self.ipc_queue.put(msg)

    # Iterator to pass objects to the grpc queue
    def __stream_req_iterator(self):
        while True:
            p = self.stream_out_queue.get()
            if p is not None:
                print '#### Stream in: '
                print p
                print "#### End stream req iterator"
                yield p
            else:
                break

    # Function to receive from the GRPC stream, if anything goes wrong, a None object is put into the queue to signal the connection has been lost
    def __stream_recv(self, in_stream):
        print "#### Initialsing receive thread"
        try:
            for p in in_stream:
                self.stream_in_queue.put(p)
                print(">>>> STREAM IN >>>>")
                print(p)
                print(">>>> END STREAM IN >>>>")
        except Exception as e:
            print "!!!! Caught Exception in Stream Receive"
            print e
            self.stream_in_queue.put(None)
            self.stream_out_queue.put(None)
            self.runFlag = False
            self.stop()

    def get_stream_packet(self, type_, timeout=1):
        start = time.time()
        try:
            while True:
                remaining = timeout - (time.time() - start)
                if remaining < 0:
                    print 'Timeout in get_stream_packet function'
                    break
                msg = self.stream_in_queue.get(timeout=remaining)
                print "#### Got message in get_stream_packet:"
                print msg
                if not msg.HasField(type_):
                    continue
                return msg
        except:  # timeout expired
            print 'Break in get_stream_packet'
            pass
        return None