#!/bin/bash -e

SRC_DIR=$(readlink -f "`dirname $0`")
cd ${SRC_DIR}

echo "build api shared"
rm -rf libapi.so
aarch64-linux-android29-clang++ -c ./api/api.cpp -fPIC -Iipc_imp -o api.o -fsanitize=address -static-libsan  -fPIE 
aarch64-linux-android29-clang -c ./ipc_imp/ipc_imp.c -fPIC -o ipc_imp.o -fsanitize=address -static-libsan  -fPIE 
aarch64-linux-android29-clang++ -c ./ipc_imp/ipc_helper.cpp -Iapi -fPIC -o ipc_helper.o -fsanitize=address -static-libsan  -fPIE 
aarch64-linux-android29-clang api.o ipc_imp.o ipc_helper.o -fPIC -shared -o libapi.so -fsanitize=address -static-libsan  -fPIE  -lc++_static -lc++abi

echo "build test bin"

rm -rf test_bin
aarch64-linux-android29-clang ./test_caller/main.c -I./api -lapi -L. -o test_bin -fsanitize=address -static-libsan

echo "run test bin"
scp test_bin cd_mi9:~/zhl/
scp libapi.so cd_mi9:~/zhl/
ssh cd_mi9 "LD_LIBRARY_PATH=~/zhl/ ~/zhl/test_bin"
