#!/usr/bin/python
#coding=utf-8

#v0.1 20180404 zhl

import os
import sys
import time
import platform
import lmdb
import multiprocessing
from multiprocessing import Process, Manager, cpu_count

#config
resize_h = 224
resize_w = 224
shuffle = True
batch_fusion = True
category = {'食物':0, '夜景':1, '人':3, '其他':4}
support_picture = ['.jpg', '.jpeg', '.png', '.bmp', '.JPG']

convert_imageset_command_head = 'export LD_LIBRARY_PATH=./:$LD_LIBRARY_PATH; ./convert_imageset '
valid_txt_tag = 'sub_database.txt'
summary_log_file_head = 'out/summary_log'
#Process pool numbers = cpu_count * process_multiple
process_multiple = 2
#end config

def check_args_and_env():
    if len(sys.argv) != 2 or not os.path.isdir(sys.argv[1]):
        print('ERR:please give the handle path to args:')
        print('eg ./auto_handle.py /home/database')
        exit(-1)

    if platform.system() != 'Linux':
        print('Err:only support env at Linux')
        exit(-1)

    if not os.path.isfile('./convert_imageset'):
        print('Err: can not find file convert_imageset')
        exit(-1)

def get_lmdb_name(t):
    return t.replace('.', '_').replace('/', '_') + '_lmdb'

def check_convert_imageset_command():
    cmd = convert_imageset_command_head + ' 2>&1'
    t = os.popen(cmd).read()
    if t.find('error while loading shared') >= 0:
        print('convert_imageset command env check failed!')
        print('ERR detail:')
        print(t)
        print('possible solution:')
        print('1:read caffe_src/docs/install_apt.md apt-get install')
        print('2:build caffe at u env, then put convert_imageset and libcaffe.so.1.0.0 to here')
        exit(-1)

def get_category_id(m):
    ret = category['其他']
    for i in m:
        try:
            ret = category[i]
            break
        except KeyError:
            continue

    return ret

def update_valid_txt_tag_fn(command):
    need_update_dir = command[0]
    lock = command[1]
    i = command[2]

    pid = os.getpid()
    need_update = False
    lmdb_path_data = i + get_lmdb_name(i) + '/data.mdb'
    if not os.path.isfile(lmdb_path_data):
        need_update = True
    else:
        newer_command = 'find %s -newer %s' % (i, lmdb_path_data)
        #print(newer_command)
        t = os.popen(newer_command).read().split('\n')
        for u in t:
            if len(u) > 0 and u.find('lock.mdb') < 0:
                need_update = True
                break

    #update valid_txt_tag
    if need_update:
        lock.acquire()
        need_update_dir.append(i)
        lock.release()

        split_path = i.split('/')
        category = get_category_id(split_path)
        with open(i+valid_txt_tag, 'w') as tag:
            for t in support_picture:
                find_command = 'find %s -name *"%s"' % (i, t)
                pic_list = os.popen(find_command).read().split('\n')
                for p in pic_list:
                    if len(p) > len(i):
                        line = '%s %d' % (p[len(i):],  category)
                        #print(line)
                        tag.write(line)
                        tag.write('\n')

    print('[update valid_txt_tag at pwd %s ][need_update:%s] Thread ID %d FINISH' % (i, need_update, pid))

def find_handle_subdir():
    global sub_dir
    sub_dir = []
    r_index = len(valid_txt_tag)
    #Use linux find command to speed
    #if database support git, may imp
    #speed version base on git diff
    find_command = 'find %s -name %s' % (sys.argv[1], valid_txt_tag)
    t = os.popen(find_command).read().split('\n')

    for i in t:
        if os.path.isfile(i):
            sub_dir.append(i[0:len(i) - r_index])

    if len(sub_dir) == 0:
        print('ERR: can not find valid_txt_tag file')
        print('may caused by invaild args')
        exit(-1)

    multiprocessing_number = cpu_count() * process_multiple
    print('handle with max %d Process' % multiprocessing_number)
    task_pool = multiprocessing.Pool(processes=multiprocessing_number)
    task_pool_args = []
    manager = Manager()
    lock = manager.Lock()
    need_update_dir = manager.list()
    for i in sub_dir:
        args = (need_update_dir, lock, i)
        task_pool_args.append(args)

    task_pool.map(update_valid_txt_tag_fn, task_pool_args)
    task_pool.close()
    task_pool.join()

    return need_update_dir

def write_log_with_lock(str, file, lock):
    lock.acquire()
    with open(file, 'a') as f:
        f.write(str)
        f.write('\n')
    lock.release()

def write_log(str, file):
    with open(file, 'a') as f:
        f.write(str)
        f.write('\n')

