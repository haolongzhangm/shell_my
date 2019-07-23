#!/bin/bash

# ref: https://help.ubuntu.com/community/SynapticsTouchpad
sleep 5
xinput --set-prop 11 "Synaptics Finger" 100 160 600
echo "use command to check: xinput --watch-props 11"
