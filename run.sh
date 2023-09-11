#!/bin/bash
#set -e
echo -e "$green << initializing compilation script >> \n $white"
cd moonlight

KERNEL_DEFCONFIG=vendor/sunny_defconfig
date=$(date +"%Y-%m-%d-%H%M")
ARCH="arm64"
SUBARCH="arm64"
DEVICE="sunny"
export GCC32=$HOME/gcc32
export GCC=$HOME/gcc64
export ARCH SUBARCH
export CROSS_COMPILE=$HOME/gcc64/bin/aarch64-linux-android-
export CROSS_COMPILE_ARM32=$HOME/gcc32/bin/arm-linux-androideabi-
export KBUILD_BUILD_USER=Arefin
export KBUILD_BUILD_HOST=Arefin
PATH="$CLANG_DIR/bin:$GCC32/bin:$GCC/bin:${PATH}"

# Speed up build process
MAKE="./makeparallel"
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

echo "**** Kernel defconfig is set to $KERNEL_DEFCONFIG ****"
echo -e "$blue***********************************************"
echo "          BUILDING KERNEL          "
echo -e "***********************************************$nocol"
make $KERNEL_DEFCONFIG O=out CC=clang
make -j$(nproc --all) O=out \
                              LLVM=1 \
                              LLVM_IAS=1 \
                              CC=$HOME/clang/bin/clang \
                              CROSS_COMPILE=$CROSS_COMPILE \
                              CROSS_COMPILE_COMPACT=$CROSS_COMPILE_ARM32 \
                              CLANG_TRIPLE=aarch64-linux-gnu- 2>&1 | tee error.log
export IMG="$MY_DIR"/out/arch/arm64/boot/Image.gz
export dtbo="$MY_DIR"/out/arch/arm64/boot/dtbo.img
export dtb="$MY_DIR"/out/arch/arm64/boot/dtb.img

find out/arch/arm64/boot/dts/ -name '*.dtb' -exec cat {} + >out/arch/arm64/boot/dtb
if [ -f "out/arch/arm64/boot/Image.gz" ] && [ -f "out/arch/arm64/boot/dtbo.img" ] && [ -f "out/arch/arm64/boot/dtb" ]; then
	echo "------ Finishing  Build ------"
        echo "------ Cloning AnyKernel -----"
	git clone -q https://github.com/arefinx/AnyKernel3
	cp out/arch/arm64/boot/Image.gz AnyKernel3
	cp out/arch/arm64/boot/dtb AnyKernel3
	cp out/arch/arm64/boot/dtbo.img AnyKernel3
	rm -f *zip
	cd AnyKernel3
	sed -i "s/is_slot_device=0/is_slot_device=auto/g" anykernel.sh
	zip -r9 "../${zipname}" * -x '*.git*' README.md *placeholder >> /dev/null
	cd ..
	rm -rf AnyKernel3
	echo -e "\nCompleted in $((SECONDS / 60)) minute(s) and $((SECONDS % 60)) second(s) !"
	echo ""
	echo -e ${zipname} " is ready!"
	echo ""
else
	echo -e "\n Compilation Failed!"
fi

# Upload Zip
echo -e "$green << Uploading Zip >> \n $white"
transfer gg  ${zipname}
echo -e "$green << Uploading Done>> \n $white"

# Remove
rm -rf transfer
rm ${zipname}
rm -rf out
