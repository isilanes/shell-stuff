# -*- coding: UTF-8 -*-

import os
import sys
import subprocess as sp

# --- #

# svn working copy? Try to get status:
s = sp.Popen("svn status", stdout=sp.PIPE, stderr=sp.PIPE, shell=True)
out, err = s.communicate()

# Exit and return nothing, if not svn working copy:
if 'not a working copy' in err:
    sys.exit()

# If working copy, process status:
state = 'clean'
for line in out.split("\n"):
    if line:
        if line[0] in '?M':
            state = 'dirty'

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

# Output:
print(branch)
print(tag)
print(state)
