#!/bin/bash
#by haolong.zhang@ck-telecom.com

function check_hole_patch(){
echo "Do you open FEATURE_EFS_ENABLE_FACTORY_IMAGE_SECURITY_HOLE to build modem (y\n)"
read char
if [ $char == 'y' ];then
	echo "OK"
else
	echo "Now apply open se hole patch..."
	echo "!!!!!just apply hole patch for 8976..."
	cd ..
	git checkout modem_proc/build/ms/cust8976.gen.prodq.h
	git apply 8956_make_fsg/8956_76_open_se_hole.patch
	git diff modem_proc/build/ms/cust8976.gen.prodq.h
	echo "You need build modem again"
	exit 0
fi
}

function check_fs_image_tar_gz(){
echo "Do you have update fs_image.tar.gz by command:perl efsreadimage.pl -z (y/n)"
read charn
if [ $charn == 'y' ];then
	echo "OK"
else
	echo "exit now..."
	exit 0
fi

echo "rm old fs_image.tar.gz.mbn.img"
if [ -f fs_image.tar.gz.mbn.img ];then
	echo "find fs_image.tar.gz.mbn.img , rm it"
	rm fs_image.tar.gz.mbn.img
else
	echo "can not find old fs_image.tar.gz.mbn.img ,ignor..."
fi
echo "check fs_image.tar.gz file now ..."
if [ -f fs_image.tar.gz ]; then
	echo "file fs_image.tar.gz..."
else
	echo "can not find fs_image.tar.gz file"
	echo "Use command: perl efsreadimage.pl -z to gen file, exit now..."
	exit 0
fi
}

function check_sectools_py(){
echo "old tmp file..."
rm tmp -rf
mkdir tmp
echo "check sectools.py file now..."
if [ -f ../common/sectools/sectools.py ]; then
	echo "find sectools.py ..."
	cd ../common/sectools/
	python sectools.py mbngen -i ../../8956_make_fsg/fs_image.tar.gz -t efs_tar_40 -o ../../8956_make_fsg/tmp/ -g
else
	echo "can not find file sectools.py"
	echo "exit now..."
	exit 0
fi
}

function try_get_fs_image_tar_gz_mbn()
{
echo "try to get fs_image.tar.gz.mbn"
python sectools.py secimage -p 8976 -i ../../8956_make_fsg/tmp/fs_image.tar.gz.mbn -g efs_tar -o ../../8956_make_fsg/tmp/ -sa

echo "try to get fs_image.tar.gz.mbn.img"
cd ../..
cd modem_proc/core/bsp/efs_image_header/tools/

echo "check file efs_image_meta.bin"
if [ -f ../../../../../modem_proc/build/ms/bin/8976.gen.prod/efs_image_meta.bin ];then
	echo "find file efs_image_meta.bin"
else
	echo "can not find file efs_image_meta.bin"
	echo "Err info: pls build modem first"
	exit 0
fi

echo "check file fs_image.tar.gz.mbn"
if [ -f ../../../../../8956_make_fsg/tmp/8976/efs_tar/fs_image.tar.gz.mbn ];then
	echo "find file fs_image.tar.gz.mbn"
else
	echo "gen fs_image.tar.gz.mbn may failed,pls check"
	exit 0
fi
}

function try_get_fs_image_tar_gz_mbn_img(){
echo "Now time to gen fs_image.tar.gz.mbn.img"
cp ../../../../../modem_proc/build/ms/bin/8976.gen.prod/efs_image_meta.bin ./
cp ../../../../../8956_make_fsg/tmp/8976/efs_tar/fs_image.tar.gz.mbn ./
python efs_image_create.py efs_image_meta.bin fs_image.tar.gz.mbn
rm efs_image_meta.bin fs_image.tar.gz.mbn
mv fs_image.tar.gz.mbn.img ../../../../../8956_make_fsg/
cd ../../../../../8956_make_fsg/
echo "#################################################"
echo "####### fs_image.tar.gz.mbn.img #################"
echo "#################################################"
ls -sh -t -l
}

##if you want to add a new proj , pls just update a handle_dir if/fi
function update_fsg_source(){
echo "sync new fsg to soruce code"
echo "please choose the dir to update fsg:"
echo "choose num :eg 1"
echo "or choose proj nam: eg wtr2955_v2_panda01a_s00a_ca"
echo "1 --- wtr2955_v2_panda01a_s00a_ca"
echo "2 --- wtr2965_v2_panda01a_s00a_ca"
read char
echo $char
if [ $char == '1' ] || [ $char == 'wtr2955_v2_panda01a_s00a_ca' ];then
	echo "will update fsg to wtr2955_v2_panda01a_s00a_ca"
	hande_dir=wtr2955_v2_panda01a_s00a_ca
	fsg_name=fsg_panda.img
else if [ $char == '2' ] || [ $char == 'wtr2965_v2_panda01a_s00a_ca' ];then
	echo "will update fsg to wtr2965_v2_panda01a_s00a_ca"
	hande_dir=wtr2965_v2_panda01a_s00a_ca
	fsg_name=fsg_panda.img
else 
	echo "do not define a proj,choose again"
	update_fsg_source $@
fi
fi
echo "check choose dir"
if [ ! -d ../modem_proc/rftarget_tabasco/msm8952/qcn/$hande_dir ]
then
	echo "can not find ../modem_proc/rftarget_tabasco/msm8952/qcn/$hande_dir will creat"
	mkdir -p ../modem_proc/rftarget_tabasco/msm8952/qcn/$hande_dir
fi

if [  -z $fsg_name ]
then
	echo "do not declaration fsg_name, will use defaule name:fs_image.tar.gz.mbn.img"
	fsg_name=fs_image.tar.gz.mbn.img
fi
	cp fs_image.tar.gz.mbn.img ../modem_proc/rftarget_tabasco/msm8952/qcn/$hande_dir/$fsg_name
}

function flash_new_fsg_into_ue(){
echo "Need FLASH new fsg into UE or not?(y\n)"
read char
if [ $char == 'y' ];then
	echo "please plugin usb and powerup UE"
	echo "======================================================="
	echo "wait for device..."
	adb wait-for-device
	adb reboot-bootloader
	fastboot flash modemst1 zero.bin
	echo "======================================================="
	sleep 1
	fastboot flash modemst2 zero.bin
	echo "======================================================="
	sleep 1
	fastboot flash fsg zero.bin
	sleep 1
	fastboot flash fsg fs_image.tar.gz.mbn.img
	echo "======================================================="
	echo "build and upate fsg to source code and sunc to UE ok"
	sleep 1
	fastboot reboot
else
	echo "build and upate fsg to source code ok"
fi
}

######################shell start here
check_hole_patch $@
check_fs_image_tar_gz $@
check_sectools_py $@
try_get_fs_image_tar_gz_mbn $@
try_get_fs_image_tar_gz_mbn_img $@
update_fsg_source $@
flash_new_fsg_into_ue $@
