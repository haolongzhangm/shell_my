#!/usr/bin/env python
import os

tuner_bin = ['clblast_tuner_copy_fast', 'clblast_tuner_copy_pad', 'clblast_tuner_invert',
        'clblast_tuner_routine_xgemm', 'clblast_tuner_routine_xtrsv',
        'clblast_tuner_transpose_fast', 'clblast_tuner_transpose_pad',
        'clblast_tuner_xaxpy', 'clblast_tuner_xdot',
        'clblast_tuner_xgemm', 'clblast_tuner_xgemm_direct',
        'clblast_tuner_xgemv', 'clblast_tuner_xger']

os.system('adb wait-for-devices')
os.system('adb root')
os.system('adb remount')
os.system('adb shell stop thermal-engine')
os.system('adb shell mkdir sdcard/tuner_jason')
os.system('adb shell rm sdcard/tuner_jason/*.json')

for i in tuner_bin:
    run_cmd = "adb shell \'cd sdcard/tuner_jason ; pwd; %s\'" % (i)
    print(run_cmd)
    os.system(run_cmd)

os.system('mkdir tmp_result')
os.system('adb pull sdcard/tuner_jason/ tmp_result/')
