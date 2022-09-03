from p4.config import p4info_pb2
import google.protobuf.text_format

p4info = p4info_pb2.P4Info()
p4info_loc = "/home/ben/p4/tiered/p4src/tiered.p4info"
with open(p4info_loc) as p4info_file:
    google.protobuf.text_format.Merge(p4info_file.read(), p4info)
    p4info_file.close()

print p4info