---
title: FAQ
category: main
---

## Index

<!-- vim-markdown-toc GFM -->

* [What `init` system is used?](#what-init-system-is-used)
* [What `libc` is used?](#what-libc-is-used)
* [What `coreutils` is used?](#what-coreutils-is-used)
* [Why is the base system ~50MB?](#why-is-the-base-system-50mb)

<!-- vim-markdown-toc -->

## What `init` system is used?

The default `init` system is `busybox init` with `busybox runit` services.


## What `libc` is used?

The default `libc` is `musl`,


## What `coreutils` is used?

The default `coreutils` is `busybox`.


## Why is the base system ~50MB?

The base is large since it contains all of the software required to compile software.
