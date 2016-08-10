#!/usr/bin/env python
#this py will get/put data via ttyUSB*,which need root, so you need command : sudo qcom_flash.py
#so you need put qcom_flash.py to /bin /usr/bin , which sudo command can find the env
#may need sudo ln -s /home/zhl/shell_my/qcom_flash.py /bin/qcom_flash.py
#may need sudo ln -s /home/zhl/shell_my/spl_qcom_download /bin/spl_qcom_download
#may need sudo ln -s /home/zhl/shell_my/img_qcom_download /bin/img_qcom_download
#ver 0.1 by haolong.zhang 2016/08/10

import os
import glob
import sys
import time

parameter_list = ['withqcn', 'withoutqcn']
spl_name = 'null'
def Usage():
    print 'sudo qcom_flash.py withqcn'
    print 'sudo qcom_flash.py withoutqcn'
    exit()

def check_args():
    if len(sys.argv) != 2:
        print 'need only one argv'
        Usage()

    if sys.argv[1] not in parameter_list:
        print 'parameter only support:'
        print parameter_list
        Usage()

#we try to check the py exec pwd,only check the boot.img and emmc_appsboot.mbn
def check_boot_emmc_boot_file():
    bootimage_check = r'boot.img'
    emmc_appsboot_check = r'emmc_appsboot.mbn'
    if os.path.exists(bootimage_check):
        print 'find %s' % bootimage_check
    else:
        print 'can not find %s ' % bootimage_check
        print 'you need change dir to ../IMAGES_FOR_QMSCT/'
        print 'exit now'
        exit() 
    if os.path.exists(emmc_appsboot_check):
        print 'find %s' % emmc_appsboot_check
    else:
        print 'can not find %s ' % emmc_appsboot_check
        print 'you need change dir to ../IMAGES_FOR_QMSCT/'
        print 'exit now'
        exit()

#now we get the SPL file eg : prog_emmc_firehose_*
def find_spl_name():
    global spl_name
    for spl_name in glob.glob("prog_emmc_firehose*"):
        print 'spl file %s' % spl_name
    if len(glob.glob("prog_emmc_firehose*")) != 1:
        print "No spl or so many spl file find ,check fisrt ,exit now"
        exit()

#download_img
def download_img():
#now we try to get dev/ttyUSB* all USBtty will be list at here
    if len(glob.glob('/dev/ttyUSB*')) ==0:
        print 'can not find ttySUB dev, pls set phone into 9008 mode eg : adb reboot edl,exit now'
        exit()
#now try flash SPL , because we have find some devs , may just serial dev ,so we need cap the flash result
    for ttyUSB_dev in glob.glob('/dev/ttyUSB*'):
        print 'try to flash SPL via %s' % ttyUSB_dev
        print 'check %s access mode' % ttyUSB_dev
        if False == os.access(ttyUSB_dev, os.R_OK | os.W_OK):
            print 'Do not have access to W.R %s' % ttyUSB_dev
            print 'pls use sudo qcom_flash.py'
            Usage()

        #Formatt exe args;eg spl_qcom_download -p /dev/ttyUSB1 -s  13:prog_emmc_firehose_8976_ddr.mbn
        exe_args = 'spl_qcom_download -p  %s  -s 13:%s' % (ttyUSB_dev, spl_name)
        print exe_args
        SPL_flash_result = -1
        #check result 0 means flash spl ok
        if os.system(exe_args) == 0:
            SPL_flash_result = 0
            print 'Flash spl ok'
            break

    if SPL_flash_result != 0:
        print 'Flash spl err, pls check phone mode,try hard reset phone to 9008'
        exit()

#after flash SPL ,have to sleep a while wait PHONE
    print 'sleep 3S'
    time.sleep(3)
#now we try to flash all other img
#Formatt exe args : eg img_qcom_download --port=/dev/ttyUSB1  --sendxml=patch0.xml --search_path=.  --sendxml=rawprogram_unsparse_without_QCN.xml --search_path=. --reset
    withoutqcn_exc = 'img_qcom_download --port=%s  --sendxml=patch0.xml --search_path=.  --sendxml=rawprogram_unsparse_without_QCN.xml --search_path=. --reset' % ttyUSB_dev
    withqcn_exc = 'img_qcom_download --port=%s  --sendxml=patch0.xml --search_path=.  --sendxml=rawprogram_unsparse.xml  --search_path=. --reset' % ttyUSB_dev

    if sys.argv[1] == parameter_list[0]:
        print 'Flash img withqcn'
        if os.system(withqcn_exc) == 0:
            print 'Flash other img with qcn ok'
            exit()
        else:
            print 'Flash other img with qcn ERR'
            Usage()

    elif sys.argv[1] == parameter_list[1]:
        print 'Flash img without qcn'
        if os.system(withoutqcn_exc) == 0:
            print 'Flash other img without qcn ok'
            exit()
        else:
            print 'Flash other img without qcn ERR'
            Usage()



##python real start here
check_args()
check_boot_emmc_boot_file()
find_spl_name()
download_img()

