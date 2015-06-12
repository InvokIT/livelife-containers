#!/bin/bash
set -e

FDKAAC_VERSION=0.1.4
LIBAV_VERSION=11.3


apt-get -q -y update \
apt-get -q -y build-dep libav-tools

mkdir -p /tmp/install-avconv
trap "rm -rf /tmp/install-avconv" EXIT

cd /tmp/install-avconv

curl -L http://downloads.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-${FDKAAC_VERSION}.tar.gz > fdk-aac.tgz
mkdir fdk-aac && tar xzf fdk-aac.tgz -C fdk-aac --strip 1
cd fdk-aac
./configure
make install

cd ..

curl -L -O ftp://ftp.videolan.org/pub/x264/snapshots/last_stable_x264.tar.bz2
mkdir x264 && tar xjf last_stable_x264.tar.bz2 -C x264 --strip 1
cd x264
./configure --enable-static
make install

cd ..

curl -L https://libav.org/releases/libav-${LIBAV_VERSION}.tar.gz > libav.tar.gz
mkdir libav && tar xzf libav.tar.gz -C libav --strip 1
cd libav
./configure --enable-gpl --enable-nonfree --enable-libfdk-aac --enable-libx264
make install