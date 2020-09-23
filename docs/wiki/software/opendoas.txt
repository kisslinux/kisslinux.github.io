OPENDOAS [0]
________________________________________________________________________________

doas is a minimal replacement for the venerable sudo. It was initially written 
by Ted Unangst of the OpenBSD project to provide 95% of the features of sudo 
with a fraction of the codebase.


Configuration
________________________________________________________________________________

Begin by first verifying that you have opendoas installed:

+------------------------------------------------------------------------------+
|                                                                              |
|   $ kiss b opendoas && kiss i opendoas                                       |
|                                                                              |
+------------------------------------------------------------------------------+

Using your preferred text editor, modify the /etc/doas.conf file. Within the 
doas.conf, there are plenty of examples of rules to choose from and modify.

Below are a few examples of *basic* rules that could be set:  

+------------------------------------------------------------------------------+
|   Allow a specific regular user, USER, to escalate to root permissions.      |
+------------------------------------------------------------------------------+
|                                                                              |
|   permit USER                                                                |
|                                                                              |
+------------------------------------------------------------------------------+
|   Allow a specific group (i.e. "wheel") to escalate to root permissions.     |
+------------------------------------------------------------------------------+
|                                                                              |
|   permit wheel                                                               |
|                                                                              |
+------------------------------------------------------------------------------+
|   You can also allow privilege escalation without a password.                |
+------------------------------------------------------------------------------+
|                                                                              |
|   permit nopass [GROUP OR USER]                                              |
|                                                                              |
+------------------------------------------------------------------------------+

Refer to OpenBSD doas.conf manual page [1] for more information.


References
________________________________________________________________________________

[0] https://github.com/Duncaen/OpenDoas
[1] https://man.openbsd.org/doas.conf.5
