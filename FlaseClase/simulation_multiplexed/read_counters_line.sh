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

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

source $THIS_DIR/../env.sh

CLI_PATH=$BMV2_PATH/targets/simple_switch/sswitch_CLI

echo "counter_read sent_counter 0" | $CLI_PATH dummy_switch.json 22222 >> out 1>>out 2>>out
echo "counter_read recv_counter 0" | $CLI_PATH dummy_switch.json 22225 >> out 1>>out 2>>out
echo "counter_read sent_counter 1" | $CLI_PATH dummy_switch.json 22222 >> out 1>>out 2>>out
echo "counter_read recv_counter 1" | $CLI_PATH dummy_switch.json 22225 >> out 1>>out 2>>out
cat out | grep "counter" | cut -d ' ' -f 4 | cut -d '=' -f 2 | cut -d ',' -f 1 | tr '\n' ,
rm out
