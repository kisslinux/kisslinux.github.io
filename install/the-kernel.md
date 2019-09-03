---
title: Configure and build the kernel
category: install
---

This step involves configuring and building your own Linux kernel. If you have not done this before, below are a few guides to get you started.

- <https://kernelnewbies.org/KernelBuild>
- <https://wiki.gentoo.org/wiki/Kernel/Gentoo_Kernel_Configuration_Guide>
- <https://www.linuxtopia.org/online_books/linux_kernel/kernel_configuration/index.html>

The Linux kernel is **not** managed by the package manager. The kernel is managed manually by the user.

**NOTE**: KISS does not support booting using an `initramfs`. When configuring your kernel ensure that all required file-system, disk controller and USB drivers are built with `[*]` (Yes) and **not** `[m]` (Module).

### Download the kernel sources

You can find the latest version at <https://kernel.org/>.

```
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.2.11.tar.xz
```

### Extract the kernel sources

```
tar xvf linux-5.2.11.tar.xz

# Change directory to the kernel sources.
cd linux-5.2.11
```

### Configure the kernel

**NOTE**: You can determine which drivers you need to enable by Googling your hardware.

**NOTE**: If you require firmware blobs the drivers you enable must be enabled as `[m]` (modules).

```
# Install 'linux-firmware' if you require firmware
# blobs for your hardware.
kiss build linux-firmware
kiss install linux-firmware

# Generate a default config with *most* drivers
# compiled as `[*]` (not modules).
make defconfig

# Open an interactive menu to edit the generated
# config, enabling anything extra you may need.
#
# NOTE: You may need 'ncurses' to run 'menuconfig'.
#       Run 'kiss build ncurses && kiss install ncurses'.
make menuconfig

# Store the generated config for reuse later.
cp .config /path/to/somewhere
```

### Build the kernel

```
# '-j $(nproc)' does a parallel build using all cores.
make -j "$(nproc)"
```

### Install the kernel

**NOTE**: This requires `root`.

**NOTE**: Ignore the LILO error, it's harmless.

```
# Install the built modules.
# This installs directly to `/lib` (symlink to `/usr/lib`).
make modules_install

# Install the built kernel.
# This installs directly to `/boot`.
make install

# Rename the kernel.
# Substitute VERSION for the kernel version you have built.
# Example: 'vmlinuz-5.2.11'
mv /boot/vmlinuz /boot/vmlinuz-VERSION
mv /boot/System.map /boot/System.map-VERSION
```

<br>

[<- **Userspace Tools**](https://getkiss.org/install/userspace-tools/)<span class=r>[**Building Grub** ->](https://getkiss.org/install/grub/)</span>

<br>
