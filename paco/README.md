# Paco

> This repository is the code that simulates the paco protocol and compares the paco protocol with the openflow protocol. The p4<sub>14</sub> code that implements the paco protocol can be seen in [paco.p4](https://github.com/an15m/paco/blob/master/p4src/paco.p4).
> 
> It total include 3 experiments.
> - [paco simulate experiment](#paco-simulate-experiment)
> - [paco time delay experiment](#paco-time-delay-experiment)
> - [paco compares with openflow experiment](#paco-compares-with-openflow-experiment)
>
> All of the three experiments hava same topology(as the following picture show). 
> But only [paco compares with openflow experiment](#paco-compares-with-openflow-experiment) uses controller.
> 
> ![topology](https://github.com/an15m/paco/blob/master/topology.png)
>
> To run the experiments, you need first install the [Requirements](#requirements)

## Requirements

>  The experimental environment was built on ubuntu14.04

1. download and install bmv2
```
git clone https://github.com/p4lang/behavioral-model.git
cd behavioral-model
git checkout 1.2.0
./install_deps.sh
./autogen.sh
./configure
make
[sudo] make install
```

2. download and install p4c-bm
```
git clone https://github.com/p4lang/p4c-bm.git
cd p4c-bm
git checkout 1.2.0
sudo pip install -r requirements.txt
sudo python setup.py install
```

3. download and install mininet
```
git clone https://github.com/mininet/mininet.git
cd mininet
git checkout 2.2.1
./util/install.sh
```

4. download and install OpenVswitch
```
# get the source code
wget http://openvswitch.org/releases/openvswitch-2.4.0.tar.gz
tar -zxvf openvswitch-2.4.0.tar.gz
cd openvswitch-2.4.0

# Check the existing version and delete it, note that everyone's version may be different
lsmod | grep openvswitch
rmmod openvswitch
find / -name openvswitch.ko –print
rm /lib/modules/*-generic/extra/openvswitch.ko

# build and install ovs
sh boot.sh
./configure --with-linux=/lib/modules/`uname -r`/build
make
make install
make modules_install
/sbin/modprobe openvswitch
mkdir -p /usr/local/etc/openvswitch
ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema  2>/dev/null
ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
                --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
                --private-key=db:Open_vSwitch,SSL,private_key \
                --certificate=db:Open_vSwitch,SSL,certificate \
                --bootstrap-ca-cert=db:Open_vSwitch,SSL,ca_cert \
                --pidfile --detach
ovs-vsctl --no-wait init
ovs-vswitchd --pidfile --detach

# note: every time you want to run ovs you should run the last three commands again. 
# For your convenience, you'd better put them in ovs_start.sh
```

5. install python2 and scapy
```
apt-get install python
pip install scapy
```

## paco simulate experiment

> The first experiment is to simulates the paco protocol. The code is on the `master` branch.

0. Preparations:
   - Change the `BMV2_PATH` and `P4C_BM_PATH` variables in `build.sh` to your own
   - Change the `BMV2_PATH` and `P4C_BM_PATH` variables in `run_demo.sh` to your own
1. run `build.sh` to build p4 code, then open `paco.json` and search `order`, then change it like:
```
"order": [
    "cpu_header",
    "ethernet",
    "paco_head",
    "ipv4"
]
```
2. run `run_demo.sh` start the experimental environment
3. after mininet is started, run `xterm h1 h2` in mininet CLI to start the console for h1 and h2
4. Start the sniffing tool such as wireshark
5. in h2 console, run `receive.py`to receive packets.
6. in h1 console, run `send.py` to send packets. At the same time, the sniffing tool will sniff the packet, and you can analyze whether the packet is transmitted according to the paco protocol.
7. to exit. 
   - exit sniffing tool
   - close the console of h1 and h2
   - exit mininet CLI
   - run `sudo mn -c` to clear mininet

## paco time delay experiment

> this experiment is to test the delay of the link when the switch runs the paco protocol.
> 
> the experiment steps are same to [paco simulate experiment](#paco-simulate-experiment), you can analysis the time delay after run `send.py`

## paco compares with openflow experiment

> This experiment is to compare the link delay of the switch when running the openflow protocol.
> 
> The code is on the `openflow-time-delay` branch.

0. Preparations:
   - Change the `BMV2_PATH` and `P4C_BM_PATH` variables in `build.sh` to your own
   - Change the `BMV2_PATH` and `P4C_BM_PATH` variables in `run_demo.sh` to your own
1. run `build.sh` to build p4 code, then open `paco.json` and search `order`, then change it like:
```
"order": [
    "cpu_header",
    "ethernet",
    "paco_head",
    "ipv4"
]
```
2. run `run_demo.sh` start the experimental environment
3. open a new terminal, run `default_commands.sh` to install default flows.
4. open a new terminal, run `cpu.py` as controller.
5. after mininet is started, run `xterm h1 h2` in mininet CLI to start the console for h1 and h2
6. Start the sniffing tool such as wireshark
7. in h2 console, run `receive.py`to receive packets.
8. in h1 console, run `send.py` to send packets. At the same time, the sniffing tool will sniff the packet, and you can analyze whether the packet is transmitted according to the paco protocol.
9. to exit. 
   - exit sniffing tool
   - close the console of h1 and h2
   - exit `cpu.py`
   - exit mininet CLI
   - run `sudo mn -c` to clear mininet
