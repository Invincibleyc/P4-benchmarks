header_type header_rotor_t {
   fields {
	preamble: 64;
 	shortest_path: 8;
	path_length: 8;
	pkt_v1: 8;
	pkt_v2: 8;
	pkt_v3: 8;
	pkt_v4: 8;
	is_edge: 1;
  }
}

header  header_rotor_t rotorTag;
