#!/usr/bin/python
#coding=utf-8

#v0.1 20180410 zhl

from skimage.io import imread
from scipy.misc import imsave
import cv2
import time
import sys
import multiprocessing
from multiprocessing import Process, Manager, cpu_count
import os
import platform
import random

#config
# OPENCV H*2，V/255，S/255
H_lower_0 = 0
H_max_0 = 30
H_lower_1 = 150
H_max_1 = 180
s_threshold = 0.4 * 255
s_target = 0.25 * 255
out_prefix = './out/'
support_picture = ['.jpg', '.jpeg', '.png', '.bmp', '.JPG']
#end config

def load_img(pic_path):
    try:
        img = imread(pic_path)
        hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
        H, S, V = cv2.split(hsv)
    except IOError:
        print('Invalid PIC: %s ingore it' % pic_path)
        return 0

    return (img, hsv, H, S, V)

def create_random_s(s):
    ret = 1
    if s > s_threshold:
        t = random.random()
        ret = t * (s / s_target - 1) + 1

    return ret

def write_log_with_lock(str, file, lock):
    lock.acquire()
    with open(file, 'a') as f:
        f.write(str)
        f.write('\n')
        f.write('-------------------------------')
        f.write('-------------------------------')
        f.write('\n')
    lock.release()

def adjust_s(img, hsv, H, S, V, scale):
    S = S / scale
    hsv[:, :, 0] = H
    hsv[:, :, 1] = S
    hsv[:, :, 2] = V
    return cv2.cvtColor(hsv, cv2.COLOR_HSV2BGR)

def handle_fn(args):
    pid = os.getpid()
    pic = args[0]
    lock = args[1]
    loop = args[3]
    total_size = args[2]
    index_t = pic.rfind('.')
    name_after_handle = pic[:index_t] + '_after_handle.' + pic[index_t+1:]
    name_after_handle = out_prefix +  name_after_handle[name_after_handle.rfind('/')+1:]
    ret = load_img(pic)
    try:
        img = ret[0]
        hsv = ret[1]
        H = ret[2]
        S = ret[3]
        V = ret[4]
    except TypeError:
        log = pic + '    Invalid PIC'
        write_log_with_lock(log, log_file, lock)
        lock.acquire()
        loop['count'] = loop['count'] + 1
        lock.release()
        print('[%3d/100][Process ID: %d finish] : handle %s' % (float(loop['count'])/total_size*100, pid, pic))
        return 0

    h = H.reshape(1, -1)[0]
    s = S.reshape(1, -1)[0]
    count = 0
    sum = 0
    for i in range(0, len(s)):
        #print('org: h = %f, s = %f' % (h[i], s[i]))
        tmp = h[i]
        if (tmp >= H_lower_0 and tmp <= H_max_0) or (tmp >= H_lower_1 and tmp <= H_max_1):
            #print('after h = %f, s = %f' % (h[i], s[i]))
            count = count + 1
            sum = sum + s[i]

    if count > 0:
        average_s = float(sum) / count
        if average_s > s_threshold:
            scale = create_random_s(average_s)
            save = adjust_s(img, hsv, H, S, V, scale)
            imsave(name_after_handle, save)
            log = pic + '    adjust S scale = %f' % scale
            write_log_with_lock(log, log_file, lock)
        else:
            log = pic + '    NO need adjust S'
            write_log_with_lock(log, log_file, lock)
    else:
        log = pic + '    NO need adjust S'
        write_log_with_lock(log, log_file, lock)

    lock.acquire()
    loop['count'] = loop['count'] + 1
    lock.release()
    print('[%3d/100][Process ID: %d finish] : handle %s' % (float(loop['count'])/total_size*100, pid, pic))

def check_args():
    if platform.system() != 'Linux':
        print('Err:only support env at Linux')
        exit(-1)

    if len(sys.argv) != 2 or not os.path.isdir(sys.argv[1]):
        print('ERR: please give the handle dir')
        print('Eg: ./.handle_saturation.py test_dir')
        exit(-1)

def patch_process():
    print('handle dir: %s' % sys.argv[1])
    print('scan handle file...')

    pic_list = []
    for i in support_picture:
        find_cmd = 'find %s -name "*%s"' % (sys.argv[1], i)
        t = os.popen(find_cmd).read().split('\n')
        for p in t:
            if len(p) > len(sys.argv[1]):
                pic_list.append(p)

    task_pool = multiprocessing.Pool(processes = cpu_count())
    task_pool_args = []
    manager = Manager()
    lock = manager.Lock()
    share_d = manager.dict()
    share_d['count'] = 0
    for i in pic_list:
        print i
        args = (i, lock, len(pic_list), share_d)
        task_pool_args.append(args)

    task_pool.map(handle_fn, task_pool_args)
    task_pool.close()
    task_pool.join()
    print('Handle detail log at: %s' % log_file)

def create_log_file():
    global log_file
    if not os.path.isdir('out'):
        os.system('mkdir out')

    t = time.strftime('%Y-%m-%d-%H-%M-%S',time.localtime(time.time()))
    log_file = out_prefix + 'log_' + time.strftime('%Y-%m-%d-%H-%M-%S',time.localtime(time.time()))
    log_file = log_file + '.log'

    print('log file at: %s' % (log_file))
    os.mknod(log_file)

check_args()
create_log_file()
patch_process()
