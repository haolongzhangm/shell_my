#!/usr/bin/env sh
NDK_T=/home/cd_engine_group/group_common_dirs/NDK/android-ndk-r17b

cmake -DCMAKE_TOOLCHAIN_FILE="${NDK_T}/build/cmake/android.toolchain.cmake" \
      -DANDROID_NDK="${NDK_T}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DANDROID_ABI="arm64-v8a" \
      -DANDROID_NATIVE_API_LEVEL=21 \
      ..
