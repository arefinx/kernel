#!/bin/bash
#set -e
# Kernel
echo -e "$green << cloning kernel >> \n $white"
git clone https://github.com/arefinx/kernel_xiaomi_sunny moonlight
echo -e "$green << cloned kernel successfully >> \n $white"

# Tool Chain
echo -e "$green << cloning gcc >> \n $white"
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_aarch64_aarch64-linux-android-4.9 "$HOME"/gcc64
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_gcc_linux-x86_arm_arm-linux-androideabi-4.9"$HOME"/gcc32
echo -e "$green << cloned gcc successfully >> \n $white"

# Clang
echo -e "$green << cloning clang >> \n $white"
git clone --depth=1 https://github.com/LineageOS/android_prebuilts_clang_kernel_linux-x86_clang-r416183b "$HOME"/clang
echo -e "$green << cloned  clang successfully >> \n $white"
