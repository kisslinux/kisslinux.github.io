---
title: "USE_FLAGS?"
---

KISS does not use the concept of `USE_FLAGS` for package customization, instead you create your own package repository and have full control over each and every package.

This keeps the package manager and the package files themselves simple and easy to maintain as they don't have to think about conditional dependencies, a configuration file or the nitty-gritty way this system would function underneath.


## What is a KISS repositoy?

A KISS repository is nothing more than a directory which you can optionally `git` track, host online and share with others.

Here's an example repository structure.

```
dylan-repo/
├─ gnupg/
│  ├─ build
│  ├─ checksums
│  ├─ sources
│  ├─ version
├─ mutt/
│  ├─ build
│  ├─ checksums
│  ├─ depends
│  ├─ sources
│  ├─ version
├─ st/
│  ├─ build
│  ├─ checksums
│  ├─ depends
│  ├─ files/
│  │  ├─ config.h
│  ├─ sources
│  ├─ version
├─ strace/
│  ├─ build
│  ├─ checksums
│  ├─ sources
│  ├─ version
└──┘
```
