# IntSight NetFPGA

IntSight Prototype for NetFPGA-SUME.

## Environment Setup

This repository provides an environment to compile the IntSight P4 program to the NetFPGA SUME platform based on the [P4-NetFPGA-live](https://github.com/NetFPGA/P4-NetFPGA-live) repository. See the following link for documentation for instructions on setting up the environment.

https://github.com/NetFPGA/P4-NetFPGA-public/wiki

## Performance Evaluation

To reproduce our performance evaluation of "Programmable Compute Resources", please follow the instructions in the following wiki up to "Step 10. Compile the bitstream".

https://github.com/NetFPGA/P4-NetFPGA-public/wiki/Workflow-Overview

After these steps, resource usage reports can be generate in the command line using the following commands:

```
open_project hw/project/simple_sume_switch.xpr
open_run impl_1
report_utilization -file <OUTPUT_FILENAME_1>  # Overall report
report_utilization -hierarchical -file <OUTPUT_FILENAME_2>  # Hierachically detailed report
```
