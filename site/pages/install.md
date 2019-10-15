---
title: Install KISS
---

The installation is very similar to Gentoo's stage 3 `tarballs`.

An archive is used which contains a full KISS system minus the boot-loader and kernel. The provided archive contains all of the tooling needed to rebuild itself as well as the remaining packages needed for an installation.

You will need an existing Linux distribution to use as a base for the installation. It does not matter what kind of distribution it is nor does it matter what `libc` it uses.

For the purpose of this guide I will be using another Linux distribution's live-CD to bootstrap KISS. The live-CD **must** include `tar` (with `xz` support), `mountpoint` and other basic utilities.

From this point on, the guide assumes you have booted a live-CD and have an **internet connection**.

## Index

<!-- vim-markdown-toc GFM -->

* [Setting up disks](#setting-up-disks)
* [Install KISS](#install-kiss)
* [Enable repository signing](#enable-repository-signing)
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

## Setting up disks

Get the disks ready for the installation. This involves creating a partition table, partitions and the desired file-systems. This step will differ depending on whether or not you are doing a BIOS or UEFI installation.

The guide will **not** cover this step. If you require assistance with this step; read one of the links below. This step is not unique to KISS and there are tried and tested resources for all kinds of disk layouts online.

- [Gentoo wiki](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks)
- [Arch wiki](https://wiki.archlinux.org/index.php/Installation_guide#Partition_the_disks)


## Install KISS

At this stage your disks should be setup and mounted to `/mnt`.

Download the latest release.

```
➜ wget https://dl.getkiss.org/kiss-chroot.tar.xz

# Recommended: Verify the download.
➜ wget https://dl.getkiss.org/kiss-chroot.tar.xz.sha256
➜ sha256sum kiss-chroot.tar.xz | diff kiss-chroot.tar.xz.sha256 - && echo good

# Recommended: Verify the download's signature.
➜ wget https://dl.getkiss.org/kiss-chroot.tar.xz.asc
➜ gpg --verify kiss-chroot.tar.xz.asc kiss-chroot.tar.xz
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

## Enable repository signing

This step is **entirely optional** and can also be done after the installation. See [#60](https://github.com/kisslinux/kiss/issues/60) for more information.

Build and install `gnupg1`:

```
➜ kiss build gnupg1
➜ kiss install gnupg1
```

Import my (*Dylan Araps*) key:

```
➜ gpg --recv-key 46D62DD9F1DE636E
```

Trust my public key:

```
➜ echo trusted-key 0x46d62dd9f1de636e >> /root/.gnupg/gpg.conf
```

Go to the system-wide repository:

```
➜ cd /var/db/kiss/repo
```

Enable signature verification:

```
➜ git config merge.verifySignatures true
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

Update all base packages to the latest versions:

```
➜ kiss update
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
➜ kiss build wpa_supplicant
➜ kiss install wpa_supplicant

# Required for connecting to the internet.
# (WIFI and Ethernet) (dynamic IP addressing).
➜ kiss build dhcpcd
➜ kiss install dhcpcd
```

## Configure and build the kernel

This step involves configuring and building your own Linux kernel. If you have not done this before, below are a few guides to get you started.

- [KernelNewbies](https://kernelnewbies.org/KernelBuild)
- [Gentoo wiki](https://wiki.gentoo.org/wiki/Kernel/Gentoo_Kernel_Configuration_Guide)
- [Linuxtopia](https://www.linuxtopia.org/online_books/linux_kernel/kernel_configuration/index.html)

The Linux kernel is **not** managed by the package manager. The kernel is managed manually by the user.

**NOTE**: KISS does not support booting using an `initramfs`. When configuring your kernel ensure that all required file-system, disk controller and USB drivers are built with `[*]` (Yes) and **not** `[m]` (Module).

### Download the kernel sources

You can find the latest version at <https://kernel.org/>.

```
➜ wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.6.tar.xz
```

### Extract the kernel sources

```
➜ tar xvf linux-5.3.6.tar.xz

# Change directory to the kernel sources.
➜ cd linux-5.3.6
```

### Configure the kernel

**NOTE**: You can determine which drivers you need to enable by Googling your hardware.

**NOTE**: If you require firmware blobs, the drivers you enable must be enabled as `[m]` (modules). You can also optionally include the firmware in the kernel itself.

```
# Install 'linux-firmware' if you require firmware
# blobs for your hardware.
➜ kiss build linux-firmware
➜ kiss install linux-firmware

# Generate a default config with *most* drivers
# compiled as `[*]` (not modules).
➜ make defconfig

# Open an interactive menu to edit the generated
# config, enabling anything extra you may need.
#
# NOTE: You may need 'ncurses' to run 'menuconfig'.
#       Run 'kiss build ncurses && kiss install ncurses'.
➜ make menuconfig

# Store the generated config for reuse later.
➜ cp .config /path/to/somewhere
```

### Build the kernel

```
# '-j $(nproc)' does a parallel build using all cores.
➜ make -j "$(nproc)"
```

### Install the kernel

**NOTE**: Ignore the LILO error, it's harmless.

```
# Install the built modules.
# This installs directly to `/lib` (symlink to `/usr/lib`).
➜ make modules_install

# Install the built kernel.
# This installs directly to `/boot`.
➜ make install

# Rename the kernel.
# Substitute VERSION for the kernel version you have built.
# Example: 'vmlinuz-5.3.6'
➜ mv /boot/vmlinuz /boot/vmlinuz-VERSION
➜ mv /boot/System.map /boot/System.map-VERSION
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

The KISS community repository is maintained by users of the distribution and contains packages which aren't in the main repositories. This repository is disabled by default since it's not maintained by the KISS developers.

```
# Clone the repository to a location of your choosing.
➜ git clone https://github.com/kisslinux/community.git

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
➜ vi /etc/profile.d/kiss_path.sh

# Spawn a new login shell to access this repository
# immediately.
➜ sh -l
```

## Further steps

You should now be able to reboot into your KISS installation. Typical configuration should follow (*hostname, creation of users, service configuration etc*).

If you encountered any issues, don't hesitate to open an issue on one of our GitHub repositories or join the IRC server.

See: [Get in touch](https://getkiss.org/pages/contact/)
