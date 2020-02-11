---
title: KISS guidestones
---

```
KISS

* There must always be a sole commander-in-chief
  in charge of the distribution. There must never
  be a below governance structure.

* With great power comes great responsibility.
  The user must have some kind of brain in their
  skull and must exercise its use where necessary.

* Prefer less software over more software where 
  possible. e.g If all a library does is make the
  cursor spin while waiting for a program to launch,
  it should be purged. 

* Favour usability over ideals. If software B is
  simpler than software A but is missing essential
  functionality (for all users), software A shall be
  the default provider.

* The ends do not justify the means. A package, fix,
  feature or what have you will not be implemented if 
  it requires gross hacks to accomplish.

* Only target the English language. English is the
  World Language. What we write our code in and
  what we use to communicate.

* All shell code must be written in a safe way,
  pass the shellcheck linter and match the style of
  any existing code.

* All distribution tooling and shell code must be
  written in a portable way. Otherwise, the user
  will be locked into a single coreutils and shell.


OFFICIAL REPOSITORIES

* The number of packages in the official repositories
  shall never exceed that which is maintainable by a 
  single person with minimal effort.

* The build process of a package should not require a
  network connection, otherwise signature verification
  and checksums are useless.

* Avoid patches for single line changes. Patches require
  rewriting on changes of the sources whereas a simple
  call to 'sed' can stand the test of time.

* Sources must use HTTPS where possible. If no HTTPS
  source is available one must be sought out or created
  by the BDFL of KISS.

* Install files to '/usr/{bin,lib,share}' always. The
  singular directory ensures simplicity and keeps
  kiss tooling and user scripts simple.

* The follow list of software must never make its way
  into the repositories as their inclusion will pave
  the way for software which unoptionally depends on them.

* dbus, systemd, polkit, gettext, intltool, pulseaudio, 
  pam, wayland, logind, ConsoleKit, libsn, electron,
  all proprietary software and all desktop environments.


PACKAGE MANAGER

* The package manager must not exceed 1000 lines of code.
  This number excludes blank lines and comments which make
  up around 50% of the program's current size.

* The user is smart, the package manager is dumb. The 
  package manager is written under the assumption that the 
  user has some kind of functioning brain in their skull.

* There are some things which can't be, shouldn't be 
  and won't be automated. Firstly, for my sanity and 
  secondly, for yours.


INIT SYSTEM

* The user should not be tied to a single provider of PID 1.
  No unrelated piece of software should require a specific
  init be in use.

* No software violating the above rule shall be included in
  the official repositories as it paves the road for the
  inclusion of software that will explicitely depend on it.
```
