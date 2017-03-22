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

### Boot PYNQ-Z1 and login fpga or root user

fpga'password is "fpga".

```
debian-fpga login: fpga
Password:
fpga@debian-fpga:~$
```

root'password is "admin".

```
debian-fpga login: root
Password:
root@debian-fpga:~#
```

Start Fibonacci Server
------------------------------------------------------------------------------------

### Login root

```
debian-fpga login: root
Password:
root@debian-fpga:~#
```

### Download "design_1_wrapper.bit" to PL

```
root@debian-fpga:~# echo 1 >/sys/class/fpgacfg/fpgacfg0/data_format
root@debian-fpga:~# echo 1 >/sys/class/fpgacfg/fpgacfg0/load_start
root@debian-fpga:~# dd if=/home/fpga/examples/fibonacci/design_1_wrapper.bit of=/dev/fpgacfg0 bs=1M
3+1 records in
3+1 records out
4045676 bytes (4.0 MB) copied, 0.296939 s, 13.6 MB/s
```

### Overlay "zptty" device-tree

```
root@debian-fpga:~# dtbocfg.rb --install zptty0 --dts /home/fpga/examples/fibonacci/zptty0-zynq-zybo.dts
[ 9913.628222] zptty 43c10000.zptty: ZPTTY Driver probe start
[ 9913.634005] zptty 43c10000.zptty: driver installed
[ 9913.638720] zptty 43c10000.zptty: device name    = zptty0
[ 9913.644163] zptty 43c10000.zptty: private record = ddec8000 (336bytes)
[ 9913.650611] zptty 43c10000.zptty: major number   = 244
[ 9913.655774] zptty 43c10000.zptty: minor number   = 0
[ 9913.660683] zptty 43c10000.zptty: regs resource  = [mem 0x43c10000-0x43c10fff flags 0x200]
[ 9913.668961] zptty 43c10000.zptty: regs address   = e1b08000
[ 9913.674533] zptty 43c10000.zptty: irq resource   = [irq 162 flags 0x404]
[ 9913.681164] zptty 43c10000.zptty: tx buf size    = 128
[ 9913.686326] zptty 43c10000.zptty: rx buf size    = 128
```

### Start "socat" (background)

```
root@debian-fpga:~# socat -d -d tcp-listen:54321,fork /dev/zptty0,raw,nonblock,echo=0 &
[2] 2145
2017/03/01 09:34:13 socat[2145] N listening on AF=2 0.0.0.0:54321
```

Run fibonacci client
------------------------------------------------------------------------------------

```
fpga@debian-fpga:~$ cd /home/fpga/examples/fibonacci
fpga@debian-fpga:~$ python3 fibnacci_client.py
0 => 0
1 => 1
2 => 1
3 => 2
4 => 3
5 => 5
6 => 8
7 => 13
8 => 21
9 => 34
10 => 55
11 => 89
12 => 144
13 => 233
14 => 377
15 => 610
16 => 987
17 => 1597
18 => 2584
19 => 4181
20 => 6765
21 => 10946
22 => 17711
23 => 28657
24 => 46368
25 => 75025
26 => 121393
27 => 196418
28 => 317811
29 => 514229
30 => 832040
31 => 1346269
32 => 2178309
33 => 3524578
34 => 5702887
35 => 9227465
36 => 14930352
37 => 24157817
38 => 39088169
39 => 63245986
40 => 102334155
41 => 165580141
42 => 267914296
43 => 433494437
```

Build 
------------------------------------------------------------------------------------

* [Build U-boot for PYNQ-Z1](doc/build/u-boot-zynq-pynqz1.md)
* [Build Linux Kernel](doc/build/linux-kernel-4.8.17.md)
* [Build Device Drivers and Services](doc/build/device-drivers.md)
* [Build Debian8 RootFS](doc/build/debian-rootfs-4.8.17.md)
