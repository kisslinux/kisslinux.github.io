---
title: Install KISS
---

The installation is very similar to Gentoo's stage 3 `tarballs`.

An archive is used which contains a full KISS system minus the boot-loader and kernel. The provided archive contains all of the tooling needed to rebuild itself as well as the remaining packages needed for an installation.

You will need an existing Linux distribution to use as a base for the installation. It does not matter what kind of distribution it is nor does it matter what `libc` it uses.

For the purpose of this guide I will be using another Linux distribution's live-CD to bootstrap KISS. The live-CD **must** include `tar` (with `xz` support), `mountpoint` and other basic utilities.

From this point on, the guide assumes you have booted a live-CD and have an **internet connection**.

## Index

<!-- vim-markdown-toc GFM -->

* [Setting up disks](#setting-up-disks)
* [Install KISS](#install-kiss)
    * [Download the latest release](#download-the-latest-release)
    * [Verify the checksums (*recommended*)](#verify-the-checksums-recommended)
    * [Verify the signature (*recommended*)](#verify-the-signature-recommended)
    * [Download the chroot helper](#download-the-chroot-helper)
    * [Unpack the tarball](#unpack-the-tarball)
    * [Enter the chroot](#enter-the-chroot)
* [Enable repository signing](#enable-repository-signing)
    * [Build and install gnupg1](#build-and-install-gnupg1)
    * [Import my (*Dylan Araps*) key](#import-my-dylan-araps-key)
    * [Enable signature verification](#enable-signature-verification)
* [Rebuild KISS](#rebuild-kiss)
    * [Modify compiler options (optional)](#modify-compiler-options-optional)
    * [Update all base packages to the latest versions](#update-all-base-packages-to-the-latest-versions)
    * [Rebuild all packages](#rebuild-all-packages)
* [Userspace tools](#userspace-tools)
    * [Filesystems](#filesystems)
    * [Device management](#device-management)
    * [WiFi (*optional*)](#wifi-optional)
    * [Dynamic IP addressing (*optional*)](#dynamic-ip-addressing-optional)
* [The Kernel](#the-kernel)
    * [Download the kernel sources](#download-the-kernel-sources)
    * [Download firmware blobs (*if required*)](#download-firmware-blobs-if-required)
    * [Configure the kernel](#configure-the-kernel)
    * [Build the kernel](#build-the-kernel)
    * [Install the kernel](#install-the-kernel)
* [The bootloader](#the-bootloader)
    * [Build and install grub](#build-and-install-grub)
    * [Setup grub](#setup-grub)
* [Install init scripts](#install-init-scripts)
* [Enable the community repository](#enable-the-community-repository)
* [Further steps](#further-steps)

<!-- vim-markdown-toc -->

## Setting up disks

Get the disks ready for the installation. This involves creating a partition table, partitions and the desired file-systems. This step will differ depending on whether or not you are doing a BIOS or UEFI installation.

The guide will **not** cover this step. If you require assistance with this step; read one of the links below. This step is not unique to KISS and there are tried and tested resources for all kinds of disk layouts online.

- [Gentoo wiki](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks)
- [Arch wiki](https://wiki.archlinux.org/index.php/Installation_guide#Partition_the_disks)


## Install KISS

Your disks should be setup and fully mounted to `/mnt`.

### Download the latest release

The download link below will always point to the latest version of KISS. If the checksums or signature fail to verify, [contact me](/pages/contact).

```
-> wget https://dl.getkiss.org/kiss-chroot.tar.xz
```

### Verify the checksums (*recommended*)

This step verifies that the release matches the `checksums` generated upon its creation and also ensures that the download completed successfully. ([What are checksums?](https://en.wikipedia.org/wiki/Checksum))

```
-> wget https://dl.getkiss.org/kiss-chroot.tar.xz.sha256
-> sha256sum kiss-chroot.tar.xz | diff kiss-chroot.tar.xz.sha256 - && echo good
```

### Verify the signature (*recommended*)

This step verifies that the release was signed by [Dylan Araps](/pages/team). If the live OS of your choice **does not** include `gpg`, this step can also be done on another machine. ([What is gpg?](https://en.wikipedia.org/wiki/GNU_Privacy_Guard))

```
-> wget https://dl.getkiss.org/kiss-chroot.tar.xz.asc

# Import my public key.
-> gpg --keyserver keys.gnupg.net --recv-key 46D62DD9F1DE636E

# Verify the signature.
-> gpg --verify kiss-chroot.tar.xz.asc kiss-chroot.tar.xz
```

### Download the chroot helper

This is a simple script to `chroot` into `/mnt` and set up the environment for the rest of the installation. ([What is chroot?](https://en.wikipedia.org/wiki/Chroot))

```
-> wget https://dl.getkiss.org/kiss-chroot

# Inspect the script before you execute it below.
-> vi kiss-chroot

# Ensure the script is executable.
-> chmod +x kiss-chroot
```

### Unpack the tarball

This step effectively **installs KISS** to `/mnt`. The tarball contains a full system minus the bootloader, kernel and optional utilities.

```
-> tar xvf kiss-chroot.tar.xz -C /mnt --strip-components 1
```

### Enter the chroot

On execution of this step you will be running KISS! The next steps involve  the kernel, software compilation and system setup.

```
-> ./kiss-chroot /mnt
```

## Enable repository signing

This step is **entirely optional** and can also be done after the installation. See [#60](https://github.com/kisslinux/kiss/issues/60) for more information.

Repository signing ensures that all updates have been signed by ([Dylan Araps](/pages/team)) and further prevents any unsigned updates from reaching your system.


### Build and install gnupg1

Welcome to the KISS package manager! These two commands are how individual packages are built and installed on a KISS system.

```
-> kiss build gnupg1
-> kiss install gnupg1
```

### Import my (*[Dylan Araps](/pages/team)*) key

If the GNU keyserver fails on your network, you can try an alternative mirror ([pgp.mit.edu](pgp.mit.edu) for example).

```
# Import my public key.
-> gpg --keyserver keys.gnupg.net --recv-key 46D62DD9F1DE636E

# Trust my public key.
-> echo trusted-key 0x46d62dd9f1de636e >> /root/.gnupg/gpg.conf
```

### Enable signature verification

Repository signature verification uses a feature built into `git` itself (`merge.verifySignatures`)! ([How does it work?](https://git-scm.com/docs/git-merge#Documentation/git-merge.txt---verify-signatures))

This can be disabled at any time using the inverse of the `git` command below.

The same steps can also be followed with 3rd-party repositories if the owner signs their commits.

```
-> cd /var/db/kiss/repo
-> git config merge.verifySignatures true
```

## Rebuild KISS

This step is **entirely optional** and you can just use the supplied binaries from the downloaded `chroot`. This step can also be done after the installation.

### Modify compiler options (optional)

These options have been tested and work with every package in the repositories. If you'd like to play it safe, use `-O2` or `-Os` instead of `-O3`.

If your system has a low amount of memory, omit `-pipe`. This option speeds up compilation but may use more memory.

If you intend to transfer packages between machines, omit `-march=native`. This option tells the compiler to use optimizations unique to your processor's architecture.

The `-jX` option should match the number of CPU cores available. You can optionally omit this, however builds will then be limited to a single core.

```
# NOTE: The 'O' in '-O3' is the letter O and NOT 0 (ZERO).
-> export CFLAGS="-O3 -pipe -march=native"
-> export CXXFLAGS="-O3 -pipe -march=native"

# NOTE: '4' should be changed to match the number of CPU cores.
-> export MAKEFLAGS="-j4"
```

### Update all base packages to the latest versions

This is how updates are performed on a KISS system. This command uses `git` to pull down changes from all enabled repositories and will then optionally handle the build/install process.

```
-> kiss update
```

### Rebuild all packages

Running `kiss build` without specifying packages will start a rebuild of all installed packages on the system.

**NOTE**: The package manager will prompt for user input on completion before installing the build packages.

```
-> kiss build
```

## Userspace tools

Each `kiss` action (build, install, etc) has a shorthand alias. From now on, `kiss b` and `kiss i` will be used in place of `kiss build` and `kiss install`.

### Filesystems

```
# Ext2, Ext3 and Ext4.
-> kiss b e2fsprogs
-> kiss i e2fsprogs

# Open an issue for additional filesystem support.
# Additional filesystems will go here.
```

### Device management

```
-> kiss b eudev
-> kiss i eudev
```

### WiFi (*optional*)

```
-> kiss b wpa_supplicant
-> kiss i wpa_supplicant
```

### Dynamic IP addressing (*optional*)

```
-> kiss b dhcpcd
-> kiss i dhcpcd
```

## The Kernel

This step involves configuring and building your own Linux kernel. If you have not done this before, below are a few guides to get you started.

- [KernelNewbies](https://kernelnewbies.org/KernelBuild)
- [Gentoo wiki](https://wiki.gentoo.org/wiki/Kernel/Gentoo_Kernel_Configuration_Guide)
- [Linuxtopia](https://www.linuxtopia.org/online_books/linux_kernel/kernel_configuration/index.html)

The Linux kernel is **not** managed by the package manager. The kernel is managed manually by the user.

**NOTE**: KISS does not support booting using an `initramfs`. When configuring your kernel ensure that all required file-system, disk controller and USB drivers are built with `[*]` (Yes) and not `[m]` (Module).

### Download the kernel sources

The following commands imply the `5.3.10` vanilla kernel. If you have chosen a different kernel, the commands are identical minus naming differences.

More kernel releases:

- `vanilla`: <https://kernel.org/>.
- `libre`: [https://www.fsfla.org/](https://www.fsfla.org/ikiwiki/selibre/linux-libre/#downloads)

A larger list of kernels can be found on the [Arch Wiki](https://wiki.archlinux.org/index.php/Kernel).


```
-> wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.10.tar.xz

# Extract the kernel sources.
-> tar xvf linux-5.3.10.tar.xz
-> cd linux-5.3.10
```

### Download firmware blobs (*if required*)

To keep the KISS repositories entirely FOSS, the proprietary kernel firmware is omitted. This also makes sense as the kernel itself is manually managed by the user.

**NOTE**: This step is only required if your hardware utilizes these drivers.

Sources: [kernel.org](https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/)

```
# Download and extract the firmware.
-> wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-20191022.tar.gz
-> tar xvf linux-firmware-20191022.tar.gz

# Copy the required drivers to '/usr/lib/firmware'.
mkdir -p /usr/lib/firmware
cp -R ./path/to/driver /usr/lib/firmware
```

### Configure the kernel

You can determine which drivers you need by searching the web for your hardware and the Linux kernel.

**NOTE**: If you require firmware blobs, the drivers you enable must be enabled as `[m]` (modules). You can also optionally include the firmware in the kernel itself.

```
# Generate a default config with *most* drivers
# compiled as `[*]` (not modules).
-> make defconfig

# Open an interactive menu to edit the generated
# config, enabling anything extra you may need.
#
# NOTE: You may need 'ncurses' to run 'menuconfig'.
#       Run 'kiss b ncurses && kiss i ncurses'.
-> make menuconfig

# Store the generated config for reuse later.
-> cp .config /path/to/somewhere
```

### Build the kernel

This may take a while to complete. The compilation time depends on your hardware and kernel configuration.

```
# '-j $(nproc)' does a parallel build using all cores.
-> make -j "$(nproc)"
```

### Install the kernel

**NOTE**: Ignore the LILO error, it's harmless.

```
# Install the built modules.
# This installs directly to `/lib` (symlink to `/usr/lib`).
-> make modules_install

# Install the built kernel.
# This installs directly to `/boot`.
-> make install

# Rename the kernel.
# Substitute VERSION for the kernel version you have built.
# Example: 'vmlinuz-5.3.10'
-> mv /boot/vmlinuz /boot/vmlinuz-VERSION
-> mv /boot/System.map /boot/System.map-VERSION
```

## The bootloader

The default bootloader is [grub](https://www.gnu.org/software/grub/) (*though nothing prevents you from using whatever bootloader you desire*).

This bootloader was chosen as most people are *familiar* with it, both BIOS and UEFI are supported and vast amounts of documentation for it exists.

**NOTE**: If using UEFI, the `efivars` filesystem may need to be mounted. See: [Mounting UEFI variables](/wiki/Mounting-UEFI-variables)

### Build and install grub

```
-> kiss b grub
-> kiss i grub

# Required for UEFI.
-> kiss b efibootmgr
-> kiss i efibootmgr
```

### Setup grub

```
# BIOS.
-> grub-install --target=i386-pc /dev/sdX
-> grub-mkconfig -o /boot/grub/grub.cfg

# UEFI (replace 'esp' with the EFI mount point).
-> grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
-> grub-mkconfig -o /boot/grub/grub.cfg
```

## Install init scripts

The default `init` is `busybox init` (*though nothing ties you to it*). The below commands install the bootup and shutdown scripts as well as the default `inittab` config.

Source code: <https://github.com/kisslinux/kiss-init>

```
-> kiss b baseinit
-> kiss i baseinit
```

## Enable the community repository

The KISS community repository is maintained by users of the distribution and contains packages which aren't in the main repositories. This repository is disabled by default as it is not maintained by the KISS developers.

```
# Clone the repository to a location of your choosing.
-> git clone https://github.com/kisslinux/community.git

# Add the repository to the system-wide 'KISS_PATH'.
# The 'KISS_PATH' variable works exactly like 'PATH'.
# Each repository is split by ':' and is checked in
# the order they're written.
#
# Add the full path to the repository you cloned
# above.
#
# NOTE: The subdirectory must also be added.
# Example: export KISS_PATH=/var/db/kiss/repo/core:/var/db/kiss/repo/extra:/var/db/kiss/repo/xorg:/path/to/community/community
-> vi /etc/profile.d/kiss_path.sh

# Spawn a new login shell to access this repository
# immediately.
-> sh -l
```

## Further steps

You should now be able to reboot into your KISS installation. Typical configuration should follow (*hostname, creation of users, service configuration etc*).

If you encountered any issues, don't hesitate to open an issue on one of our GitHub repositories, post on the [subreddit](https://reddit.com/r/kisslinux) or join the IRC server.

See: [Get in touch](https://getkiss.org/pages/contact/)
See: [The Wiki](https://getkiss.org/wiki/)
