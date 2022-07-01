#!/usr/bin/env bash
set -e

rm -rf sym.so
clang sym.c -fvisibility=default -shared -Wl,--version-script=version.ld -o sym.so
nm -D sym.so
