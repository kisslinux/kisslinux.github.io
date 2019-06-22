[KISS](/) / [BLOG](/posts)

# elfutils

KISS uses `musl` by default as the `libc` implementation. This has its pros and it has its cons. Software compiled with `musl` is smaller in size and tends to be faster. `musl` is a lot simpler than `glibc`.

The major cons of using `musl` aren't exactly `musl`'s fault. It boils down to software using a plethora of "`glibc`-isms". Features which are exclusive to `glibc` and do not exist in `musl`.

The core repository does not include `elfutils` as it has zero official support for `musl`. The `elfutils` package is required to build the Linux kernel and is the sole reason it would have existed in the core repository.

There is another alternative which KISS has opted for, the old and dated `libelf` library. This library saw its last release in 2013, however it requires zero new dependencies and it works with `musl`.

The goal for the core repository was to keep it simple and this (old) library allows us to do so. Nothing is stopping you as a user from using `elfutils` in KISS, it just won't be a part of core.

Most "problem" software you'll come across requires a simple patch or two, however `elfutils` requires far more than that. Firstly 7 or so patches are required but in addition to that a myriad of workarounds.

`musl` has no `argp` implementation. The `argp` implementation [ripped out of `glibc`](https://pkgs.alpinelinux.org/package/edge/main/x86_64/argp-standalone) is typically used (there's also a ripped out `argp` from [`uclibc-ng`](https://github.com/xhebox/libuargp)).

`musl` uses `err.h` so a separate file to define `error.h` (which is used by `glibc`) is required.

`musl` is also missing the `fts` library functions which requires you to either rip it of `glibc` or in Void Linux and Alpine Linux's case, [from NetBSD](https://github.com/pullmoll/musl-fts/).

`glibc`'s `obstack` is also absent from `musl` requiring yet another ripped out [`glibc` library](https://github.com/pullmoll/musl-obstack) (Used again by Void Linux).

The amount of work and the packages, workarounds and patches required to ship `elfutils` in core was just not worth our while and so we went with the old `libelf`.

What's interesting is that `gcc` now compiles with `musl` without requiring a single patch! I hope in the future that more and more software will become compatible with `musl` (and other `libc` implementations).
