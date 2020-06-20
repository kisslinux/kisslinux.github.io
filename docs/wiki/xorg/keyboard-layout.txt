SETTING THE KEYBOARD LAYOUT IN X
________________________________________________________________________________


Using setxkbmap
________________________________________________________________________________


First, install setxkbmap:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ kiss b setxkbmap && kiss i setxkbmap                                     |
|                                                                              |
+------------------------------------------------------------------------------+

Available layouts can be found in /usr/share/X11/xkb/symbols/ and set from the
command line:

+------------------------------------------------------------------------------+
|                                                                              |
|  $ setxkbmap latam                                                           |
|                                                                              |
+------------------------------------------------------------------------------+

Put the above command in ~/.xinitrc to load it whenever an X session is started.


Exiting xorg configuration files
________________________________________________________________________________

Create 00-keyboard.conf in /etc/X11/xorg.conf.d/ and edit the Xkb* options
below to suit your needs. [0]

+------------------------------------------------------------------------------+
|                                                                              |
|   Section "InputClass"                                                       |
|       Identifier          "system-keyboard"                                  |
|       MatchIsKeyboard     "on"                                               |
|       Option "XkbLayout"  "de"                                               |
|       Option "XkbModel"   "pc105"                                            |
|       Option "XkbVariant" ",qwertz"                                          |
|       Option "XkbOptions" "grp:alt_shift_toggle"                             |
|   EndSection                                                                 |
|                                                                              |
+------------------------------------------------------------------------------+


References
________________________________________________________________________________

[0] https://www.x.org/releases/X11R7.5/doc/input/XKB-Config.html
