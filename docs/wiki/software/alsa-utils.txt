ALSA-UTILS [0]
________________________________________________________________________________

The Advanced Linux Sound Architecture (ALSA) provides audio and MIDI 
functionality to the Linux operating system. 


Configuration
________________________________________________________________________________

First verify that you have alsa-utils installed:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ kiss b alsa-utils && kiss i alsa-utils                                   |
|                                                                              |
+------------------------------------------------------------------------------+

By default, ALSA routes audio to card "0" and device "0" (see /etc/asound.conf
file), which may not be preferred. Luckily, we can change this behavior via 
local user configuration:

+------------------------------------------------------------------------------+
|   ~/.asoundrc, simple example                                                |
+------------------------------------------------------------------------------+
|                                                                              |
|   defaults.pcm!card 1                                                        |
|   defaults.pcm.!device 7                                                     |
|                                                                              |
+------------------------------------------------------------------------------+

In the example, the numeric device name is specified. When multiple sound cards 
are in use, the device numbers could be reordered across boots, such that using 
a descriptive device name is preferred.

You can then test your local sound card configuration with the command below:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ speaker-test -c 2                                                        |
|                                                                              |
+------------------------------------------------------------------------------+

Note: Replace the "2" to match the number of channels in your sound card.


Tips and Tricks
________________________________________________________________________________

- Use the following command to obtain a list of available sound card and device 
  numbers:
  
  +----------------------------------------------------------------------------+
  |                                                                            |
  |   $ aplay -L                                                               |
  |                                                                            |
  +----------------------------------------------------------------------------+

- A list of descriptive device names can be obtained with the following command:

  +----------------------------------------------------------------------------+
  |                                                                            |
  |   $ cat /sys/class/sound/card*/id                                          |
  |                                                                            |
  +----------------------------------------------------------------------------+

- Use the following command to open an easy to use, terminal based alsa control interface:
  
  +----------------------------------------------------------------------------+
  |                                                                            |
  |   $ alsamixer                                                              |
  |                                                                            |
  +----------------------------------------------------------------------------+

- More "complex" .asoundrc configuration file examples can be found on the 
  Gentoo Wiki [1] and Arch Linux Wiki [2].


References
________________________________________________________________________________

[0] https://www.alsa-project.org/wiki/Main_Page
[1] https://wiki.gentoo.org/wiki/ALSA
[2] https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture
