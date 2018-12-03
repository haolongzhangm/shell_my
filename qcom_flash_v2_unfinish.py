#!/usr/bin/env python
#this py will get/put data via ttyusb*,which need root or $user in dialout
#group caused by: (ttyusb crw-rw---- 1 root dialout)
#just add $user into dialout group: sudo adduser $user dialout
#=========================================================================
#base ver 0.1 by haolong.zhang 2016/08/10

#update v1.0 2016/12/13
#update v2.0 2017/08/25:support user customize flash xml
#                       support multi device flash


import os
import sys
import time
import platform
import glob

class flasher(object):

    spl_qcom_download_bin_type_d = {'32bit':'spl_qcom_download_32', \
            '64bit':'spl_qcom_download'}

    img_qcom_download_bin_type_d = {'32bit':'img_qcom_download_32', \
            '64bit':'img_qcom_download'}

    host_type = 'default'

    firehose = 'default'

    valid_ttyusb_devices = []

    needed_file_set = {'NON-HLOS.bin', 'boot.img', 'emmc_appsboot.mbn', \
            'patch0.xml'}

    def __init__(self):
        if platform.architecture()[0].find('64') >= 0:
            self.host_type = '64bit'
        elif platform.architecture()[0].find('32') >= 0:
            self.host_type = '32bit'
        if 'default' == self.host_type:
            self.err_print("Host do not support")

        print("HOST TYPE: %s" % self.host_type)

        self.check_needed_file(self)

        self.choose_usb_firehose(self)

        self.choose_flash_xml(self)

    def err_print(self, str):
        print('######################')
        print('#####Err happened#####')
        print('Detail: ' + str)
        print('######################')
        self.Usage()

    @classmethod
    def Usage(cls):
        print('cd FW root dir, then run this script')
        print('---------------------------------------------')
        print('Usage:')
        print('put file: qcom_flash.py spl_qcom_download*')
        print('          img_qcom_download* to env, eg:/usr/bin')
        print('Env: if U use this script fisrtly')
        print('need run command: sudo adduser $user dialout')
        print('then logout/login or reboot pc')
        print('---------------------------------------------')
        exit()

    @staticmethod
    def choose_usb_firehose(self):
        firehose_list = glob.glob('*firehose*')
        len_firehose_list = len(firehose_list)
        choose_firehose_index = -1
        if len_firehose_list == 1:
            print('find firehose %s') % firehose_list[0]
            choose_firehose_index = 0
        elif len_firehose_list > 1:
            print('find so many firehose, pls choose one:')
            for index_firehose in range(len_firehose_list):
                print('index_firehose  %d  %s') % (index_firehose + 1, firehose_list[index_firehose])

            while choose_firehose_index <= 0 or choose_firehose_index > len_firehose_list:
                print('input vaild num 1---%d>>>') % len_firehose_list
                choose_firehose_index = input('find so many firehose, pls choose one:')

            choose_firehose_index = choose_firehose_index - 1

        else:
            self.err_print('Can not find firehose')

        print('choose firehose :%s') % firehose_list[choose_firehose_index]
        self.firehose = firehose_list[choose_firehose_index]
    
    @staticmethod
    def check_needed_file(self):
        file_list = os.listdir('./')
        if self.needed_file_set.issubset(set(file_list)):
            print('check needed file success')
        else:
            self.err_print('check needed file failed, pls cd into FW dir fisrtly')

    @staticmethod
    def choose_flash_xml(self): /////////////////////////////////////////////////////
        xml_list = glob.glob('*.xml')
        len_firehose_list = len(xml_list)
        choose_firehose_index = -1
        if len_firehose_list == 1:
            print('find firehose %s') % firehose_list[0]
            choose_firehose_index = 0
        elif len_firehose_list > 1:
            print('find so many firehose, pls choose:')
            for index_firehose in range(len_firehose_list):
                print('index_firehose  %d  %s') % (index_firehose + 1, firehose_list[index_firehose])

            while choose_firehose_index <= 0 or choose_firehose_index > len_firehose_list:
                print('input vaild num 1---%d>>>') % len_firehose_list
                choose_firehose_index = input('find so many firehose, pls choose one:')

            choose_firehose_index = choose_firehose_index - 1

        else:
            self.err_print('Can not find firehose')

        print('choose firehose :%s') % firehose_list[choose_firehose_index]
        self.firehose = firehose_list[choose_firehose_index]

    def download_firehose_and_append_valid_device(self):
        if len(glob.glob('/dev/ttyUSB*')) == 0:
            self.err_print("can not find ttyUSB dev, please set phone to 9008 eg: adb reboot edl")

        for ttyusb in glob.glob('/dev/ttyUSB*'):
            print("try to flash sbl via %s" % ttyusb)
            print("check %s access mode"% ttyusb)
            if False == os.access(ttyusb, os.R_OK | os.W_OK):
                print("Do not have access to W.R to %s" % ttyusb)
                self.err_print("pls do: sudo adduser $USER dialout ;  logout/login")

            download_firehose_exec = '%s -p  %s  -s 13:%s' % \
                    (self.spl_qcom_download_bin_type_d[self.host_type], ttyusb, self.firehose)
            print(download_firehose_exec)
            if os.system(download_firehose_exec) == 0:
                print("flash firehose to %s ok" % ttyusb)
                self.valid_ttyusb_devices.append(ttyusb)

            if len(self.valid_ttyusb_devices) == 0:
                self.err_print("do not find valid device")

    def download_img(self):
        print("3")

if __name__ == "__main__":

    flasher_object = flasher()

    flasher_object.download_firehose_and_append_valid_device()
    flasher_object.download_img()
