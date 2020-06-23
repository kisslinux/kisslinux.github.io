X11VNC [0]
________________________________________________________________________________

x11vnc allows one to view remotely and interact with real X displays (i.e. a 
display corresponding to a physical monitor, keyboard, and mouse) with any VNC 
viewer.


Dependencies
________________________________________________________________________________

Refer to the @/xorg/xorg-server page for X server and Window Manager setup and 
configuration.


Configuration
________________________________________________________________________________

First verify that you have x11vnc installed:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ kiss b x11vnc && kiss i x11vnc                                           |
|                                                                              |
+------------------------------------------------------------------------------+

Assuming that you have an X session already running, you can start x11vnc from
a virtual terminal:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ x11vnc -forever                                                          |
|                                                                              |
+------------------------------------------------------------------------------+

The "-forever" switch is not required, but prevents the x11vnc from exiting at
the end of a client session. For more information on this switch or additional 
switch options, refer to the man page [1].


Tips and Tricks
________________________________________________________________________________

* If x11vnc fails to start or you are not operating from a virtual terminal
  (e.g. over SSH), you may also need to specify the xauthority file location in
  addition to the display:

  +----------------------------------------------------------------------------+
  |   "sx" example, configured per #/wiki/xorg/sx                              |
  +----------------------------------------------------------------------------+
  |                                                                            |
  |   $ x11vnc -forever -display :1 -auth /home/USER/.config/sx/xauthority     |
  |                                                                            |
  +----------------------------------------------------------------------------+
  |   "startx" example, configured per #/wiki/xorg/startx                      |
  +----------------------------------------------------------------------------+
  |                                                                            |
  |   $ x11vnc -forever -display :1 -auth /home/USER/.Xauthority               |
  |                                                                            |
  +----------------------------------------------------------------------------+

  Note: Remember to replace USER with the name of the regular user.  

* You can start x11vnc in the background by passing the optional "-bg" switch.


References
________________________________________________________________________________

[0] https://github.com/LibVNC/x11vnc
[1] https://linux.die.net/man/1/x11vnc
