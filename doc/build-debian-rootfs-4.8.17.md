Build Debian8 RootFS
------------------------------------------------------------------------------------

#### Setup parameters 

```
shell$ apt-get install qemu-user-static debootstrap binfmt-support
shell$ export targetdir=debian8-rootfs
shell$ export distro=jessie
```

#### Build the root file system in $targetdir(=debian8-rootfs)

```
shell$ mkdir $targetdir
shell$ sudo debootstrap --arch=armhf --foreign $distro                       $targetdir
shell$ sudo cp /usr/bin/qemu-arm-static                                      $targetdir/usr/bin
shell$ sudo cp /etc/resolv.conf                                              $targetdir/etc
shell$ sudo cp scripts/build-debian8-rootfs-with-qemu.sh                     $targetdir
````

#### Build debian8-rootfs with QEMU

##### Change Root to debian8-rootfs

```
shell$ sudo chroot $targetdir
```

There are two ways

1. run build-debian8-rootfs-with-qemu.sh (easy)
2. run this chapter step-by-step (annoying)

##### Setup APT

````
debian8-rootfs# distro=jessie
debian8-rootfs# export LANG=C
debian8-rootfs# /debootstrap/debootstrap --second-stage
````

```
debian8-rootfs# cat <<EOT > /etc/apt/sources.list
deb     http://ftp.jp.debian.org/debian            jessie         main contrib non-free
deb-src http://ftp.jp.debian.org/debian            jessie         main contrib non-free
deb     http://ftp.jp.debian.org/debian            jessie-updates main contrib non-free
deb-src http://ftp.jp.debian.org/debian            jessie-updates main contrib non-free
deb     http://security.debian.org/debian-security jessie/updates main contrib non-free
deb-src http://security.debian.org/debian-security jessie/updates main contrib non-free
EOT
```

```
debian8-rootfs# cat <<EOT > /etc/apt/apt.conf.d/71-no-recommends
APT::Install-Recommends "0";
APT::Install-Suggests   "0";
EOT
```

```
debian8-rootfs# apt-get update
```

##### Install applications

```
debian8-rootfs# apt-get install -y locales dialog
debian8-rootfs# dpkg-reconfigure locales
debian8-rootfs# apt-get install -y openssh-server ntpdate resolvconf sudo less hwinfo ntp tcsh zsh
```

##### Setup hostname

```
debian8-rootfs# echo pynq > /etc/hostname
```

##### Setup root password

```
debian8-rootfs# passwd
```

This time, we set the "admin" at the root' password.

To be able to login as root from Zynq serial port.

```
debian8-rootfs# cat <<EOT >> /etc/securetty
# Seral Port for Xilinx Zynq
ttyPS0
EOT
```

##### Add a new guest user

```
debian8-rootfs# adduser fpga
```

This time, we set the "fpga" at the fpga'password.

```
debian8-rootfs# echo "fpga ALL=(ALL:ALL) ALL" > /etc/sudoers.d/fpga
```

##### Setup sshd config

```
debian8-rootfs# sed -i -e 's/#PasswordAuthentication/PasswordAuthentication/g' /etc/ssh/sshd_config
```

##### Setup Time Zone

```
debian8-rootfs# dpkg-reconfigure tzdata
```

or if noninteractive set to Asia/Tokyo

```
debian8-rootfs# echo "Asia/Tokyo" > /etc/timezone
debian8-rootfs# dpkg-reconfigure -f noninteractive tzdata
```


##### Setup fstab

```
debian8-rootfs# cat <<EOT > /etc/fstab
/dev/mmcblk0p1	/boot	auto		defaults	0	0
none		/config	configfs	defaults	0	0
EOT
````

##### Setup Network Interface

