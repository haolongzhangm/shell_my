#!/usr/bin/env python
#this py will get/put data via ttyUSB*,which need root or $USER in dialout
#group caused by: (ttyUSB crw-rw---- 1 root dialout)
#===============ways B====================================================
#just add $USER into dialout group: sudo adduser $USER dialout

#=========================================================================
#base ver 0.1 by haolong.zhang 2016/08/10

#-------------------------------------------------------------------------
#update v1.0 2016/12/13
#>>>Format char number to 80
#>>>remove env prapre way A
#>>>remove c style ;
#-------------------------------------------------------------------------
#=========================================================================

import os
import glob
import sys
import time

parameter_list = ['withqcn', 'withoutqcn']
sbl_name = 'null'
def Usage():
    print('v1.0')
    print('[sudo] qcom_flash.py withqcn')
    print('[sudo] qcom_flash.py withoutqcn')
    exit()

def check_args():
    if len(sys.argv) != 2:
        print('need only one argv')
        Usage()

    if sys.argv[1] not in parameter_list:
        print('parameter only support:')
        print(parameter_list)
        Usage()

#check the py exec pwd,only check the boot.img and emmc_appsboot.mbn etc
def check_needed_file():
    needed_file_set = ['NON-HLOS.bin', 'boot.img', 'emmc_appsboot.mbn', \
                        'patch0.xml', 'rawprogram_unsparse_without_QCN.xml', \
                        'rawprogram_unsparse.xml']
    file_list =os.listdir('./')
    #print(file_list)
    if set(needed_file_set).issubset(set(file_list)):
        print('check needed file success')
    else:
        print('check needed file failed , pls cd IMAGES_FOR_QMSCT fisrtly')
        exit()

#now we get the SBL file eg : prog_emmc_firehose_*
def find_sbl_name():
    global sbl_name
    for sbl_name in glob.glob("prog_emmc_firehose*"):
        print('sbl file %s' % sbl_name)
    if len(glob.glob("prog_emmc_firehose*")) != 1:
        print("No sbl or so many sbl file find ,check fisrt ,exit now")
        exit()

#download_img
def download_img():
#now we try to get dev/ttyUSB* all USBtty will be list at here
    if len(glob.glob('/dev/ttyUSB*')) ==0:
        print('can not find ttySUB dev, pls set phone into 9008 mode \
                eg : adb reboot edl,exit now')
        exit()
#now try flash SBL , because we have find some devs,
#may just serial dev ,so we need cap the flash result
    for ttyUSB_dev in glob.glob('/dev/ttyUSB*'):
        print('try to flash SBL via %s' % ttyUSB_dev)
        print('check %s access mode' % ttyUSB_dev)
        if False == os.access(ttyUSB_dev, os.R_OK | os.W_OK):
            print('Do not have access to W.R %s' % ttyUSB_dev)
            print('pls use sudo qcom_flash.py or just add $USER into \
                    dialout group: sudo adduser $USER dialout')
            Usage()

        #Formatt exe args;eg spl_qcom_download -p /dev/ttyUSB1 -s
        #13:prog_emmc_firehose_8976_ddr.mbn
        exe_args = 'spl_qcom_download -p  %s  -s 13:%s' % (ttyUSB_dev, sbl_name)
        print(exe_args)
        SBL_flash_result = -1
        #check result 0 means flash sbl ok
        if os.system(exe_args) == 0:
            SBL_flash_result = 0
            print('Flash sbl ok')
            break

    if SBL_flash_result != 0:
        print('Flash sbl err, pls check phone mode,try hard reset phone to 9008')
        exit()

#after flash SBL ,have to sleep a while wait PHONE
    print('sleep 3S')
    time.sleep(3)
#now we try to flash all other img
#Formatt exe args : eg img_qcom_download --port=/dev/ttyUSB1
#--sendxml=patch0.xml --search_path=.
#--sendxml=rawprogram_unsparse_without_QCN.xml --search_path=. --reset
    withoutqcn_exc = 'img_qcom_download --port=%s  --sendxml=patch0.xml \
            --search_path=.  --sendxml=rawprogram_unsparse_without_QCN.xml \
            --search_path=. --reset' % ttyUSB_dev

    withqcn_exc = 'img_qcom_download --port=%s  --sendxml=patch0.xml \
            --search_path=.  --sendxml=rawprogram_unsparse.xml \
            --search_path=. --reset' % ttyUSB_dev

    if sys.argv[1] == parameter_list[0]:
        print('Flash img withqcn')
        if os.system(withqcn_exc) == 0:
            print('Flash other img with qcn ok')
            exit()
        else:
            print('Flash other img with qcn ERR')
            Usage()

    elif sys.argv[1] == parameter_list[1]:
        print('Flash img without qcn')
        if os.system(withoutqcn_exc) == 0:
            print('Flash other img without qcn ok')
            exit()
        else:
            print('Flash other img without qcn ERR')
            Usage()



##python real start here
check_args()
check_needed_file()
find_sbl_name()
download_img()
