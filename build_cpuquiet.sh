#!/bin/bash
KBE_PATH=~/kernel_dev/build_hut/
KERNEL_DIR=~/kernel_dev/next_endeavoru_kernel/
QUIET_PATH=~/kernel_dev/build_hut/kernel/cpuquiet/
QUIETM_PATH=~/kernel_dev/build_hut/kernel/cpuquiet/modules/
#TOOLCHAIN=~/toolchain/arm-cortex_a9-linux-gnueabihf-linaro_4.7.4-2014.01/bin/arm-cortex_a9-linux-gnueabihf-
#TOOLCHAIN=~/toolchain/arm-unknown-linux-gnueabi-linaro_4.6.4-2013.05/bin/arm-gnueabi-
TOOLCHAIN=~/OmniRom/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-
#TOOLCHAIN=~/OmniRom/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
QUIET_LOG="../quiet.log"
NUM_THREADS=6

rm -f $QUIET_PATH/zImage
rm -f $QUIETM_PATH/*.ko

startBuildTimeM=$(date +%r)

cd $KERNEL_DIR

make clean && make mrproper

#Start kernel build
rm -f $QUIET_LOG
echo "Initializing build..."
make clean >> $QUIET_LOG 2>&1
export ARCH=arm SUBARCH=arm CROSS_COMPILE=$TOOLCHAIN clean >> $QUIET_LOG 2>&1
export LOCALVERSION=".next™7.5"
make nextcpuquiet_sense_defconfig >> $QUIET_LOG 2>&1
make -j16  >> $QUIET_LOG 2>&1
echo "Building kernel..."
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` clean -j7 >> $QUIET_LOG 2>&1	
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` -j7  >> $QUIET_LOG 2>&1
echo "Saving binaries..."
cp $KERNEL_DIR/arch/arm/boot/zImage $QUIET_PATH/
find . -iname "*.ko" -exec cp {} $QUIETM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/compat/ -type f -name '*.ko' -exec cp -f {} $QUIETM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/mac80211/ -type f -name '*.ko' -exec cp -f {} $QUIETM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/wireless/ -type f -name '*.ko' -exec cp -f {} $QUIETM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/drivers/net/wireless/wl12xx/ -type f -name '*.ko' -exec cp -f {} $QUIETM_PATH \;
echo "Kernel build done."
#Kernel build end
wait
make clean
endBuildTimeM=$(date +%r)

echo " "
echo "Build Time: $startBuildTimeM"
echo "Finished: $endBuildTimeM"
