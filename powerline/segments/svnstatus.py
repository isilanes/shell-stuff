# -*- coding: utf-8 -*-
from __future__ import print_function

# Standard libs:
import os
import sys
import subprocess as sp

# Functions:
def main():
    """Main loop."""

    s = get_state(os.getcwd())
    print(s)

def get_state(directory):
    """Return full status of repo, as a dictionary.
    Return None if not within a SVN repo.
    """
    # svn working copy? Try to get status:
    proc = sp.Popen(["svn", "status"], stdout=sp.PIPE, stderr=sp.PIPE)
    out, err = proc.communicate()

    if not isinstance(out, str):
        out = out.decode("utf-8")

    if not isinstance(err, str):
        err = err.decode("utf-8")

    # Exit and return nothing, if not svn working copy:
    if 'not a working copy' in err:
        return None

    # Process output:
    changed, new, untracked = 0, 0, 0
    for line in out.splitlines():
        if line[0] == "M":
            changed += 1
        elif line[0] == "?":
            untracked += 1
        elif line[0] == "A":
            new += 1

    # If in working copy, get branch/tag from path:
    branch = None
    tag = None
    pwd = os.path.abspath('.').split('/')
    pwd.reverse()
    last = None
    for item in pwd:
        if item == 'trunk':
            branch = 'trunk'
            break

        if item == 'branches':
            branch = last
            break

        if item == 'tags':
            tag = last
            break

        # Remember, for next cycle:
        last = item

    data = {
        "branch": branch,
        "remote": (0, 0),
        "staged": new,
        "conflicts": 0,
        "changed": changed,
        "untracked": untracked,
    }

    return data


# Main loop:
if __name__ == "__main__":
    main()

