---
title: "USE_FLAGS?"
---

KISS does not use the concept of `USE_FLAGS` for package customization, instead you create your own package repository and have full control over each and every package.

This keeps the package manager and the package files themselves simple and easy to maintain as they don't have to think about conditional dependencies, a configuration file or the nitty-gritty way this system would function underneath.


## Index

<!-- vim-markdown-toc GFM -->

* [What is a KISS repositoy?](#what-is-a-kiss-repositoy)
* [How do I create a repository?](#how-do-i-create-a-repository)

<!-- vim-markdown-toc -->


## What is a KISS repositoy?

A KISS repository is nothing more than a directory which you can optionally `git` track, host online and share with others.

Here's an example repository structure.

```
dylan-repo/
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

## How do I create a repository?

Creating a repository for KISS is as simple as creating a directory and adding it to the `KISS_PATH` environment variable.

NOTE: You can optionally fork the `community` repository to allow for merging of changes between your fork and KISS through `git`.

```
# Create a directory (this can be anywhere on the system).
➜ mkdir -p myrepo

# Adding your repository to the repository list.
# Put this in your `.profile` or `.shellrc` or etc.
➜ export KISS_PATH=:/path/to/myrepo:$KISS_PATH

# Forking your first package.
➜ cp -r "$(kiss s st)" myrepo

# Optionally git track it.
cd myrepo
git init
```
