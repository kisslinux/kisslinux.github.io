[KISS](/) / [HANDBOOK](/handbook) / [BLOG](/posts)

# HANDBOOK

Welcome to KISS, a new independent distribution with a focus on simplicity. This guide will walk you through all of the required steps to install KISS on your hardware.

You may run into an issue while following the steps in this guide. Head on over to the [issue tracker](https://github.com/kissx/packages/issues) and open an issue. We are happy to help.

**NOTE**: This guide is a work in progress and is currently incomplete. This notice will be removed once the guide is complete.


## INDEX

<!-- vim-markdown-toc GFM -->

* [0 - GENESIS (Preamble)](#0---genesis-preamble)
* [1 - EXODUS (Setting up disks)](#1---exodus-setting-up-disks)
* [2 - LEVITICUS (Downloading KISS)](#2---leviticus-downloading-kiss)

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

**BIOS basic requirements**

- MBR partition table.
- Swap (optional)
- Remainder of disk (up to you).

**UEFI basic requirements**

- GPT partition table.
- 256-512MiB EFI system partition (at `/dev/sdX1`).
- Swap (optional)
- Remainder of disk (up to you).

This guide will **not** cover this step. If you require assistance with this step; read one of the links below.

- https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks
- https://wiki.archlinux.org/index.php/Installation_guide#Partition_the_disks

## [2 - LEVITICUS (Downloading KISS)](#2---leviticus-downloading-kiss)

Download the latest release.

```
➜ wget https://github.com/kissx/packages/releases/download/0.0.4-musl/kiss-chroot-0.0.4.tar.xz

# Verify the download.
# Does it match?
# 2c422301e710da739cd5aa8bce110f42f37739469a959fa218d8775f82b60648
➜ sha256sum kiss-chroot.*
```

Unpack the `tarball`.

```
➜ tar xvf kiss-chroot.*
```

