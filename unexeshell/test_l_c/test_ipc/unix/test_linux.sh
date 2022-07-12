#!/bin/bash -e

clang ./test_ipc.c -o test_ipc -g

./test_ipc
