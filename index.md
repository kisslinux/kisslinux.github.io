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

* [Package Management](#package-management)
* [Installation](#installation)

<!-- vim-markdown-toc -->


## Package Management

Binaries are not provided, all programs must be built. KISS uses `pkg` a package manager built for the distribution in POSIX `sh`. The workflow is `pkg b` to build the package and `pkg a pkg.tar.gz` to install the package.

KISS has no system-wide repositories. Instead you fork the main repository and manage things yourself. You can add new packages and modify existing ones. A simple `git pull` will update the repository and `git` will handle any conflicts for you.

This has the added benefit of making package contribution simple. A pull request from your fork is all that is needed. You can also keep branches for different machines; you have all that `git` offers at your fingertips.


## Installation

To install KISS you will need to hijack the live installation of another `musl` based Linux distribution. From there you need to manually partition the disks and install the distribution from a `chroot`.
