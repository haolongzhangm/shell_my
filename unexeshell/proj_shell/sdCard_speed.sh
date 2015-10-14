#!/bin/bash
do_test()
{
	echo "*****test-item:$i-k data write"
	time dd if=$INPUTFILE bs=$((1024*$i)) count=$((1048576/$i)) of=$TESTFILE
	echo ""
}

INPUTFILE="/dev/zero"
LOGFILE="/mnt/sdcard/sdcard_speed_test.log"
TESTFILE="/mnt/sdcard2/sdcard_speed_test_1Gb.flie"
TESTTIMES=10000
touch $LOGFILE
pid=$!
echo ""
echo "START-when test is done, console will print <END>"

exec 3>&1
exec &>>$LOGFILE
echo "SdCard speed test start!">$LOGFILE
echo ""
t=1
while(($t<$TESTTIMES))
do
echo ""
echo "TEST time counts:$t"
echo ""
for i in 1 2 4 8 16 32 64 128
{
	do_test
}
t=$(($t+1))
done
echo "SdCard speed test done!"
ret=$?

exec 1>&3 3>&-
echo "END"
kill -15 $pid
exit $ret
