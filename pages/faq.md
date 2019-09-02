---
title: FAQ
category: main
---

## Index

<!-- vim-markdown-toc GFM -->

* [How should I refer to the distribution?](#how-should-i-refer-to-the-distribution)
* [Why is the distribution called "KISS"?](#why-is-the-distribution-called-kiss)
* [Why another Linux distribution?](#why-another-linux-distribution)
* [Why is the logo a woman?](#why-is-the-logo-a-woman)
* [Why is software X not in the repositories?](#why-is-software-x-not-in-the-repositories)
* [Why is there no `initramfs` support?](#why-is-there-no-initramfs-support)

<!-- vim-markdown-toc -->

## How should I refer to the distribution?

KISS is called "KISS", refer to it as so!


## Why is the distribution called "KISS"?

The distribution is named after the [KISS Principle](https://en.wikipedia.org/wiki/KISS_principle); "Keep it simple stupid".


## Why another Linux distribution?

> I was swapping from distribution to distribution looking for something minimal, simple and well written. Not being satisfied by any of the existing options, I decided to swap to OpenBSD (*only to find that it did not support my hardware*). This pushed me to create my own distribution, reflecting my beliefs and desires.<br>- Dylan Araps (Creator of KISS)


## Why is the logo a woman?

The word "kiss" has a feminine connotation (at least in the eyes of the creator) and the logo/avatars reflect this.


## Why is software X not in the repositories?

In keeping the system simple a lot of the typical software is intentionally excluded. There is no "Natural Language Support" (`gettext`, `intltool`, `ICU` etc), no `pam` or `polkit`, no `dbus`, no `pulseaudio`, no GNOME, no KDE etc.

This does **not** go on to say that these cannot be installed, they just aren't in the official repositories. KISS provides a minimal and extendible base with the belief that it is easier to **add** software than it is to **remove** it.

Users can create their own repositories and track them with `git`. Other users can then enable these repositories. I envision users creating repositories for the software which won't be included in the official repositories!

## Why is there no `initramfs` support?

KISS is usable without one (*minus **full** disk encryption*) and in terms of simplicity it's far simpler to not include one. There was an attempt to add support for it, however we failed in doing so.

This isn't to say that KISS won't ever include this functionality, pull requests will of course be accepted. If you're reading this and are willing to help out we'd appreciate it!
