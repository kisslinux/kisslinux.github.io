---
title: FAQ
---

May you find what you are looking for.

## Index

<!-- vim-markdown-toc GFM -->

* [Why should I use this over X distribution?](#why-should-i-use-this-over-x-distribution)
* [What init system is used?](#what-init-system-is-used)
* [Is full disk encryption supported?](#is-full-disk-encryption-supported)
* [Are USE flags supported?](#are-use-flags-supported)
* [How can I speed up GCC builds?](#how-can-i-speed-up-gcc-builds)
* [How can I easily fork a package?](#how-can-i-easily-fork-a-package)

<!-- vim-markdown-toc -->

## Why should I use this over X distribution?

If you see no value in this distribution's philosophy, software choices and development, it isn't for you.

## What init system is used?

The default init system is `busybox init` with `busybox runit` services.

## Is full disk encryption supported?

Full disk encryption is supported through `dm-mod.create=`.

See: [kernel.org](https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/admin-guide/device-mapper/dm-init.rst) and [cateee.net](https://cateee.net/lkddb/web-lkddb/DM_INIT.html)

## Are USE flags supported?

No.

Package customization is done through local repositories which enable full flexibility while keeping the package format, package manager and package build files **simple**.

## How can I speed up GCC builds?

If you are building an identical version of GCC or a new minor release (9.1 -> 9.2) you can speed up the build with the `--disable-bootstrap` configure flag.

## How can I easily fork a package?

```
# Create your own repository.
mkdir -p /path/to/myrepo

# Add it to 'KISS_PATH'.
# To make this permanent, add it to your '.profile' or '.shellrc'.
export KISS_PATH="/path/to/myrepo:$KISS_PATH

# Fork the package.
cp -r "$(kiss s pkg_name)" /path/to/myrepo
```
