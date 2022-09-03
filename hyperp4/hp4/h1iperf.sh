#!/bin/bash

echo 5; sleep 1; echo 4; sleep 1; echo 3; sleep 1; echo 2; sleep 1; echo 1; sleep 1
iperf -c 10.1.0.102 -t 70
