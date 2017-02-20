#!/usr/bin/env python

#add this for update FW by adb & fastboot,replace win bat
#haolong.zhang v2 2017,2,18


import os
import glob
import sys
import time
import commands
import datetime

begin_time = datetime.datetime.now()
commands_list = []
adb_devices_list = []
fastboot_devices_list = []
def usage():
    print 'v0.1'
    print 'enable adb then connect to pc'
    print 'hw_fw.py'
    exit()

def check_device():
#check adb device fistly
    global fastboot_devices_serial_num
    choose_adb_index = -1
    devices_list_tmp = commands.getoutput('adb devices').split('\n')
    for loop_devices_list in devices_list_tmp:
        adb_devices_list.append(loop_devices_list.replace('\tdevice', '').replace('\toffline', ''))

    #print(adb_devices_list)
    adb_devices_list_len = len(adb_devices_list)
    #2 means have no adb device
    if 2 == adb_devices_list_len:
        print('warning: we do not find adb devices')
        have_no_adb_device = 1
    elif 3 == adb_devices_list_len:
        choose_adb_index = 1
    elif 3 < adb_devices_list_len:
        for index_adb in range(adb_devices_list_len):
            print('index_adb   %d: %s') % (index_adb, adb_devices_list[index_adb])

        while choose_adb_index >= adb_devices_list_len - 1 or choose_adb_index <= 0:
            print('input vaild num 1---%d') % (adb_devices_list_len - 2)
            choose_adb_index = input('Find so many adb devices, choose one:>')

    if 3 <= adb_devices_list_len:
        print('>>>>>>>>>>>Will handle device %s<<<<<<<') % adb_devices_list[choose_adb_index]
        exx_args_reboot_bootloader = 'adb -s %s reboot-bootloader' % adb_devices_list[choose_adb_index]
        print(exx_args_reboot_bootloader)
        result_set_to_fastboot_mode = commands.getoutput(exx_args_reboot_bootloader)
        if 'error: device offline' == result_set_to_fastboot_mode:
            print('#########ERR: pls author the adb on the device########')
            usage()

#check fastboot device
    choose_fastboot_index = -1
    fastboot_devices_list_tmp = commands.getoutput('fastboot devices').split('\n')
    for loop_devices_list_i in fastboot_devices_list_tmp:
        fastboot_devices_list.append(loop_devices_list_i.replace('\tfastboot', ''))

    fastboot_devices_list_len = len(fastboot_devices_list)
    if fastboot_devices_list[0] == '':
        print('#######ERR: do not have fastboot ,pls connect device fistly!')
        usage()

    for index_fastboot in range(fastboot_devices_list_len):
        print('index fastboot  %d: %s') % (index_fastboot + 1, fastboot_devices_list[index_fastboot])
    if fastboot_devices_list_len == 1:
        choose_fastboot_index = 0
    elif fastboot_devices_list_len > 1:
        while choose_fastboot_index > fastboot_devices_list_len or \
                choose_fastboot_index < 1:
            print('input vaild num 1---%d') % fastboot_devices_list_len
            choose_fastboot_index = input('Find so many fastboot devices, choose one:>')

    fastboot_devices_serial_num = fastboot_devices_list[choose_fastboot_index - 1]
    print('>>>>>will handle device %s') % fastboot_devices_serial_num

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
        fastboot_args = 'fastboot -s %s %s' % (fastboot_devices_serial_num, flash_string)
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
parse_windows_bat()
go_download_fw()
