---
title: FAQ
category: main
---

## Index

<!-- vim-markdown-toc GFM -->

* [What `init` system is used?](#what-init-system-is-used)
* [What software is excluded?](#what-software-is-excluded)
* [Why should I use this over X distribution?](#why-should-i-use-this-over-x-distribution)
* [Is full disk encryption supported?](#is-full-disk-encryption-supported)
* [Are USE flags supported?](#are-use-flags-supported)
* [How can I speed up GCC builds?](#how-can-i-speed-up-gcc-builds)
* [How do I change the keyboard layout?](#how-do-i-change-the-keyboard-layout)

<!-- vim-markdown-toc -->

## What `init` system is used?

The default `init` system is `busybox init` with `busybox runit` services.

## What software is excluded?

Software absent from the official repositories includes:

- `systemd`
- `dbus`
- `polkit`
- `GNU coreutils`/`glibc`
- `pam`
- `pulseaudio`/`pipewire`
- `gettext`/`intltool`
- `startup-notification`
- `wayland`
- `logind`/`elogind`
- `ConsoleKit2`
- `GNOME`/`KDE`/`XFCE4`/`MATE`

**NOTE**: This software can still be packaged by users and made available through personal or third-party repositories.

## Why should I use this over X distribution?

If you see no value in this distribution's philosophy, software choices and development, it isn't for you.

## Is full disk encryption supported?

Full disk encryption is supported through `dm-mod.create=`.

See:

- <https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/admin-guide/device-mapper/dm-init.rst>
- <https://cateee.net/lkddb/web-lkddb/DM_INIT.html>

## Are USE flags supported?

No.

Package customization is done through local repositories which enable full flexibility while keeping the package format, package manager and package build files **simple**.

## How can I speed up GCC builds?

If you are building an identical version of GCC or a new minor release (`9.1` -> `9.2`) you can speed up the build with the following `./configure` flag.

```
--disable-bootstrap
```

## How do I change the keyboard layout?

- Download the desired keymap from: <https://dev.alpinelinux.org/bkeymaps/>
- Run `loadkmap < file` to load it.
