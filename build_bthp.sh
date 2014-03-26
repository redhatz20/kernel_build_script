#!/bin/bash
KBE_PATH=~/kernel_dev/build_hut/
KERNEL_DIR=~/kernel_dev/next_endeavoru_kernel/
AOSP_PATH=~/kernel_dev/build_hut/kernel/aosp/
AOSPM_PATH=~/kernel_dev/build_hut/kernel/aosp/modules/
SENSE_PATH=~/kernel_dev/build_hut/kernel/sense/
SENSEM_PATH=~/kernel_dev/build_hut/kernel/sense/modules/
TOOLCHAIN=~/toolchain/arm-cortex_a9-linux-gnueabihf-linaro_4.7.4-2014.01/bin/arm-cortex_a9-linux-gnueabihf-
AOSP_LOG="../aosp.log"
SENSE_LOG="../sense.log"
NUM_THREADS=6

rm -f $AOSP_PATH/zImage
rm -f $SENSE_PATH/zImage
rm -f $AOSPM_PATH/*.ko
rm -f $SENSEM_PATH/*.ko

startBuildTimeM=$(date +%r)

cd $KERNEL_DIR

make clean && make mrproper

#Sense
rm -f $SENSE_LOG
echo "Initializing Sense build..."
make clean >> $SENSE_LOG 2>&1
export ARCH=arm SUBARCH=arm CROSS_COMPILE=$TOOLCHAIN clean >> $SENSE_LOG 2>&1
export LOCALVERSION=".next™9.1"
make next_sense_defconfig >> $SENSE_LOG 2>&1
make -j7 >> $SENSE_LOG 2>&1
echo "Building kernel..."
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` clean -j7 >> $SENSE_LOG 2>&1	
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` -j7 >> $SENSE_LOG 2>&1
echo "Saving binaries..."
cp $KERNEL_DIR/arch/arm/boot/zImage $SENSE_PATH/
find . -iname "*.ko" -exec cp {} $SENSEM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/compat/ -type f -name '*.ko' -exec cp -f {} $AOSPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/mac80211/ -type f -name '*.ko' -exec cp -f {} $AOSPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/wireless/ -type f -name '*.ko' -exec cp -f {} $AOSPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/drivers/net/wireless/wl12xx/ -type f -name '*.ko' -exec cp -f {} $AOSPM_PATH \;
echo "Sense build done."
#Sense end

#Sense
rm -f $AOSP_LOG
echo "Initializing aosp build..."
make clean >> $AOSP_LOG 2>&1
export ARCH=arm SUBARCH=arm CROSS_COMPILE=$TOOLCHAIN clean >> $AOSP_LOG 2>&1
export LOCALVERSION=".next™9.1"
make next_aosp_defconfig >> $AOSP_LOG 2>&1
make -j7  >> $AOSP_LOG 2>&1
echo "Building kernel..."
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` clean -j7 >> $AOSP_LOG 2>&1	
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` -j7  >> $AOSP_LOG 2>&1
echo "Saving binaries..."
cp $KERNEL_DIR/arch/arm/boot/zImage $AOSP_PATH/
find . -iname "*.ko" -exec cp {} $AOSPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/compat/ -type f -name '*.ko' -exec cp -f {} $AOSPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/mac80211/ -type f -name '*.ko' -exec cp -f {} $AOSPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/wireless/ -type f -name '*.ko' -exec cp -f {} $AOSPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/drivers/net/wireless/wl12xx/ -type f -name '*.ko' -exec cp -f {} $AOSPM_PATH \;
echo "Aosp build done."
#Aosp end
wait
make clean
endBuildTimeM=$(date +%r)

echo " "
echo "Build Time: $startBuildTimeM"
echo "Finished: $endBuildTimeM"
