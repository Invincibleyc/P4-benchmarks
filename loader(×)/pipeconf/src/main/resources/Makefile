all: mytunnel

mytunnel: lodge.p4
	rm -rf mytunnel.json
	p4c -o mytunnel.json --p4runtime-file mytunnel.p4info --p4runtime-format text lodge.p4
	mv mytunnel.json mytunnel
	mv mytunnel/lodge.json ./mytunnel.json
	mv mytunnel/lodge.p4rt ./mytunnel.p4infotemp
	rm -rf mytunnel
	cat mytunnel.p4infotemp | grep -v "  idle_timeout_behavior: NO_TIMEOUT" > mytunnel.p4info

