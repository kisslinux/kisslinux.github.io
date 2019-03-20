# KISS

An ultra minimal Linux distribution.

- `musl` is used in place of `glibc`.
- `busybox` acts as the `coreutils`, `shell`, `init` etc.
- `lilo` is the bootloader.


**Links**

- Repository: <https://github.com/kissx/kiss>
- Package Manager: <https://github.com/kissx/pkg>


**STATUS**: Buildable inside a `chroot`.


## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Introduction](#introduction)
* [Installation](#installation)
* [Package Management](#package-management)
    * [`pkgfiles`](#pkgfiles)
* [Frequently Asked Questions](#frequently-asked-questions)
    * [Can I replace NAME program?](#can-i-replace-name-program)

<!-- vim-markdown-toc -->


## Introduction

KISS Linux in the simplest terms is a distribution simpler than Alpine with packages you must compile yourself. This distribution targets `x86_64` only and is meant for advanced users.

The distribution goes against the flow of the major distributions and back to a simpler system. None of the components are tied to the system and you can replace any portion of it.


## Installation

To install KISS you will need to hijack the live installation of another `musl` based Linux distribution. From there you need to manually partition the disks and install the distribution from a `chroot`.


## Package Management

Binaries are not provided, all programs must be built. KISS uses `pkg`, a package manager built for the distribution in POSIX `sh`. The workflow is `pkg b` to build the package and `pkg a pkg.tar.gz` to install the package.

KISS has no system-wide repositories. Instead you fork the main repository and manage things yourself. You can add new packages and modify existing ones. A simple `git pull` will update the repository and `git` will handle any conflicts for you.

This has the added benefit of making package contribution simple. A pull request from your fork is all that is needed. You can also keep branches for different machines; you have all that `git` offers at your fingertips.

### `pkgfiles`

Packages are stored in `pkgfiles` which are similar to `PKGBUILDS`/`APKBUILDS` but stupid simple. Here's how `musl` is built.

```
name=musl
version=1.1.21
release=1
desc="An efficient, small, quality libc implementation"
source="http://www.musl-libc.org/releases/musl-$version.tar.gz"
depends=""

build() {
    ./configure \
        --prefix=/usr

    make
    make DESTDIR="$BUILD" install
}
```

## Frequently Asked Questions

### Can I replace NAME program?

You can change any of the running software with the exception of `musl` and `gcc` (*though with some work this is doable*). None of it is tightly wrapped into the distributions workings.
