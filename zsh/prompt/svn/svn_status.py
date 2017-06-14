# -*- coding: UTF-8 -*-

import os
import sys
import subprocess as sp

# --- #

# svn working copy? Try to get status:
proc = sp.Popen(["svn", "status"], stdout=sp.PIPE, stderr=sp.PIPE)
out, err = proc.communicate()

if not isinstance(out, str):
    out = out.decode("utf-8")

if not isinstance(err, str):
    err = err.decode("utf-8")

# Exit and return nothing, if not svn working copy:
if 'not a working copy' in err:
    sys.exit()

# If working copy, process status:
state = 'clean'
for line in out.split("\n"):
    if line and line[0] in '?MD':
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
