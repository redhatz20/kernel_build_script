# Script to unpack Galaxy R Kernel 
# @Adi_Pat
tput setaf 6
setterm -bold 
echo "**** KERNEL UNPACK SCRIPT ****"
echo "**** FOR I9103 ****"
echo "**** By Adi_Pat ****"
tput sgr0 
setterm -bold 
tput setaf 1
echo "Checking stale files"
if test -d ramdisk
then rm -rf ramdisk
fi
if test -d kernel
then rm -rf kernel
fi
if test -d out
then rm -rf out
fi
tput setaf 6
echo "Checking for boot.img"
if test -e boot.img
  then
   mkdir kernel
   mkdir ramdisk
   mkdir -p unpack
   echo "Extracting Kernel + Ramdisk" 
   ./tools/unpackbootimg -i boot.img -o unpack 
   cp unpack/boot.img-zImage kernel/zImage 
   rm unpack/boot.img-zImage
   echo "Extracting ramdisk" 
   cd ramdisk
   gzip -dc ../unpack/boot.img-ramdisk.gz | cpio -i 
   cd .. 
   rm -rf unpack
   tput setaf 2
   echo "Extracted Kernel is in kernel/zImage"
   echo "Extracted Ramdisk is in ramdisk folder" 
tput sgr0
else echo "boot.img not found!"
fi 
