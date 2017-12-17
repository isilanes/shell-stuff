# vim:fileencoding=utf-8
from __future__ import (unicode_literals, division, absolute_import, print_function)

# Standard libs:
import os

# Powerline libs:
from powerline.theme import requires_segment_info
from powerline.segments import Segment, with_docstring
from powerline.lib.vcs import guess, tree_status
from powerline.theme import requires_filesystem_watcher

# My libs:
from powerline.isilanes import gitstatus

# Classes:
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
        # Get current dir:
        name = self.get_directory(segment_info)
        if not name:
            return

        # Get state of Git repo:
        state = gitstatus.get_state(name)

        # Choose color (dirty or clean):
        scol = ["branch_clean"]
        if state.is_dirty:
            scol = ["branch_dirty"]

        # Build contents:
        contents = str(state)

        """
        repo = guess(path=name, create_watcher=create_watcher)
        if repo is None:
            return

        branch = repo.branch()
        scol = ['branch']

        if status_colors:
            try:
                status = tree_status(repo, pl)
            except Exception as e:
                pl.exception('Failed to compute tree status: {0}', str(e))
                status = '?'
        else:
            status = status and status.strip()
            if status in ignore_statuses:
                status = None
                
        scol.insert(0, 'branch_dirty' if status else 'branch_clean')
        """
        
        res = {
            'contents': contents,
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
