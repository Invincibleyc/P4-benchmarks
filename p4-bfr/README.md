# P4 Bit Forwarding Router (p4-bfr)

This repository will contain the source code for a BFR implementation in P4
that supports:

- IP multicast
- BIER multicast
- BIER-TE multicast
- BIER-TE Fast Reroute (FRR)

# Compilation of P4 code

The executable file p4c-bmv2 must be in the path.  See
https://github.com/p4lang for installation of p4.

    p4c-bmv2 --json sdn-bfr.json sdn-bfr.p4

# Starting a P4 Bit Forwarding Router

The simple switch target 'simple_switch' and the 'simple_switch_CLI' should be in the PATH.
P4 can be installed using the git repository: https://github.com/p4lang

  simple_switch <interfaces> <other-options> sdn-bfr.json

Example call for a switch that uses the interfaces s1h1, s1s2, s1s3, and provides various logging stuff

  simple_switch -i 1@s1h1 -i 2@s1s2 -i 3@s1s3 --nanolog ipc:///tmp/bm-1-log.ipc --device-id 1 sdn-bfr.json --log-file /tmp/p4s.s1.log --log-flush --log-level trace

# Configuration

Each switch will have a required set of actions executed on them.  We prepared
them in commands.txt.  The can be installed with

  cat commands.txt | simple_switch_CLI --thrift-ip <ip-address of switch> --thrift-port <thrift-port>

Other tables must be filled depending on the network topology and bit
assignments for BIER and BIER-TE.  Information about BIER and BIER-TE tables
can be found in the IETF drafts

- https://datatracker.ietf.org/doc/draft-ietf-bier-architecture/
- https://datatracker.ietf.org/doc/draft-eckert-bier-te-arch/
- https://datatracker.ietf.org/doc/draft-eckert-bier-te-frr/

Details for the contents of the P4 tables are found in the source code (e.g.,
bier.p4, bier-te.p4).

Multicast features provided by the p4-switch can be found using the
simple_switch_CLI or in the P4-tutorials.
