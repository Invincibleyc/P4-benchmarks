#!/bin/bash

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $THIS_DIR/../env.sh

PROJ=${PWD##*/}

CLI_PATH=$BMV2_PATH/targets/simple_switch/sswitch_CLI

$CLI_PATH $THIS_DIR/hp4.json $1
