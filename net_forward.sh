#!/bin/bash
set -ex

ssh -X -p 3222 -D 1080 -o "ServerAliveInterval 60" -f -N zhlvm@localhost

export http_proxy="socks5://127.0.0.1:1080"
export https_proxy="socks5://127.0.0.1:1080"

curl --socks5 127.0.0.1:1080 http://ifconfig.me

pkill -9 chrome || true
cat ~/.ssh/config
google-chrome --proxy-server="socks5://127.0.0.1:1080"
