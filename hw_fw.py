#!/usr/bin/env python

#add this for update FW by adb & fastboot,replace win bat
#zhanghaolong v2 2017,2,18
#zhanghaolong v2.1 2017.2.18 #<<< support multithread
#zhanghaolong v3.0 2017.2.22 #<<< compat for windows and linux env
#zhanghaolong v3.0 2017.2.23 #<<< add more platform

import os
import glob
import sys
import time
import datetime
import threading
import copy
import platform

begin_time = datetime.datetime.now()
commands_list = []
adb_devices_list = []
adb_devices_list_tmp = []
fastboot_devices_list = []
result_task_dict = dict()
def usage():
    print('v3.0')
    print('enable adb then connect to pc')
    print('hw_fw.py')
    print('Env prepare:')
    print('Linux   os: put this python to env,eg /bin')
    print('Windows os: install python fisrtly, then put this python srcipt in FW root dir')
    if platform.system() == 'Windows':
        os.system('cmd')
    exit()

def check_device():
#check adb device fistly
    #global fastboot_devices_serial_num
    choose_adb_index = -1
    adb_already_choose_all_device = 0
    #devices_list_tmp = commands.getoutput('adb devices').split('\n')
    devices_list_tmp = os.popen('adb devices').read().split('\n')
    for loop_devices_list in devices_list_tmp:
        adb_devices_list_tmp.append(loop_devices_list.replace('\tdevice', '').replace('\toffline', '').replace('\tunauthorized', ''))

    for i_node in range(len(adb_devices_list_tmp)):
        #remove print info from adb
        if adb_devices_list_tmp[i_node].find('daemon') < 0:
            adb_devices_list.append(adb_devices_list_tmp[i_node])

    #print(adb_devices_list)
    adb_devices_list_len = len(adb_devices_list) - 1
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
            print('input vaild num 1---%d (input 100 to flash all devices)') % (adb_devices_list_len - 2)
            choose_adb_index = input('Find so many adb devices, choose one:>')
            if 100 == choose_adb_index:
                break

    if 100 == choose_adb_index:
        all_result_set_to_fastboot_mode_err = 0
        print('Warning: will flash all adb devices, fistly reboot-bootloader')
        adb_already_choose_all_device = 1
        for all_index_all in range(adb_devices_list_len):
            if all_index_all > 0 and all_index_all < adb_devices_list_len - 1:
                all_exx_args_reboot_bootloader = 'adb -s %s reboot-bootloader 2>&1' % adb_devices_list[all_index_all]
                print(all_exx_args_reboot_bootloader)
                #all_result_set_to_fastboot_mode = commands.getoutput(all_exx_args_reboot_bootloader)
                all_result_set_to_fastboot_mode = os.popen(all_exx_args_reboot_bootloader).read()
                if all_result_set_to_fastboot_mode.find('error:') >= 0:
                    all_result_set_to_fastboot_mode_err = 1
                    adb_already_choose_all_device = 0

        if all_result_set_to_fastboot_mode_err == 1:
            print('########ERR: pls authenticate ALL adb perssion, then run again')
            usage()
        else:
            print('need wait 4S for device')
            time.sleep(4)

    elif 3 <= adb_devices_list_len:
        print('>>>>>>>>>>>Will handle device %s<<<<<<<') % adb_devices_list[choose_adb_index]
        exx_args_reboot_bootloader = 'adb -s %s reboot-bootloader 2>&1 ' % adb_devices_list[choose_adb_index]
        print(exx_args_reboot_bootloader)
        #result_set_to_fastboot_mode = commands.getoutput(exx_args_reboot_bootloader)
        result_set_to_fastboot_mode = os.popen(exx_args_reboot_bootloader).read()
        if result_set_to_fastboot_mode.find('error:') >= 0:
            print('#########ERR: may need authenticate the adb on the device or kill adb service########')
            usage()
        else:
            print('need wait 4S for device')
            time.sleep(4)

