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

[Install to PYNQ-Z1](doc/install/zynq-pynqz1.md)

Get started 
------------------------------------------------------------------------------------

* [Get started fibonacci](doc/tutorial/fibonacci.md)

Build 
------------------------------------------------------------------------------------

* [Build U-boot for PYNQ-Z1](doc/build/u-boot-zynq-pynqz1.md)
* [Build Linux Kernel](doc/build/linux-kernel-4.8.17.md)
* [Build Device Drivers and Services](doc/build/device-drivers.md)
* [Build Debian8 RootFS](doc/build/debian-rootfs-4.8.17.md)