```
debian8-rootfs# cat <<EOT > /etc/network/interfaces.d/eth0
allow-hotplug eth0
iface eth0 inet dhcp
EOT
````

##### Install Development applications

```
debian8-rootfs# apt-get install -y build-essential
debian8-rootfs# apt-get install -y device-tree-compiler
debian8-rootfs# apt-get install -y u-boot-tools
debian8-rootfs# apt-get install -y socat
debian8-rootfs# apt-get install -y ruby ruby-msgpack ruby-serialport
debian8-rootfs# gem install rake
debian8-rootfs# apt-get install -y python  python-dev
debian8-rootfs# apt-get install -y python3 python3-dev
debian8-rootfs# wget https://bootstrap.pypa.io/get-pip.py
debian8-rootfs# python  ./get-pip.py
debian8-rootfs# apt-get install -y python-pip
debian8-rootfs# python3 ./get-pip.py
debian8-rootfs# apt-get install -y python3-pip
debian8-rootfs# rm get-pip.py
debian8-rootfs# pip3 install msgpack-rpc-python
debian8-rootfs# pip3 install jupyter
debian8-rootfs# apt-get install -y samba
debian8-rootfs# apt-get install -y avahi-daemon
```

##### Finish

```
debian8-rootfs# exit
shell$ sudo rm -f $targetdir/usr/bin/qemu-arm-static
shell$ sudo rm -f $targetdir/build-debian8-rootfs-with-qemu.sh
shell$ sudo mkdir $targetdir/root/debian
shell$ sudo cp    linux-image-4.8.17-armv7-fpga_4.8.17-armv7-fpga-1_armhf.deb   $targetdir/root/debian
shell$ sudo cp    linux-headers-4.8.17-armv7-fpga_4.8.17-armv7-fpga-1_armhf.deb $targetdir/root/debian
shell$ sudo cp    fpga-soc-linux-drivers-4.8.17-armv7-fpga_0.0.5-1_armhf.deb    $targetdir/root/debian
shell$ sudo cp    fpga-soc-linux-services_0.0.5-1_armhf.deb                     $targetdir/root/debian
```

#### Build debian8-rootfs-vanilla.tgz

```
shell$ cd $targetdir
shell$ sudo tar cfz ../debian8-rootfs-vanilla.tgz *
```

### Install Device Drivers 

#### Boot PYNQ-Z1 and login fpga or root user

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

#### Install Linux Headers Package

```
fpga@debian-fpga:~$ sudo dpkg -i /root/debian/linux-image-4.8.17-armv7-fpga_4.8.17-armv7-fpga-1_armhf.deb
fpga@debian-fpga:~$ sudo dpkg -i /root/debian/linux-headers-4.8.17-armv7-fpga_4.8.17-armv7-fpga-1_armhf.deb
```

#### Install Device Drivers and Services Package

```
fpga@debian-fpga:~$ sudo dpkg -i /root/debian/fpga-soc-linux-drivers-4.8.17-armv7-fpga_0.0.5-1_armhf.deb
Selecting previously unselected package fpga-soc-linux-drivers-4.8.17-armv7-fpga.
(Reading database ... 39197 files and directories currently installed.)
Preparing to unpack fpga-soc-linux-drivers-4.8.17-armv7-fpga_0.0.5-1_armhf.deb ...
Unpacking fpga-soc-linux-drivers-4.8.17-armv7-fpga (0.0.5-1) ...
Setting up fpga-soc-linux-drivers-4.8.17-armv7-fpga (0.0.5-1) ...
```

```
fpga@debian-fpga:~$ sudo dpkg -i /root/debian/fpga-soc-linux-services_0.0.5-1_armhf.deb
Selecting previously unselected package fpga-soc-linux-services.
(Reading database ... 39210 files and directories currently installed.)
Preparing to unpack fpga-soc-linux-services_0.0.5-1_armhf.deb ...
Unpacking fpga-soc-linux-services (0.0.5-1) ...
Setting up fpga-soc-linux-services (0.0.5-1) ...
Created symlink from /etc/systemd/system/multi-user.target.wants/device-tree-overlay.service to /etc/systemd/system/device-tree-overlay.service.
Created symlink from /etc/systemd/system/multi-user.target.wants/fpga-manager.service to /etc/systemd/system/fpga-manager.service.
Created symlink from /etc/systemd/system/multi-user.target.wants/udmabuf.service to /etc/systemd/system/udmabuf.service.
Created symlink from /etc/systemd/system/multi-user.target.wants/zptty.service to /etc/systemd/system/zptty.service.
```

#### Check Installed Device Drivers and Services Package

```
fpga@debian-fpga:~$ sudo lsmod
Module                  Size  Used by
zptty                   8529  0
udmabuf                10177  0
fpgacfg                12287  0
dtbocfg                 3200  2
```

```
fpga@debian-fpga:~$ sudo systemctl status device-tree-overlay.service
● device-tree-overlay.service - Device Tree Overlay Service.
   Loaded: loaded (/etc/systemd/system/device-tree-overlay.service; enabled)
   Active: active (exited) since Tue 2017-02-21 23:03:05 JST; 1min 19s ago
  Process: 1665 ExecStart=/sbin/modprobe dtbocfg (code=exited, status=0/SUCCESS)
 Main PID: 1665 (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/device-tree-overlay.service

Feb 21 23:03:05 debian-fpga systemd[1]: Started Device Tree Overlay Service..
```

```
fpga@debian-fpga:~$ sudo systemctl status fpga-manager.service
● fpga-manager.service - FPGA Manager Service.
   Loaded: loaded (/etc/systemd/system/fpga-manager.service; enabled)
   Active: active (exited) since Tue 2017-02-21 23:03:06 JST; 3min 44s ago
  Process: 1674 ExecStartPost=/usr/bin/fpgacfg-service.rb --install (code=exited, status=0/SUCCESS)
  Process: 1671 ExecStart=/sbin/modprobe fpgacfg (code=exited, status=0/SUCCESS)
 Main PID: 1671 (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/fpga-manager.service

Feb 21 23:03:06 debian-fpga systemd[1]: Started FPGA Manager Service..
```

```
fpga@debian-fpga:~$ sudo systemctl status udmabuf.service
● udmabuf.service - User space mappable DMA Buffer Service.
   Loaded: loaded (/etc/systemd/system/udmabuf.service; enabled)
   Active: active (exited) since Tue 2017-02-21 23:03:06 JST; 4min 26s ago
  Process: 1687 ExecStart=/sbin/modprobe udmabuf (code=exited, status=0/SUCCESS)
 Main PID: 1687 (code=exited, status=0/SUCCESS)
   CGroup: /system.slice/udmabuf.service

Feb 21 23:03:06 debian-fpga systemd[1]: Started User space mappable DMA Buff....
Hint: Some lines were ellipsized, use -l to show in full.
```

```
fpga@debian-fpga:~$ sudo systemctl status zptty.service
● zptty.service - Pseudo TTY Driver for communication with FPGA.
   Loaded: loaded (/etc/systemd/system/zptty.service; enabled)
   Active: active (exited) since Tue 2017-02-21 23:03:06 JST; 5min ago
  Process: 1694 ExecStart=/sbin/modprobe zptty (code=exited, status=0/SUCCESS)
 Main PID: 1694 (code=exited, status=0/SUCCESS)

Feb 21 23:03:06 debian-fpga systemd[1]: Started Pseudo TTY Driver for commun....
Hint: Some lines were ellipsized, use -l to show in full.
```

### Build debian8-rootfs-4.8.17.tgz

```
shell# mount /dev/sdc2 /mnt/usb2
shell# cd /mnt/usb2
shell# tar cfz debian8-rootfs-4.8.17.tgz *
shell# umount /mnt/usb2
```
