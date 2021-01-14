# Emulating a Raspberry Pi

While it may not be immediately obvious how this is related to assembly language programming, this tutorial is tied to my main objectives of developing expertise as a vulnerability science researcher in two ways. First, many of the assembly language tutorials I have been reading focus on ARM-based assembly and this should provide a suitable means for testing this code. Secondly, a large portion of my group has been using emulation for various purposes and at this point I have no real experience with it. The objective, therefore, is to gain a little experience with emulation while also establishing a platform for ARM-based assembly programming that doesn't require me to have an RPI sitting and available to program.

## Credits

As with most of the items on this site, this information is not unique to me. I will be working through a [tutorial](https://azeria-labs.com/emulate-raspberry-pi-with-qemu/) provided by [@Fox0x01](https://twitter.com/fox0x01) and [@azeria_labs](https://twitter.com/azeria_labs). Any credit goes to her and you should check out [her site](https://azeria-labs.com/).

## Setup

I wasted quite a bit of time trying to get my remote development enviornment working. I have an Ubuntu-based desktop in my office that is a beefy box and is perfect for this sort of thing. Additionally, it has VMWare Workstation installed and I would prefer to use that machine/VM instance as a "central" spot for this sort of work rather than having it installed on my laptop. This _shouldn't_ be too hard.

### Problem #1: VMWare is out of date

I updated my machine (normal patches) and rebooted. Without thinking about it, this caused a kernel update, which is normally no big deal. However, since I am currently interacting with the machine remotely, _and_ my machine is configured to only allow `sudo` with smartcard-based authentications, I was somewhat stuck. I tried a number of things, with `xforwarding` enabled, but couldn't get it to go... I kept getting prompted for my credentials in a way that wouldn't really process them. Then, I tried from a local Linux box with xforwarding and it sort of worked, but would fail under sudo to do xforwarding. I [found a little write-up](https://blog.mobatek.net/post/how-to-keep-X11-display-after-su-or-sudo/) that gave me some hints as to what to do.

```bash
# create an xauthority file for the root user
sudo touch /root/.Xauthority

# take my user's xauthority info and dump it into the root's
sudo xauth add $(xauth -f ~<username>/.Xauthority list|tail -1)

# get persistent sudo
sudo -i

# run vmware to trigger privileged updates to kernel
vmware
```

Now, I should be able to run vmware remotely.

### Problem #2: VMWare over XFowarding is painfully slow

Not sure there is a good solution here... it is what it is.

### Problem #3: VNC server isn't working 

There is a VNC server built-in to Ubuntu, but it is not properly configured, and there are [some known bugs](https://gitlab.gnome.org/GNOME/gnome-control-center/-/issues/999) with trying to configure/enable it remotely. I expect that, if I were able to sit directly at the console, I'd be fine, but alas, that is not currently an option.

Therefore, I (loosely) followed a [writeup](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-vnc-on-ubuntu-20-04-quickstart) that got me going. Once everything was installed and happy, I did something like the following:

```bash
# connect via SSH with proper port-forwarding
ssh -L 59000:localhost:5901 -C user@machine

# start the VNC server (I don't really want it running all the time)
vncserver -localhost -geometry 1920x1080 -depth 24

# connect to it via a regular VNC client

# kill the server when I'm done
vncserver -kill :1
```

With this in place, I was able to connect to the desktop via the Real VNC Viewer and drive VMWare Workstation with a reasonable level of performance. Now, I am _finally_ able to pick back up with the original tutorial.

### Configuring VM

I elected to utilize a VM to support the emulation. I set up an Ubuntu 20.04 desktop VM and fully patched it.

### Getting needed bits

Next, I downloaded the latest version of Raspberry PI OS. Specifically, I grabbed [https://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2021-01-12/2021-01-11-raspios-buster-armhf.zip](https://downloads.raspberrypi.org/raspios_armhf/images/raspios_armhf-2021-01-12/2021-01-11-raspios-buster-armhf.zip). I extracted the zip file to `~/Downloads/2021-01-11-raspios-buster-armhf.img`.

The other key item is the qemu kernel. Starting at [the linked github site](https://github.com/dhruvvyas90/qemu-rpi-kernel), I downloaded the latest version-4 kernel. Specifically, [https://raw.githubusercontent.com/dhruvvyas90/qemu-rpi-kernel/master/kernel-qemu-4.19.50-buster](https://raw.githubusercontent.com/dhruvvyas90/qemu-rpi-kernel/master/kernel-qemu-4.19.50-buster).

### Preparing my Machine

The following steps are self-explanatory and commented inline

```bash
# make a working directory and copy the downloaded bits into it
mkdir ~/qemu_vms
cd ~/qemu_vms
cp ~/Downloads/*.img .
cp ~/Downloads/kernel* .

# install qemu
sudo apt-get install qemu-system

# inspect the image file
fdisk -l ./2021-01-11-raspios-buster-armhf.img

Disk ./2021-01-11-raspios-buster-armhf.img: 3.71 GiB, 3963617280 bytes, 7741440 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x904a3764

Device                                 Boot  Start     End Sectors Size Id Type
./2021-01-11-raspios-buster-armhf.img1        8192  532479  524288 256M  c W95 FAT32 (LBA)
./2021-01-11-raspios-buster-armhf.img2      532480 7741439 7208960 3.4G 83 Linux
```

We see that the filesystem (.img2) starts at sector 532480. Now take that value and multiply it by 512, in this case it’s 512 * 532480 = 272629760 bytes. Use this value as an offset in the following command:

```bash
sudo mkdir /mnt/raspbian
sudo mount -v -o offset=272629760 -t ext4 ~/qemu_vms/2021-01-11-raspios-buster-armhf.img /mnt/raspbian

# now edit the ld preload
sudo vim /mnt/raspbian/etc/ld.so.preload
# comment out the one line in that file ('#') and then save/exit

# check fstab for any mmcblk0 entries
sudo vim /mnt/raspbian/etc/fstab

# if found (I didn't find any)...
# 1. Replace the first entry containing /dev/mmcblk0p1 with /dev/sda1
# 2. Replace the second entry containing /dev/mmcblk0p2 with /dev/sda2, save and exit.

# unmount the image
cd ~/
sudo umount /mnt/raspbian
```

Now we are ready to try to run it in an emulator. The following command should do it:

```bash

# NOTE: I changed the cpu and memory from the tutorial based on what the data sheet stated
# was accurate.
qemu-system-aarch64 -kernel ~/qemu_vms/kernel-qemu-4.19.50-buster -cpu cortex-a72 -m 256 -M versatilepb -serial stdio -append "root=/dev/sda2 rootfstype=ext4 rw" -hda ~/qemu_vms/2021-01-11-raspios-buster-armhf.img -redir tcp:5022::22 -no-reboot
```

As noted in the comments above, the Raspberry Pi 4 uses the [ARM Cortex-A72 chip](https://www.raspberrypi.org/documentation/hardware/raspberrypi/bcm2711/README.md)