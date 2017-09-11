#!/usr/bin/env python

import sys
import os

for i in sys.argv[1:]:
    handle_file = i
    args_c = 'cp %s ./' % handle_file

    print('now handle file: ' + handle_file)
    os.system(args_c)

