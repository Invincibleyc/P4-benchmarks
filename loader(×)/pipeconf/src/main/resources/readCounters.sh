#!/bin/bash

numReplicas=3

local=1
global=1
remote=1

rp1=3
rp2=1
rp3=4

printLocal(){
echo LOCAL
echo S$rp1 $R1
echo S$rp2 $R2
echo S$rp3 $R3
}

printGlobal(){
echo
echo GLOBAL
echo S$rp1 $R11
echo S$rp2 $R22
echo S$rp3 $R33
}

printRemote(){
echo
echo REMOTE
echo S$rp1 "${RR1[*]}"
echo S$rp2 "${RR2[*]}"
echo S$rp3 "${RR3[*]}"
}

while true; do
if [ $local -gt 0 ]; then
registerToRead="localEstimation"
R1=$(echo register_read $registerToRead 0 | simple_switch_CLI --thrift-port $(cat /tmp/bmv2-$rp1-thrift-port) | grep $registerToRead | cut -f 3 -d " ")
R2=$(echo register_read $registerToRead 0 | simple_switch_CLI --thrift-port $(cat /tmp/bmv2-$rp2-thrift-port) | grep $registerToRead | cut -f 3 -d " ")
R3=$(echo register_read $registerToRead 0 | simple_switch_CLI --thrift-port $(cat /tmp/bmv2-$rp3-thrift-port) | grep $registerToRead | cut -f 3 -d " ")
fi

if [ $global -gt 0 ]; then
registerToRead="globalEstimation"
R11=$(echo register_read $registerToRead 0 | simple_switch_CLI --thrift-port $(cat /tmp/bmv2-$rp1-thrift-port) | grep $registerToRead | cut -f 3 -d " ")
R22=$(echo register_read $registerToRead 0 | simple_switch_CLI --thrift-port $(cat /tmp/bmv2-$rp2-thrift-port) | grep $registerToRead | cut -f 3 -d " ")
R33=$(echo register_read $registerToRead 0 | simple_switch_CLI --thrift-port $(cat /tmp/bmv2-$rp3-thrift-port) | grep $registerToRead | cut -f 3 -d " ")
fi

if [ $remote -gt 0 ]; then
registerToRead="remoteEstimation"
for i in $(seq 0 $numReplicas); do
RR1[i]=$(echo register_read $registerToRead $i | simple_switch_CLI --thrift-port $(cat /tmp/bmv2-$rp1-thrift-port) | grep $registerToRead | cut -f 3 -d " ")
RR2[i]=$(echo register_read $registerToRead $i | simple_switch_CLI --thrift-port $(cat /tmp/bmv2-$rp2-thrift-port) | grep $registerToRead | cut -f 3 -d " ")
RR3[i]=$(echo register_read $registerToRead $i | simple_switch_CLI --thrift-port $(cat /tmp/bmv2-$rp3-thrift-port) | grep $registerToRead | cut -f 3 -d " ")
done
fi

clear
if [ $local -gt 0 ]; then
printLocal
fi
if [ $global -gt 0 ]; then
printGlobal
fi
if [ $remote -gt 0 ]; then
printRemote
fi

done
