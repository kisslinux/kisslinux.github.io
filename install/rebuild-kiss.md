---
title: Rebuild KISS
category: install
---

This step is **entirely optional** and you can just use the supplied binaries from the downloaded `chroot`. This step can also be done after the installation.

Modify compiler options (optional):

```
# NOTE: The 'O' in '-O3' is the letter O and NOT 0 (ZERO).
➜ export CFLAGS="-O3 -pipe -march=native"
➜ export CXXFLAGS="-O3 -pipe -march=native"
➜ export MAKEFLAGS="-j4"
```

Start rebuilding all packages:

```
➜ kiss build
```

<br>

[<- **Install KISS**](https://getkiss.org/install/install-kiss/)<span class=r>[**Userspace Tools** ->](https://getkiss.org/install/userspace-tools/)</span>
