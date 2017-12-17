# vim:fileencoding=utf-8
from __future__ import (unicode_literals, division, absolute_import, print_function)

import os

from powerline.lib.unicode import out_u
from powerline.theme import requires_segment_info
from powerline.segments import Segment, with_docstring

from powerline.lib.vcs import guess, tree_status
from powerline.theme import requires_filesystem_watcher
from powerline.lib import add_divider_highlight_group

@requires_segment_info
def environment(pl, segment_info, variable=None):
    """Return the value of any defined environment variable
    
    :param string variable:
        the environment variable to return if found. None, otherwise.
    """
    return segment_info['environ'].get(variable, None)


@requires_segment_info
def virtualenv(pl, segment_info, ignore_venv=False, ignore_conda=False):
    """Return the name of the current Python or conda virtualenv.
    :param bool ignore_venv:
        whether to ignore virtual environments. Default is False.
    :param bool ignore_conda:
        whether to ignore conda environments. Default is False.
    """
    venv_val = os.path.basename(segment_info['environ'].get('VIRTUAL_ENV', ''))
    if not ignore_venv and venv_val:
        return u"\u2622 {v}".format(v=venv_val)
    
    conda_val = segment_info['environ'].get('CONDA_DEFAULT_ENV', '')
    if not ignore_conda and conda_val:
        return u"\u2622 {v}".format(v=conda_val)
    
    return None


if os.path.exists('/proc/uptime'):
    def _get_uptime():
        with open('/proc/uptime', 'r') as f:
            return int(float(f.readline().split()[0]))

elif 'psutil' in globals():
    from time import time
    
    if hasattr(psutil, 'boot_time'):
        def _get_uptime():
            return int(time() - psutil.boot_time())
    else:
        def _get_uptime():
            return int(time() - psutil.BOOT_TIME)

else:
    def _get_uptime():
        raise NotImplementedError


@add_divider_highlight_group('background:divider')
def uptime(pl, days_format='{days:d}d', hours_format=' {hours:d}h', minutes_format=' {minutes:d}m', seconds_format=' {seconds:d}s', shorten_len=4):
    """Return system uptime.

    :param str days_format:
      day format string, will be passed ``days`` as the argument
    :param str hours_format:
      hour format string, will be passed ``hours`` as the argument
    :param str minutes_format:
      minute format string, will be passed ``minutes`` as the argument
    :param str seconds_format:
      second format string, will be passed ``seconds`` as the argument
    :param int shorten_len:
      shorten the amount of units (days, hours, etc.) displayed

    Divider highlight group used: ``background:divider``.
    """
    try:
        seconds = _get_uptime()
    
    except NotImplementedError:
        pl.warn('Unable to get uptime. You should install psutil module')
        return None

    minutes, seconds = divmod(seconds, 60)
    hours, minutes = divmod(minutes, 60)
    days, hours = divmod(hours, 24)
    time_formatted = list(filter(None, [
      days_format.format(days=days) if days and days_format else None,
      hours_format.format(hours=hours) if hours and hours_format else None,
      minutes_format.format(minutes=minutes) if minutes and minutes_format else None,
      seconds_format.format(seconds=seconds) if seconds and seconds_format else None,
    ]))[0:shorten_len]

    return u"\u25b2 " + u''.join(time_formatted).strip()

