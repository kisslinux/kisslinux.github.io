---
title: "USE_FLAGS?"
---

KISS does not use the concept of `USE_FLAGS` for package customization, instead you create your own package repository and have full control over each and every package.

This keeps the package manager and the package files themselves simple and easy to maintain as they don't have to think about conditional dependencies, a configuration file or the nitty-gritty way this system would function underneath.

**NOTE**: If you are unfamiliar with the package format in KISS, I recommend first reading this page: <https://getkiss.org/#package-system>


## Index

<!-- vim-markdown-toc GFM -->

* [What is a KISS repositoy?](#what-is-a-kiss-repositoy)
* [How do I create a repository?](#how-do-i-create-a-repository)
* [How do I copy a package into my repository?](#how-do-i-copy-a-package-into-my-repository)

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

**NOTE**: You can optionally fork the `community` repository to allow for merging of changes between your fork and KISS through `git`.

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

## How do I copy a package into my repository?

The `kiss s` (or `kiss search`) operator displays the full path to the first found match of a package name. This path points to the package's repository files and allows you to easily find and view information.

Examples:

```
➜ kiss s st
/home/goldie/dylan-repo/st

➜ kiss s vim
/home/goldie/projects/kiss-new/extra/vim

➜ kiss s btrfs-progs
/home/goldie/projects/community/community/btrfs-progs
```

Copying a package to your repository.

```
➜ cp -r "$(kiss s vim)" /path/to/myrepo
```

Turning this into a shell function for easier use.

```
pkgcp () {
    cp -r "$(kiss s "$1")" /path/to/myrepo
}

# Usage:
pkgcp vim
```
