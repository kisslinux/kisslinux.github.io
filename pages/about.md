---
title: About
category: main
---

KISS is a highly opinionated and ultra minimal, Linux distribution. Simplicity takes precedence above all. The default installation is *just* minimal enough to rebuild itself and any additional packages the user desires.


## Index

<!-- vim-markdown-toc GFM -->

* [Package System](#package-system)
* [Package Manager](#package-manager)
* [History](#history)

<!-- vim-markdown-toc -->

## Package System

The package system was built specifically for KISS and employs a UNIX-like file model. Instead of the typical shell script with variables, arrays and functions; this system uses easily parseable plain text files.

The data in each file is separated by lines and spaces. The repository and packages can be manipulated and read using any programming language. The build script (*for each package*) can be written in whatever language you desire.


## Package Manager

The package manager ([`kiss`](https://github.com/kisslinux/kiss)) is written in 500~ lines of POSIX `sh` (*excluding comments and blank lines*). The intention is to showcase the package system's simplicity.


## History

KISS was started by [Dylan Araps](https://github.com/dylanaraps) (Creator of [`neofetch`](https://github.com/dylanaraps/neofetch), [`pywal`](https://github.com/dylanaraps/pywal) and the [pure bash bible](https://github.com/dylanaraps/pure-bash-bible)) in March of 2019. A few months into the project, a long time contributor to `neofetch` and a member of [Artix Linux](https://artixlinux.org/), [Konimex (Muhammad Herdiansyah)](https://github.com/konimex) joined the project and brought with him additional knowledge and expertise.

With two developers at the helm and the bouncing back and forth of ideas; development accelerated, far exceeding the original planned time frame. The project also saw external testing, ideas and bug reports from a group of people in the Discord server and GitHub repositories.
