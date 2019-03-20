# KISS

An ultra minimal Linux distribution.

- `musl` is used in place of `glibc`.
- `busybox` acts as the `coreutils`, `shell`, `init` etc.
- `lilo` is the bootloader.


**Links**

- Repository: <https://github.com/kissx/kiss>
- Package Manager: <https://github.com/kissx/pkg>

<!-- vim-markdown-toc GFM -->

* [Package Management](#package-management)

<!-- vim-markdown-toc -->

## Package Management

KISS has no system-wide repositories. Instead you fork the main repository and manage things yourself. You can add new packages and modify existing ones. A simple `git pull` will update the repository and `git` will handle any conflicts for you.

This has the added benefit of making package contribution simple. A pull request from your fork is all that is needed.
