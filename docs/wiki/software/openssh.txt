OPENSSH [0]
________________________________________________________________________________

OpenSSH (also known as OpenBSD Secure Shell) is a suite of secure networking
utilities based on the Secure Shell (SSH) protocol, which provides a secure 
channel over an unsecured network in a client-server architecture.


Remote Server Configuration
________________________________________________________________________________

Begin by first verifying that you have openssh installed on the remote server:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ kiss b openssh && kiss i openssh                                         |
|                                                                              |
+------------------------------------------------------------------------------+

Using busybox's runsv, create a new managed service for the ssh daemon:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ ln -s /etc/sv/sshd /var/service                                          |
|                                                                              |
+------------------------------------------------------------------------------+

At this point, you can either restart the remote server or manually start the 
SSH daemon:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ sv up sshd                                                               |
|                                                                              |
+------------------------------------------------------------------------------+


Client Authentication
________________________________________________________________________________

From an SSH client, use the following command to connect to the remote SSH 
server:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ ssh USERNAME@SERVER                                                      |
|                                                                              |
+------------------------------------------------------------------------------+

Replace USERNAME with the name of a regular user and SERVER with the hostname or 
IP address of the SSH remote server. Upon pressing return, you will also be
prompted to enter the password of the regular user specified.


Passwordless Authentication (Optional)
________________________________________________________________________________

Passwordless login to a remove server can be achieved by creating a key pair. 
From the SSH client, use the following command to generate the key:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ ssh-keygen -t rsa                                                        |
|                                                                              |
+------------------------------------------------------------------------------+

Copy the id_rsa.pub file generated from the previous step into the remote 
server's ~/.ssh/authorized_keys with the following command:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ ssh-copy-id USERNAME@SERVER                                              |
|                                                                              |
+------------------------------------------------------------------------------+

Replace USERNAME with the name of a regular user and SERVER with the hostname or 
IP address of the SSH remote server. Upon pressing return, you will also be
prompted to enter the password of the regular user specified.

Verify that the key was copied to the remote server and passwordless login works
by entering the following command from the previous section:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ ssh USERNAME@SERVER                                                      |
|                                                                              |
+------------------------------------------------------------------------------+

Once passwordless login has been verified, disable password authentication on
the remote server:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ echo "PasswordAuthentication no" >> /etc/ssh/sshd_config                 |
|                                                                              |
+------------------------------------------------------------------------------+


Tips and Tricks
________________________________________________________________________________

* When connecting to an SSH server, there are three different levels of debug
  modes that can help with troubleshooting issues. Use the "-v" switch when
  connecting to print the debugging messages:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ ssh USERNAME@SERVER -v                                                   |
|   $ ssh USERNAME@SERVER -vv                                                  |
|   $ ssh USERNAME@SERVER -vvv                                                 |
|                                                                              |
+------------------------------------------------------------------------------+

* If you are looking to forward GUI-based applications through an SSH tunnel,
  refer to the #/wiki/xorg/x11-forwarding article.


troubleshooting
________________________________________________________________________________

* you can fix errors such as this one

+------------------------------------------------------------------------------+
|                                                                              |
|  top error: Error opening terminal: xterm-256color                           |
|                                                                              |
+------------------------------------------------------------------------------+

By running this command in your ssh session

+------------------------------------------------------------------------------+
|                                                                              |
|  $ export TERM=xterm                                                         |
|                                                                              |
+------------------------------------------------------------------------------+

References
________________________________________________________________________________

[0] https://www.openssh.com/openbsd.html
[1] https://wiki.gentoo.org/wiki/SSH
