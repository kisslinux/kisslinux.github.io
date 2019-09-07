---
title: KISS
---

An independent Linux® distribution with a focus on simplicity and the concept of "less is more". The distribution targets **only** the x86-64 architecture and the English language.

> “Simple can be harder than complex: You have to work hard to get your thinking clean to make it simple. But it's worth it in the end because once you get there, you can move mountains.” - Steve Jobs


## Philosophy

### Simplicity

This distribution follows the [KISS principle](https://en.wikipedia.org/wiki/KISS_principle) (*Keep it Simple Stupid*). Stupid in this context refers to the knowledge required to develop and maintain the distribution.

The word "simple" has many different interpretations in this context, is the distribution simple to use, simple to develop or simple in its implementation? Further the phrase "simple to use" differs depending on the person.

Users with a prior knowledge of Linux and basic programming skills will find KISS simple in all three examples given above. A user without prior knowledge may see KISS as the exact opposite.

Making things "easy" through GUI configuration tools, a next-next-next installation process and other niceties cause the system to become more and more complex.

The more code and documentation you add to a project, the more time it takes to maintain it and the risk of things going awry rises.

KISS does away with these things which gives additional responsibility to the user while at the same time giving them increased flexibility and in the end a simpler system.

### Less is more

KISS uses **less** software where possible and follows the belief that the less software/code running the less error prone the distribution will be overall.

Some of the more notable replacements to the rather bloated distribution software stack are `musl` (replaces `glibc`) and `busybox` (replaces `systemd`, `coreutils` and many other tools).

When running KISS you will find a lot of the software from your typical distribution absent from the repositories entirely. Software like `dbus`, `gettxt`, `intltool`, `ICU`, `polkit`, `pam`, `systemd`, `pulseaudio`, etc.

The absence of software from the repositories does **not** mean it cannot be installed. As a user you can package whatever you like or use a third-party repository.

It is easier to **add** things to a system than it is to **remove** them. You don't have to "de-bloat" KISS as it provides you with a minimal base you can extend to meet your personal needs.


