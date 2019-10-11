---
title: Package Manager
category: main
---

A tiny and straightforward package manager for KISS.

- Only 500~ lines of POSIX `sh` (*excluding blanks and comments*).
- Runtime dependency detection.
- Incremental package installation.
- Fast dependency solver.
- Package conflict detection.
- Binary stripping.
- `shellcheck` compliant.

Source code: <https://github.com/kisslinux/kiss>

## Usage:

```
➜ kiss
=> kiss [b|c|i|l|r|s|u] [pkg] [pkg] [pkg]
=> build:     Build a package.
=> checksum:  Generate checksums.
=> install:   Install a package.
=> list:      List installed packages.
=> remove:    Remove a package.
=> search:    Search for a package.
=> update:    Check for updates.
```

## Extending the package manager

See: <https://github.com/kisslinux/kiss-utils>
