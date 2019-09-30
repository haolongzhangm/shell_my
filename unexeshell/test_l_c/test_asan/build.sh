echo "build asan test file for pc side============================================"
/usr/bin/clang++ -fsanitize=address -O0 -fno-omit-frame-pointer -g main.cc -o host_test_asan
echo "pls run with: ./host_test_asan [type]"

echo "build valgrind test file for pc side========================================"
/usr/bin/clang++ -O0 -g main.cc -o host_test_valgrind
echo "pls run with: valgrind --leak-check=full ./host_test_valgrind [type]"

echo "build asan test file for Android side======================================="
aarch64-linux-android-clang++ -fsanitize=address -O0 -fno-omit-frame-pointer -g -pie -fPIE main.cc -o android_test_asan
echo "push file..."
adb push android_test_asan /system/bin/

echo "build asan test file for Android side======================================="
aarch64-linux-android-clang++ -O0 -fno-omit-frame-pointer -g -pie -fPIE main.cc -o android_test_valgrind
echo "push file..."
adb push android_test_valgrind /system/bin/
