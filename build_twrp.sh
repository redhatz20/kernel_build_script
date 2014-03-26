#!/bin/bash
KBE_PATH=~/kernel_dev/build_hut/
KERNEL_DIR=~/kernel_dev/next_endeavoru_kernel/
TWRP_PATH=~/kernel_dev/build_hut/kernel/bthp/
TWRPM_PATH=~/kernel_dev/build_hut/kernel/bthp/modules/
#TOOLCHAIN=~/toolchain/arm-cortex_a9-linux-gnueabihf-linaro_4.7.4-2014.01/bin/arm-cortex_a9-linux-gnueabihf-
#TOOLCHAIN=~/OmniRom/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin/arm-eabi-
TOOLCHAIN=~/OmniRom/prebuilts/gcc/linux-x86/arm/arm-eabi-4.6/bin/arm-eabi-
TWRP_LOG="../twrp.log"
SENSE_LOG="../sense.log"
NUM_THREADS=6

rm -f $TWRP_PATH/zImage
rm -f $TWRPM_PATH/*.ko

startBuildTimeM=$(date +%r)

cd $KERNEL_DIR

make clean

#Twrp
rm -f $TWRP_LOG
echo "Initializing twrp build..."
make clean >> $TWRP_LOG 2>&1
export ARCH=arm SUBARCH=arm CROSS_COMPILE=$TOOLCHAIN clean >> $TWRP_LOG 2>&1
export LOCALVERSION=".twrp"
make twrp_rec_defconfig >> $TWRP_LOG 2>&1
make -j7  >> $TWRP_LOG 2>&1
echo "Building kernel..."
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` clean -j7 >> $TWRP_LOG 2>&1	
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -C drivers/net/wireless/compat-wireless_R5.SP2.03 KLIB=`pwd` KLIB_BUILD=`pwd` -j7  >> $TWRP_LOG 2>&1
echo "Saving binaries..."
cp $KERNEL_DIR/arch/arm/boot/zImage $TWRP_PATH/
find . -iname "*.ko" -exec cp {} $TWRPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/compat/ -type f -name '*.ko' -exec cp -f {} $TWRPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/mac80211/ -type f -name '*.ko' -exec cp -f {} $TWRPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/net/wireless/ -type f -name '*.ko' -exec cp -f {} $TWRPM_PATH \;
find $KERNEL_DIR/drivers/net/wireless/compat-wireless_R5.SP2.03/drivers/net/wireless/wl12xx/ -type f -name '*.ko' -exec cp -f {} $TWRPM_PATH \;
echo "Twrp build done."
#Twrp
wait
make clean
endBuildTimeM=$(date +%r)

echo " "
echo "Build Time: $startBuildTimeM"
echo "Finished: $endBuildTimeM"
