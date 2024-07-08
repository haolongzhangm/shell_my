#!/bin/sh
set -e

service corplink start
ps -aux | grep corplink

echo "start corplink success"
