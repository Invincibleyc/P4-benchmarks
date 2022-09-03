#!/usr/bin/python

# Takes two pcap files, extracts timestamps, and calculates and plots the
# histogram and CDF of the differences between timestamps
#
# Assumption 1 is that file 1 includes timestamps of packets received on the inbound
# switch interface; file 2 includes timestamps of the corresponding packets sent
# out the outbound switch interface.
#
# Assumption 2 is there are at least 1000 samples.  If less, recommend adjusting the
# percentile values in pbins.
#
# DAVID HANCOCK
# University of Utah

import sys
import os
import datetime
import time
import numpy as np
import matplotlib.pyplot as plt
from scapy.all import sniff, IP, TCP
import code

# get run#
if len(sys.argv) < 2:
  print("usage: %s <run #>\n" % sys.argv[0])
  exit()

# construct filenames (1 for eth1, 1 for eth2)
filestart1 = "run" + sys.argv[1] + "-eth1"
filestart2 = "run" + sys.argv[1] + "-eth2"

file1pcap = filestart1 + ".pcap"
file2pcap = filestart2 + ".pcap"

times1 = {}
times2 = {}
diffs = []

# process the two files
packets_eth1 = sniff(offline=file1pcap)
print("%s processed" % file1pcap)
packets_eth2 = sniff(offline=file2pcap)
print("%s processed" % file2pcap)

if len(packets_eth1) < 10000:
  print("WARNING: number of samples in " + file1pcap + "(%d) less than 10000; percentile values may not be appropriate" % len(packets_eth1))
if len(packets_eth2) < 10000:
  print("WARNING: number of samples in " + file2pcap + "(%d) less than 10000; percentile values may not be appropriate" % len(packets_eth2))
if len(packets_eth1) != len(packets_eth2):
  print("WARNING: %s (%d) and %s (%d) do not have the same number of samples" % (file1pcap, len(packets_eth1), file2pcap, len(packets_eth2)))

for pkt in packets_eth1:
  if IP in pkt:
    ip = pkt[IP].src
  else:
    continue
  if TCP in pkt:
    seq = pkt[TCP].seq
  else:
    continue
  times1[(ip, seq)] = pkt.time

for pkt in packets_eth2:
  if IP in pkt:
    ip = pkt[IP].src
  else:
    continue
  if TCP in pkt:
    seq = pkt[TCP].seq
  else:
    continue
  times2[(ip, seq)] = pkt.time

lostpkts = []
# - calculate difference between corresponding timestamps
for key in times1.keys():
  if key not in times2:
    print("Key %s in times1 not found in times2" % str(key))
    lostpkts.append(('in 1 not 2', key, times1[key]))
  else:
    diffs.append( abs(round( (times2[key] - times1[key]) * 1000, 3)) )

for key in times2.keys():
  if key not in times1:
    print("Key %s in times2 not found in times1" % str(key))
    lostpkts.append(('in 2 not 1', key, times1[key]))
code.interact(local=locals())
arr = np.array(diffs)

density, bins = np.histogram(arr, density=True)
unity_density = density / density.sum()
pbins = np.array([0, 50, 90, 99, 99.9, 99.99, 100])
pindices = np.arange(len(pbins))
percentile = np.zeros(len(pbins))
for i in range(len(pbins)):
  percentile[i] = np.percentile(arr, pbins[i])

code.interact(local=locals())

fig, (ax1, ax2, ax3) = plt.subplots(nrows=1, ncols=3, sharex=False, figsize=(12,4))
widths = bins[:-1] - bins[1:]
ax1.bar(bins[1:], unity_density, width=widths)
ax2.bar(bins[1:], unity_density.cumsum(), width = widths)
ax3.plot(pindices, percentile)
ax3.xaxis.set_ticks(pindices)
ax3.xaxis.set_ticklabels(pbins)
ax1.set_xlabel('PDF (ms)')
ax2.set_xlabel('CDF (ms)')
ax3.set_xlabel('Percentiles')
ax3.set_ylabel('milliseconds')
fig.tight_layout()
plt.show()
