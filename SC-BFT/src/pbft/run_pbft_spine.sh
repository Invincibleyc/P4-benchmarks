##########################
BMV2_PATH=~/behavioral-model
P4C_BM_PATH=~/p4c-bm
##########################

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

P4C_BM_SCRIPT=$P4C_BM_PATH/p4c_bm/__main__.py
SWITCH_PATH=$BMV2_PATH/targets/simple_switch/simple_switch
CLI_PATH=$BMV2_PATH/targets/simple_switch/sswitch_CLI

$P4C_BM_SCRIPT pbftswitch.p4 --json pbft_switch.json
$P4C_BM_SCRIPT pbftleader.p4 --json pbft_leader.json
$P4C_BM_SCRIPT pbftclient.p4 --json pbft_client.json
$P4C_BM_SCRIPT l2switch.p4 --json switch.json

sudo PYTHONPATH=$PYTHONPATH:$BMV2_PATH/mininet/ python ~/myp4/pbft_topy_spine.py \
    --behavioral-exe $BMV2_PATH/targets/simple_switch/simple_switch \
    --switch switch.json \
    --leader pbft_leader.json \
    --pbftswitch pbft_switch.json \
    --client pbft_client.json \
    --cli $CLI_PATH 