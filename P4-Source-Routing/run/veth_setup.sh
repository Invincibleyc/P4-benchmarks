#!/bin/bash
set -e
let NUMSWITCHES=$1-1

for i in $(seq 0 $NUMSWITCHES);
do
    echo "Creating pair" $i
    for j in $(seq 0 3);
    do
        echo sw${i}veth{$j}
        sudo ip link add sw${i}veth${j}a type veth peer name sw${i}veth${j}b
        sudo ip link set dev sw${i}veth${j}a up
        sudo ip link set dev sw${i}veth${j}b up
    done;
done;