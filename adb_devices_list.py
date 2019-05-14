#!/usr/bin/env python3

import os
import glob
import sys
import socket
import threadpool
import threading

#add more device here
#please add all device with port:5555
LAN_IP_PRE = '10.235.'
LAN_PORT = 5555
#TODO: consider cpu core and fd limits
SCAN_THREADPOOL_SIZE = 128 * 4
scan_find_device = False
config_devices = {
        '10.235.68.92:5555':'sdm660_dangzhiyong',
        '10.235.69.178:5555':'qcom710_liyuzhong',
        '10.235.69.73:5555':'car_8665_android32',
        'all':'try connect/disconnect all device'
        }

action = ['connect', 'disconnect']
old_connect_status = []
scan_result = []
lock = threading.Lock()
count = 0
#remap adb command to adb -P $UID for group user
#detail check /etc/bash.bashrc: alias adb="adb -P `expr $UID \* 10`"
#pytho os.system can not get the alias from /etc/bash.bashrc
adb = ''

def err_print(msg):
    print("ERR: " + msg)
    help()

def check_devices_status(ip_with_port):
    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    #TODO: choose a opt time
    s.settimeout(0.5)
    ip = ip_with_port.split(':')[0]
    port = int(ip_with_port.split(':')[1])
    try:
        s.connect((ip, port))
        s.shutdown(2)
        s.close()
        return "available"
    except:
        s.close()
        return "unavailable"
def devices_status_result_f(key):
    print('| %-20s description: %-20s status: %-13s|' %
            (key, config_devices[key], check_devices_status(key)))

def help():
    print("config devices list:")
    #E5 with 32 core
    print("------------------------------------------------------------------------------")
    data = []
    for key in config_devices:
        if key != 'all':
            data.append(key)
    pool = threadpool.ThreadPool(32)
    requests = threadpool.makeRequests(devices_status_result_f, data)
    [pool.putRequest(req) for req in requests]
    pool.wait()
    print("------------------------------------------------------------------------------")

    print("Usage:")
    print("1: connect/disconnect one device:")
    print("adb_devices_list.py ip:port" + " connect/disconnect")
    print("[sdm660] adb_devices_list 10.235.68.92:5555" + " connect")
    print("")
    print("2: connect/disconnect all config devices:")
    print("adb_devices_list.py all connect")
    print("adb_devices_list.py all disconnect")
    print("")
    print("3: scan LAN available devices [only for 5555 port]")
    print("after get scan result, u may need update device to: config_devices")
    print("adb_devices_list.py lan_scan")
    exit()

def try_get_cpu_info(key):
    cpu_info = 'null'
    old_connect = False
    if key in old_connect_status:
        old_connect = True
    if not old_connect:
        if os.popen('%s connect %s' % (adb, key)).read().find('fail') >= 0:
            #remove offline device before return
            os.system('%s disconnect %s' % (adb, key))
            return cpu_info

    #try get cpu_info now
    os.system('%s -s %s root' % (adb, key))
    cpu_info = os.popen('%s -s %s shell cat /proc/cpuinfo | grep ware' % (adb, key)).read()
    if not old_connect:
        os.system('%s disconnect %s' % (adb, key))
    return cpu_info.replace('\n', '')

def lan_scan_result_f(key):
    global count
    lock.acquire()
    count = count + 1
    lock.release()

    print('----%d%%-----' %  (count / 256.0 / 256.0 * 100), end='\r')
    global scan_find_device
    if 'available' == check_devices_status(key):
        cpu_info = try_get_cpu_info(key)
        if 'null' != cpu_info:
            ret = '| %-20s status: available cpu_info: %s|' % (key, cpu_info)
            lock.acquire()
            scan_result.append(ret)
            lock.release()
            scan_find_device = True

def update_old_connect_status():
    log = os.popen('%s devices' % adb).read().split('\n')
    for i in log:
        if i.find('device') >= 0:
            old_connect_status.append(i.split()[0])
    #for i in old_connect_status:
    #    print(i)

def lan_scan():
    update_old_connect_status()
    data = []
    for a in range(256):
        for b in range(256):
            key = LAN_IP_PRE + str(a) + '.' + str(b) + ':' + str(LAN_PORT)
            data.append(key)
    pool = threadpool.ThreadPool(SCAN_THREADPOOL_SIZE)
    requests = threadpool.makeRequests(lan_scan_result_f, data)
    [pool.putRequest(req) for req in requests]
    pool.wait()

def run():
    if len(sys.argv) == 2 and sys.argv[1] == 'lan_scan':
        print('Warning: will scan LAN %d port,may take some time!' % LAN_PORT)
        print('scan with %d threads' % SCAN_THREADPOOL_SIZE)
        print('scan range: %s0.0 - %s255.255, will take about one minute' % (LAN_IP_PRE, LAN_IP_PRE))
        lan_scan()
        print('----100%-----')
        print("Scan result:")
        if not scan_find_device:
            print('ERR: can not find any device!')
        else:
            print()
            for i in scan_result:
                print(i)
        return

    if len(sys.argv) != 3:
        err_print("need two args")
        help()
    
    '''
    if sys.argv[1] not in config_devices.keys():
        err_print("can not find key: " + sys.argv[1])
    '''

    if sys.argv[2] not in action:
        err_print("error args!")

    if sys.argv[1] != 'all':
        status = check_devices_status(sys.argv[1])
        if status == 'unavailable':
            err_print("input device: %s unavailable, please try devices owner: %s" % (sys.argv[1], config_devices[sys.argv[1]]))
        exec_args = '%s %s %s' % (adb, sys.argv[2], sys.argv[1])
        print(exec_args)
        print("command: " + exec_args)
        os.system(exec_args)
        os.system('%s devices' % adb)
    else:
        if sys.argv[2] == 'connect':
            for key in config_devices:
                if key != 'all':
                    exec_args = '%s %s %s' % (adb, sys.argv[2], key)
                    print("command: " + exec_args)
                    os.system(exec_args)
        else:
            #fast disconnect all devices
            exec_args = '%s %s' % (adb, sys.argv[2])
            os.system(exec_args)
        os.system('%s devices' % adb)

if __name__ == '__main__':
    adb = 'adb -P %s' % (os.getuid()*10)
    run()
