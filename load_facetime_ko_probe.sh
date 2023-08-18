#!/bin/bash -e
sudo modprobe facetimehd
mplayer tv://
echo "also can do: echo facetimehd >> /etc/modules to make auto load"
