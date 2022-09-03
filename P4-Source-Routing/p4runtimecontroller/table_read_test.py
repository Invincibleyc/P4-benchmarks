from p4 import p4runtime_pb2
from p4runtime_lib import helper, convert
import grpc

def readTableEntries():
    request = p4runtime_pb2.ReadRequest()
    request.device_id = 2
    entity = request.entities.add()
    table_entry = entity.table_entry
    if table_id is not None:
        table_entry.table_id = table_id
    else:
        table_entry.table_id = 0
    if dry_run:
        print "P4 Runtime Read:", request
    else:
        for response in client_stub.Read(request):
            yield response

channel = grpc.insecure_channel("localhost:50052")
client_stub = p4runtime_pb2.P4RuntimeStub(channel)

p4info_helper = helper.P4InfoHelper('/home/ben/p4/tiered/p4src/tiered.p4info')

table_id = None
dry_run = False

for response in readTableEntries():
    for entity in response.entities:
        entry = entity.table_entry
        print entry.table_id

