#!/bin/bash

# Copyright 2013-present Barefoot Networks, Inc. 
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# set MININET_PATH, BMV2_PATH, P4C_BM_PATH
source $THIS_DIR/../env.sh

PROJ=${PWD##*/}

P4C_BM_SCRIPT=$P4C_BM_PATH/p4c_bm/__main__.py

SWITCH_PATH=$BMV2_PATH/targets/simple_switch/simple_switch

CLI_PATH=$BMV2_PATH/targets/simple_switch/sswitch_CLI

SCENARIO=""
SEED=""
COMMANDS=""
TOPO=""

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    --scenario)
    SCENARIO="--scenario $2"
    shift # past argument
    ;;
    --seed)
    SEED="--seed $2"
    shift # past argument
    ;;
    -c|--commands)
    COMMANDS="$COMMANDS $2"
    shift # past argument
    ;;
    -t|--topo)
    TOPO="--topo $2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done

if [ ! -z "${COMMANDS}" ]; then
  COMMANDS="--commands "$COMMANDS
fi

$P4C_BM_SCRIPT p4src/$PROJ.p4 --json $PROJ.json
sudo PYTHONPATH=$PYTHONPATH:$BMV2_PATH/mininet/ \
    python $MININET_PATH/topo.py \
    --behavioral-exe $SWITCH_PATH \
    --json $PROJ.json \
    $COMMANDS \
    --cli $CLI_PATH \
    $SCENARIO \
    $SEED \
    $TOPO
