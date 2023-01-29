#!/usr/bin/env bash
set -e

aarch64-linux-android29-clang test.c --static -march=armv8.2-a+bf16+i8mm
