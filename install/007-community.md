
---
title: Enable the community repository
category: install
---

The KISS community repository is maintained by users of the distribution and contains packages which aren't in the main repositories. This repository is disabled by default as it is not 100% maintained by the KISS developers as the other repositories are.

```
# Clone the repository to a location of your choosing.
git clone https://github.com/kisslinux/community.git

# Add the repository to the system-wide 'KISS_PATH'.
# The 'KISS_PATH' variable works exactly like 'PATH'.
# Each repository is split by ':' and is checked in
# the order they're written.
#
# Add the full path to the repository you cloned
# above.
#
# NOTE: The subdirectory must also be added.
# Example: export KISS_PATH=/var/db/kiss/repo/core:/var/db/kiss/repo/extra:/var/db/kiss/repo/xorg:/path/to/community/community
vi /etc/profile.d/kiss_path.sh

# Spawn a new login shell to access this repository
# immediately.
sh -l
```

