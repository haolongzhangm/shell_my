#!/usr/bin/env python
import os
import sys

if 2 != len(sys.argv):
    print('need a param, device sn')
    os.system('adb devices')
    exit()

sn = sys.argv[1]
tuner_bin = ['clblast_tuner_copy_fast', 'clblast_tuner_copy_pad', 'clblast_tuner_invert',
        'clblast_tuner_routine_xgemm', 'clblast_tuner_routine_xtrsv',
        'clblast_tuner_transpose_fast', 'clblast_tuner_transpose_pad',
        'clblast_tuner_xaxpy', 'clblast_tuner_xdot',
        'clblast_tuner_xgemm', 'clblast_tuner_xgemm_direct',
        'clblast_tuner_xgemv', 'clblast_tuner_xger']

print("wait for devices")
os.system('adb -s %s wait-for-devices' % sn)
os.system('adb -s %s root' % sn)
os.system('adb -s %s remount' % sn)
os.system('adb -s %s shell stop thermal-engine' % sn)
os.system('adb -s %s shell mkdir sdcard/tuner_jason' % sn)
os.system('adb -s %s shell rm sdcard/tuner_jason/*.json' % sn)
print("DO PRECHECK FIRSTLY")
os.system('adb -s %s shell cl_precheck' % sn)

for i in tuner_bin:
    run_cmd = "adb -s %s shell \'cd sdcard/tuner_jason ; pwd; %s\'" % (sn, i)
    print(run_cmd)
    os.system(run_cmd)

out_dir = 'tuner_result_for_%s' % sn
os.system('mkdir %s' % out_dir)
os.system('adb -s %s pull sdcard/tuner_jason/ %s/' % (sn, out_dir))
