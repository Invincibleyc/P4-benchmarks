#!/bin/bash

echo 5; sleep 1; echo 4; sleep 1; echo 3; sleep 1; echo 2; sleep 1; echo 1; sleep 1
iperf -c 10.3.0.105 -t 70
