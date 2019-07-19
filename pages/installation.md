---
title: <b>Install KISS</b>
category: main
---

Welcome to KISS, a new independent distribution with a focus on simplicity. This guide will walk you through the required steps to install KISS.

You may run into an issue while following the steps in this guide. Head on over to the [issue tracker](https://github.com/kisslinux/repo/issues) and open an issue. We are happy to help.

**NOTE**: This guide is a work in progress and is currently incomplete. This notice will be removed in due time.


## Index

<!-- vim-markdown-toc GFM -->

* [Preamble](#preamble)
* [Setting up disks](#setting-up-disks)
* [Install KISS](#install-kiss)
* [Rebuild KISS](#rebuild-kiss)
* [Install the kernel](#install-the-kernel)
* [Install grub](#install-grub)
* [Install init scripts](#install-init-scripts)
* [Further steps](#further-steps)

<!-- vim-markdown-toc -->

## Preamble

The installation is very similar to Gentoo's stage 3 `tarballs`.

An archive is used which contains a full KISS system minus the boot-loader and kernel. The provided archive contains all of the tooling needed to rebuild itself as well as the remaining packages needed for an installation.

You will need an existing Linux distribution to use as a base for the installation. It does not matter what kind of distribution it is nor does it matter what `libc` it uses.

For the purpose of this guide I will be using another Linux distribution's live-CD to bootstrap KISS. From this point on; the guide assumes you have booted a live-CD.

## Setting up disks

Get the disks ready for the installation. This involves creating a partition table, partitions and the desired file-systems. This step will differ depending on whether or not you are doing a BIOS or UEFI installation.

The guide will **not** cover this step. If you require assistance with this step; read one of the links below. This step is not unique to KISS and there are tried and tested resources for all kinds of disk layouts online.

- <https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks>
- <https://wiki.archlinux.org/index.php/Installation_guide#Partition_the_disks>


## Install KISS

Download the latest release.

```
➜ wget https://dl.getkiss.org/kiss-chroot.tar.xz

# Verify the download, does it match?
# 5e34f4844b9b363229c292401418fa98f09491894d9b74681d2213acbaa5ff95
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
# Make sure all disks are mounted to '/mnt'.
➜ tar xvf kiss-chroot.tar.xz -C /mnt --strip-components 1
```

Enter the `chroot`.

```
➜ ./kiss-chroot /mnt
```

## Rebuild KISS

This step is **entirely optional** and you can just use the supplied binaries from the downloaded `chroot`.

Modify compiler options (optional):

```
➜ export CFLAGS="-O3 -pipe -march=native"
➜ export CXXFLAGS="-O3 -pipe -march=native"
➜ export MAKEFLAGS="-j4"
```

Start rebuilding all packages:

```
➜ kiss build
```

## Install the kernel

```
➜ kiss build linux
➜ kiss install linux
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
# UEFI (WIP)
# Replace 'esp' with its mount point.
➜ grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
➜ grub-mkconfig -o /boot/grub/grub.cfg

# BIOS
➜ grub-install --target=i386-pc /dev/sdX
➜ grub-mkconfig -o /boot/grub/grub.cfg
```

## Install init scripts

This is the final "mandatory" step.

```
➜ kiss build baseinit
➜ kiss install baseinit
```


## Further steps

You should now be able to reboot into your KISS installation. Typical configuration should follow (hostname, creation of users, service configuration etc).
