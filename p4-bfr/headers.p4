/* headers.p4 -*- c -*-
 *
 *  Copyright 2017 Wolfgang Braun, Joshua Hartmann
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Ethernet defintion from P4 tutorial
header_type ethernet_t {
  fields {
    dstAddr : 48;
    srcAddr : 48;
    etherType : 16;
  }
}

// IPv4 defintion from P4 tutorial
header_type ipv4_t {
  fields {
    version : 4;
    ihl : 4;
    diffserv : 8;
    totalLen : 16;
    identification : 16;
    flags : 3;
    fragOffset : 13;
    ttl : 8;
    protocol : 8;
    hdrChecksum : 16;
    srcAddr : 32;
    dstAddr : 32;
  }
}

// IPv4 checksum definition from P4 tutorial
field_list ipv4_checksum_list {
  ipv4.version;
  ipv4.ihl;
  ipv4.diffserv;
  ipv4.totalLen;
  ipv4.identification;
  ipv4.flags;
  ipv4.fragOffset;
  ipv4.ttl;
  ipv4.protocol;
  ipv4.srcAddr;
  ipv4.dstAddr;
}

field_list_calculation ipv4_checksum {
  input {
    ipv4_checksum_list;
  }
  algorithm : csum16;
  output_width : 16;
}

calculated_field ipv4.hdrChecksum  {
  verify ipv4_checksum;
  update ipv4_checksum;
}

/*
 * Definition of intrinsic metadata specific to the software switch.  If this
 * is missing, we cannot access the multicast specific information in this P4
 * program.
 */
header_type intrinsic_metadata_t {
  fields {
    ingress_global_timestamp : 48;
    lf_field_list : 8;
    mcast_grp : 16;
    egress_rid : 16;
    resubmit_flag : 8;
    recirculate_flag : 8;
  }
}

metadata intrinsic_metadata_t intrinsic_metadata;

/***************************************************************************
 *                          BIER Section                                   *
 ***************************************************************************/

// Static Bit String Length (BSL) for the BIER header
#define BSL 64

/*
 * BIER header based on the BIER MPLS encap draft:
 * https://datatracker.ietf.org/doc/draft-ietf-bier-mpls-encapsulation/
 *
 * We only use `BitString' and `Proto' fields in our implemenation.
 */
header_type bier_t {
  fields {
    first_nibble : 4;
    Ver : 4;
    Len : 4;
    Entropy : 20;
    // The bitstring of the header of length BSL
    BitString : BSL;
    OAM : 2;
    Reserved : 10;
    // Either BIER_PROTO_IPV4 or BIER_PROTO_BIER
    Proto : 4;
    BFIR_id : 16;
  }
}

// Metadata definition (local variables) for BIER forwarding
header_type bier_metadata_t {
  fields {
    // A bitstring/bitmask used in forwarding
    bs : BSL;
    // Recirculation flag (used by BIER and BIER-TE) to enforce packet
    // recirculation at the end of the `egress' pipeline.
    recirculate : 1;
  }
}

metadata bier_metadata_t bier_md;

// Metadefintion (local variables) for BIER-TE forwarding
header_type bier_te_metadata_t {
  fields {
    // Stores the failed adjacencies for fast reroute (FRR)
    bfd : BSL;
    // Stores the add-bitmask used for FRR
    add : BSL;
    // Stores a copy of the initial bitstring of BIER-TE packets used in FRR
    // processing.  See `bier_te_bfd' and `bier_te_btaft' for details
    bs : BSL;
  }
}

metadata bier_te_metadata_t bier_te_md;

/*
 * Field lists are used for
 * - clone_ingress_pkt_to_egress(X, <field-list>)
 * - resubmit(<field-list>)
 * - recirculate(<field-list>)
 */

// needed for cloning without keeping specific metadata
field_list empty_list {
  intrinsic_metadata;
  standard_metadata;
}

// Keeps BIER metadata
field_list bier_fields {
  bier_md;
  standard_metadata;
}

// Keeps BIER and BIER-TE metadata
field_list bier_te_fields {
  bier_md;
  bier_te_md;
  standard_metadata;
}
