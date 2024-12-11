#!/usr/bin/env bash
set -e

rm -rf out
mkdir -p out

echo "build for aarch64...."
aarch64-linux-android29-clang++ -static-libstdc++ -pie -fPIE -Iopencl-stub/include/ src/cl_svm_test.cpp opencl-stub/src/libopencl.cpp -llog -o out/cl_svm_test_64 -g
echo "build for arm...."
armv7a-linux-androideabi23-clang++ -static-libstdc++ -pie -fPIE -Iopencl-stub/include/ src/cl_svm_test.cpp opencl-stub/src/libopencl.cpp -llog -o out/cl_svm_test_32 -g

ls out/cl_svm_test*
