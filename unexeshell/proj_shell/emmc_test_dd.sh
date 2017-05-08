#!/system/bin/sh
i=1
max_use=98


function usage_p(){
echo "Usage:"
echo "$0 multithreading_num"
echo "$0 10"
exit 0
}

function check_parm(){
if [ ! $# -eq 1 ]
then
	echo ">>>>>>>>>>>>>>>>>>Need one paramters<<<<<<<<<<<<<<<"
	echo "just show usage"
	usage_p	
	exit 0
fi
expr $1 + 0 &>/dev/null
if [ $? -gt 0 ]
then
	echo "Errr: pls input a number : eg 10"
	usage_p
fi
}

function init_go(){
mkdir -p /data/mmc_test
#rm -rf /data/mmc_test/*
echo "mmc hpi log" >> /data/mmc_hpi_kernel.log
cat /dev/kmsg | grep mmc_interrupt_hpi >> /data/mmc_hpi_kernel.log &
}

function go_write(){
while(($i<=2))
do
	next_name=`cat /proc/sys/kernel/random/uuid`
	echo "threading id = $1"
	echo $next_name
	dd if=/dev/random of=/data/mmc_test/$next_name count=$RANDOM*30
	sleep 1
	sync
	echo "threading id = $1 next time"
	mem_str=`df  | grep mmcblk0p62`
	echo $mem_str
	comp=${mem_str:0-11:4}
	echo $comp
	if [ $comp -gt $max_use ]
	then
		echo "out for mem,rm old file"
		rm -rf /data/mmc_test/*
	fi
done
}


function disable_chagre_768_min(){
echo 0x0a >  /d/smb1360/address
echo 0x20 >  /d/smb1360/data
cat  /d/smb1360/data

}
function multithreading_go(){
	if [ $1 -eq 0 ]
	then
		echo "Err: input a valid number: eg:10"
		usage_p
	fi

	echo "Now time to creat mmc_wirte threading, number = $1"
	for thread_n in $(seq 1 $1)
	do
		echo "#############################"
		echo "thread number $thread_n / $1"
		go_write $thread_n &
	done
}

#########################shell start here
check_parm $@
init_go $@
disable_chagre_768_min $@
multithreading_go $@
