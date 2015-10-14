#!system/bin/sh
i=1;
while [ i -gt 0 ];do 
	echo "monitor wifi status";
	echo "=========================================================================================" >> /storage/sdcard1/ifconfig_save.log;
	echo $(date "+%Y-%m-%d %H:%M:%S") >> /storage/sdcard1/ifconfig_save.log;
	busybox ifconfig  wlan0 >> /storage/sdcard1/ifconfig_save.log;
	sleep 3;
done 

