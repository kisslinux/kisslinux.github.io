---
title: Package System
---

The distribution employs a package system based around the concept of easily parseable plain-text files (*separated by lines and spaces*). This format allows effortless interface using any programming language or just basic UNIX tools.

## Directory Structure

```
zlib/            # Package name.
├─ build         # Build script (must be executable).
├─ depends       # Dependencies (usually required).
├─ sources       # Remote and local sources.
├─ version       # Package version.
┘

# Optional files.
├─ pre-remove    # Pre-remove script (must be executable).
├─ post-install  # Post-install script (must be executable).
├─ patches/*     # Directory to store patches.
├─ files/*       # Directory to store misc files.
┘
```

## build

The `build` file should contain all of the steps necessary to patch, configure, make and install (*`make install` in this context*) the package.

The script is language agnostic and the only requirement is that it be executable. On execution the script will start in the directory of the package's source (*there is no need to change the working directory*).

The script is also given a single argument (*equivalent to `script arg`*), this argument contains the path where the script should install the compiled files. Everything in the path is added to the package tarball and later installed to the system.

### Example build file

```
#!/bin/sh -e

# Disable stripping (add this line only if needed).
:> nostrip

./configure \
    --prefix=/usr

make
make DESTDIR="$1" install
```

## depends

The `depends` file should contain any other packages the package depends on to function correctly. Each dependency should be listed one per line and an optional second field allows for the distinction between a compile time dependency and a run time one.

### Example depends file

```
# Comments are also supported.
perl make
zlib
```

## sources

The `sources` file should contain all remote and local files the package needs to be built. This includes the source, patches and any other miscellaneous files which may be needed.

Each source should be listed one per line. An optional second field specifies an extraction directory (*relative to the build directory*).

Sources which pull from a `git` repository use a special syntax. An additional prefix `git+` should be added with an optional suffix `#hash` or `#branch`).

### Example sources file

```
https://roy.marples.name/downloads/dhcpcd/dhcpcd-8.0.2.tar.xz
files/dhcpcd.run
```

### Example sources file with optional fields

```
https://gcc.gnu.org/pub/gcc/releases/gcc-9.1.0/gcc-9.1.0.tar.xz gcc
https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz gcc/gmp
http://www.mpfr.org/mpfr-4.0.2/mpfr-4.0.2.tar.xz gcc/mpfr
https://ftp.gnu.org/gnu/mpc/mpc-1.1.0.tar.gz gcc/mpc
files/c99
```

### Example sources file using `git`.

```
git+https://github.com/dylanaraps/eiwd

# Grabbing a specific commit.
git+https://github.com/dylanaraps/eiwd#8deb4ff84e3ed7b6f4f85b1259c6a0d88e137c7d
```

## version

The `version` file should contain a single line with two fields. The first field should contain the software's upstream version and the second field should contain the version number of the repository files themselves.

If the package is using a `git` source to pull down the latest commit, the version should be simply set to `git`.

### Example version file

```
1.2.3 1
```

## post-install

The `post-install` file should contain anything that needs to be run **after** a package installation to properly setup the software.

The script is language agnostic and the only requirement is that it be executable.

### Example post-install file

```
#!/bin/sh -e

/usr/sbin/update-ca-certificates --fresh
```

## patches/*

The patches directory should contain any patches the software needs. In the `sources` file patches are referred to by using a relative path (`patches/musl.patch`).

The package manager **does not** automatically apply patches. This must be done in the `build` script of the package. The build script has direct access to the patches in its current working directory.

### Example build file with patches

```
#!/bin/sh -e

patch -p1 < rxvt-unicode-kerning.patch
patch -p1 < gentables.patch

./configure \
    --prefix=/usr \
    --with-terminfo=/usr/share/terminfo \
    --enable-256-color \
    --disable-utmp \
    --disable-wtmp \
    --disable-lastlog

make DESTDIR="$1" install
```

## files/*

The `files/` directory should contain any miscellaneous files the software needs. In the `sources` file, files are referred to by using a relative path (`files/busybox.config`).

The build script has direct access to the files in its current working directory.

### Example build file with files

```
#!/bin/sh -e

install -D kiss "$1/usr/bin/kiss"

# 'kiss_path.sh' is stored in 'files/kiss_path.sh'.
# The build script has direct access to it and it is
# added to the final tarball under /etc/profile.d/kiss_path.sh.
install -D kiss_path.sh "$1/etc/profile.d/kiss_path.sh"
```
