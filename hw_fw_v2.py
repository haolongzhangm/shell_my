#!/usr/bin/env python

#add this for update FW by adb & fastboot,replace win bat
#haolong.zhang v0.1 2017,1,8


import os
import glob
import sys
import time
import commands
import datetime

begin_time = datetime.datetime.now()
commands_list = []
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

def parse_windows_bat():
    if os.path.exists('./fm3_fastboot_update_8917.bat'):
        print('find windows bat, now parse it!.........')
    else:
        print('Can not find windows bat, pls cd BIN,then run this script')
        usage()

    tmp_lists = []
    for line in open('./fm3_fastboot_update_8917.bat'):
        #print(line)
        tmp_lists.append(line)

    tmp_lists_next = tmp_lists[:]
    for loop_list_i in tmp_lists:
        if "flash" in loop_list_i:
            print("Find reserve partition")
        else:
            #print("remove it")
            tmp_lists_next.remove(loop_list_i)

    #print(tmp_lists_next)
    for loop_list_i_next in tmp_lists_next:
        #print(loop_list_i_next)
        commands_list.append(loop_list_i_next.replace('%FASTBOOT_CMD%', '').replace('\r\n', ''))

    #print(commands_list)

def go_download_fw():
    err_code = 0

    for flash_string in commands_list:
        #Format fastoot cmd
        fastboot_args = 'fastboot %s' %flash_string
        print '============================================================'
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
        end_time = datetime.datetime.now()
        print(end_time - begin_time)
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
parse_windows_bat()
go_download_fw()
