#!/bin/bash
fastboot flash devcfg       devcfg.mbn
fastboot flash devcfgbak    devcfg.mbn
rm devcfg.mbn

fastboot flash dsp          adspso.bin
rm adspso.bin

fastboot flash cmnlib64     mnlib64.mbn
fastboot flash cmnlib64bak  cmnlib64.mbn
rm cmnlib64.mbn

fastboot flash cmnlibbak    cmnlib.mbn
fastboot flash cmnlib       cmnlib.mbn
rm cmnlib.mbn

fastboot flash aboot        emmc_appsboot.mbn
fastboot flash abootbak     emmc_appsboot.mbn
rm emmc_appsboot.mbn

fastboot flash keymasterbak keymaster.mbn
fastboot flash keymaster    keymaster.mbn
rm keymaster.mbn

fastboot flash mdtp         mdtp.img 
rm mdtp.img

fastboot flash modem        NON-HLOS.bin 
rm NON-HLOS.bin

fastboot flash persist      persist_1.img
rm persist_1.img

fastboot flash rpm          rpm.mbn
fastboot flash rpmbak       rpm.mbn
rm rpm.mbn

fastboot flash sbl1         sbl1.mbn
fastboot flash sbl1bak      sbl1.mbn
rm sbl1.mbn

fastboot flash tz           tz.mbn
fastboot flash tzbak        tz.mbn
rm tz.mbn

rm system*.img
rm userdata*.img
rm boot.img

echo "then flash bootimg and system.img"
