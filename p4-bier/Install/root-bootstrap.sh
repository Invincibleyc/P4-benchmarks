#!/bin/bash

# Print commands and exit on errors
set -xe

# DEBIAN_FRONTEND=noninteractive sudo add-apt-repository -y ppa:webupd8team/sublime-text-3
# DEBIAN_FRONTEND=noninteractive sudo add-apt-repository -y ppa:webupd8team/atom

apt-get update

KERNEL=$(uname -r)
DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" upgrade
apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  bison \
  build-essential \
  ca-certificates \
  cmake \
  cpp \
  curl \
  flex \
  git \
  libboost-dev \
  libboost-filesystem-dev \
  libboost-iostreams-dev \
  libboost-program-options-dev \
  libboost-system-dev \
  libboost-test-dev \
  libboost-thread-dev \
  libc6-dev \
  libevent-dev \
  libffi-dev \
  libfl-dev \
  libgc-dev \
  libgc1c2 \
  libgflags-dev \
  libgmp-dev \
  libgmp10 \
  libgmpxx4ldbl \
  libjudy-dev \
  libpcap-dev \
  libreadline-dev \
  libssl1.0-dev \
  libtool \
  make \
  pkg-config \
  python \
  python-dev \
  python-ipaddr \
  python-pip \
  python-scapy \
  python-setuptools \
  tcpdump \
  unzip \
  vim \
  wget \
  xcscope-el \
  xterm \
  mininet \
  iputils-ping \
  python-tk \
  iproute2
