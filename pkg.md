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
* [Example `pkgfile`](#example-pkgfile)
* [Example package manifest](#example-package-manifest)
* [Example package checksums](#example-package-checksums)

<!-- vim-markdown-toc -->

## Introduction

The package manager for KISS is tiny and comes in at around `250` lines of code. The package manager has 5 basic functions; `build`, `add`, `del`, `list` and `checksum`.

**Build**

- Downloads the source files defined in the `pkgfile`.
- Verifies their checksums.
- All source files are moved to `build/src`.
- The package is built.
- The package is "installed" to `build/pkg`.
- The package's database entry is included in the package.
- Generates a `.manifest` containing the package's contents.
- Generates a `PKG-pkg_version-release.tar.gz` file.

**Add**

- Takes the mentioned tarball above.
- Uninstalls the previous version of the package (*if applicable*).
- Extracts the archive to `/` or `PKG_ROOT` if defined.

**Del**

- Reads the installed package's manifest.
- Deletes all files in the manifest.
- Deletes database entry (*it's in the manifest*).
- Deletes all directories in the manifest (*if empty*).

**List**

- List all installed packages.
- `pkg list pkgname` (*return 0 for installed, 1 for not-installed*)

**Checksum**

- Downloads all sources.
- Generates checksums for all package sources.


## Example `pkgfile`

- The working directory starts inside the package source.
- `$BUILD` is the destination directory (what goes in the package).

```
name=curl
version=7.64.0
release=1
desc="URL retrival utility and library"
source="https://curl.haxx.se/download/curl-$version.tar.xz"
depends="openssl zlib autoconf automake perl"

build() {
    autoreconf -vif

    ./configure \
        --prefix=/usr \
        --enable-ipv6 \
        --enable-unix-sockets \
        --enable-hidden-symbols \
        --without-libidn \
        --without-libidn2 \
        --disable-manual \
        --disable-ldap \
        --disable-ares \
        --without-libidn \
        --without-librtmp \
        --with-pic

    make
    make DESTDIR="$BUILD" install
}
```

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

## Example package checksums

```
a878fd281ed78e5a461ee7e8ab85546467bf24c20ac5069aed719daff34d33d0  signify-0.1p1.tar.gz
c752016319c5c70daaa08533c4fbd429f0244538fb214bfab2aed40788329486  fix-decls.patch
```
