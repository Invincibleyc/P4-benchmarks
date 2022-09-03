##########################
BMV2_PATH=~/behavioral-model
P4C_BM_PATH=~/p4c-bm
##########################

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

P4C_BM_SCRIPT=$P4C_BM_PATH/p4c_bm/__main__.py
SWITCH_PATH=$BMV2_PATH/targets/simple_switch/simple_switch
CLI_PATH=$BMV2_PATH/targets/simple_switch/sswitch_CLI

$P4C_BM_SCRIPT bft_switch.p4 --json bft_switch.json
$P4C_BM_SCRIPT bft_server.p4 --json bft_server.json
$P4C_BM_SCRIPT bft_client.p4 --json bft_client.json
$P4C_BM_SCRIPT l2switch.p4 --json switch.json

sudo PYTHONPATH=$PYTHONPATH:$BMV2_PATH/mininet/ python ~/myp4/scbft_topo.py \
    --behavioral-exe $BMV2_PATH/targets/simple_switch/simple_switch \
    --bftswitch bft_switch.json \
    --server bft_server.json \
    --client bft_client.json \
    --switch switch.json \
    --cli $CLI_PATH 