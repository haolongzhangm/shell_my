#!/bin/bash -e
cd ~/code/bcwc_pcie
git clean -xdf
make -j4
sudo make install
sudo depmod
sudo modprobe facetimehd
lsmod | grep facetime
mplayer tv://
