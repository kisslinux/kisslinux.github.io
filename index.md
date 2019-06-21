# KISS

A highly opinionated, ultra minimal, Linux distribution.

> Simplicity is the ultimate sophistication.<br>- Leonardo da Vinci

## Index

- [Status](#status)
- [Rationale](#rationale)
- [Repository](https://github.com/kissx/packages)
- [Package Manager](https://github.com/kissx/kiss)
- [Init Scripts](https://github.com/kissx/kiss-init)
- [Chroot Scripts](https://github.com/kissx/kiss-chroot)

## Status

First hardware boot to TTY!

<img src="../_assets/boot.jpg" alt="First hardware boot!">

The core KISS repository has been finalized and the distribution is at a stage where a functioning `chroot` can be built. The KISS `chroot` can also successfully built itself. There's no longer a reliance on another distribution.

The `rc.boot` and `rc.shutdown` scripts for the init-system are complete (I am using them on hardware already). Over the next few days the default services will be written and if all goes well a VM image will be released.


## Rationale

A Linux distribution specifically for desktop that aims to be simple, minimal and hackable. KISS is meant for users with prior Linux and programming knowledge and for those who want something simple.

The main repository will contain a minimal and curated package set. However, as a user you can easily create your own repository and package what you like. The tools are made available to you; KISS is just the base.

Packages in KISS employ a new concept. Instead of your typical sourceable shell scripts, multiple plain-text files are used. This new format is easily parseable in any programming language as file data is either separated by spaces or lines.

To showcase this concept, the reference package manager is written in around 200 lines of POSIX `sh`. Nothing stops you from interfacing with the repositories outside of the base package manager. You can easily write your own tools.
