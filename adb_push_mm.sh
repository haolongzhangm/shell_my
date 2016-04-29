#setp 1 root
#adb setprop ro.debuggable 1
#adb root
#adb wait-for-device
##setp 2 remount
#adb remount

PWD=pwd
echo $PWD
if [ $# -ne 1 ] ;then
	echo $0 filename or log:$#
	exit
fi
if [ -e ./$1 ] ;then
	files=`cat $1 |sed 's/Install.*system/system/g'`
else
	files=`echo $1|sed 's/out.*system/system/g'`
fi
#if [ $# -ge 1 ] ;then
#	files=`echo $1|sed 's/out.*system/system/g'`
#else
#	files=`cat $1 |sed 's/Install.*system/system/g'`
#fi
for f in $files 
do
	echo /$f
	adb push $OUT/$f /$f
done
