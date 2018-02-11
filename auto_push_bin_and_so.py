#!/usr/bin/env python
import os
import time
import getopt
import sys

#haolong.zhang v0.1 2018.2
def customer_do_something():

    print("config u self here, eg restart mediaserver!")
    #do u code here

out_dir = {'arm64_so':'/system/lib64/', 'arm_so':'/system/lib/',
        'arm_bin':'/system/bin/', 'arm64_bin':'/system/bin/'}

all_file_timestamp = {}

handle_pwd = []

serial_number = 'null'

def handle_pwd_f(l):

    m = l.split(',')
    for s in m:
        if os.path.isdir(s):
            handle_pwd.append(s)
        else:
            print('err args -p')
            Usage()

    if len(handle_pwd) == 0:
        print('err args -p, pls check it')
        Usage()

def find_update_file(sync_tag_dir):

    global all_file_timestamp
    update_file = []
    for root, sub_dirs, files in os.walk(sync_tag_dir):
        for special_file in files:
            t = os.path.join(root, special_file)
            if os.path.isfile(os.path.join(t)):
                strip_file = False
                m = time.localtime(os.stat(t).st_mtime)
                h = float(time.strftime("%Y%m%d%H%M%S", m))
                if t in all_file_timestamp:
                    if all_file_timestamp[t] < h:
                        strip_file = False
                    else:
                        strip_file = True
                    all_file_timestamp[t] = h
                else:
                    strip_file = False
                    temp_d = {t:h}
                    all_file_timestamp.update(temp_d)

                if not strip_file:
                    update_file.append(t)

    return update_file

def get_file_type(may_push_file):

    elf_mode = 'null'
    elf_type = 'null'
    with open(may_push_file, 'rb') as f:
        #get elf bit code
        b = f.read(24).encode('hex')
        if '7f454c460201010000000000000000000300b70001000000' == b:
            elf_mode = 'arm64'
        elif '7f454c460101010000000000000000000300280001000000' == b:
            elf_mode = 'arm'

        if elf_mode != 'null':
            index = may_push_file.rfind('.')
            if index >= 0:
                if may_push_file[index+1:] == 'so':
                    elf_type = 'so'
                else:
                    elf_type = 'bin'
            else:
                elf_type = 'bin'

    file_type = elf_mode + '_' +elf_type
    return file_type

def handle_devices():

    global serial_number
    print('hand devices')
    if serial_number != 'null':
        print('wait devices')
        os.system('adb -s %s wait-for-devices' % (serial_number))
        print('root devices')
        os.system('adb -s %s root' % (serial_number))
        print('remonut devices')
        os.system('adb -s %s wait-for-devices' % (serial_number))
        os.system('adb -s %s remount' % (serial_number))
        os.system('adb -s %s wait-for-devices' % (serial_number))
    else:
        print('wait devices')
        os.system('adb wait-for-devices')
        print('root devices')
        os.system('adb root')
        print('remonut devices')
        os.system('adb wait-for-devices')
        os.system('adb remount')
        os.system('adb wait-for-devices')
    print('handle_devices finish')

def do_loop():

    global out_dir
    if len(handle_pwd) == 0:
        print('err args -p, pls check it')
        Usage()

    while(True):
        handle_devices()
        for t in handle_pwd:
            update_file = find_update_file(t)
            for i in update_file:
                print('now handle file %s' % i)
                file_type = get_file_type(i)
                if file_type in out_dir:
                    if serial_number != 'null':
                        push_args = 'adb -s %s push %s %s' % (serial_number, i, out_dir[file_type])
                    else:
                        push_args = 'adb push %s %s' % (i, out_dir[file_type])
                    print('COMMAND: %s' % push_args)
                    os.system(push_args)
                else:
                    print('Do not suport file type: %s strip it' % file_type)

        customer_do_something()

        print('wait next checking....')

        time.sleep(2)

def Usage():
    print('v1.0')
    print('python %s [hs:p:]' % sys.argv[0])
    print(' -h: show help info')
    print(' -s: device serial number')
    print(' -p: handle pwd_dir')
    print('eg1: python -p clblast_tuner')
    print('eg2: python -s 1a3cfe80 -p clblast_tuner')
    print('eg3: python -s 1a3cfe80 -p clblast_tuner,releaseto_hal')
    exit()

if __name__ == '__main__':

    serial_number
    if 1 >= len(sys.argv):
        print("Err: too few args")
        Usage()

    try:
        optlist, args = getopt.getopt(sys.argv[1:], "hs:p:")
    except getopt.GetoptError:
        print('args err')
        Usage()

    for c, value in optlist:
        if '-h' == c:
            Usage()
        elif '-s' == c:
            serial_number = value
        elif '-p' == c:
            handle_pwd_f(value)

    do_loop()
