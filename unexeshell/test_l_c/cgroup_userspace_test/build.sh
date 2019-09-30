echo "build gnu linux for arm64..."
aarch64-linux-gnu-g++ cgroup_userspace_test.cc -o cgroup_userspace_gnu_linux
echo ""

if [ `which aarch64-linux-android-g++` ]
then
	echo "find toolchain..."
	echo "try  build for android ..."
	aarch64-linux-android-g++ cgroup_userspace_test.cc -pie -fPIE -o cgroup_userspace_android
else
	echo "ERR: can not find android toolchain"
	echo "u can try run command:"
	echo "python build/tools/make_standalone_toolchain.py at NDK root dir"
	echo "export the PATH create by make_standalone_toolchain.py"
fi
echo ""

echo "build for linux for x86..."
g++ cgroup_userspace_test.cc -o cgroup_userspace_x86
