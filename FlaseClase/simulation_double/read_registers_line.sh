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

echo "register_read ts_sent_reg 0" | $CLI_PATH dummy_switch.json 22222 >> out_reg 1>>out_reg 2>>out_reg
echo "register_read ts_recv_reg 0" | $CLI_PATH dummy_switch.json 22225 >> out_reg 1>>out_reg 2>>out_reg
cat out_reg | grep "RuntimeCmd: ts" | cut -d ' ' -f 3 | tr '\n' ,
rm out_reg
