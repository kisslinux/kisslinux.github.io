---
title: Solutions
category: main
---

## Index

<!-- vim-markdown-toc GFM -->

* [I have installed `libinput` and `xf86-input-libinput` but it's not working.](#i-have-installed-libinput-and-xf86-input-libinput-but-its-not-working)

<!-- vim-markdown-toc -->


## I have installed `libinput` and `xf86-input-libinput` but it's not working.

Your user must be a part of the `input` group for input devices to work.

```
addgroup USER input
```


