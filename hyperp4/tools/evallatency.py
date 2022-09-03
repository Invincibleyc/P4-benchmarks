#!/usr/bin/python

# Takes two pcap files, extracts timestamps, and calculates the average and
# standard deviation of the differences between timestamps
#
# Assumption is that file 1 includes timestamps of packets received on the inbound
# switch interface; file 2 includes timestamps of the corresponding packets sent
# out the outbound switch interface.
#
# DAVID HANCOCK
# University of Utah

import sys
import os
import datetime
import time
import numpy

filestart = "test"

filepcap = filestart + ".pcap"
filetxt = filestart + ".txt"

# use tcpdump -r to convert .pcap files to .txt
execstr = "tcpdump -r " + filepcap + " > " + filetxt
os.system(execstr)

times1 = []
times2 = []
diffs = []

# process the two files
with open(file1txt, 'r') as f1:
  for line in f1:
    # store the time in an array
    t = datetime.datetime.strptime( line.split()[0], "%H:%M:%S.%f" )
    times1.append( time.mktime(t.timetuple()) + (t.microsecond / 1000000.0) )
    
with open(file2txt, 'r') as f2:
  for line in f2:
    # store the time in an array
    t = datetime.datetime.strptime( line.split()[0], "%H:%M:%S.%f" )
    times2.append( time.mktime(t.timetuple()) + (t.microsecond / 1000000.0) )

# - calculate difference between corresponding timestamps
for t1, t2 in zip(times1, times2):
  diffs.append( round( (t2 - t1) * 1000, 3) )

# - calculate average, stddev and print to stdout
arr = numpy.array(diffs)
#for num in diffs:
#  print(num)
print("avg: %.3fms, std: %.3f, count: %i" % (numpy.mean(arr), numpy.std(arr), int(len(diffs)) ))
