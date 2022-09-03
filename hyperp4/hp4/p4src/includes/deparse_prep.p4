/*
David Hancock
FLUX Research Group
University of Utah
dhancock@cs.utah.edu

HyPer4: A P4 Program to Run Other P4 Programs

deparse_prep.p4: Prepare packet for deparsing
*/

action a_prep_deparse_00_38() {
  modify_field(parse_ctrl.small_packet, 1);
  remove_header(ext_first);
  modify_field(ext[0].data, (extracted.data >> 792) & 0xFF);
  modify_field(ext[1].data, (extracted.data >> 784) & 0xFF);
  modify_field(ext[2].data, (extracted.data >> 776) & 0xFF);
  modify_field(ext[3].data, (extracted.data >> 768) & 0xFF);
  modify_field(ext[4].data, (extracted.data >> 760) & 0xFF);
  modify_field(ext[5].data, (extracted.data >> 752) & 0xFF);
  modify_field(ext[6].data, (extracted.data >> 744) & 0xFF);
  modify_field(ext[7].data, (extracted.data >> 736) & 0xFF);
  modify_field(ext[8].data, (extracted.data >> 728) & 0xFF);
  modify_field(ext[9].data, (extracted.data >> 720) & 0xFF);
  modify_field(ext[10].data, (extracted.data >> 712) & 0xFF);
  modify_field(ext[11].data, (extracted.data >> 704) & 0xFF);
  modify_field(ext[12].data, (extracted.data >> 696) & 0xFF);
  modify_field(ext[13].data, (extracted.data >> 688) & 0xFF);
  modify_field(ext[14].data, (extracted.data >> 680) & 0xFF);
  modify_field(ext[15].data, (extracted.data >> 672) & 0xFF);
  modify_field(ext[16].data, (extracted.data >> 664) & 0xFF);
  modify_field(ext[17].data, (extracted.data >> 656) & 0xFF);
  modify_field(ext[18].data, (extracted.data >> 648) & 0xFF);
  modify_field(ext[19].data, (extracted.data >> 640) & 0xFF);
  modify_field(ext[20].data, (extracted.data >> 632) & 0xFF);
  modify_field(ext[21].data, (extracted.data >> 624) & 0xFF);
  modify_field(ext[22].data, (extracted.data >> 616) & 0xFF);
  modify_field(ext[23].data, (extracted.data >> 608) & 0xFF);
  modify_field(ext[24].data, (extracted.data >> 600) & 0xFF);
  modify_field(ext[25].data, (extracted.data >> 592) & 0xFF);
  modify_field(ext[26].data, (extracted.data >> 584) & 0xFF);
  modify_field(ext[27].data, (extracted.data >> 576) & 0xFF);
  modify_field(ext[28].data, (extracted.data >> 568) & 0xFF);
  modify_field(ext[29].data, (extracted.data >> 560) & 0xFF);
  modify_field(ext[30].data, (extracted.data >> 552) & 0xFF);
  modify_field(ext[31].data, (extracted.data >> 544) & 0xFF);
  modify_field(ext[32].data, (extracted.data >> 536) & 0xFF);
  modify_field(ext[33].data, (extracted.data >> 528) & 0xFF);
  modify_field(ext[34].data, (extracted.data >> 520) & 0xFF);
  modify_field(ext[35].data, (extracted.data >> 512) & 0xFF);
  modify_field(ext[36].data, (extracted.data >> 504) & 0xFF);
  modify_field(ext[37].data, (extracted.data >> 496) & 0xFF);
  modify_field(ext[38].data, (extracted.data >> 488) & 0xFF);
}

table t_prep_deparse_00_38 {
  actions {
    a_prep_deparse_00_38;
  }
}

action a_prep_deparse_SEB() {
  modify_field(ext_first.data, (extracted.data >> 480));
}

table t_prep_deparse_SEB {
  actions {
    a_prep_deparse_SEB;
  }
}

