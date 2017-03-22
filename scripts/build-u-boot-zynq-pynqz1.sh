#!/bin/bash

UBOOT_BUILD_DIR=u-boot-zynq-pynqz1

### Download U-Boot Source
git clone git://git.denx.de/u-boot.git $UBOOT_BUILD_DIR
cd $UBOOT_BUILD_DIR

#### CHeckout v2016.03
git checkout -b u-boot-2016.03-zynq-pynqz1 refs/tags/v2016.03

### Patch for zynq-pynqz1

patch -p0 < ../files/u-boot-2016.03-zynq-pynqz1.diff
git add --update
git commit -m "patch for zynq-pynqz1"

### Setup for Build 

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make zynq_pynqz1_defconfig

### Build u-boot

make

### Copy boot.bin and u-boot.img to boot/

cp spl/boot.bin  ../boot/
cp u-boot.img    ../boot/

cd ..
