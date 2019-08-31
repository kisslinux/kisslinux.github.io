---
title: <b>Install KISS</b>
category: main
---

Welcome to KISS, a new independent distribution with a focus on simplicity. This guide will walk you through the required steps to install KISS.

While this may be called a *guide* it will **not** take you through each step holding your hand along the way. A more comprehensive guide may be written in the future.

**NOTE**: KISS is still in its early days, tinkering, troubleshooting and general bug squashing may occur and should probably be expected at this point in time.

**NOTE**: KISS does not currently support booting using an `initramfs`. When configuring your kernel ensure that all required file-system, disk controller and USB drivers are built with `[*]` (Yes) and **not** `[m]` (Module).

**NOTE**: You may run into an issue while following the steps in this guide. Head on over to the [issue tracker](https://github.com/kisslinux/repo/issues) and open an issue. We are happy to help.


## Index

<!-- vim-markdown-toc GFM -->

* [Preamble](#preamble)
* [Setting up disks](#setting-up-disks)
* [Install KISS](#install-kiss)
* [Rebuild KISS](#rebuild-kiss)
* [Build userspace tools](#build-userspace-tools)
* [Configure and build the kernel](#configure-and-build-the-kernel)
    * [Download the kernel sources](#download-the-kernel-sources)
    * [Extract the kernel sources](#extract-the-kernel-sources)
    * [Configure the kernel](#configure-the-kernel)
    * [Build the kernel](#build-the-kernel)
    * [Install the kernel](#install-the-kernel)
* [Install grub](#install-grub)
* [Install init scripts](#install-init-scripts)
* [Enable the community repository](#enable-the-community-repository)
* [Further steps](#further-steps)

<!-- vim-markdown-toc -->

## Preamble

The installation is very similar to Gentoo's stage 3 `tarballs`.

An archive is used which contains a full KISS system minus the boot-loader and kernel. The provided archive contains all of the tooling needed to rebuild itself as well as the remaining packages needed for an installation.

You will need an existing Linux distribution to use as a base for the installation. It does not matter what kind of distribution it is nor does it matter what `libc` it uses.

For the purpose of this guide I will be using another Linux distribution's live-CD to bootstrap KISS. From this point on; the guide assumes you have booted a live-CD and have an **internet connection**.

## Setting up disks

Get the disks ready for the installation. This involves creating a partition table, partitions and the desired file-systems. This step will differ depending on whether or not you are doing a BIOS or UEFI installation.

The guide will **not** cover this step. If you require assistance with this step; read one of the links below. This step is not unique to KISS and there are tried and tested resources for all kinds of disk layouts online.

- <https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks>
- <https://wiki.archlinux.org/index.php/Installation_guide#Partition_the_disks>


## Install KISS

At this stage your disks should be setup and mounted to `/mnt`.

Download the latest release.

```
➜ wget https://dl.getkiss.org/kiss-chroot.tar.xz

# Verify the download, does it match?
# bc399782caf4bb8b6b131d63715604b1b35e3c95925eb6fd9a8c9d8978c047f9
➜ sha256sum kiss-chroot.tar.xz
```

Download the `chroot` helper script.

```
➜ wget https://dl.getkiss.org/kiss-chroot

# Inspect the script before you execute it below.
➜ vi kiss-chroot

# Ensure the script is executable.
➜ chmod +x kiss-chroot
```

Unpack the `tarball` (Install KISS).

```
# Make sure disks are first mounted to '/mnt'.
➜ tar xvf kiss-chroot.tar.xz -C /mnt --strip-components 1
```

Enter the `chroot`.

```
➜ ./kiss-chroot /mnt
```

## Rebuild KISS

This step is **entirely optional** and you can just use the supplied binaries from the downloaded `chroot`. This step can also be done after the installation.

Modify compiler options (optional):

```
# NOTE: The 'O' in '-O3' is the letter O and NOT 0 (ZERO).
➜ export CFLAGS="-O3 -pipe -march=native"
➜ export CXXFLAGS="-O3 -pipe -march=native"
➜ export MAKEFLAGS="-j4"
```

Start rebuilding all packages:

```
➜ kiss build
```

## Build userspace tools

```
# Required for mounting drives.
➜ kiss build e2fsprogs eudev

# Required for connecting to WIFI.
➜ kiss build dhcpcd wpa_supplicant
```

## Configure and build the kernel

This step involves configuring and building your own Linux kernel. If you have not done this before, below are a few guides to get you started.

- <https://kernelnewbies.org/KernelBuild>
- <https://wiki.gentoo.org/wiki/Kernel/Gentoo_Kernel_Configuration_Guide>
- <https://www.linuxtopia.org/online_books/linux_kernel/kernel_configuration/index.html>

The Linux kernel is **not** managed by the package manager. The kernel is managed manually by the user.

**NOTE**: KISS does not currently support booting using an `initramfs`. When configuring your kernel ensure that all required file-system, disk controller and USB drivers are built with `[*]` (Yes) and **not** `[m]` (Module).

### Download the kernel sources

You can find the latest version at <https://kernel.org/>.

```
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.2.10.tar.xz
```

### Extract the kernel sources

```
tar xvf linux-5.2.10.tar.xz

# Change directory to the kernel sources.
cd linux-5.2.10
```

### Configure the kernel

**NOTE**: You can determine which drivers you need to enable by Googling your hardware.

**NOTE**: If you require firmware blobs the drivers you enable must be enabled as `[m]` (modules).

```
# Install 'linux-firmware' if you require firmware
# blobs for your hardware.
kiss build linux-firmware
kiss install linux-firmware

# Generate a default config with *most* drivers
# compiled as `[*]` (not modules).
make defconfig

# Open an interactive menu to edit the generated
# config, enabling anything extra you may need.
#
# NOTE: You may need 'ncurses' to run 'menuconfig'.
#       Run 'kiss build ncurses && kiss install ncurses'.
make menuconfig

# Store the generated config for reuse later.
cp .config /path/to/somewhere
```

### Build the kernel

```
# '-j $(nproc)' does a parallel build using all cores.
make -j "$(nproc)"
```

### Install the kernel

**NOTE**: This requires `root`.

**NOTE**: Ignore the LILO error, it's harmless.

```
# Install the built modules.
# This installs directly to `/lib` (symlink to `/usr/lib`).
make modules_install

# Install the built kernel.
# This installs directly to `/boot`.
make install

# Rename the kernel.
# Substitute VERSION for the kernel version you have built.
mv /boot/vmlinuz /boot/vmlinuz-VERSION
mv /boot/System.map /boot/System.map-VERSION
```

## Install grub

Build and install `grub`.

```
➜ kiss build grub
➜ kiss install grub

# Also needed for UEFI.
➜ kiss build efibootmgr
➜ kiss install efibootmgr
```

Setup `grub`.

```
# BIOS
➜ grub-install --target=i386-pc /dev/sdX
➜ grub-mkconfig -o /boot/grub/grub.cfg

# UEFI
# Replace 'esp' with its mount point.
➜ grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
➜ grub-mkconfig -o /boot/grub/grub.cfg
```

## Install init scripts

This is the final "mandatory" step.

```
➜ kiss build baseinit
➜ kiss install baseinit
```

## Enable the community repository

The KISS community repository is maintained by users of the distribution and contains packages which aren't in the main repositories. This repository is disabled by default as it is not 100% maintained by the KISS developers as the other repositories are.

```
# Clone the repository to a location of your choosing.
git clone https://github.com/kisslinux/community.git

# Add the repository to the system-wide 'KISS_PATH'.
# The 'KISS_PATH' variable works exactly like 'PATH'.
# Each repository is split by ':' and is checked in
# the order they're written.
#
# Add the full path to the repository you cloned
# above.
#
# NOTE: The subdirectory must also be added.
# Example: export KISS_PATH=/var/db/kiss/repo/core:/var/db/kiss/repo/extra:/var/db/kiss/repo/xorg:/path/to/community/community
vi /etc/profile.d/kiss_path.sh

# Spawn a new login shell to access this repository
# immediately.
sh -l
```

## Further steps

You should now be able to reboot into your KISS installation. Typical configuration should follow (hostname, creation of users, service configuration etc).

If you encountered any issues during this guide, don't hesitate to open an issue on one of our GitHub repositories or join the IRC and Discord servers. We are happy to help!
