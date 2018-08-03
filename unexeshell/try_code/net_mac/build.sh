gcc lib.c -fPIC -shared -o libinto.so

gcc net_mac.c -L. -linto

export LD_LIBRARY_PATH=.

./a.out
