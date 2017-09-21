#!/usr/bin/env python

import os.path
import os

#customer you code dir preifx
code_dir_prefix = ['/home/zhl/mycode', '/media/zhl/second/code/']

index = 0
code_dir = {}

for dir_i in code_dir_prefix:
    print('Now handle prefix dir: %s' % dir_i)
    if (os.path.exists(dir_i)):
        for i in os.listdir(dir_i):
            file_d = os.path.join(dir_i, i)
            if os.path.isdir(file_d):
                index = index + 1
                code_dir[index] = file_d

if 0 == len(code_dir):
    print('Can not find valid dir form code_dir_prefix, pls config it')
    exit()

print('-------------------------------------------------------')
print('code inde info:')
for key in code_dir:
    print('index: %3s --- [%s]' % (key, code_dir[key]))

system_argc = 'null'
while True:
    try:
        print('please input the valid index number or code dir')
        try:
            choose = raw_input(':>')
        except (KeyboardInterrupt, EOFError):
            print()
            exit()
        try:
            if code_dir.has_key(int(choose)):
                system_argc = code_dir[int(choose)]
                break
        except ValueError:
            if choose in code_dir.values():
                system_argc = choose
                break
    except (NameError, SyntaxError):
        continue

if 'null' == system_argc:
    print('ERR HAPPENED!')
    exit

run = 'gnome-terminal --working-directory=%s' % system_argc
print(run)
os.system(run)