action a_prep_deparse_40_59() {
  modify_field(ext[0].data, (extracted.data >> 472) & 0xFF);
  modify_field(ext[1].data, (extracted.data >> 464) & 0xFF);
  modify_field(ext[2].data, (extracted.data >> 456) & 0xFF);
  modify_field(ext[3].data, (extracted.data >> 448) & 0xFF);
  modify_field(ext[4].data, (extracted.data >> 440) & 0xFF);
  modify_field(ext[5].data, (extracted.data >> 432) & 0xFF);
  modify_field(ext[6].data, (extracted.data >> 424) & 0xFF);
  modify_field(ext[7].data, (extracted.data >> 416) & 0xFF);
  modify_field(ext[8].data, (extracted.data >> 408) & 0xFF);
  modify_field(ext[9].data, (extracted.data >> 400) & 0xFF);
  modify_field(ext[10].data, (extracted.data >> 392) & 0xFF);
  modify_field(ext[11].data, (extracted.data >> 384) & 0xFF);
  modify_field(ext[12].data, (extracted.data >> 376) & 0xFF);
  modify_field(ext[13].data, (extracted.data >> 368) & 0xFF);
  modify_field(ext[14].data, (extracted.data >> 360) & 0xFF);
  modify_field(ext[15].data, (extracted.data >> 352) & 0xFF);
  modify_field(ext[16].data, (extracted.data >> 344) & 0xFF);
  modify_field(ext[17].data, (extracted.data >> 336) & 0xFF);
  modify_field(ext[18].data, (extracted.data >> 328) & 0xFF);
  modify_field(ext[19].data, (extracted.data >> 320) & 0xFF);
}

table t_prep_deparse_40_59 {
  actions {
    a_prep_deparse_40_59;
  }
}

action a_prep_deparse_60_79() {
  modify_field(ext[20].data, (extracted.data >> 312) & 0xFF);
  modify_field(ext[21].data, (extracted.data >> 304) & 0xFF);
  modify_field(ext[22].data, (extracted.data >> 296) & 0xFF);
  modify_field(ext[23].data, (extracted.data >> 288) & 0xFF);
  modify_field(ext[24].data, (extracted.data >> 280) & 0xFF);
  modify_field(ext[25].data, (extracted.data >> 272) & 0xFF);
  modify_field(ext[26].data, (extracted.data >> 264) & 0xFF);
  modify_field(ext[27].data, (extracted.data >> 256) & 0xFF);
  modify_field(ext[28].data, (extracted.data >> 248) & 0xFF);
  modify_field(ext[29].data, (extracted.data >> 240) & 0xFF);
  modify_field(ext[30].data, (extracted.data >> 232) & 0xFF);
  modify_field(ext[31].data, (extracted.data >> 224) & 0xFF);
  modify_field(ext[32].data, (extracted.data >> 216) & 0xFF);
  modify_field(ext[33].data, (extracted.data >> 208) & 0xFF);
  modify_field(ext[34].data, (extracted.data >> 200) & 0xFF);
  modify_field(ext[35].data, (extracted.data >> 192) & 0xFF);
  modify_field(ext[36].data, (extracted.data >> 184) & 0xFF);
  modify_field(ext[37].data, (extracted.data >> 176) & 0xFF);
  modify_field(ext[38].data, (extracted.data >> 168) & 0xFF);
  modify_field(ext[39].data, (extracted.data >> 160) & 0xFF);
}

table t_prep_deparse_60_79 {
  actions {
    a_prep_deparse_60_79;
  }
}

action a_prep_deparse_80_99() {
  modify_field(ext[40].data, (extracted.data >> 152) & 0xFF);
  modify_field(ext[41].data, (extracted.data >> 144) & 0xFF);
  modify_field(ext[42].data, (extracted.data >> 136) & 0xFF);
  modify_field(ext[43].data, (extracted.data >> 128) & 0xFF);
  modify_field(ext[44].data, (extracted.data >> 120) & 0xFF);
  modify_field(ext[45].data, (extracted.data >> 112) & 0xFF);
  modify_field(ext[46].data, (extracted.data >> 104) & 0xFF);
  modify_field(ext[47].data, (extracted.data >> 96) & 0xFF);
  modify_field(ext[48].data, (extracted.data >> 88) & 0xFF);
  modify_field(ext[49].data, (extracted.data >> 80) & 0xFF);
  modify_field(ext[50].data, (extracted.data >> 72) & 0xFF);
  modify_field(ext[51].data, (extracted.data >> 64) & 0xFF);
  modify_field(ext[52].data, (extracted.data >> 56) & 0xFF);
  modify_field(ext[53].data, (extracted.data >> 48) & 0xFF);
  modify_field(ext[54].data, (extracted.data >> 40) & 0xFF);
  modify_field(ext[55].data, (extracted.data >> 32) & 0xFF);
  modify_field(ext[56].data, (extracted.data >> 24) & 0xFF);
  modify_field(ext[57].data, (extracted.data >> 16) & 0xFF);
  modify_field(ext[58].data, (extracted.data >> 8) & 0xFF);
  modify_field(ext[59].data, (extracted.data >> 0) & 0xFF);
}

table t_prep_deparse_80_99 {
  actions {
    a_prep_deparse_80_99;
  }
}
