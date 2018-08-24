echo "test pc side============================================"
clang++ -fsanitize=address -O0 -fno-omit-frame-pointer -g main.cc
./a.out

echo "test android side======================================"
aarch64-linux-android-clang++ -fsanitize=address -O0 -fno-omit-frame-pointer -g -pie -fPIE main.cc
adb push a.out /system/bin/
adb shell a.out
