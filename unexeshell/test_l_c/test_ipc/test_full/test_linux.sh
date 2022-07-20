#!/bin/bash -e

SRC_DIR=$(readlink -f "`dirname $0`")
cd ${SRC_DIR}

echo "build api shared"
rm -rf libapi.so
clang++ -g -c ./api/api.cpp -fPIC -Iipc_imp -o api.o -fsanitize=address -static-libsan
clang -g -c ./ipc_imp/ipc_imp.c -fPIC -o ipc_imp.o -fsanitize=address -static-libsan
clang++ -g -c ./ipc_imp/ipc_helper.cpp -fPIC -o ipc_helper.o -Iapi -fsanitize=address -static-libsan
clang -g api.o ipc_imp.o ipc_helper.o -fPIC -shared -o libapi.so -fsanitize=address -static-libsan -lstdc++

echo "build test bin"

rm -rf test_bin
clang -g ./test_caller/main.c -I./api -lapi -L. -o test_bin -fsanitize=address -static-libsan

echo "run test bin"
LD_LIBRARY_PATH=. ./test_bin


