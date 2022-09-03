#!/usr/bin/env bash

sudo ip link | grep -o "sw[0-9]\+veth[0-9]\w[@]" | grep -o "sw[0-9]\+veth[0-9]\w" | xargs -L 1 sudo ip link delete dev