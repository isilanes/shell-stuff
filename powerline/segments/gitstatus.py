# -*- coding=utf-8 -*-
from __future__ import print_function

# Standard libs:
import os
import sys
import subprocess as  sp

# Change those symbols to whatever you prefer:
symbols = {'ahead of': u'↑', 'behind': u'↓', 'prehash': u':'}

# Functions:
def main():
    """Main loop."""

    pass

def get_state(directory):
    """Return full status, in a dictionary. Empty dir if not inside Git repo."""

    # Exit early if not a Git repo:
    branch = which_branch(directory)
    if not branch:
        return {}

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
                revlist, _ = [x.decode('utf-8') for x in s.communicate()]

            revlist = revlist.decode("utf-8")

            behead = revlist.splitlines()
            ahead = len([x for x in behead if x[1]=='>'])
            behind = len(behead) - ahead

            remote = ''
            if behind:
                remote += '{s}{n}'.format(s=symbols['behind'], n=behind)

            if ahead:
                remote += '{s}{n}'.format(s=symbols['ahead of'], n=ahead)
        else:
            remote = ""

    data = {
        "branch": branch,
        "remote": remote,
        "staged": staged,
        "conflicts": conflicts,
        "changed": changed,
        "untracked": untracked,
        "clean": clean,
    }

    return RepoState(data)

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
class RepoState(object):
    """Class to hold and serve info about Git repository state."""

    # Constructor:
    def __init__(self, data={}):
        self.data = data


    # Properties:
    @property 
    def is_dirty(self):
        """Return True if dirty, False otherwise."""

        if self.conflicts + self.changed + self.untracked:
            return True

        if self.remote:
            return True

        return False

    @property 
    def branch(self):
        """Return Branch, or None."""

        return self.data.get("branch", None)

    @property 
    def remote(self):
        """Return remote, or None."""

        return self.data.get("remote", None)

    @property 
    def staged(self):
        """Return amount of staged files, or 0."""

        try:
            return int(self.data["staged"])
        except:
            return 0

    @property 
    def conflicts(self):
        """Return amount of conflicting files, or 0."""

        try:
            return int(self.data["conflicts"])
        except:
            return 0

    @property 
    def changed(self):
        """Return amount of changed files, or 0."""

        try:
            return int(self.data["changed"])
        except:
            return 0

    @property 
    def untracked(self):
        """Return amount of untracked files, or 0."""

        try:
            return int(self.data["untracked"])
        except:
            return 0


    # Special methods:
    def __str__(self):
        if self.is_dirty:
            string = "({s.branch}|".format(s=self)

            bits = []

            if self.staged:
                bits.append("{s.staged}S".format(s=self))

            if self.conflicts:
                bits.append("{s.conflicts}C".format(s=self))

            if self.changed:
                bits.append("{s.changed}M".format(s=self))

            if self.untracked:
                bits.append("{s.untracked}U".format(s=self))

            if self.remote:
                bits.append("{s.remote}R".format(s=self))

            string += " ".join(bits)

            string += ")"
            return string
        else:
            return self.branch


# Main loop:
if __name__ == "__main__":
    main()
