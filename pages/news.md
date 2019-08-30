---
title: News
category: main
---

## Index

<!-- vim-markdown-toc GFM -->

* [30/08/2019: Removal of `fakeroot`.](#30082019-removal-of-fakeroot)
* [28/08/2019: Removal of `atk-bridge-fake`.](#28082019-removal-of-atk-bridge-fake)
* [24/08/2019: Rust update requires manual intervention.](#24082019-rust-update-requires-manual-intervention)
* [24/08/2019: New version of KISS.](#24082019-new-version-of-kiss)
* [24/08/2019: Manual repository fix needed.](#24082019-manual-repository-fix-needed)
* [23/08/2019: KISS repository split.](#23082019-kiss-repository-split)
* [22/08/2019: KISS is now on <https://repology.org>!](#22082019-kiss-is-now-on-httpsrepologyorg)
* [11/08/2019: KISS installed on hardware.](#11082019-kiss-installed-on-hardware)
* [04/08/2019: Firefox has been built.](#04082019-firefox-has-been-built)
* [19/07/2019: Building a web browser.](#19072019-building-a-web-browser)

<!-- vim-markdown-toc -->

## 30/08/2019: Removal of `fakeroot`.

The `fakeroot` package is no longer used by the package manager. Instead each package is built and archived with the ownership of whatever user ran the package manager.

On installation of a package the files are then installed with the ownership set to `root:root` achieving the same behavior in the end as `fakeroot`.

`fakeroot` is a nasty hack and adds quite a lot of overhead to builds. I am now able to rebuild GCC in only 10 minutes (using `ccache` with and without `fakeroot`)!

Steps for removal of `fakeroot`.

- Update `kiss` to `0.10.0`.
- Remove `fakeroot` (`kiss remove fakeroot`).


## 28/08/2019: Removal of `atk-bridge-fake`.

This package was used to patch out the `dbus` requirement from GTK2/3, I have found a simpler way of accomplishing the same goal without the need for a fake library!

Steps for removal of `atk-bridge-fake`.

- Update `gtk+2` and `gtk+3`.
- Remove `atk-bridge-fake` (`kiss remove atk-bridge-fake`).

## 24/08/2019: Rust update requires manual intervention.

Remove `cargo` with `kiss remove cargo` before updating `rust`.

## 24/08/2019: New version of KISS.

- GCC updated to 9.2.
- All other packages updated.
- Fixed repository pulls.

Download: <https://github.com/kisslinux/repo/releases/download/0.0.24-musl/kiss-chroot.tar.xz>

## 24/08/2019: Manual repository fix needed.

The repository split has caused existing repository `git pull` commands to fail. Run the following commands to fix it. Apologies.

```
cd /var/db/kiss
rm -rf repo
git clone https://github.com/kisslinux/repo
```

## 23/08/2019: KISS repository split.

The `public` repository was split from the main repositories and renamed to `community`. This change was made to reflect the split in maintainer responsibility. This repository is now disabled by default.

It goes to say that the KISS developers are not solely responsible for maintaining packages in this repository. By enabling this repository you accept the risks of a curated community repository.

To enable `community` follow the instructions here: <https://getkiss.org/pages/installation/#enable-the-community-repository>

## 22/08/2019: KISS is now on <https://repology.org>!

The KISS repositories were recently added to <https://repology.org>. You can track our packages here: https://repology.org/repository/kiss


## 11/08/2019: KISS installed on hardware.

KISS has been successfully installed on hardware! This includes a working Firefox and Xorg server. A number of issues have sprung up as expected and these will be ironed out before a proper release is made.

![screenshot](https://user-images.githubusercontent.com/6799467/62836271-fed09980-bc50-11e9-884f-47cc1c2f32e5.jpg)

## 04/08/2019: Firefox has been built.

After hours of build attempts of both Chromium and Firefox, we have successfully packaged Firefox. Chromium is a story for another time. The build systems for these two browsers border on insanity and their overall size and complexity is paramount.

- Firefox requires both GTK2 and GTK3. GTK2 is required only for flash. \[1\]
- Both Chromium and Firefox require `nodejs` to build.
- Both Chromium and Firefox require Python 2.
- Both browsers bundle all of their required third-party libraries and they cannot all be set to use the system's.
- `clang` is now the default and "supported" compiler of both browsers.
- Firefox requires a version of `automake` which is 18(?) years old. \[2\] \[3\]
- Firefox requires `rust` which was painful to package for `musl` to say the least.
- Chromium's build scripts require `python2` yet call `python` which points to `python3`.
- A large number of patches were needed for both to support `musl`.
- Both browsers depend on GTK+3 which depends on `dbus`. This dependency was removed by using a fake `atk` library.
- ALSA audio support is being removed from Firefox. This includes the configure flag to enable it.
- This will be updated as I remember things.

Sources:

- \[1\] <https://bugzilla.mozilla.org/show_bug.cgi?id=1377445>
- \[2\] <https://bugzilla.mozilla.org/show_bug.cgi?id=104642>
- \[3\] <https://bugzilla.mozilla.org/show_bug.cgi?id=297544>


## 19/07/2019: Building a web browser.

We are busy at work packaging a browser for KISS. To begin with, a single browser will be packaged with the sole purpose of making KISS "usable". The chosen starting browser will be whatever is easiest to package (*this is an understatement*).

The dependency chains and build systems for the major web browsers are nonsensical to say the least. Firefox and Chromium require Python 2 despite it being EOL in less than 5 months. Both Chromium and Firefox require **both** GTK2 and GTK3. Firefox no longer has ALSA support and the configure option to enable it will be gone in the coming releases.

The complexities go further but this news entry will not go into it.
