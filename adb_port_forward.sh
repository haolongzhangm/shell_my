#!/usr/bin/env bash
set -ex

# check two arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <local_port> <local_ip>"
    exit 1
fi

adb devices
adb -d tcpip $1

#sleep 3s
echo "sleep 3s"
sleep 3

adb -d forward tcp:$1 tcp:$1

#do ssh forward
ssh -L $2:$1:127.0.0.1:$1 $USER@$2
