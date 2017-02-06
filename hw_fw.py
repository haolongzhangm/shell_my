#!/usr/bin/env python

#add this for update FW by adb & fastboot,replace win bat
#haolong.zhang v0.1 2017,1,8


import os
import glob
import sys
import time
import commands


def usage():
    print 'v0.1'
    print 'enable adb then connect to pc'
    print 'hw_fw.py'
    exit()

def check_device():
    if 0 < len(commands.getoutput('adb devices | grep -w device')) or 0 < len(commands.getoutput('fastboot devices')):
        print 'Find device'
    else:
        print 'Can not find device'
        usage()

def adb_reboot_bootloader_ignore_result():
#ignore result, because some device may already into fastboot mode
    os.system('adb reboot-bootloader')
#   print 'sleep 3s, wait fastboot devices'
#   time.sleep(3)

def go_download_fw():
    err_code = 0
    handle_img_num = commands.getoutput('grep flash -w fm3_fastboot_update_8917.bat | wc -l')
    if '25' == handle_img_num:
        print 'will handle 25 img'
    else:
        print 'fm3_fastboot_update_8917.bat may update check it firstly'
        print 'new handle_img_num = %s' % handle_img_num
        usage()

    #check flash xml again
    result = os.system('diff fm3_fastboot_update_8917.bat ~/desktop/hw_flash_compare_xml/fm3_fastboot_update_8917.bat')
    print 'result = %s' % result
    if 0 == result:
        print 'check xml ok go ....'
    else:
        print 'check xml failed'
        usage()

    img_d = {'gpt_both0.bin' : 'partition', 'rpm.mbn' : 'rpm', \
            'tz.mbn' : 'tz', 'sbl1.mbn' : 'sbl1', \
            'cmnlib.mbn' : 'cmnlib', 'cmnlib64.mbn' : 'cmnlib64', \
            'devcfg.mbn' : 'devcfg', 'lksecapp.mbn' : 'lksecapp', \
            'keymaster.mbn' : 'keymaster', 'emmc_appsboot.mbn' : 'aboot', \
            'mdtp.img' : 'mdtp', 'cust.img' : 'cust', \
            'NON-HLOS.bin' : 'modem', 'adspso.bin' : 'dsp', \
            'boot.img' : 'boot', 'recovery.img' : 'recovery', \
            'erecovery.img' : 'erecovery', 'cache.img' : 'cache', \
            'system.img' : 'system', 'apdp.mbn' : 'apdp', \
            'msadp.mbn' : 'msadp', 'userdata.img' : 'userdata', \
            'vendor.img' : 'vendor', 'product.img' : 'product', \
            'version.img' : 'version'
            }	
    #check all img exsit or not
    infact_list = os.listdir('./')
    if set(img_d.keys()).issubset(set(infact_list)):
        print 'check file exsit success!'
    else:
        print 'check file failed!, cd img dir fisrtly'
        usage()

    for key, value in img_d.items():
        #Format fastoot cmd
        fastboot_args = 'fastboot flash %s %s' %(value, key)
        print '========================================'
        print 'Handle----' + fastboot_args

        #now do flash
        if 0 == os.system(fastboot_args):
            err_code = err_code + 1
            print '>>>>>result = ok, img number %d' % err_code
            print '\r\n'
        else:
            print '>>>>>result = failed'
            err_code = -1
            break

    if 0 < err_code:
        print '========================================'
        print '                @@@   @@@  @@'
        print '               @@ @@   @@  @@'
        print '              @@   @@  @@ @@'
        print '              @@   @@  @@ @@'
        print '              @@   @@  @@@@'
        print '              @@   @@  @@ @@'
        print '              @@   @@  @@ @@'
        print '               @@ @@   @@  @@'
        print '                @@@   @@@  @@'
        print '========================================'
        os.system('fastboot reboot')
    else:
        print '========================================'
        print '      @@@@@@@   @@     @@@@   @@@@'
        print '       @@  @@  @@@@     @@     @@'
        print '       @@   @ @@  @@    @@     @@'
        print '       @@     @@  @@    @@     @@'
        print '       @@  @  @@  @@    @@     @@'
        print '       @@@@@  @@  @@    @@     @@'
        print '       @@  @  @@@@@@    @@     @@   @'
        print '       @@     @@  @@    @@     @@  @@'
        print '       @@     @@  @@    @@     @@  @@'
        print '      @@@@    @@  @@   @@@@   @@@@@@@'
        print '========================================'




#############################################start here!
check_device()
adb_reboot_bootloader_ignore_result()
go_download_fw()
