#!/bin/bash -e

aarch64-linux-android29-clang -pie -fPIE  ./test_ipc.c -o test_ipc

scp test_ipc cd_mi9:~/zhl/
ssh cd_mi9 "~/zhl/test_ipc"
