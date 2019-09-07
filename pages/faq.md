---
title: FAQ
category: main
---

## Index

<!-- vim-markdown-toc GFM -->

* [What `init` system is used?](#what-init-system-is-used)
* [What `libc` is used?](#what-libc-is-used)
* [What `coreutils` is used?](#what-coreutils-is-used)
* [What software is excluded?](#what-software-is-excluded)
* [Why should I use this over X distribution?](#why-should-i-use-this-over-x-distribution)

<!-- vim-markdown-toc -->

## What `init` system is used?

The default `init` system is `busybox init` with `busybox runit` services.


## What `libc` is used?

The default `libc` is `musl`,


## What `coreutils` is used?

The default `coreutils` is `busybox`.


## What software is excluded?

Software absent from the official repositories includes:

- `systemd`
- `dbus`
- `polkit`
- `glibc`
- `GNU coreutils`
- `pam`
- `pulseaudio`
- `gettext`
- `intltool`
- `startup-notification`
- `pipewire`
- `wayland`

**NOTE**: This software can still be packaged by users and made available through personal or third-party repositories.

## Why should I use this over X distribution?

If you see no value in this distribution's philosophy, software choices and development, it isn't for you.
