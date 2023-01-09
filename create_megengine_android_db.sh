#!/usr/bin/env sh
set -eu

EXTRA_CMAKE_ARGS="-DMGE_WITH_OPENCL=ON -DMGE_OPENCL_SEARCH_ALGO=ON -DMGE_OPENCL_SEARCH_ALGO_CHECK=ON -DMGE_WITH_TEST=ON" ./scripts/cmake-build/cross_build_android_arm_inference.sh -n

cp build_dir/android/arm64-v8a/Release/build/compile_commands.json .

ls -l compile_commands.json
