#!/usr/bin/env bash
set -e

rm -rf out/out/cl_svm_test*

#from NDK17, default use clang
echo "build for aarch64...."
aarch64-linux-android29-clang++ -static-libstdc++ -pie -fPIE -IOpenCL -LOpenCL/aarch64_lib -lOpenCL -fuse-ld=gold src/cl_svm_test.cpp -o out/cl_svm_test_64 -g
echo "build for arm...."
armv7a-linux-androideabi23-clang++ -static-libstdc++ -pie -fPIE -IOpenCL -LOpenCL/arm_lib -lOpenCL -fuse-ld=gold src/cl_svm_test.cpp -o out/cl_svm_test_32 -g

ls out/cl_svm_test*
