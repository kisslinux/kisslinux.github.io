---
title: Package Manager
category: main
---

Source code: <https://github.com/kisslinux/kiss>

- Only 500~ lines of POSIX `sh` (*excluding blank lines and comments*).
- Runtime dependency detection.
- Incremental package installation.
- Fast dependency solver.
- Package conflict detection.
- Binary stripping.
- `shellcheck` compliant.

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
