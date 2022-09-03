# HyPer4

[HyPer4][1] is a *portable* and *dynamic* solution for virtualizing the [P4-programmable][2] data plane.

Virtualization can take a single physical data plane and present the illusion of multiple data planes.
Each virtual data plane on a network device can host a different packet processing program, i.e., function.
These functions can be chained together in complex ways for arbitrary [compositions][3].
Or they can be isolated from each other in distinct [network slices][4].
Support for network function composition permits a modular development process, yielding advantages in independent debugging and optimization efforts.
Support for slices permits support for multiple tenants, or mixes of research experiments and production operations, where each slice could involve completely distinct protocol headers and functions.

This repository is for the HyPer4 *persona*, a P4 program capable of emulating other P4 programs.
Practical use of HyPer4 requires the [*controller*][5].  The controller includes a compiler, a linker/loader, a P4 API command interpreter, and a composer.

## Demo branch

If you want to see the version HyPer4 as it was when the [CoNEXT 2016 paper][1] was produced, including working mininet demonstrations with step-by-step instructions, checkout the demo branch.
In the demo branch, all instructions for running the demonstrations are in the README in the top directory.
This branch assumes [bmv2][6] at commit f53451a280b7bb27b5f2b8410ab086122ee77526, and has not been tested extensively on later versions of bmv2.

## Related Work

The [Flowvisor][4] project virtualizes the *control plane* and relies on [OpenFlow][7], which has a fixed data plane (relative to [P4][2]).

[References]: #

[1]: http://dl.acm.org/citation.cfm?id=2999607 "HyPer4: Using P4 to Virtualize the Programmable Data Plane"
[2]: http://arxiv.org/pdf/1312.1719.pdf "P4: Programming Protocol Independent Packet Processors"
[3]: https://www.usenix.org/system/files/conference/nsdi13/nsdi13-final232.pdf "Composing Software Defined Networks"
[4]: http://archive.openflow.org/downloads/technicalreports/openflow-tr-2009-1-flowvisor.pdf "FlowVisor: A Network Virtualization Layer"
[5]: https://gitlab.flux.utah.edu/hp4/hp4-ctrl.git "HyPer4 Controller"
[6]: https://github.com/p4lang/behavioral-model/ "Behavioral Model Repository"
[7]: http://www3.cs.stonybrook.edu/~vyas/teaching/CSE_534/Spring13/papers/OpenFlow.pdf "OpenFlow: Enabling Innovation in Campus Networks"
