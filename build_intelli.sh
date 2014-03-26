#!/bin/bash
KBE_PATH=~/kernel_dev/build_hut/
KERNEL_DIR=~/kernel_dev/next_endeavoru_kernel/
ZIMAGE=~/kernel_dev/build_hut/kernel/intelliplug/
MODULE=~/kernel_dev/build_hut/kernel/intelliplug/modules/
TOOLCHAIN=~/toolchain/arm-cortex_a9-linux-gnueabihf-linaro_4.7.4-2014.01/bin/arm-cortex_a9-linux-gnueabihf-
#TOOLCHAIN=~/OmniRom/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-
#TOOLCHAIN=~/OmniRom/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
INTEL_LOG="../intel.log"
NUM_THREADS=6

rm -f $ZIMAGE/zImage
rm -f $SENSE_PATH/zImage
rm -f $MODULE/*.ko
rm -f $SENSEM_PATH/*.ko

startBuildTimeM=$(date +%r)

cd $KERNEL_DIR

make clean

#Start kernel build
rm -f $INTEL_LOG
echo "Initializing aosp build..."
make clean >> $INTEL_LOG 2>&1
export ARCH=arm SUBARCH=arm CROSS_COMPILE=$TOOLCHAIN clean >> $INTEL_LOG 2>&1
export LOCALVERSION=".next™10.0"
make next_intelli_defconfig >> $INTEL_LOG 2>&1
make -j16  >> $INTEL_LOG 2>&1
echo "Building kernel..."
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` clean -j7 >> $INTEL_LOG 2>&1	
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` -j7  >> $INTEL_LOG 2>&1
echo "Saving binaries..."
cp $KERNEL_DIR/arch/arm/boot/zImage $ZIMAGE/
find . -iname "*.ko" -exec cp {} $MODULE \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/compat/ -type f -name '*.ko' -exec cp -f {} $MODULE \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/mac80211/ -type f -name '*.ko' -exec cp -f {} $MODULE \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/wireless/ -type f -name '*.ko' -exec cp -f {} $MODULE \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/drivers/net/wireless/wl12xx/ -type f -name '*.ko' -exec cp -f {} $MODULE \;
echo "Aosp build done."
#Kernel build end
wait
make clean
endBuildTimeM=$(date +%r)

echo " "
echo "Build Time: $startBuildTimeM"
echo "Finished: $endBuildTimeM"
