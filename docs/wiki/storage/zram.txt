ZRAM [0]
________________________________________________________________________________

zram is a kernel feature which allows for the creation of compressible ramdisks,
or RAM-based block devices. These virtual devices can be used to extend the
amount of RAM available on a system by utilizing in-RAM compression, in a
similar sense to how swap is used in low-memory conditions. Unlike zswap, zram
does not require a swapfile or swap partition to exist on a drive. As a result, 
zram can be incredibly useful on systems where memory availability is low and
disk-space is at a premium.


Prerequisites
________________________________________________________________________________

zram is managed by the kernel and requires very little user intervention to 
enable and configure. First, ensure zram is enabled in the kernel:

+------------------------------------------------------------------------------+
|                                                                              |
|   General setup --->                                                         |
|       <*> Support for paging of anonymous memory (swap)                      |
|                                                                              |
|   Memory Management options --->                                             |
|       <*> Memory allocator for compressed pages                              |
|                                                                              |
|   Device Drivers --->                                                        |
|       <*> Block devices --->                                                 |
|           <M> Compressed RAM block device support                            |
|                                                                              |
|   # To use the lz4 algorithm with zram,                                      |
|   Cryptographic API --->                                                     |
|       <*> LZ4 compression algorithm                                          |
|                                                                              |
|                                                                              |
+------------------------------------------------------------------------------+

lz4 is available in community. The default compression algorithm is lzo and
CONFIG_CRYPTO_LZO=y/m is forced when CONFIG_ZRAM=y/m.

Building compressed RAM block devices as a module is recommended because it
enables runtime block device creation. If it is built-in to the kernel, pass
zram.num_devices=X in the kernel commandline (bootloader or built-in).


Setup
________________________________________________________________________________

Compressed block devices can be setup on-the-fly or at boot-time. A quick 
method using an /etc/rc.d/zram.{boot,pre.shutdown} script is shown below. 
Because multiple ramdisks are allowed, it might be preferable to create 
multiple zram devices for better utilization on multicore systems. 

The compression used on zram block devices cannot be changed once the device is
initialized. This means that you cannot swap compression algorithms at run-time,
unlike with zswap.

$SIZE below can be given in bytes or suffixed by M,G.

+------------------------------------------------------------------------------+
|   /etc/rc.d/zram.boot                                                        |
+------------------------------------------------------------------------------+
|   #!/bin/sh -e                                                               |
|                                                                              |
|   # Create four zram devices for swap, one for tmpfs                         |
|                                                                              |
|   modprobe zram num_devices=5                                                |
|                                                                              |
|   # create zram devices of $SIZE 2G                                          |
|   # Use lz4 compression on the devices                                       |
|   # Mark the devices as swap devices                                         |
|   # Enable the swap devices                                                  |
|                                                                              |
|   for dev in 0 1 2 3; do                                                     |
|       echo lz4 > "/sys/block/zram$dev/comp_algorithm"                        |
|       echo 2G >  "/sys/block/zram$dev/disksize"                              |
|       mkswap     "/dev/zram$dev"                                             |
|       swapon     "/dev/zram$dev" -p 10                                       |
|   done                                                                       |
|                                                                              |
|   # Create a 4G ext4 zram device to use as tmpfs with lz4 compression        |
|                                                                              |
|   echo lz4  > /sys/block/zram4/comp_algorithm                                |
|   echo 4G   > /sys/block/zram4/disksize                                      |
|   mkfs.ext4   /dev/zram4                                                     |
|   mount       /dev/zram4 /tmp                                                |
|                                                                              |
|   # /tmp requires sticky bit permissions for nonroot user access             |
|   chmod 1777 /tmp                                                            |
|                                                                              |
+------------------------------------------------------------------------------+

+------------------------------------------------------------------------------+
|   /etc/rc.d/zram.pre.shutdown                                                |
+------------------------------------------------------------------------------+
|   #!/bin/sh -e                                                               |
|                                                                              |
|   # Disable the swap devices                                                 |
|   # Reset the swap devices                                                   |
|   for dev in 0 1 2 3; do                                                     |
|       swapoff "/dev/zram$dev"                                                |
|       echo 1 > "/sys/block/zram$dev/reset"                                   |
|   done                                                                       |
|                                                                              |
|   # Unmount /tmp, reset zram device                                          |
|   umount /dev/zram4                                                          |
|   echo 1 > /sys/block/zram4/reset                                            |
|                                                                              |
+------------------------------------------------------------------------------+

Note: because zram has a 2:1 compression ratio, a total disk size of no more 
than twice the amount of available RAM should be selected - otherwise, space 
will be wasted.

In addition to manipulating values in /sys/block/zramX/*, users can use the
zramctl program provided by util-linux to manage their zram devices. See [1] for
more information.


References
________________________________________________________________________________

[0] https://kernel.org/doc/Documentation/blockdev/zram.txt
[1] https://man7.org/linux/man-pages/man8/zramctl.8.html
