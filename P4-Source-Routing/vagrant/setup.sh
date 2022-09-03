#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive

# Some housekeeping to save digging through scripts in future
# These versions are the ones that were used for
export BM_VERSION="1.11.0-14-gde8f08b"
export P4C_VERSION="f9e5b1abd6ea54cb436b1637eaedfdc155c21a79"
export PI_VERSION="5bad01ba2f778a127cbfdc2dcaabd4a97c73c1f2"

sudo apt-get -y update
sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
sudo apt -y install build-essential cmake libpcre3-dev libavl-dev libev-dev libprotobuf-c-dev protobuf-c-compiler libreadline-dev build-essential ca-certificates cmake git tmux wget vim python-pip sudo curl unzip libreadline-dev g++ git automake libtool libgc-dev bison flex libfl-dev libgmp-dev libboost-dev libboost-iostreams-dev libboost-graph-dev pkg-config python python-scapy python-ipaddr tcpdump cmake lubuntu-desktop

mkdir /home/vagrant/temp
export WD="/home/vagrant/temp"
cd /home/vagrant/temp
git clone https://github.com/CESNET/libyang.git
cd libyang
git checkout v0.14-r1
mkdir build
cd build
cmake ..
make -j8
sudo make install

cd $WD/

git clone https://github.com/sysrepo/sysrepo.git
cd sysrepo
git checkout v0.7.2
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_EXAMPLES=Off -DCALL_TARGET_BINS_DIRECTLY=Off ..
make -j8
sudo make install

cd $WD/
git clone https://github.com/p4lang/behavioral-model
cd behavioral-model
git checkout $BM_VERSION
./install_deps.sh
./autogen.sh
./configure --enable-debugger --with-pdfixed
make -j8
sudo make install
cd $WD/
git clone https://github.com/google/protobuf.git
cd $WD/protobuf/
git checkout tags/v3.2.0
./autogen.sh
./configure
make -j8
sudo make install
sudo ldconfig
cd $WD/
git clone https://github.com/google/grpc.git
cd $WD/grpc/
git checkout tags/v1.3.2
git submodule update --init --recursive
make -j8
sudo make install
sudo ldconfig

cd $WD/
git clone https://github.com/p4lang/PI
cd $WD/PI
git submodule update --init --recursive
git checkout $PI_VERSION
#read -p "Press Enter to continue" </dev/tty
./autogen.sh
./configure --with-bmv2 --with-proto --with-cli #--with-sysrepo
make -j8
sudo make install
# cp -r proto/py_out/* /usr/lib/python2.7/
cd $WD/behavioral-model
./install_deps.sh
./autogen.sh
./configure --with-pi --with-pdfixed
make -j8
sudo make install
cd $WD/behavioral-model/targets/simple_switch_grpc
sudo ldconfig
./autogen.sh
./configure --with-thrift --enable-debugger
make -j8
sudo make install
sudo ldconfig
cd $WD/
git clone --recursive https://github.com/p4lang/p4c
cd $WD/p4c
git checkout $P4C_VERSION
mkdir build
cd build
cmake ..
make -j8
sudo make install

echo "P4 set up and install done"

echo "Installing pip dependencies"
pip install pexpect zmq libtmux iproute2 grpcio protobuf
cd ~

git clone https://github.com/BenRLewis/P4-Source-Routing
echo "Repo cloned, see README.md for further info"
cd P4-Source-routing/
p4c-bm2-ss --std p4-14 p4src/tiered.p4 -o p4src/tiered.json --p4runtime-file p4src/tiered.p4info --p4runtime-format text
