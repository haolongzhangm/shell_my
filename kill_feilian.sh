#!/bin/sh
set -e

service corplink stop
sudo systemctl disable corplink
pkill -9 corplink* || true

ps -aux | grep corplink

echo "kill corplink success"
