---
title: News
category: main
---

## Status

- [x] Working `chroot`.
- [x] Working installation method.
- [x] Working `xorg-server`.
- [ ] Web browser.
- [ ] `mpv`


## Index

<!-- vim-markdown-toc GFM -->

* [19/07/2019: Building a web browser.](#19072019-building-a-web-browser)

<!-- vim-markdown-toc -->


## 19/07/2019: Building a web browser.

We are busy at work packaging a browser for KISS. To begin with, a single browser will be packaged with the sole purpose of making KISS "usable". The chosen starting browser will be whatever is easiest to package (*this is an understatement*).

The dependency chains and build systems for the major web browsers are nonsensical to say the least. Firefox and Chromium require Python 2 despite it being EOL in less than 5 months. Both Chromium and Firefox require **both** GTK2 and GTK3. Firefox no longer has ALSA support and the configure option to enable it will be gone in the coming releases.

The complexities go further but this news entry will not go into it.
