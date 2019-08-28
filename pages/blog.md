---
title: Blog
category: main
---

## Index

<!-- vim-markdown-toc GFM -->

* [28/08/2019 - Why does GTK3 Firefox require GTK2?](#28082019---why-does-gtk3-firefox-require-gtk2)
* [28/08/2019 - Firefox 69 now fully depends on `dbus`](#28082019---firefox-69-now-fully-depends-on-dbus)
* [27/08/2019 - Python 2 will never die](#27082019---python-2-will-never-die)

<!-- vim-markdown-toc -->


## 28/08/2019 - Why does GTK3 Firefox require GTK2?

Firefox only supports Linux builds with GTK3 for some time now, however GTK2 is still a mandatory dependency. It turns out that GTK2 is required for NPAPI plugins and the **only** plugin which is still in use is the Flash Plugin!

You cannot disable NPAPI plugin support which means that **Firefox has a dependency on GTK2 solely for Flash**. The sole reason that KISS ships GTK2 is for Firefox, Flash will die some time in 2020 (*possibly 2021*) so until then we're stuck with GTK2.

Source:

> As long as NPAPI plugins are supported, build dependency on gtk2 cannot be dropped.

> NPAPI is currently only around to support Flash (bug 1269807). Per https://developer.mozilla.org/en-US/docs/Plugins/Roadmap, Firefox's Flash support (and thus NPAPI support) will be removed sometime in 2020.

<https://bugzilla.mozilla.org/show_bug.cgi?id=1377445>


## 28/08/2019 - Firefox 69 now fully depends on `dbus`

The upcoming Firefox release now depends on `dbus` and this dependency can't be disabled. The usual `--disable-dbus` `mozconfig` option has no effect.

Until this is fixed upstream or we find a way to patch this out KISS will be swapping to the next ESR release of Firefox (68.0.2 -> 68.1.0). This gives us a little over a year to sort out this situation.

With the release of Firefox 70 ALSA support will also be dropped from Firefox and we will have to ship `apulse` with KISS to fix this.

It seems to be getting harder and harder to run and maintain a system which doesn't follow the usual trend of software choices. Firefox even has a `dbus` dependency on FreeBSD and OpenBSD!


## 27/08/2019 - Python 2 will never die

When developing KISS I wanted to ship Python 3 and try to avoid the dependence on Python 2. This ended up becoming an impossibility due to two offending packages, Firefox and NodeJS (*a build dependency of the former*).

We are nearing the day that Python 2 reaches EOL (*end of life*) and as is usually the case with deadlines, it has been left to the last minute. Python 2's end has been known as far back as 2010 (*possibly sooner*) and yet I foresee it being used well past 2020. \[0\]

**Firefox**

Firefox's build process depends on both Python 2 and Python 3. Mozilla is currently in the process of converting their Python code to support **both** 2 and 3.

This effort only recently started and there is a long road ahead to completion.

> In mozilla-central there are over **3500 Python files** (excluding third party files), comprising roughly **230k lines of code**. Additionally there are **462 repositories** labelled with Python in the Mozilla org on Github \[...\] \[1\]

Will Mozilla finish before the deadline? It doesn't look that way.

> Do we need to be 100% migrated by Python 2’s EOL?
> Technically, no. \[...\] \[1\]


**NodeJS**

Node is in a similar position to Mozilla, work is being done but to say it is nearing completion is an overstatement. NodeJS is closer to being Python 3 compatible than Firefox but I myself doubt that we will see a release with support by 2020.


**The Future**

It is looking more and more like we will be using Python 2 for a while longer. Despite the decade or near decade long time for transition these projects have left the transition till beyond the EOL date.

Since the EOL announcement till today how much Python 2 code has been added to these two projects? A transition even 5 years ago would've been beneficial!

So it looks like KISS will keep Python 2 in the official repositories past 2019 and into 2020.

**Sources:**

- \[0\] https://mail.python.org/pipermail/python-dev/2010-May/099971.html
- \[1\] https://ahal.ca/blog/2019/python-3-at-mozilla/