def show_message(per, title):
    t = time.strftime('%Y-%m-%d-%H:%M:%S',time.localtime(time.time()))
    print('[%3d/100][%s][%s]' % (per, t, title))

def update_lmdb_fn(command):
    pid = os.getpid()
    os.system(command[0])
    ret = os.popen(command[1]).read().split('\n')
    lock = command[2]
    total_size = command[3]
    loop = command[4]
    for i in ret:
        if i.find('Could not open or find file') >=0:
            print('Err handle file: %s' % i)
            write_log_with_lock(i, log_file, lock)

    lock.acquire()
    loop['count'] = loop['count'] + 1
    lock.release()
    message = 'update sublmdb Thread ID %d FINISH' % pid
    show_message(float(loop['count'])/total_size*100, message)

def update_subdir_lmdb(d):
    global log_file
    updated_lmdb = []
    if len(d) == 0:
        print('NO update find! skip')
        return False

    multiprocessing_number = cpu_count() * process_multiple
    print('handle with max %d Process' % multiprocessing_number)
    task_pool = multiprocessing.Pool(processes=multiprocessing_number)
    task_pool_args = []
    manager = Manager()
    lock = manager.Lock()
    share_d = manager.dict()
    share_d['count'] = 0
    for t in d:
        print("Now update subdir lmdb %s" % t)
        subdir_lmdb_command_b = '%s --resize_height=%d --resize_width=%d' \
                % (convert_imageset_command_head, resize_h, resize_w)
        if shuffle:
            subdir_lmdb_command_b = subdir_lmdb_command_b + ' --shuffle '

        subdir_lmdb_command_b = subdir_lmdb_command_b + t + ' '
        subdir_lmdb_command_b = subdir_lmdb_command_b + t + valid_txt_tag + ' '
        subdir_lmdb_command_b = subdir_lmdb_command_b + t + get_lmdb_name(t) + ' '
        subdir_lmdb_command_b = subdir_lmdb_command_b + '2>&1' + ' '
        #print(subdir_lmdb_command_b)
        rm_old_lmdb_command = 'rm -rf %s' % (t + get_lmdb_name(t))
        args = (rm_old_lmdb_command, subdir_lmdb_command_b, lock, len(d), share_d)
        task_pool_args.append(args)
        updated_lmdb.append(t+get_lmdb_name(t))

    task_pool.map(update_lmdb_fn, task_pool_args)
    task_pool.close()
    task_pool.join()

    if len(updated_lmdb) > 0:
        return True
    else:
        return False

def do_fusion(t):
    global sub_dir
    if t:
        print('ALL sub Thread handle findish,Time to do fusion..')
        #max 10T
        total_lmdb_t = lmdb.open(total_lmdb, map_size=1099511627776 * 100)
        total_lmdb_t_e = total_lmdb_t.begin(write=True)
        new_database = total_lmdb_t_e.cursor()
        size = len(sub_dir)
        loop = 0
        for i in sub_dir:
            loop = loop + 1
            message = 'fusion subdir:' + i+get_lmdb_name(i)
            show_message(float(loop)/size*100, message)
            env_i = lmdb.open(i + get_lmdb_name(i))
            t_n = env_i.begin()
            t_i = t_n.cursor()
            if batch_fusion:
                new_database.putmulti(t_i)
            else:
                for (key, value) in t_i:
                    new_database.put(key, value)
            env_i.close()

        total_lmdb_t_e.commit()
        total_lmdb_t.close()
        print('\n')
        print('--------------------------------------------------------------')
        print('FINISH create total lmdb at: %s' % total_lmdb)
        print('Handle detail log at: %s' % log_file)
        print('--------------------------------------------------------------')
    else:
        print('no lmdb need to fusion')

def create_log_file():
    global log_file
    global total_lmdb
    if not os.path.isdir('out'):
        os.system('mkdir out')

    t = time.strftime('%Y-%m-%d-%H-%M-%S',time.localtime(time.time()))
    log_file = summary_log_file_head + time.strftime('%Y-%m-%d-%H-%M-%S',time.localtime(time.time()))
    log_file = log_file + '.log'

    total_lmdb = 'out/all_lmdb' + '_' + t
    print('log file at: %s; total_lmdb at: %s' % (log_file, total_lmdb))
    os.mknod(log_file)

def commit_update_subdir_log(t):
    write_log('', log_file)
    write_log('FIND UPDATE SUBDIR INFO:', log_file)
    for i in t:
        write_log(i, log_file)

check_args_and_env()
check_convert_imageset_command()
create_log_file()
handle_dir = find_handle_subdir()
t = update_subdir_lmdb(handle_dir)
do_fusion(t)
commit_update_subdir_log(handle_dir)
