PYNQ-Festival
====================================================================================

Overview
------------------------------------------------------------------------------------

### Introduction

This Repository provides a Linux Boot Image(U-boot, Kernel, Root-fs) examples for PYNQ.

### Features

* Hardware
  + PYNQ-Z1 : Python Productive for Zynq by Digilent
* U-Boot v2016.03 (customized)
  + Build for ZYBO, PYNQ-Z1 and DE0-Nano-SoC
  + Customized boot by uEnv.txt
  + Customized boot by boot.scr
* Linux Kernel Version v4.8.17
  + Available in both Xilinx-Zynq-7000 and Altera-SoC in a single image
  + Enable Device Tree Overlay
  + Enable FPGA Manager
* Debian8(jessie) Root File System
  + Installed build-essential
  + Installed device-tree-compiler
  + Installed ruby ruby-msgpack ruby-serialport
  + Installed u-boot-tools
  + installed python3 pip3
  + installed Jupyter Notebook

### Slide

[python で FPGA プログラミング](doc/PYNQ祭り資料.pdf)


Install
------------------------------------------------------------------------------------

### Downlowd from github

```
shell$ git clone git://github.com/ikwzm/FPGA-SoC-Linux
shell$ cd FPGA-SoC-Linux
shell$ git lfs pull origin master
```

### File Description

 * boot/
   + boot.bin                                  : Stage 1 Boot Loader(U-boot-spl)
   + u-boot.img                                : Stage 2 Boot Loader(U-boot)
   + uEnv.txt                                  : U-Boot environment variables for linux boot
   + zImage-4.8.17-armv7-fpga                  : Linux Kernel Image       
   + devicetree-4.8.17-zynq-pynqz1.dtb         : Linux Device Tree Blob   
   + devicetree-4.8.17-zynq-pynqz1.dts         : Linux Device Tree Source
 * debian8-rootfs-4.8.17.tgz                   : Debian8 Root File System (use Git LFS)

### Format SD-Card

````
shell# fdisk /dev/sdc
   :
   :
   :
shell# mkfs-vfat /dev/sdc1
shell# mkfs.ext3 /dev/sdc2
````

### Write to SD-Card

````
shell# mount /dev/sdc1 /mnt/usb1
shell# mount /dev/sdc2 /mnt/usb2
shell# cp boot/*                            /mnt/usb1
shell# tar xfz debian8-rootfs-4.8.17.tgz -C /mnt/usb2
shell# umount mnt/usb1
shell# umount mnt/usb2
````

Build 
------------------------------------------------------------------------------------

[Build Debian8 RootFS](doc/build-debian-rootfs-4.8.17.md)

