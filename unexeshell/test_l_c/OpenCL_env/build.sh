#!/usr/bin/env bash
set -e

rm -rf out
mkdir -p out

echo "build for aarch64...."
aarch64-linux-android29-clang++ -static-libstdc++ -pie -fPIE -Iopencl-stub/include/  src/OpenCLInfo.cpp opencl-stub/src/libopencl.cpp -llog -o out/OpenCLInfo_aarch64
echo "build for arm...."
armv7a-linux-androideabi23-clang++ -static-libstdc++ -pie -fPIE -Iopencl-stub/include/  src/OpenCLInfo.cpp opencl-stub/src/libopencl.cpp -llog -o out/OpenCLInfo_arm
