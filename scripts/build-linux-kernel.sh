#!/bin/bash

CURRENT_DIR=`pwd`
LINUX_BUILD_DIR=linux-4.8.17-armv7-fpga

### Download Linux Kernel Source
git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git $LINUX_BUILD_DIR
cd $LINUX_BUILD_DIR
git checkout -b linux-4.8.17-armv7-fpga refs/tags/v4.8.17

### Patch for armv7-fpga
patch -p0 < ../files/linux-4.8.17-armv7-fpga.diff
git add --update
git add arch/arm/configs/armv7_fpga_defconfig
git add arch/arm/boot/dts/zynq-pynqz1.dts
git commit -m "patch for armv7-fpga"
git tag -a v4.8.17-armv7-fpga -m "relase v4.8.17-armv7-fpga"

### Setup for Build 
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
make armv7_fpga_defconfig

### Build Linux Kernel and device tree
make deb-pkg
make zynq-pynqz1.dtb
 
### Copy zImage and devicetree to tareget/zybo-pynqz1/boot/
cp arch/arm/boot/zImage              ../boot/zImage-4.8.17-armv7-fpga
cp arch/arm/boot/dts/zynq-pynqz1.dtb ../boot/devicetree-4.8.17-zynq-pynqz1.dtb
dtc -I dtb -O dts -o ../boot/devicetree-4.8.17-zynq-pynqz1.dts arch/arm/boot/dts/zynq-pynqz1.dtb

cd ..
