#!/usr/bin/env bash

set -e

# This script is used to create megengine android database.
EXTRA_CMAKE_ARGS="-DMGE_WITH_TEST=ON -DMGE_WITH_OPENCL=ON -DMGE_OPENCL_SEARCH_ALGO=ON" ./scripts/cmake-build/cross_build_android_arm_inference.sh -n
