#!/bin/bash

ex_time_background=4000
ex_time_bombing=20
L=30
slow_rate=48000 #20 pkt/s
fast_rate=48000 #20 pkt/s

iperf -s &

ping 10.0.0.1 -c 2
ping 10.0.0.2 -c 2
ping 10.0.0.3 -c 2
ping 10.0.0.4 -c 2
ping 10.0.0.5 -c 2

sleep 5

iperf -c 10.0.0.1 -u -b $slow_rate -t $ex_time_background -l $L & # sends 20 packets per second for 1 minute
iperf -c 10.0.0.2 -u -b $slow_rate -t $ex_time_background -l $L &
iperf -c 10.0.0.3 -u -b $slow_rate -t $ex_time_background -l $L &
iperf -c 10.0.0.4 -u -b $slow_rate -t $ex_time_background -l $L &
iperf -c 10.0.0.5 -u -b $slow_rate -t $ex_time_background -l $L &

exit
sleep $ex_time_bombing
echo $(date +%s%N) > ./statistics/consistency/start_of_bombing
iperf -c 10.0.0.1 -u -b $fast_rate -t $ex_time_bombing -l $L & # sends 10 packets per second for 1 minute
iperf -c 10.0.0.2 -u -b $fast_rate -t $ex_time_bombing -l $L &
iperf -c 10.0.0.3 -u -b $fast_rate -t $ex_time_bombing -l $L &
iperf -c 10.0.0.4 -u -b $fast_rate -t $ex_time_bombing -l $L
