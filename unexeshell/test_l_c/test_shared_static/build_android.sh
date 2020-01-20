aarch64-linux-android29-clang -c -std=c11 -pie -fPIE ./static.c  -static -o static.o
aarch64-linux-android-ar rcs libss.a static.o

aarch64-linux-android29-clang  -std=c11  -fPIE -L./  -Wl,--whole-archive -lss  -Wl,--no-whole-archive  ./dynamic_a.c  -shared -o libset.so
aarch64-linux-android29-clang  -std=c11  -fPIE -L./  -Wl,--whole-archive -lss  -Wl,--no-whole-archive  ./dynamic_b.c  -shared -o libget.so


aarch64-linux-android29-clang  -std=c11  -fPIE -L./ -lset -lget  ./main.c  -o s_d.bin
