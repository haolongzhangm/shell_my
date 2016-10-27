#!/bin/bash

function try_to_root_device(){
echo "wait device...."
echo ===================================================================================
adb wait-for-device
echo ===find adb devices=====
adb devices
sleep 1
echo =========try to root now===========================================================
adb shell setprop ro.debuggable 1
echo =========plug out usb and then plugn in===========================================
adb root
echo =========plug out usb and then plugn in===========================================
sleep 1
}

function print_usage(){
echo Usage:
echo "eg:"
echo "$0 shared_lib_name"
}

function check_parameter_number(){
if [ $# -eq 1 ]
then
	echo "Find one paramter..."
	echo "grep so = $1"
else
	echo "ERR:need one paramter..."
	print_usage
	exit 0
fi
}

function get_device_proc_data(){
echo "wait device...."
adb wait-for-device
adb shell " ls -d proc/*/" > /tmp/adb_device_proc_data.log
}

function handle_data(){
n=$(awk 'END{print NR}' /tmp/adb_device_proc_data.log)
for i in `seq $n`
do
	#echo $i
	hande_line=$i
	#echo "hande_line=$hande_line"
	sed -n  "$hande_line""p" /tmp/adb_device_proc_data.log > /tmp/tmp_handle.log
	#sed 's/^M//g' /tmp/tmp_handle.log
	sed -i "s/$(echo -e '\015')//g"  /tmp/tmp_handle.log
	out=`cat -v /tmp/tmp_handle.log`
	out_s=$out"fd"
	echo $out_s
	echo "wait device...."
	adb wait-for-device
	adb shell "ls -l $out_s" > /tmp/tmp_maps.log
	grep $1 /tmp/tmp_maps.log
done
}

##############################shell start here##########
check_parameter_number $@
try_to_root_device $@
get_device_proc_data $@
handle_data $@

