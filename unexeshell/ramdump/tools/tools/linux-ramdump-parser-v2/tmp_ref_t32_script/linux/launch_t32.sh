#!/bin/sh

cd $(dirname $0)
/opt/t32/bin/pc_linux64/t32marm64-qt -c t32_config.t32, t32_startup_script.cmm &
