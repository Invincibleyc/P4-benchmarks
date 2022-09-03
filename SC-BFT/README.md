# SC-BFT
SC-BFT is a switch-centric byzantine fault tolerant (SC-BFT) mechanism, in which key BFT functions (e.g., message authentication and comparison) are implemented at the programmable switches to accelerate the consensus procedure among controllers and mitigate the communication overhead.

Note that this is the preliminary prototype of SC-BFT implementation for measuring its response time.

## For measuring response time
1. Run the program: 
```
    ._path/run_[consensus].sh
```
  For measuring response time, we give five files (run_paxos.sh, run_pbft.sh, run_pbft_spine.sh, run_sc-bft.sh, run_pbft_spine.sh) in /tools
  
  You should change PYTHONPATH and CLI in the shell file according to the location of the [consensus]\_topo.py and your BMv2 path.

2. Populate table for measuring response time:
```
    ._path/[consensus]command.sh
```
 Through enter the command above, the tables of each program are configured. 
 
 You should change CLI in the shell file according to your BMv2 path.
 
