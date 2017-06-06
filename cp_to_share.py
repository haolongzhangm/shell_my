#!/usr/bin/env python

import os
import sys
import getpass

share_dir = "~/desktop/tmp_file/"

def usage():
    print("cp_to_share.py xx xx xx")
    exit()

def check_args():
    if len(sys.argv) < 2:
        print("Err: need at least one args")
        usage()

def run_cp():
    user_name = getpass.getuser()
    i_share_dir = share_dir.replace('~', '/home/%s') % user_name

    if not os.path.exists(i_share_dir):
        print("Err: can not find dir" + i_share_dir)
        usage()

    for i in sys.argv:
        if 0 > i.find("cp_to_share.py"):
            exec_string = "cp -rf %s %s "% (i, i_share_dir)
            if not os.path.exists(i):
                print("Warning: can not find " + i + " ignore it...")
                continue

            print exec_string
            os.system(exec_string)

###start here
check_args()
run_cp()
