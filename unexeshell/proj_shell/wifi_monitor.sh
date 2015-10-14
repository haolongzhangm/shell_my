#!system/bin/sh
i=1;
while [ i -gt 0 ];do 
	echo "monitor wifi status";
	svc wifi disable ; svc wifi enable;
	echo "next time 5min";
	sleep 300;
done 

