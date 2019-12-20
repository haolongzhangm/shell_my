#from NDK17, default use clang
echo "build for aarch64...."
aarch64-linux-android29-clang++ -static-libstdc++ -pie -fPIE -IOpenCL -LOpenCL/aarch64_lib -lOpenCL -fuse-ld=gold src/HelloWorld.cpp -o out/HelloWorld_64
echo "build for arm...."
armv7a-linux-androideabi23-clang++ -static-libstdc++ -pie -fPIE -IOpenCL -LOpenCL/arm_lib -lOpenCL -fuse-ld=gold src/HelloWorld.cpp -o out/HelloWorld_32
