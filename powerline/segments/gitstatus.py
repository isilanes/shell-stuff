# -*- coding=utf-8 -*-
from __future__ import print_function

# Standard libs:
import os
import sys
import subprocess as  sp

# Change those symbols to whatever you prefer:
symbols = {'prehash': u':'}

# Functions:
def main():
    """Main loop."""

    s = get_state(os.getcwd())
    print(s)

def get_state(directory):
    """Return full status as a dictionary.
    Return None if not inside Git repo.
    """
    # Exit early if not a Git repo:
    branch = which_branch(directory)
    if not branch:
        return None

    # Get status:
    s = sp.Popen(['git','diff','--name-status'], stdout=sp.PIPE, stderr=sp.PIPE)
    out, err = [ x.decode('utf-8') for x in s.communicate() ]

    # Exit early if error:
    if err:
        return None

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

    if not branch: # not on any branch
        s = sp.Popen(['git','rev-parse','--short','HEAD'], stdout=sp.PIPE)
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
            revlist, _ = [x.decode('utf-8') for x in s.communicate()]

            if s.poll(): # fallback to local
                mn = '{m}...HEAD'.format(m=merge_name)
                s = sp.Popen(['git', 'rev-list', '--left-right', mn], stdout=sp.PIPE, stderr=sp.PIPE)
                revlist, _ = [x.decode('utf-8') for x in s.communicate()]

            nahead, nbehind = 0, 0
            for element in revlist.splitlines():
                if element[0] == ">":
                    nahead += 1
                else:
                    nbehind += 1

            remote = (nahead, nbehind)
        else:
            remote = (0, 0)

    data = {
        "branch": branch,
        "remote": remote,
        "staged": staged,
        "conflicts": conflicts,
        "changed": changed,
        "untracked": untracked,
    }

    return data

def in_git_repo(directory):
    """Return True if 'directory' is inside a Git repo. False, otherwise."""

    # Get symbolic-ref:
    os.chdir(directory)
    s = sp.Popen(['git', 'symbolic-ref', 'HEAD'], stdout=sp.PIPE, stderr=sp.PIPE)
    out, err = s.communicate()

    # Exit early if not a Git repo:
    if 'fatal: Not a git repository' in err.decode("utf-8"):
        return False

    return True

def which_branch(directory):
    """Return current branch. None, if not inside Git repo."""

    # Get symbolic-ref:
    os.chdir(directory)
    s = sp.Popen(['git', 'symbolic-ref', 'HEAD'], stdout=sp.PIPE, stderr=sp.PIPE)
    out, err = s.communicate()

    # Exit early if not a Git repo:
    if 'fatal: Not a git repository' in err.decode("utf-8"):
        return None

    return out.decode("utf-8").split("/")[-1].strip()


# Classes:

# Main loop:
if __name__ == "__main__":
    main()
