---
title: <b>Install KISS</b>
---

Welcome to KISS, a new independent distribution with a focus on simplicity. This guide will walk you through the required steps to install KISS.

While this may be called a *guide* it will **not** take you through each step holding your hand along the way.

You may run into an issue while following the steps in this guide. Head on over to the [issue tracker](https://github.com/kisslinux/repo/issues) and open an issue. We are happy to help.

**NOTE**: KISS does not support booting using an `initramfs`. When configuring your kernel ensure that all required file-system, disk controller and USB drivers are built with `[*]` (Yes) and **not** `[m]` (Module).

## Preamble

The installation is very similar to Gentoo's stage 3 `tarballs`.

An archive is used which contains a full KISS system minus the boot-loader and kernel. The provided archive contains all of the tooling needed to rebuild itself as well as the remaining packages needed for an installation.

You will need an existing Linux distribution to use as a base for the installation. It does not matter what kind of distribution it is nor does it matter what `libc` it uses.

For the purpose of this guide I will be using another Linux distribution's live-CD to bootstrap KISS. From this point on; the guide assumes you have booted a live-CD and have an **internet connection**.


## Let's go

[Setting up the disks ->](https://getkiss.org/install/disks/)
