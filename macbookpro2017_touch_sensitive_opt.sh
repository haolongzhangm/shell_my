#!/bin/bash

# ref: https://help.ubuntu.com/community/SynapticsTouchpad
# ref: https://askubuntu.com/questions/483707/14-04-touchpad-is-too-sensitive
xinput --set-prop 11 "Synaptics Finger" 100 160 600
sleep 2
xinput --set-prop 11 "Synaptics Noise Cancellation" 200 200
echo "use command to check: xinput --watch-props 11"
