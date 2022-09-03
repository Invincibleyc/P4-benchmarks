##########################
BMV2_PATH=~/behavioral-model
P4C_BM_PATH=~/p4c-bm
##########################

THIS_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

P4C_BM_SCRIPT=$P4C_BM_PATH/p4c_bm/__main__.py
SWITCH_PATH=$BMV2_PATH/targets/simple_switch/simple_switch
CLI_PATH=$BMV2_PATH/targets/simple_switch/sswitch_CLI

$P4C_BM_SCRIPT coordinator_s.p4 --json paxos_coordinator.json
$P4C_BM_SCRIPT acceptor_s.p4 --json paxos_acceptor.json
$P4C_BM_SCRIPT pal_s.p4 --json paxos_learner.json
$P4C_BM_SCRIPT client.p4 --json paxos_client.json

sudo PYTHONPATH=$PYTHONPATH:$BMV2_PATH/mininet/ python ~/myp4/p4xos_topo.py \
    --behavioral-exe $BMV2_PATH/targets/simple_switch/simple_switch \
    --acceptor paxos_acceptor.json \
    --coordinator paxos_coordinator.json \
    --pandl paxos_learner.json \
    --client paxos_client.json \
    --cli $CLI_PATH 