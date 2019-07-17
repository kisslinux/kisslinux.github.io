---
title: KISS
---

A highly opinionated, ultra minimal, Linux distribution.

> “Simplicity is a great virtue but it requires hard work to achieve it and education to appreciate it. And to make matters worse: complexity sells better.” - Edsger Wybe Dijkstra


## Differences

- Plain text, UNIX-like package format.
- Package manager written in 500~ lines of POSIX `sh`.
- All shell code is **safe** and passes `shellcheck`.
    - `init` scripts.
    - Package `build` files.
    - Package manager.
    - Miscellaneous distribution scripts.
- `musl` instead of `glibc`.
- `busybox` instead of `GNU coreutils`.
- `libressl` instead of `openssl`.
- `busybox init` instead of `systemd`.
