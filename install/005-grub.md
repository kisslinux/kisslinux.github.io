---
title: Install grub
category: install
---

Build and install `grub`.

```
➜ kiss build grub
➜ kiss install grub

# Also needed for UEFI.
➜ kiss build efibootmgr
➜ kiss install efibootmgr
```

Setup `grub`.

```
# BIOS
➜ grub-install --target=i386-pc /dev/sdX
➜ grub-mkconfig -o /boot/grub/grub.cfg

# UEFI
# Replace 'esp' with its mount point.
➜ grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
➜ grub-mkconfig -o /boot/grub/grub.cfg
```
