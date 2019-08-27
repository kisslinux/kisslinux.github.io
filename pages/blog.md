---
title: Blog
---

## Index

<!-- vim-markdown-toc GFM -->

* [27/08/2019 - Python 2 will never die](#27082019---python-2-will-never-die)

<!-- vim-markdown-toc -->

## 27/08/2019 - Python 2 will never die

When developing KISS I wanted to ship Python 3 and try to avoid the dependence on Python 2. This ended up becoming an impossibility due to two offending packages, Firefox and NodeJS (*a build dependency of the former*).

We are nearing the day that Python 2 reaches EOL (*end of life*) and as is usually the case with deadlines, it has been left to the last minute. Python 2's end has been known as far back as 2010 (*possibly sooner*) and yet I foresee it being used well past 2020. \[0\]

**Firefox**

Firefox's build process depends on both Python 2 and Python 3. Mozilla is currently in the process of converting their Python code to support **both** 2 and 3.

This effort only recently started and there is a long road ahead to completion.

> In mozilla-central there are over **3500 Python files** (excluding third party files), comprising roughly **230k lines of code**. Additionally there are **462 repositories** labelled with Python in the Mozilla org on Github ... \[1\]

On finishing by or before the deadline:

> Do we need to be 100% migrated by Python 2’s EOL?
> Technically, no. ... \[1\]


**NodeJS**

Node is in a similar position to Mozilla, work is being done but to say it is nearing completion is an overstatement. NodeJS is closer to being Python 3 compatible than Firefox but I myself doubt that we will see a release with support by 2020.


**Sources:**

- \[0\] https://mail.python.org/pipermail/python-dev/2010-May/099971.html
- \[1\] https://ahal.ca/blog/2019/python-3-at-mozilla/

