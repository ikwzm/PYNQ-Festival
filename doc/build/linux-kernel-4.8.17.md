### Build Linux Kernel

There are two ways

1. run scripts/build-linux-kernel.sh (easy)
2. run this chapter step-by-step (annoying)

#### Download Linux Kernel Source

##### Clone from linux-stable.git

```
shell$ git clone git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.8.17-armv7-fpga
```

##### Checkout v4.8.17

```
shell$ cd linux-4.8.17-armv7-fpga
shell$ git checkout -b linux-4.8.17-armv7-fpga refs/tags/v4.8.17
```

#### Patch for armv7-fpga

```
shell$ patch -p0 < ../files/linux-4.8.17-armv7-fpga.diff
shell$ git add --update
shell$ git add arch/arm/configs/armv7_fpga_defconfig
shell$ git add arch/arm/boot/dts/zynq-pynqz1.dts
shell$ git commit -m "patch for armv7-fpga"
shell$ git tag -a v4.8.17-armv7-fpga -m "relase v4.8.17-armv7-fpga"
```

#### Setup for Build 

````
shell$ cd linux-4.8.17-armv7-fpga
shell$ export ARCH=arm
shell$ export CROSS_COMPILE=arm-linux-gnueabihf-
shell$ make armv7_fpga_defconfig
````

#### Build Linux Kernel and device tree

````
shell$ make deb-pkg
shell$ make zynq-pynqz1.dtb
````

#### Copy zImage and devicetree to boot/

```
shell$ cp arch/arm/boot/zImage              ../boot/zImage-4.8.17-armv7-fpga
shell$ cp arch/arm/boot/dts/zynq-pynqz1.dtb ../boot/devicetree-4.8.17-zynq-pynqz1.dtb
shell$ dtc -I dtb -O dts -o ../boot/devicetree-4.8.17-zynq-pynqz1.dts arch/arm/boot/dts/zynq-pynqz1.dtb
```

