rm -rf *.so main.bin

# dynamic link
aarch64-linux-android29-clang  -std=c11  -fPIE ./so.c  -shared -o libso.so -I.
#aarch64-linux-android29-clang  -std=c11  -fPIE ./so.c  -shared -o libso.so -I. -Wl,-z,nodelete

# dlopen
#aarch64-linux-android29-clang  -std=c11  -fPIE ./sdk_so.c  -shared -o libsdk_so.so -L. -lso -I.
aarch64-linux-android29-clang  -std=c11  -fPIE ./sdk_so.c  -shared -o libsdk_so.so -L. -lso -I. -Wl,-z,nodelete

aarch64-linux-android29-clang  -std=c11  -fPIE  ./main.c -o main.bin
