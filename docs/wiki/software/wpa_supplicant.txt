WPA_SUPPLICANT [0]
________________________________________________________________________________

wpa_supplicant is a cross-platform supplicant with support for WEP, WPA and WPA2
(IEEE 802.11i). It is suitable for desktops, laptops and embedded systems. It is 
the IEEE 802.1X/WPA component that is used in the client stations. It implements
key negotiation with a WPA authenticator and it controls the roaming and IEEE 
802.11 authentication/association of the wireless driver. 


Configuration
________________________________________________________________________________

Begin by first verifying that you have wpa_supplicant installed:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ kiss b wpa_supplicant && kiss i wpa_supplicant                           |
|                                                                              |
+------------------------------------------------------------------------------+

At this point, you will want to create a wpa_supplicant file to store your 
wireless network information and credentials:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ mkdir -p /etc/wpa_supplicant                                             |
|   $ touch /etc/wpa_supplicant/wpa_supplicant.conf                            |
|                                                                              |
+------------------------------------------------------------------------------+

The following wpa_supplicant.conf can be used as a *starter* configuration
file. Remember to replace the BSSID and PASSWORD with your actual wireless
network credentials.

+------------------------------------------------------------------------------+
|                                                                              |
|   # Allow users in the 'wheel' group to control wpa_supplicant               |
|   ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel                     |
|                                                                              |
|   # Make this file writable for wpa_gui / wpa_cli                            |
|   update_config=1                                                            |
|                                                                              |
|   network={                                                                  |
|          ssid="BSSID"                                                        |
|          psk="PASSWORD"                                                      |
|   }                                                                          |
|                                                                              |
+------------------------------------------------------------------------------+

For additional network requirements, refer to the "wpa_supplicant" Arch Linux 
Wiki page [0].


Generating a Passphrase
________________________________________________________________________________

NOTE: This section is not required but HIGHLY recommended since storing your
      password in clear text is not good practice. 

To allow for quicker connections to a network whose BSSID is already known, we
can make use of wpa_passphrase, a command line tool which generates the minimal
configuration needed by wpa_supplicant: 

+------------------------------------------------------------------------------+
|                                                                              |
|   $ wpa_passphrase BSSID PASSWORD                                            |
|                                                                              |
+------------------------------------------------------------------------------+

Replace BSSID and PASSWORD with your actual wireless network credentials. The 
output of this command can then be used to replace the network section of the 
wpa_supplicant.conf file created in the previous section (just remember to 
delete the line containing your password in clear text).


Manual Wireless Connection
________________________________________________________________________________

A new wireless connection can be manually started with the following command:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ wpa_supplicant -B -i INTERFACE \                                         |
|                       -c /etc/wpa_supplicant/wpa_supplicant.conf             |
|                                                                              |
+------------------------------------------------------------------------------+

Replace INTERFACE with your appropriate wireless LAN interface name. After, 
use your preferred method to manually obtain an IP address. For example, when 
using dhcpcd, run the following:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ dhcpcd INTERFACE                                                         |
|                                                                              |
+------------------------------------------------------------------------------+

The wireless status connection can be verified by reviewing the output of the
following command:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ ifconfig                                                                 |
|                                                                              |
+------------------------------------------------------------------------------+


Managed Wireless Connection via dhcpcd
________________________________________________________________________________

Assuming that dhcpcd is already installed, busybox's runsv can be used to create 
new managed services for wpa_supplicant and dhcpcd:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ ln -s /usr/share/dhcpcd/hooks/10-wpa_supplicant \                        |
|           /usr/lib/dhcpcd/dhcpcd-hooks/                                      |
|   $ ln -s /etc/sv/dhcpcd/ /var/service                                       |
|                                                                              |
+------------------------------------------------------------------------------+


Tips and Tricks
________________________________________________________________________________

* A list of possible INTERFACE names can be obtained by running the following:

  +----------------------------------------------------------------------------+
  |                                                                            |
  |   $ ls /sys/class/net                                                      |
  |                                                                            |
  +----------------------------------------------------------------------------+
  
* While testing arguments/configuration it may be helpful to launch 
  wpa_supplicant in the foreground (i.e. without the -B option) for better 
  debugging messages.


References
________________________________________________________________________________

[0] https://wiki.archlinux.org/index.php/wpa_supplicant
