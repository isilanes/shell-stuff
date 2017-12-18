# -*- coding=utf-8 -*-
from __future__ import unicode_literals, division, absolute_import, print_function

# Standard libs:
import os

# Powerline libs:
from powerline.lib.vcs import guess, tree_status
from powerline.theme import requires_segment_info
from powerline.segments import Segment, with_docstring
from powerline.theme import requires_filesystem_watcher

# My libs:
from powerline.isilanes import gitstatus, svnstatus

# Constants:
SYMBOLS = {
    "change": "\u267b",
    "up": "\u2191",
    "down": "\u2193",
    "untracked": "*",
    "conflict": "\u2620",
    "staged": "+",
    "git": "",
    "svn": "\u2144",
}

# Classes:
class RepoState(object):
    """Class to hold and serve info about repository state."""

    # Constructor:
    def __init__(self, directory):
        self.directory = directory
        self.is_git = False
        self.is_svn = False
        self.data = {}

        gitdata = gitstatus.get_state(self.directory)
        if gitdata:
            self.data = gitdata
            self.is_git = True

        svndata = svnstatus.get_state(self.directory)
        if svndata:
            self.data = svndata
            self.is_svn = True


    # Properties:
    @property 
    def is_dirty(self):
        """Return True if dirty, False otherwise."""

        if self.conflicts + self.changed + self.untracked + self.remote_ahead + self.remote_behind + self.staged:
            return True

        return False

    @property 
    def branch(self):
        """Return Branch, or None."""

        return self.data.get("branch", None)

    @property 
    def remote_ahead(self):
        """Return remote ahead, or 0."""

        val = self.data.get("remote", (0, 0))

        return val[0]

    @property 
    def remote_behind(self):
        """Return remote behind, or 0."""

        val = self.data.get("remote", (0, 0))

        return val[1]

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
        if self.is_git:
            string = "{S[git]} {s.branch}".format(s=self, S=SYMBOLS)
        elif self.is_svn:
            string = "{S[svn]} {s.branch}".format(s=self, S=SYMBOLS)
        else:
            string = ""

        if self.is_dirty:
            if self.is_git:
                string += " ("
            elif self.is_svn:
                string += " ["

            bits = []

            if self.conflicts:
                bits.append("{S[conflict]}{s.conflicts}".format(s=self, S=SYMBOLS))

            if self.changed:
                bits.append("{S[change]}{s.changed}".format(s=self, S=SYMBOLS))

            if self.untracked:
                bits.append("{S[untracked]}{s.untracked}".format(s=self, S=SYMBOLS))

            if self.remote_ahead:
                bits.append("{S[up]}{s.remote_ahead}".format(s=self, S=SYMBOLS))

            if self.remote_behind:
                bits.append("{S[down]}{s.remote_behind}".format(s=self, S=SYMBOLS))

            if self.staged:
                bits.append("{S[staged]}{s.staged}".format(s=self, S=SYMBOLS))

            string += " ".join(bits)

            if self.is_git:
                string += ")"
            elif self.is_svn:
                string += "]"

        return string


@requires_filesystem_watcher
@requires_segment_info
class BranchSegment(Segment):
    
    divider_highlight_group = None

    # Static methods:
    @staticmethod
    def get_directory(segment_info):
        return segment_info['getcwd']()


    # Special methods:
    def __call__(self, pl, segment_info, create_watcher, status_colors=False, ignore_statuses=()):
        # Get current dir, exit early if unable:
        name = self.get_directory(segment_info)
        if not name:
            return None

        # Get state of repo:
        state = RepoState(directory=name)

        # Choose color (dirty or clean, git or svn):
        if state.is_git:
            if state.is_dirty:
                scol = ["branch_git_dirty"]
            else:
                scol = ["branch_git_clean"]

        elif state.is_svn:
            if state.is_dirty:
                scol = ["branch_svn_dirty"]
            else:
                scol = ["branch_svn_clean"]

        else:
            return None

        # Build contents:
        res = {
            'contents': str(state),
            'highlight_groups': scol,
            'divider_highlight_group': self.divider_highlight_group,
        }
        
        return [res]


@requires_filesystem_watcher
@requires_segment_info
class StashSegment(Segment):
    
    divider_highlight_group = None
    
    # Static methods:
    @staticmethod
    def get_directory(segment_info):
        return segment_info['getcwd']()
    

    # Special methods:
    def __call__(self, pl, segment_info, create_watcher):
        name = self.get_directory(segment_info)
        if not name:
            return

        repo = guess(path=name, create_watcher=create_watcher)
        if repo is None:
            return

        stash = getattr(repo, 'stash', None)
        if not stash:
            return

        stashes = stash()
        if not stashes:
            return

        res = {
            'contents': str(stashes),
            'highlight_groups': ['stash'],
            'divider_highlight_group': self.divider_highlight_group
        }
        
        return [res]


# Add docstring:
branch = with_docstring(BranchSegment(),
"""Return the current VCS branch.

:param bool status_colors:
    Determines whether repository status will be used to determine highlighting. 
    Default: False.
:param bool ignore_statuses:
    List of statuses which will not result in repo being marked as dirty. Most 
    useful is setting this option to '["U"]': this will ignore repository 
    which has just untracked files (i.e. repository with modified, deleted or 
    removed files will be marked as dirty, while just untracked files will make 
    segment show clean repository). Only applicable if 'status_colors' option 
    is True.

Highlight groups used: 'branch_clean', 'branch_dirty', 'branch'.
""")

stash = with_docstring(StashSegment(),
"""Return the number of current VCS stash entries, if any.

Highlight groups used: 'stash'.
""")
