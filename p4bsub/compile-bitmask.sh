

#compile p4 file
[ -e router_compiled.json ] && sudo rm -f router_compiled.json
p4c-bm2-ss srcP4_bitmask-based/router.p4 --std p4-16 -o router_compiled.json