#check fastboot device
    choose_fastboot_index = -1
    #fastboot_devices_list_tmp = commands.getoutput('fastboot devices').split('\n')
    fastboot_devices_list_tmp = os.popen('fastboot devices').read().split('\n')
    for loop_devices_list_i in fastboot_devices_list_tmp:
        fastboot_devices_list.append(loop_devices_list_i.replace('\tfastboot', ''))

    fastboot_devices_list_len = len(fastboot_devices_list) - 1
    if fastboot_devices_list[0] == '':
        print('#######ERR: do not have fastboot devices,pls connect device fistly!')
        usage()

    print('Now check fastboot devices:')
    for index_fastboot in range(fastboot_devices_list_len):
        print('index fastboot  %d: %s') % (index_fastboot + 1, fastboot_devices_list[index_fastboot])
    if fastboot_devices_list_len == 1:
        choose_fastboot_index = 1
    elif fastboot_devices_list_len > 1 and adb_already_choose_all_device == 0:
        while choose_fastboot_index > fastboot_devices_list_len or \
                choose_fastboot_index < 1:
            print('input vaild num 1---%d(choose 100 meaning flash all devices)') % fastboot_devices_list_len
            choose_fastboot_index = input('Find so many fastboot devices, choose one:>')
            if 100 == choose_fastboot_index:
                print('Warning:User choose flash all devices')
                break

    if (fastboot_devices_list_len > 1 and adb_already_choose_all_device == 1) \
            or choose_fastboot_index == 100:
        print('Now handle fastboot all devices FW via fastboot')
        task_dict = dict()
        fastboot_task = []
        global result_task_dict
        for thread_index_fastboot_result in range(fastboot_devices_list_len):
            result_task_dict[fastboot_devices_list[thread_index_fastboot_result]] = 0

        for thread_index_fastboot in range(fastboot_devices_list_len):
            #print('thread index fastboot  %d: %s') % (thread_index_fastboot + 1, fastboot_devices_list[thread_index_fastboot])
            task_dict[fastboot_devices_list[thread_index_fastboot]] = \
                    threading.Thread(target = go_download_fw, args = (fastboot_devices_list[thread_index_fastboot], )) 
            task_dict[fastboot_devices_list[thread_index_fastboot]].start()
            fastboot_task.append(task_dict[fastboot_devices_list[thread_index_fastboot]])
        for task_i in fastboot_task:
            task_i.join()

        print('\n\n\n\n\n\n\n\n')
        print('>>>>>Devices ALL flash result:<<<<<')
        print('Serial ID               Result')
        for key in result_task_dict:
            if result_task_dict[key] == 0:
                print('%s        %s' % (key, 'Failed'))
            elif result_task_dict[key] > 0:
                print('%s        Success flash img num %s' % (key, result_task_dict[key]))

    else:
        fastboot_devices_serial_num = fastboot_devices_list[choose_fastboot_index - 1]
        print('>>>>>will handle device %s') % fastboot_devices_serial_num
        go_download_fw(fastboot_devices_serial_num)

    if platform.system() == 'Windows':
        os.system('cmd')

#   time.sleep(3)

def parse_windows_bat():

    bat_list = glob.glob('*.bat')
    len_bat_list = len(bat_list)
    choose_bat_index = -1
    if len_bat_list == 1:
        print('find windows bat %s, now parse it!.........') % bat_list[0]
        choose_bat_index = 0
    elif len_bat_list > 1:
        print('find so many bat, pls choose one:')
        for index_bat in range(len_bat_list):
            print('index_bat  %d  %s') % (index_bat + 1, bat_list[index_bat])

        while choose_bat_index <= 0 or choose_bat_index > len_bat_list:
            print('input vaild num 1---%d>>>') % len_bat_list
            choose_bat_index = input('find so many bat, pls choose one:')

        choose_bat_index = choose_bat_index - 1

    else:
        print('Err: Can not find windows bat, pls cd BIN,then run this script')
        usage()

    print('choose bat %s') % bat_list[choose_bat_index]

    tmp_lists = []
    for line in open(bat_list[choose_bat_index]):
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

def go_download_fw(str):
    flash_img_num = 0

#for debug
#    result_task_dict[str] = flash_img_num
#    return
#end for debug
    for flash_string in commands_list:
        #Format fastoot cmd
        fastboot_args = 'fastboot -s %s %s' % (str, flash_string)
        print('==========================================================================')
        print('Handle----' + fastboot_args)

        #now do flash
        if 0 == os.system(fastboot_args):
            flash_img_num = flash_img_num + 1
            print('>>>>>result = ok, img number %d / %d') % (flash_img_num, len(commands_list))
            print('\r\n')
        else:
            print('>>>>>result = failed')
            flash_img_num = 0
            break

    if 0 < flash_img_num:
        print('========================================')
        print('                @@@   @@@  @@')
        print('               @@ @@   @@  @@')
        print('              @@   @@  @@ @@')
        print('              @@   @@  @@ @@')
        print('              @@   @@  @@@@')
        print('              @@   @@  @@ @@')
        print('              @@   @@  @@ @@')
        print('               @@ @@   @@  @@')
        print('                @@@   @@@  @@')
        print('========================================')
        fastboot_reboot_args = 'fastboot -s %s reboot' % str
        print(fastboot_reboot_args)
        os.system(fastboot_reboot_args)
        end_time = datetime.datetime.now()
        print('Use time:')
        print(end_time - begin_time)
    else:
        print('========================================')
        print('      @@@@@@@   @@     @@@@   @@@@')
        print('       @@  @@  @@@@     @@     @@')
        print('       @@   @ @@  @@    @@     @@')
        print('       @@     @@  @@    @@     @@')
        print('       @@  @  @@  @@    @@     @@')
        print('       @@@@@  @@  @@    @@     @@')
        print('       @@  @  @@@@@@    @@     @@   @')
        print('       @@     @@  @@    @@     @@  @@')
        print('       @@     @@  @@    @@     @@  @@')
        print('      @@@@    @@  @@   @@@@   @@@@@@@')
        print('========================================')

    result_task_dict[str] = flash_img_num


#############################################start here!
parse_windows_bat()
check_device()
