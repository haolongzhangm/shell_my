#from NDK17, default use clang
echo "build for aarch64...."
aarch64-linux-android-clang++ -pie -fPIE -IOpenCL -LOpenCL/aarch64_lib -lOpenCL -fuse-ld=gold src/OpenCLInfo.cpp -o out/OpenCLInfo_aarch64
echo "build for arm...."
arm-linux-androideabi-clang++ -pie -fPIE -IOpenCL -LOpenCL/arm_lib -lOpenCL -fuse-ld=gold src/OpenCLInfo.cpp -o out/OpenCLInfo_arm
