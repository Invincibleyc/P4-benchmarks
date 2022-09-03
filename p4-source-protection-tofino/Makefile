all:
	p4c --target tofino --arch tna -o output protection.p4 --p4runtime-files output/p4_runtime.p4info.txt
	sudo $(SDE)/install/bin/bf_switchd --install-dir $(SDE)/install --conf-file $(SDE)/install/share/p4/targets/tofino/skip_p4.conf --skip-p4 --p4rt-server=0.0.0.0:9090

compile:
	git pull origin master
	p4c --target tofino --arch tna -o output protection.p4 --p4runtime-files output/p4_runtime.p4info.txt

start: 
	sudo $(SDE)/install/bin/bf_switchd --install-dir $(SDE)/install --conf-file $(SDE)/install/share/p4/targets/tofino/skip_p4.conf --skip-p4 --p4rt-server=0.0.0.0:9091
