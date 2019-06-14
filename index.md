# KISS

A highly opinionated, ultra minimal, Linux distribution.

**Links**

- [Repository](https://github.com/kissx/packages)
- [Package Manager](https://github.com/kissx/kiss)


## Rationale

A Linux distribution specifically for desktop that aims to be minimal in every sense of the word. KISS is meant for users with prior Linux and programming knowledge and for those who want something simple.

The distribution is highly opinionated and the main repository will contain a minimal package set. However, as a user you can easily create your own repository and package what you like. The tools are made available to you, KISS is just the base.

Packages in KISS employ a new concept. Instead of your typical sourceable shell scripts, multiple plain-text files are used. This new format is easily parseable in any programming language as file data is either separated by spaces or lines.

To show off this concept, the reference package manager is written in under 200 lines of POSIX `sh`. Nothing stops you from interfacing with the package repositories outside of the base package manager. You can easily write your own tools.
