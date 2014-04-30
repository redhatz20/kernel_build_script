#!/bin/bash
now=$(date +"%m%d_%H%M")

#Source
ZIMAGE=~/kernel_dev/build_hut/kernel/cpuquiet
MODULE=~/kernel_dev/build_hut/kernel/cpuquiet/

#Repacking
CM11=~/kernel_dev/final_hut/bootimg_repacker/cm11
CM10_2=~/kernel_dev/final_hut/bootimg_repacker/cm10_2
AICP=~/kernel_dev/final_hut/bootimg_repacker/aicp
AICP43=~/kernel_dev/final_hut/bootimg_repacker/aicp43
SENSE=~/kernel_dev/final_hut/bootimg_repacker/sense
OMNI=~/kernel_dev/final_hut/bootimg_repacker/omni

#Packaging
PACKED=~/kernel_dev/final_hut/release

#Out
OUT=~/kernel_dev/final_hut/final/cpuquiet/

rm -f $CM11/kernel/zImage
rm -f $CM10_2/kernel/zImage
rm -f $AICP/kernel/zImage
rm -f $AICP43/kernel/zImage
rm -f $SENSE/kernel/zImage
rm -f $OMNI/kernel/zImage

rm -R $PACKED/system/lib/modules

cp -f $ZIMAGE/zImage $CM11/kernel/zImage
cp -f $ZIMAGE/zImage $CM10_2/kernel/zImage
cp -f $ZIMAGE/zImage $AICP/kernel/zImage
cp -f $ZIMAGE/zImage $AICP43/kernel/zImage
cp -f $ZIMAGE/zImage $SENSE/kernel/zImage
cp -f $ZIMAGE/zImage $OMNI/kernel/zImage
wait
cp -R $MODULE/modules $PACKED/system/lib
wait

cd $OMNI
. pack_boot.sh
wait

cd $CM11
. pack_boot.sh
wait
cp -f $CM11/out/boot.img $PACKED/cm11.img
wait

cd $CM10_2
. pack_boot.sh
wait
cp -f $CM10_2/out/boot.img $PACKED/cm10_2.img
wait

cd $AICP
. pack_boot.sh
wait
cp -f $AICP/out/boot.img $PACKED/aicp.img
wait

cd $AICP43
. pack_boot.sh
wait
cp -f $AICP/out/boot.img $PACKED/aicp43.img
wait

cd $SENSE
. pack_boot.sh
wait
cp -f $SENSE/out/boot.img $PACKED/sense.img
wait

#Zipping aosp
cd $PACKED
zip -r next_cpuquiet$(echo $now).zip *
mv *.zip $OUT
wait

