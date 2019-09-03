---
title: Install KISS
category: install
---

At this stage your disks should be setup and mounted to `/mnt`.

Download the latest release.

```
➜ wget https://dl.getkiss.org/kiss-chroot.tar.xz

# Verify the download, does it match?
# 655334e4b0ac03115cbf779fe3b16a0099b499dae672c2d3af706b6853ef76cd
➜ sha256sum kiss-chroot.tar.xz
```

Download the `chroot` helper script.

```
➜ wget https://dl.getkiss.org/kiss-chroot

# Inspect the script before you execute it below.
➜ vi kiss-chroot

# Ensure the script is executable.
➜ chmod +x kiss-chroot
```

Unpack the `tarball` (Install KISS).

```
# Make sure disks are first mounted to '/mnt'.
➜ tar xvf kiss-chroot.tar.xz -C /mnt --strip-components 1
```

Enter the `chroot`.

```
➜ ./kiss-chroot /mnt
```

