#!/bin/bash

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

NANO_PATH=$THIS_DIR/../tools/nanomsg_client.py

PROJ=${PWD##*/}

ARG1=22222

if [ "$#" -gt 0 ]; then
  ARG1=$1
fi

sudo $NANO_PATH --thrift-port $ARG1
