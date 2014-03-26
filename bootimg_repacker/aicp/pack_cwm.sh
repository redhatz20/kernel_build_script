# Script Pack Kernel + Ramdisk
# By Adi_Pat
tput setaf 6
setterm -bold 
echo "**** KERNEL PACKER SCRIPT ****"
echo "**** FOR I9103 ****"
echo "**** By Adi_Pat ****"
tput sgr0 
setterm -bold
echo "Checking zImage in kernel/zImage"
if test -e kernel/zImage
   then echo "zImage found"
else echo "Kernel not found!"
   tput sgr0
   exit 
fi
echo "Checking Ramdisk"
if test -d ramdisk 
then echo "Ramdisk found" 
else echo "Ramdisk not found!"
tput sgr0
exit 
fi

echo "zImage + ramdisk found, preparing ramdisk"
sleep 2 
./tools/mkbootfs ramdisk | gzip > ramdisk.gz
sleep 2
echo "Packing final Kernel (boot.img) "
mkdir -p out
./tools/mkbootimg --kernel kernel/zImage --ramdisk ramdisk.gz -o out/boot.img --base 10000000 
sleep 2
setterm -bold 
rm ramdisk.gz
echo "boot.img ready!"
echo "Making CWM Flashable zip file"
cd out 
# Copy some essential files 
cp -r ../tools/META-INF META-INF
cp ../tools/signapk.jar signapk.jar 
cp ../tools/testkey.x509.pem testkey.x509.pem
cp ../tools/testkey.pk8 testkey.pk8
###################################
zip -r I9103_Kernel.zip META-INF boot.img 
echo "ZIP Ready, signing it"
java -jar signapk.jar testkey.x509.pem testkey.pk8 I9103_Kernel.zip SIGNED_I9103_KERNEL.zip
# Remove everything ###############
rm I9103_Kernel.zip
rm *.jar
rm *.pk8
rm *.pem
rm -r META-INF 
cd ..
##################################
 
s1=`ls -lh boot.img | sed -e 's/.* [ ]*\([0-9]*\.[0-9]*[MK]\) .*/\1/g'`
cd out 
s2=`ls -lh boot.img | sed -e 's/.* [ ]*\([0-9]*\.[0-9]*[MK]\) .*/\1/g'`
rm boot.img 
tput setaf 3
echo "Size of old boot.img: $s1" 
echo "Size of new boot.img: $s2"
tput setaf 1
echo "Flashable zip is out/SIGNED_I9103_KERNEL.zip"
tput sgr0
setterm -bold
echo "All Done, press enter to exit"
tput sgr0
read ANS
