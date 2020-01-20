gcc -c -std=c11 -pie -fPIE -fPIC ./static.c  -static -o static.o
ar rcs libss.a static.o

gcc  -std=c11  -fPIE -fPIC -L./ -Wl,--whole-archive -lss  -Wl,--no-whole-archive ./dynamic_a.c  -shared -o libset.so
gcc  -std=c11  -fPIE -fPIC -L./ -Wl,--whole-archive -lss  -Wl,--no-whole-archive ./dynamic_b.c  -shared -o libget.so


gcc  -std=c11 ./main.c -pie -fPIE -L./ -lset -lget  -o s_d.bin
