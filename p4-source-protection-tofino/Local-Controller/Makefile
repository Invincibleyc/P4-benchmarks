all: compile start
	@echo "done"

start:
	./controller.py --loglevel 3 --grpc-port 9091 --device-id 0 --id 1 --logfile logs.txt --prog-name protection --bin-path ../output/pipe/tofino.bin --cxt-path ../output/pipe/context.json --p4info ../output/p4_runtime.p4info.txt --bmv2-json ../output/protection.conf --ports tofino-ports.json --config config.json

compile:
	cd ../ && make compile
		
