# -*- coding=utf-8 -*-

from __future__ import print_function

import sys
import subprocess as  sp

# Change those symbols to whatever you prefer
symbols = {'ahead of': u'↑', 'behind': u'↓', 'prehash': u':'}
#symbols = {'ahead of': '↑', 'behind': '↓', 'prehash': ':'}

# Get symbolic-ref:
s = sp.Popen(['git', 'symbolic-ref', 'HEAD'], stdout=sp.PIPE, stderr=sp.PIPE)
out, err = s.communicate()

# Exit early if not a Git repo:
if 'fatal: Not a git repository' in err.decode("utf-8"):
    sys.exit(0)

branch = out.decode("utf-8").split("/")[-1].strip()

# Get status:
s = sp.Popen(['git','diff','--name-status'], stdout=sp.PIPE, stderr=sp.PIPE)
out, err = [ x.decode('utf-8') for x in s.communicate() ]

# Exist early if error:
if 'fatal' in err:
    sys.exit(0)

# Process outputs:
changed_files = [ x[0] for x in out.splitlines() ]
nb_changed = len(changed_files) - changed_files.count('U')
changed = str(nb_changed)

s = sp.Popen(['git','diff', '--staged','--name-status'], stdout=sp.PIPE)
out, err = s.communicate()
out = out.decode("utf-8")
staged_files = [ x[0] for x in out.splitlines() ]
nb_U = staged_files.count('U')
nb_staged = len(staged_files) - nb_U
staged = str(nb_staged)
conflicts = str(nb_U)

s = sp.Popen(['git','ls-files','--others','--exclude-standard'], stdout=sp.PIPE)
out, err = s.communicate()
out = out.decode("utf-8")
nb_untracked = len(out.splitlines())
untracked = str(nb_untracked)

if nb_changed or nb_staged or nb_U or nb_untracked:
    clean = '0'
else:
    clean = '1'

if not branch: # not on any branch
    s = sp.Popen(['git','rev-parse','--short','HEAD'], stdout=sp.PIPE)
    #out, err = s.communicate()
    out, err = [ x.decode('utf-8') for x in s.communicate() ]
    out = out.decode('utf-8')
    branch = "{sp}{o}".format(sp=symbols['prehash'], o=out[:-1])
else:
    br = 'branch.{b}.remote'.format(b=branch)
    s = sp.Popen(['git', 'config', br], stdout=sp.PIPE)
    out, err = s.communicate()
    remote_name = out.strip().decode("utf-8")
    if remote_name:
        s = sp.Popen(['git','config','branch.{b}.merge'.format(b=branch)], stdout=sp.PIPE)
        out, err = s.communicate()
        merge_name = out.strip().decode("utf-8")

        if remote_name == '.': # local
            remote_ref = merge_name
        else:
            remote_ref = 'refs/remotes/{}/{}'.format(remote_name, merge_name.split("/")[-1].strip())

        rr = '{r}...HEAD'.format(r=remote_ref)
        s = sp.Popen(['git', 'rev-list', '--left-right', rr], stdout=sp.PIPE, stderr=sp.PIPE)
        revlist, _ = s.communicate()

        if s.poll(): # fallback to local
            mn = '{m}...HEAD'.format(m=merge_name)
            s = sp.Popen(['git', 'rev-list', '--left-right', mn], stdout=sp.PIPE, stderr=sp.PIPE)
            #revlist, _ = s.communicate()
            revlist, _ = [ x.decode('utf-8') for x in s.communicate() ]
        
        if not isinstance(revlist, str):
            revlist = revlist.decode("utf-8")

        behead = revlist.splitlines()
        ahead = len([x for x in behead if x[0]=='>'])
        behind = len(behead) - ahead

        sao = symbols["ahead of"]
        remote = ''
        if behind:
            remote += '{s}{n}'.format(s=symbols['behind'], n=behind)

        if ahead:
            remote += '{s}{n}'.format(s=symbols['ahead of'], n=ahead)
    else:
        remote = ""

out = '\n'.join([
	branch,
	remote,
	staged,
	conflicts,
	changed,
	untracked,
	clean])

print(out)
