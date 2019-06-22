[KISS](/) / [HANDBOOK](/handbook) / [BLOG](/posts)

# HANDBOOK

Welcome to KISS, a new independent distribution with a focus on simplicity. This guide will walk you through all of the required steps to install KISS on your hardware.

You may run into an issue while following the steps in this guide. Head on over to the [issue tracker](https://github.com/kissx/packages/issues) and open an issue. We are happy to help.

**NOTE**: This guide is a work in progress and is currently incomplete. This notice will be removed once the guide is complete.


## Index

<!-- vim-markdown-toc GFM -->

* [0 - GENESIS](#0---genesis)
* [1 - EXODUS](#1---exodus)

<!-- vim-markdown-toc -->


## 0 - GENESIS

The installation is very similar to Gentoo's stage 3 `tarballs`.

An archive is used which contains a full KISS system minus the boot-loader and kernel. The provided archive contains all of the tooling needed to rebuild itself as well as the remaining packages needed for an installation.

You will need an existing Linux distribution to use as a base for the installation. It does not matter what kind of distribution it is nor does it matter what `libc` it uses.

Download the latest release.

```
wget https://github.com/kissx/packages/releases/download/0.0.3-musl/kiss-chroot-0.0.3.tar.xz
```

## 1 - EXODUS
