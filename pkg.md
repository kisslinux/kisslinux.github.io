<a href='/'>KISS</a>

# pkg

The package manager for KISS Linux.

- Written in POSIX `sh`.
- Uses POSIX `coreutils`.
- Simple

**Links**

- Repository: <https://github.com/kissx/pkg>


## Table of Contents

<!-- vim-markdown-toc GFM -->

* [Introduction](#introduction)
* [Example package manifest](#example-package-manifest)

<!-- vim-markdown-toc -->

## Introduction

The package manager for KISS is tiny and comes in at around `250` lines of code. The package manager has 5 basic functions; `build`, `add`, `del`, `list` and `checksum`.

**Build**

- Downloads the source files defined in the `pkgfile`.
- Verifies their checksums.
- Builds the package.
- The package's database entry is included in the package.
- Generates a `.manifest` containing the package's contents.
- Generates a `pkg-version.tar.gz` file.

**Add**

- Takes the mentioned tarball above.
- Uninstalls the previous version of the package (*if applicable*).
- Extracts the archive to `/` or `PKG_ROOT` if defined.

**Del**

- Reads the installed package's manifest.
- Deletes all files in the manifest.
- Deletes all directories in the manifest (*if empty*).

**List**

- List all installed packages.
- `pkg list pkgname` (*return 0 for installed, 1 for not-installed*)

**Checksum**

- Generate checksums for all package sources.


## Example package manifest

- Files are listed first.
- Directories are listed next (*in reverse*).
- `/var/db/pkg` is the database entry.

```
/usr/include/gnumake.h
/usr/bin/make
/usr/share/info/dir
/usr/share/info/make.info-1
/usr/share/info/make.info
/usr/share/info/make.info-2
/usr/share/man/man1/make.1
/var/db/pkg/make/version
/var/db/pkg/make/manifest
/var/db/pkg/make
/var/db/pkg
/var/db
/var
/usr/share/man/man1
/usr/share/man
/usr/share/info
/usr/share
/usr/include
/usr/bin
/usr
```
