### Install to PYNQ-Z1

#### Downlowd from github

```
shell$ git clone git://github.com/ikwzm/PYNQ-Fextival
shell$ cd PYNQ-Fextival
shell$ git lfs pull origin master
```

#### File Description

 * boot/
   - boot.bin                              : Stage 1 Boot Loader(U-boot-spl)
   - u-boot.img                            : Stage 2 Boot Loader(U-boot)
   - uEnv.txt                              : U-Boot environment variables for linux boot
   - zImage-4.8.17-armv7-fpga              : Linux Kernel Image       
   - devicetree-4.8.17-zynq-pynqz1.dtb     : Linux Device Tree Blob   
   - devicetree-4.8.17-zynq-pynqz1.dts     : Linux Device Tree Source
   - design_1_wrapper.bit                  : fibonacci server for PYNQ-Z1
 * debian8-rootfs-4.8.17.tgz               : Debian8 Root File System (use Git LFS)

#### Format SD-Card

````
shell# fdisk /dev/sdc
   :
   :
   :
shell# mkfs-vfat /dev/sdc1
shell# mkfs.ext3 /dev/sdc2
````

#### Write to SD-Card

````
shell# mount /dev/sdc1 /mnt/usb1
shell# mount /dev/sdc2 /mnt/usb2
shell# cp boot/*                            /mnt/usb1
shell# tar xfz debian8-rootfs-4.8.17.tgz -C /mnt/usb2
shell# umount mnt/usb1
shell# umount mnt/usb2
````
