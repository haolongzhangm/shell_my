 armv7a-linux-androideabi28-clang++ -static-libstdc++ --std=c++14 -pie -fPIE -fPIC -Os -shared  find_rw_dir.cpp -llog -o find_rw_dir_32.so
 aarch64-linux-android28-clang++  -static-libstdc++ --std=c++14 -pie -fPIE -fPIC -Os -shared  find_rw_dir.cpp -llog -o find_rw_dir_64.so

 armv7a-linux-androideabi28-clang++ -static-libstdc++ --std=c++14 -pie -fPIE -fPIC -Os find_rw_dir.cpp -llog -o find_rw_dir_32_bin
 aarch64-linux-android28-clang++  -static-libstdc++ --std=c++14 -pie -fPIE -fPIC -Os find_rw_dir.cpp -llog -o find_rw_dir_64_bin
