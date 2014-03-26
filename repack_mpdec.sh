#!/bin/bash
now=$(date +"%m%d_%H%M")

#Source
ZIMAGE_A=~/kernel_dev/build_hut/kernel/aosp
ZIMAGE_S=~/kernel_dev/build_hut/kernel/sense
MODULE_A=~/kernel_dev/build_hut/kernel/aosp/
MODULE_S=~/kernel_dev/build_hut/kernel/sense/

#Repacking
CM11=~/kernel_dev/build_hut/bootimg_repacker/cm11
CM10_2=~/kernel_dev/build_hut/bootimg_repacker/cm10_2
AICP=~/kernel_dev/build_hut/bootimg_repacker/aicp
AICP43=~/kernel_dev/build_hut/bootimg_repacker/aicp43
SENSE=~/kernel_dev/build_hut/bootimg_repacker/sense
OMNIEXP=~/kernel_dev/build_hut/bootimg_repacker/omni-exp

#Packaging
P_AOSP=~/kernel_dev/build_hut/release/aosp
P_SENSE=~/kernel_dev/build_hut/release/sense

#Out
OUT=~/kernel_dev/build_hut/final/mpdec/

rm -f $CM11/kernel/zImage
rm -f $CM10_2/kernel/zImage
rm -f $AICP/kernel/zImage
rm -f $AICP43/kernel/zImage
rm -f $SENSE/kernel/zImage
rm -f $OMNIEXP/kernel/zImage

rm -R $P_AOSP/system/lib/modules
rm -R $P_SENSE/system/lib/modules

cp -f $ZIMAGE_A/zImage $CM11/kernel/zImage
cp -f $ZIMAGE_A/zImage $CM10_2/kernel/zImage
cp -f $ZIMAGE_A/zImage $AICP/kernel/zImage
cp -f $ZIMAGE_A/zImage $AICP43/kernel/zImage
cp -f $ZIMAGE_A/zImage $SENSE/kernel/zImage
cp -f $ZIMAGE_A/zImage $OMNIEXP/kernel/zImage
wait
cp -R $MODULE_A/modules $P_AOSP/system/lib
cp -R $MODULE_S/modules $P_SENSE/system/lib
wait

cd $CM11
. pack_boot.sh
wait
cp -f $CM11/out/boot.img $P_AOSP/cm11.img
wait

cd $CM10_2
. pack_boot.sh
wait
cp -f $CM10_2/out/boot.img $P_AOSP/cm10_2.img
wait

cd $AICP
. pack_boot.sh
wait
cp -f $AICP/out/boot.img $P_AOSP/aicp.img
wait

cd $AICP43
. pack_boot.sh
wait
cp -f $AICP/out/boot.img $P_AOSP/aicp43.img
wait

cd $SENSE
. pack_boot.sh
wait
cp -f $SENSE/out/boot.img $P_SENSE/sense.img
wait

cd $OMNIEXP
. pack_boot.sh
wait

#Zipping aosp
cd $P_AOSP
zip -r next_aosp_mpdec$(echo $now).zip *
mv *.zip $OUT
wait
#Zipping sense
cd $P_SENSE
zip -r next_sense_mpdec$(echo $now).zip *
mv *.zip $OUT
