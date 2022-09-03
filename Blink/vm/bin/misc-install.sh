#!/usr/bin/env bash

set -xe

#Install mininet

cd $HOME

git clone git://github.com/mininet/mininet mininet
cd mininet
sudo ./util/install.sh -nwv
cd ..

#install tmux

sudo apt-get remove -y tmux
sudo apt-get -y --no-install-recommends install libncurses5-dev libncursesw5-dev

wget https://github.com/tmux/tmux/releases/download/2.6/tmux-2.6.tar.gz
tar -xvf tmux-2.6.tar.gz

cd tmux-2.6
./configure && make
sudo make install
sudo mv /home/vagrant/.tmux.conf ~/
sudo chown p4:p4 /home/p4/.tmux.conf

cd ..

# Install iperf3 (last version)

cd /tmp
sudo apt-get remove iperf3 libiperf0
wget https://iperf.fr/download/ubuntu/libiperf0_3.1.3-1_amd64.deb
wget https://iperf.fr/download/ubuntu/iperf3_3.1.3-1_amd64.deb
sudo dpkg -i libiperf0_3.1.3-1_amd64.deb iperf3_3.1.3-1_amd64.deb
rm libiperf0_3.1.3-1_amd64.deb iperf3_3.1.3-1_amd64.deb

cd $HOME

# Clone the Blink github repo and install some dependencies:

sudo pip install pyshark
sudo pip install numpy
sudo pip install pyyaml
sudo pip install py-radix
sudo pip install sortedcontainers
git clone https://github.com/nsg-ethz/Blink.git /home/p4/Blink/

# Install speedometer
sudo apt-get -y install speedometer
