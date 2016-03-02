#!/bin/bash
#by haolong.zhang@ck-telecom.com
#func usage
function print_usage(){
echo Usage:
echo "$0 [build_function]" 
echo "eg:"
echo "$0 r_all "
echo "build_function can be:---------"
echo "n_all : first clear old build obj and then build"
echo "r_all : just rebuild proj"
echo "Nothing NONE!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
}

function check_adsp_build(){
echo "check ADSP build:"
echo "Do you have build ADSP or not (y/n)"
read char
if [ $char == 'y' ];then
	echo "you should make sure already build ADSP"
else
	echo "need build ADSP first...."
	echo "Now build ADSP"
	cd adsp_proc/build
	python build.py -c msm8976 -o all
	cd ../..
fi

}
#func check build env
function check_lunch(){
if [ -z $TARGET_PRODUCT ]
then
	echo "Do not get android build env, Help you lunch or not? (y/n)"
read char
if [ $char == 'y' ];then
	echo "check android file..."
	if [ -f LINUX/android/build/envsetup.sh ];then
	cd LINUX/android/
	. build/envsetup.sh
	lunch
	cd ../..
	echo "check env again....."
	if [ -z $TARGET_PRODUCT ]
	then
	check_lunch $@
	fi
	else
		echo "can not find andriod file ,exit now..."
		exit 0
	fi
else
	echo ">>>>>>>>>>>>>>>>>>>lunch android first<<<<<<<<<<<<<<<<<<<<"
	print_usage
	exit 0
fi
fi
}

#func check android alrady build
function check_android_already_build(){
if [ ! -d "$PWD/LINUX/android/out/target/product/$TARGET_PRODUCT" ]
then
	echo ">>>>>>>>>>>>>>>>>>>>build android first<<<<<<<<<<<<<<<<<<<"
	echo "$PWD/LINUX/android/out/target/product/$TARGET_PRODUCT dir not exit"
	print_usage
	exit 0
fi
}
#func check parameter number
#need one paramters, check first
function check_parameter_number(){
if [ ! $# -eq 1 ]
then
	echo ">>>>>>>>>>>>>>>>>>Need one paramters<<<<<<<<<<<<<<<"
	echo "just show usage"
	print_usage
	exit 0
fi
}

#func check fisrt parameter
#check fisrt  parameters should be n_all or r_all
function check_first_parameter(){
if [[ ! $1 == "n_all" && ! $1 == "r_all" ]]
then
echo "first parameter should be n_all or r_all"
echo "just show Usage"
print_usage
exit 0
fi
}

#func check_and_set_proj
function check_and_set_proj()
{
qcom_platform=msm8952_64
proj_sed=$TARGET_PRODUCT
proj_dir=$PWD
}

#func print env
#for debug print 
function print_env(){
echo proj_dir = $proj_dir
echo proj_sed= $proj_sed
echo qcom_platform = $qcom_platform
}
#build func
#really build modem
function build_really(){
echo "=============================================================="
echo "=======================Now build begin========================"
echo proj_dir = $proj_dir
echo proj_sed= $proj_sed
echo qcom_platform = $qcom_platform
echo "=============================================================="
cd $proj_dir/modem_proc/build/ms
pwd

if [ $1 == "n_all" ]
then
	echo "clean old build first, rm old clear_build log"
rm clear_build.log
./build.sh 8976.gen.prod -k -c | tee clear_build.log

if [ ! -f "clear_build.log" ]; then
	echo ">>>>>>>>>>>>can not find clear_build log<<<<<<<<<<"
	exit 0
fi

grep "returned code 0" clear_build.log > /dev/null

if [ $? -eq 0 ]; then
	echo "clear build log ok ,will build later"
else
	echo ">>>>>>>>>>>>clear build log Err , please check err first<<<<<<<<<<<<"
	exit 0
fi

fi

if [[ $1 == "n_all"  ||  $1 == "r_all" ]]
then
echo "rm old build log"
rm build_modem.log
./build.sh 8976.gen.prod -k | tee build_modem.log

if [ ! -f "build_modem.log" ]; then
	echo "can not find build log !!!!!!!!!!!!!!!!!!!!!!"
	exit 0
fi

grep "returned code 0" build_modem.log > /dev/null

if [ $? -eq 0 ]; then
	echo "modem build_ok ,will package later"
else
	echo "modem build err happened, please check err first!!!!!!!!!!!"
	exit 0
fi

cd $proj_dir
git checkout contents.xml
cp contents_8976_64.xml contents.xml
sed s/$qcom_platform/$proj_sed/g -i contents.xml
cd $proj_dir/common/build
python build.py
cd $proj_dir/common/build/bin
echo "=====================second print build result=============="

if [ $1 == "n_all" ]
then
echo "==================clear log result=========================="
grep "returned code" $proj_dir/modem_proc/build/ms/clear_build.log
fi

echo "==================build log result==========================="
grep "returned code" $proj_dir/modem_proc/build/ms/build_modem.log
else 
	print_usage
	exit 0
fi
}


#########################shell start here######################
check_parameter_number $@
check_first_parameter $@
check_lunch $@
check_android_already_build $@
check_and_set_proj $@
print_env $@
check_adsp_build $@
build_really $@

