Kernel configuration for IBM ThinkPad
________________________________________________________________________________


X230
________________________________________________________________________________

A defconfig is sufficent for the machine to boot. Sound and WIFI must be manu-
ally enabled. A firmware blob for INTEL Centrino Advanced-N 6205 is necessary.
It can be found in the root directory of the proprietary kernel firmware. Think-
Pad specific ACPI options _can_ be enabled.

+------------------------------------------------------------------------------+
|                                                                              |
|   $ make defconfig                                                           |
|   $ cp iwlwifi-6000g2a-6.ucode /usr/lib/firmware                             |
|                                                                              |
+------------------------------------------------------------------------------+

+------------------------------------------------------------------------------+
| .config                                                                      |
+------------------------------------------------------------------------------+
|                                                                              |
|   CONFIG_IWLWIFI=y                                                           |
|   CONFIG_IWLDVM=y                                                            |
|   CONFIG_EXTRA_FIRMWARE="iwlwifi-6000g2a-6.ucode"                            |
|   CONFIG_EXTRA_FIRMWARE_DIR="/usr/lib/firmware"                              |
|   CONFIG_SND_HDA_CODEC_REALTEK=y                                             |
|   CONFIG_THINKPAD_ACPI=y                                                     |
|                                                                              |
+------------------------------------------------------------------------------+
