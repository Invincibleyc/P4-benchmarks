/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

parser.p4: Define various parse functions allowing us to extract a specified
           number of bits from the received packet.
*/

metadata parse_ctrl_t parse_ctrl;
header ext_first_t ext_first;
header ext_t ext[60];

parser start {
  set_metadata(parse_ctrl.next_action, PROCEED);
  return select(parse_ctrl.small_packet) {
    1 : startsmall;
    default : prX;
  }
}

parser startsmall {
  return select(parse_ctrl.numbytes) {
    1 : pr01;
    2 : pr02;
    3 : pr03;
    4 : pr04;
    5 : pr05;
    6 : pr06;
    7 : pr07;
    8 : pr08;
    9 : pr09;
    default : pr10;
  }
}

parser prX {
  extract(ext_first);
  return select(parse_ctrl.numbytes) {
    0 : pr0;
    40 : ingress;
    41 : pr01;
    42 : pr02;
    43 : pr03;
    44 : pr04;
    45 : pr05;
    46 : pr06;
    47 : pr07;
    48 : pr08;
    49 : pr09;
    default : p50;
  }
}

parser pr0 {
  set_metadata(parse_ctrl.numbytes, 40);
  return ingress;
}

parser pr01 {
  extract(ext[next]);
  return ingress;
}

parser pr02 {
  extract(ext[next]);
  extract(ext[next]);
  return ingress;
}

parser pr03 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return ingress;
}

parser pr04 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return ingress;
}

parser pr05 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return ingress;
}

parser pr06 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return ingress;
}

parser pr07 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return ingress;
}

parser pr08 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return ingress;
}

parser pr09 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return ingress;
}

parser pr10 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return select(parse_ctrl.numbytes) {
    10 : ingress;
    11 : pr01;
    12 : pr02;
    13 : pr03;
    14 : pr04;
    15 : pr05;
    16 : pr06;
    17 : pr07;
    18 : pr08;
    19 : pr09;
    default : pr20;
  }
}

parser pr20 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return select(parse_ctrl.numbytes) {
    20 : ingress;
    21 : pr01;
    22 : pr02;
    23 : pr03;
    24 : pr04;
    25 : pr05;
    26 : pr06;
    27 : pr07;
    28 : pr08;
    29 : pr09;
    default : pr30;
  }
}

parser_exception pe_unhandled_select {
  parser_drop;
}

parser pr30 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return select(parse_ctrl.numbytes) {
    30 : ingress;
    31 : pr01;
    32 : pr02;
    33 : pr03;
    34 : pr04;
    35 : pr05;
    36 : pr06;
    37 : pr07;
    38 : pr08;
    39 : pr09;
    default : parse_error pe_unhandled_select;
  }
}

parser p50 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return select(parse_ctrl.numbytes) {
    50 : ingress;
    51 : pr01;
    52 : pr02;
    53 : pr03;
    54 : pr04;
    55 : pr05;
    56 : pr06;
    57 : pr07;
    58 : pr08;
    59 : pr09;
    default : p60;
  }
}

parser p60 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return select(parse_ctrl.numbytes) {
    60 : ingress;
    61 : pr01;
    62 : pr02;
    63 : pr03;
    64 : pr04;
    65 : pr05;
    66 : pr06;
    67 : pr07;
    68 : pr08;
    69 : pr09;
    default : p70;
  }
}

parser p70 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return select(parse_ctrl.numbytes) {
    70 : ingress;
    71 : pr01;
    72 : pr02;
    73 : pr03;
    74 : pr04;
    75 : pr05;
    76 : pr06;
    77 : pr07;
    78 : pr08;
    79 : pr09;
    default : p80;
  }
}

parser p80 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return select(parse_ctrl.numbytes) {
    80 : ingress;
    81 : pr01;
    82 : pr02;
    83 : pr03;
    84 : pr04;
    85 : pr05;
    86 : pr06;
    87 : pr07;
    88 : pr08;
    89 : pr09;
    default : p90;
  }
}

parser p90 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return select(parse_ctrl.numbytes) {
    90 : ingress;
    91 : pr01;
    92 : pr02;
    93 : pr03;
    94 : pr04;
    95 : pr05;
    96 : pr06;
    97 : pr07;
    98 : pr08;
    99 : pr09;
    default : p100;
  }
}

parser p100 {
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  extract(ext[next]);
  return ingress;
}
