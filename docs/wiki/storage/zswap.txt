ZSWAP [0]
________________________________________________________________________________

zswap is a feature built-in to the Linux kernel [1] which allows users to 
utilize compressed caches in RAM as swap pages. Instead of the kernel 
immediately swapping pages in RAM and writing them to the hard drive, wasting 
time on I/O operations, it compresses them into a pool in RAM. Only when the 
available RAM is exhausted will the kernel then write-out the least recently 
used page as an uncompressed file to swap on the drive.

When swap will be used, zswap should provide performance improvements.


Prerequisites
________________________________________________________________________________

zswap works in conjuction with swap and is handled entirely by the kernel. As
such, there are only two requirements: zswap enabled in the kernel and a
swapfile or swap partition on the system.

Several compression options are available for zswap. The choice is use-case
dependent, with the primary trade-offs being speed or size. See [2] for example
benchmarks of compressors in general.

Ensure zswap (CONFIG_ZSWAP) support and a compressor are enabled in the kernel:

+------------------------------------------------------------------------------+
|                                                                              |
|   Memory Management options --->                                             |
|       <*> Compressed cache for swap pages                                    |
|           Compressed cache for swap pages default compressor (xxx)           |
|           Compressed cache for swap pages default allocator (xxx)            |
|       <*> Enable the compression cache for swap pages by default             |
|                                                                              |
+------------------------------------------------------------------------------+

Either set CONFIG_ZSWAP_DEFAULT_ON=y in the kernel config or add zswap_enabled=1
to your kernel command line (via the bootloader or the built-in command line) to
have zswap enabled at boot-time. To enable zswap at runtime,

+------------------------------------------------------------------------------+
|                                                                              |
|   $ echo 1 > /sys/module/zswap/parameters/enabled                            |
|                                                                              |
+------------------------------------------------------------------------------+

zswap has many options that can also be configured at runtime, including which
compressor is in use. To see them all, 

+------------------------------------------------------------------------------+
|                                                                              |
|   $ grep -R . /sys/module/zswap/parameters                                   |
|                                                                              |
+------------------------------------------------------------------------------+

For information on setting up a swapfile or swap partition, see @/storage/disks.


zbud versus z3fold versus zsmalloc
________________________________________________________________________________

There are three different allocators to choose from for compressed pages:

+-------------+----------------------------------------------------------------+
| Allocator   | Description                                                    |
|-------------+----------------------------------------------------------------|
|             |                                                                |
| zbud        | Uses a 2:1 compressed:uncompressed page allocation (legacy)    |
| z3fold      | Uses a 3:1 ratio                                               |
| zsmalloc    | Designed for zram - better under low memory conditions         |
|             |                                                                |
+-------------+----------------------------------------------------------------+

In general, z3fold should be preferred to zbud; the latter is supported solely
for compatibility purposes. z3fold provides a better compression ratio and
should be preferred when possible. 

zsmalloc has a very different page allocation method than either zbud or z3fold,
and provides for greater storage density. However, zsmalloc does not implement
compressed page eviction; it can only reject new pages when full.

For more information on z3fold and zsmalloc, see [3] and [4].


References
________________________________________________________________________________

[0] https://kernel.org/doc/html/latest/vm/zswap.html
[1] https://lkml.iu.edu/hypermail/linux/kernel/1212.1/01472.html
[2] https://github.com/lz4/lz4
[3] https://kernel.org/doc/html/latest/vm/z3fold.html
[4] https://kernel.org/doc/html/latest/vm/zsmalloc.html
