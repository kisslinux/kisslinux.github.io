[KISS](/) / [HANDBOOK](/handbook) / [BLOG](/posts)

# HANDBOOK

Welcome to KISS, a new independent distribution with a focus on simplicity. This guide will walk you through all of the required steps to install KISS on your hardware.

You may run into an issue while following the steps in this guide. Head on over to the [issue tracker](https://github.com/kissx/packages/issues) and open an issue. We are happy to help.

**NOTE**: This guide is a work in progress and is currently incomplete. This notice will be removed once the guide is complete.


## INDEX

<!-- vim-markdown-toc GFM -->

* [0 - GENESIS (Preamble)](#0---genesis-preamble)
* [1 - EXODUS (Setting up disks)](#1---exodus-setting-up-disks)
* [2 - LEVITICUS (Install KISS)](#2---leviticus-install-kiss)
* [3 - NUMBERS (Rebuild KISS)](#3---numbers-rebuild-kiss)
* [4 - DEUTERONOMY (Installing `linux`)](#4---deuteronomy-installing-linux)
* [5 - JOSHUA (Installing `grub`)](#5---joshua-installing-grub)
* [6 - JUDGES (Install `init-scripts`)](#6---judges-install-init-scripts)

<!-- vim-markdown-toc -->


## [0 - GENESIS (Preamble)](#0---genesis-preamble)

The installation is very similar to Gentoo's stage 3 `tarballs`.

An archive is used which contains a full KISS system minus the boot-loader and kernel. The provided archive contains all of the tooling needed to rebuild itself as well as the remaining packages needed for an installation.

You will need an existing Linux distribution to use as a base for the installation. It does not matter what kind of distribution it is nor does it matter what `libc` it uses.

For the purpose of this guide I will be using another Linux distribution's live-CD to bootstrap KISS. The workflow for the installation roughly follows the following steps.

1. Partition the disks.
2. Download KISS.
3. Rebuild KISS (optional)
    - You can also just install the bootstrap.
4. Copy KISS to `/`.
5. `chroot` into KISS.
6. Build the kernel.
7. Build `grub`.
8. Configure other little parts.

## [1 - EXODUS (Setting up disks)](#1---exodus-setting-up-disks)

Get the disks ready for the installation. This involves creating a partition table, partitions and the desired file-systems. This step will differ depending on whether or not you are doing a BIOS or EUFI installation.

This guide will **not** cover this step. If you require assistance with this step; read one of the links below. This step is not unique to KISS and there are tried and tested resources for all kinds of disk layouts online.

- <https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks>
- <https://wiki.archlinux.org/index.php/Installation_guide#Partition_the_disks>


## [2 - LEVITICUS (Install KISS)](#2---leviticus-downloading-kiss)

Download the latest release.

```
➜ wget https://github.com/kissx/packages/releases/download/0.0.6-musl/kiss-chroot-0.0.6.tar.xz

# Verify the download.
# Does it match?
# 62b14df28fb22ea4e37acbe7ffdcf2cff2db79a60bdee792711ecb6fd8707b52
➜ sha256sum kiss-chroot*
```

Download the `chroot` helper script.

```
➜ wget https://raw.githubusercontent.com/kissx/kiss-chroot/master/kiss-chroot

# Inspect the script before you execute it below.
➜ vi kiss-chroot

# Ensure the script is executable.
➜ chmod +x kiss-chroot
```

Unpack the `tarball` (Install KISS).

```
# Make sure all disks are mounted to '/mnt'.
➜ tar xvf kiss-chroot* -C /mnt --strip-components 1
```

Enter the `chroot`.

```
➜ ./kiss-chroot /mnt
```

## [3 - NUMBERS (Rebuild KISS)](#3---numbers-rebuild-kiss)

This step is **entirely optional** and you can just use the supplied binaries from the downloaded `chroot`.

Download the `bootstrap` helper script.

```
➜ wget https://raw.githubusercontent.com/kissx/kiss-bootstrap/master/kiss-bootstrap

# Inspect the script before you execute it below.
➜ vi kiss-bootstrap

# Ensure the script is executable.
➜ chmod +x kiss-bootstrap
```

Modify compiler options (optional):

```
➜ export CFLAGS=""
➜ export CXXFLAGS=""
➜ export MAKEFLAGS=""
```

Start rebuilding all packages:

```
➜  ./kiss-bootstrap -f
```

## [4 - DEUTERONOMY (Installing `linux`)](#4---deuteronomy-installing-linux)

```
➜ kiss install libelf
➜ kiss install linux
```

## [5 - JOSHUA (Installing `grub`)](#5---joshua-installing-grub)

Build and install `grub`.

```
➜ kiss install python
➜ kiss install automake
➜ kiss install grub

# Also needed for UEFI.
➜ kiss install popt
➜ kiss install efivar
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

## [6 - JUDGES (Install `init-scripts`)](#5---joshua-installing-grub)

This is the final "mandatory" step.

```
➜ kiss install baseinit
```

You should now be able to reboot into your KISS installation. Typical configuration should follow (hostname, creation of users, service configuration etc).
