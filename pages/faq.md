---
title: FAQ
category: main
---

## Index

<!-- vim-markdown-toc GFM -->

* [General](#general)
    * [Why is the distribution called "KISS"?](#why-is-the-distribution-called-kiss)
    * [Why another Linux distribution?](#why-another-linux-distribution)
    * [Why is the logo a woman?](#why-is-the-logo-a-woman)
* [Software choices](#software-choices)
    * [What `coreutils` does KISS use?](#what-coreutils-does-kiss-use)
    * [What `libc` does KISS use?](#what-libc-does-kiss-use)
    * [What `init` system and service manager does KISS use?](#what-init-system-and-service-manager-does-kiss-use)

<!-- vim-markdown-toc -->


## General

### Why is the distribution called "KISS"?

The distribution is named after the [KISS Principle](https://en.wikipedia.org/wiki/KISS_principle); "Keep it simple stupid".

### Why another Linux distribution?

> I was swapping from distribution to distribution looking for something minimal, simple and well written. Not being satisfied by any of the existing options, I decided to swap to OpenBSD (*only to find that it did not support my hardware*). This pushed me to create my own distribution, reflecting my beliefs and desires.<br>- Dylan Araps (Creator of KISS)

### Why is the logo a woman?

The word "kiss" has a feminine connotation (at least in the eyes of the creator) and the logo/avatars reflect this.

## Software choices

### What `coreutils` does KISS use?

KISS uses `busybox`.

### What `libc` does KISS use?

KISS uses `musl`

### What `init` system and service manager does KISS use?

KISS uses `busybox init` with `runit` services (*which it supports*). The `init` system can also be configured to use `sysvinit` style scripts or just plain shell commands if you so desire. You have options.

The source for the boot scripts can be found here: <https://github.com/kisslinux/kiss-init>
