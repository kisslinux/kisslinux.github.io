ACPID
________________________________________________________________________________

Acpid is a daemon that executes certain actions whenever ACPI events are
received. Depending on your hardware and kernel configuration, these events
include closing a laptop lid, connecting to an AC power adapter, pressing
buttons and more.


Index
________________________________________________________________________________

- Usage                                                                    [0.0]
- Kernel Setup                                                             [1.0]
- Busybox acpid                                                            [2.0]
- acpid2                                                                   [3.0]


[0.0] Usage
________________________________________________________________________________

KISS Linux offers two options for acpid management: busybox acpid, which is
installed by default, and acpid2 [1], which can be installed with the acpid
package. To use either version of acpid, you will need to enable a few kernel
options and enable the acpid service. See @/init/busybox.


[1.0] Kernel Setup
________________________________________________________________________________

ACPI-related kernel drivers must be enabled for acpid to function properly. In
menuconfig, these options are found under Power management and ACPI options
> Power Management support > ACPI support. Most of the drivers are
self-explanatory, but the following notable options can be safely disabled:

+------------------------------------------------------------------------------+
|                                                                              |
|   CONFIG_ACPI_PROCFS_POWER    This option is deprecated                      |
|   CONFIG_ACPI_EC_DEBUGFS      Potentially interferes with reboot             |
|   CONFIG_ACPI_TABLE_UPGRADE   KISS does not use an initrd by default         |
|   CONFIG_ACPI_DEBUG           Adds 50k to kernel size                        |
|   CONFIG_ACPI_PCI_SLOT        Usually unnecessary                            |
|   CONFIG_ACPI_CUSTOM_METHOD   Potential security flaw                        |
|                                                                              |
+------------------------------------------------------------------------------+


[2.0] Busybox acpid
________________________________________________________________________________

When events are received, acpid checks /etc/acpi.map for a matching event and
/etc/acpid.conf for a corresponding handler script in /etc/acpi/ to execute.

Create the files below to suspend your laptop whenever the lid is closed:

+------------------------------------------------------------------------------+
| /etc/acpi.map                                                                |
+------------------------------------------------------------------------------+
|                                                                              |
|   EV_SW 0x05 SW_LID 0 1 button/lid LID0 00000080                             |
|                                                                              |
+------------------------------------------------------------------------------+
| /etc/acpid.conf                                                              |
+------------------------------------------------------------------------------+
|                                                                              |
|   LID0 LID/00000080                                                          |
|                                                                              |
+------------------------------------------------------------------------------+
| /etc/acpi/LID/00000080                                                       |
+------------------------------------------------------------------------------+
|                                                                              |
|   #!/bin/sh                                                                  |
|                                                                              |
|   printf mem > /sys/power/state                                              |
|                                                                              |
+------------------------------------------------------------------------------+

Each line in /etc/acpi.map has six space-delimited fields:
    1. Type name (EV_SW),
    2. Type numerical value (0x05)
    3. Keycode name (SW_LID)
    4. Keycode numerical value (0)
    5. Value (1)
    6. Description (button/lid LID0 00000080)

Event types and keycodes are listed in /usr/include/linux/input-event-codes.h.
For example, a keyboard WLAN button event would use EV_KEY 0x05 and KEY_WLAN
238. The event value should be 1 and the event description can be any string
potentially including spaces.

Each line in /etc/acpid.conf has a key (LID0) and an action (LID/00000080). The
key is any unique substring of the event description in /etc/acpi.map and the
action is the relative path to an executable script in /etc/acpi/.

To see if a configured event is received, check /var/log/acpid.log for output
lines that list the path of your handler scripts.


[3.0] acpid2
________________________________________________________________________________

acpid2 is a more user-friendly version of acpid that avoids the tedious process
of mapping events with flexible configuration and better documentation. The
acpid package also installs acpi_listen which prints events as they occur. For
example, pressing the volume mute button will print something like this:

+------------------------------------------------------------------------------+
|                                                                              |
|   button/mute MUTE 00000080 00000000 K                                       |
|                                                                              |
+------------------------------------------------------------------------------+

When events are received, acpid2 checks files in /etc/acpi/event/ for a matching
event and a corresponding handler script to execute. Create the following files
to handle the mute button event by toggling the Master audio channel:

+------------------------------------------------------------------------------+
| /etc/acpi/event/anything                                                     |
+------------------------------------------------------------------------------+
|                                                                              |
|   event=.*                                                                   |
|   action=/etc/acpi/handler.sh %e                                             |
|                                                                              |
+------------------------------------------------------------------------------+
| /etc/acpi/handler.sh                                                         |
+------------------------------------------------------------------------------+
|                                                                              |
|   #!/bin/sh                                                                  |
|                                                                              |
|   case $1 in                                                                 |
|       button/mute)                                                           |
|           amixer sset Master toggle                                          |
|       ;;                                                                     |
|   esac                                                                       |
|                                                                              |
+------------------------------------------------------------------------------+

Files in /etc/acpi/event/ match events using event=REGEX with an action to
execute. In this example, .* matches all events and the action executes
/etc/acpi/handler.sh. The argument %e expands to five event parameters:
$1=button/mute, $2=MUTE, $3=00000080, $4=00000000, $5=K. The event parameters
provide an easy way to handle all events in a single script instead of the more
complex multi-file system used by busybox.


References
________________________________________________________________________________

[0] https://sourceforge.net/projects/acpid2
