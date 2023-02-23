mkdir -p build 
cd build
cmake .. -DBENCH_WITH_ARM=ON         \
         -DBENCH_WITH_ARM82_FP16=OFF \
         -DBENCH_WITH_ARM8_SVE2=OFF  \
         -DARM_TARGET_OS=android     \
         -DARM_TARGET_ARCH_ABI=armv8 \

