---
title: FAQ
category: main
---

## Index

<!-- vim-markdown-toc GFM -->

* [Why is the distribution called "KISS"?](#why-is-the-distribution-called-kiss)
* [Why another Linux distribution?](#why-another-linux-distribution)
* [Why is the logo a woman?](#why-is-the-logo-a-woman)
* [Why `busybox`?](#why-busybox)
* [What `libc` does KISS use?](#what-libc-does-kiss-use)
* [What `init` system does KISS use?](#what-init-system-does-kiss-use)

<!-- vim-markdown-toc -->


## Why is the distribution called "KISS"?

The distribution is named after the [KISS Principle](https://en.wikipedia.org/wiki/KISS_principle); "Keep it simple stupid".

## Why another Linux distribution?

> I was swapping from distribution to distribution looking for something minimal and simple. Not being satisfied by any of the existing options, I decided to swap to OpenBSD (*only to find that it did not support my hardware*). This pushed me to create my own distribution, reflecting my beliefs and desires.<br>- Dylan Araps (Creator of KISS)

## Why is the logo a woman?

The word "kiss" has a feminine connotation (at least in the eyes of the creator) and the logo/avatars reflect this.

## Why `busybox`?

It's small, minimal and provides nearly everything needed. It also has a really nice feature which removes all overhead from running commands and spawning subshells. Everything is treated as a shell "builtin".

## What `libc` does KISS use?

KISS uses `musl`, it is small, correct and aligns with the overall views of the distribution.

## What `init` system does KISS use?

KISS uses `busybox init` with `runit` services (*which it supports*). The `init` system can also be configured to use `sysvinit` style scripts or just plain shell commands if you so desire. You have options.

The source for the boot scripts can be found here: <https://github.com/kissx/kiss-init>
