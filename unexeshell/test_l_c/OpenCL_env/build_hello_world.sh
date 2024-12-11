#!/usr/bin/env bash
set -e

rm -rf out
mkdir -p out

echo "build for aarch64...."
aarch64-linux-android29-clang++ -static-libstdc++ -pie -fPIE -Iopencl-stub/include/ src/HelloWorld.cpp opencl-stub/src/libopencl.cpp -llog -o out/HelloWorld_64
echo "build for arm...."
armv7a-linux-androideabi23-clang++ -static-libstdc++ -pie -fPIE -Iopencl-stub/include/ src/HelloWorld.cpp opencl-stub/src/libopencl.cpp -llog -o out/HelloWorld_32
