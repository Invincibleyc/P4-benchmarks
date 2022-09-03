header_type a_t {
  fields {
    f1 : 16;
    f2 : 16;
    f3 : 288;
  }
}

header_type c_t {
  fields {
    f1 : 64;
  }
}

header a_t a;
header c_t c;

parser start {
  extract(a);
  return select(a.f1) {
    0x01 : p_b;
    0x02 : p_c;
    default : ingress;
  }
}

parser p_b {
  return select(a.f2) {
    0x01 : p_c;
    default : ingress;
  }
}

parser p_c {
  extract(c);
  return ingress;
}

action _no_op() {
}

table t {
  actions {
    _no_op;
  }
}

control ingress {
  apply(t);
}

/*
Expected compiler results

pcs's:
- 0: pre-start
- 1: start
- 2: start->p_b
- 3: start->p_b->p_c
- 4: start->p_c

HP4 action / table definition reminders:
action set_next_action(next_action, state)
action extract_more(numbytes, state)
tset_parse_control mparams: vdev_ID, pc_state
tset_parse_select_* mparams: vdev_ID, pc_state, <bytes>

Expected parser-related table entries:
tset_parse_control set_next_action :[VDEV ID] 0:[PARSE_SELECT_00_19] 1
tset_parse_control set_next_action :[VDEV ID] 2:[PARSE_SELECT_00_19] 2
tset_parse_control set_next_action :[VDEV ID] 4:[PROCEED] 4
tset_parse_control set_next_action :[VDEV ID] 3:[PROCEED] 3
tset_parse_select_00_19 extract_more :[VDEV ID] 1 [a.f1: 0x01]:320 2
tset_parse_select_00_19 extract_more :[VDEV ID] 1 [a.f1: 0x02]:384 4
tset_parse_select_00_19 set_next_action :[VDEV ID] 1 [a.f1: 0&&&0]:[PROCEED] 1
tset_parse_select_00_19 extract_more :[VDEV ID] 2 [a.f2: 0x01]:384 3
tset_parse_select_00_19 set_next_action :[VDEV ID] 2 [a.f2: 0&&&0]:[PROCEED] 2
*/
