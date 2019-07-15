---
title: About
category: main
---

KISS is a highly opinionated and ultra minimal, Linux distribution. Simplicity takes precedence above all. The default installation is *just* minimal enough to rebuild itself and any additional packages the user desires.


## Index

<!-- vim-markdown-toc GFM -->

* [Package System](#package-system)
* [Package Manager](#package-manager)

<!-- vim-markdown-toc -->

## Package System

The package system was built specifically for KISS and employs a UNIX-like file model. Instead of the typical shell script with variables, arrays and functions; this system uses easily parseable plain text files.

The data in each file is separated by lines and spaces. The repository and packages can be manipulated and read using any programming language. The build script (*for each package*) can be written in whatever language you desire.

## Package Manager

The package manager is called [`kiss`](https://github.com/kissx/kiss) and is written in 500~ lines of POSIX `sh`. This was done as `sh` is available by default and it worked as a showcase of the package system's simplicity.
