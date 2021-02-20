from __future__ import annotations
from typing import Optional, Tuple
import subprocess as sp
import json
import os
import re

WARN_COLOR = "\033[38;5;105m"
END_COLOR = "\033[0m"
COLUMNS = [
    {
        "name": "Device",
        "plike_attr": "device",
    },
    {
        "name": "Filesystem",
        "plike_attr": "fs",
    },
    {
        "name": "subvolid",
        "plike_attr": "btrfs_subvolume_id",
    },
    {
        "name": "Size",
        "plike_attr": "total_size",
        "is_number": True,
    },
    {
        "name": "Used",
        "plike_attr": "used_space",
        "is_number": True,
    },
    {
        "name": "Compression",
        "plike_attr": "compress_percent",
        "is_number": True,
    },
    {
        "name": "Fill%",
        "plike_attr": "fill_percent",
        "is_number": True,
    },
    {
        "name": "Mounted on",
        "plike_attr": "mountpoint",
    },
]


def run_command(cmd: list) -> Tuple[list, str]:
    """Returns a list of output lines as strings."""

    proc = sp.Popen(cmd, stdout=sp.PIPE, stderr=sp.PIPE)
    out, err = proc.communicate()

    if not isinstance(out, str):
        out = out.decode("utf-8")

    if not isinstance(err, str):
        err = err.decode("utf-8")

    return out.strip().split("\n"), err


def get_max_widths(partitions) -> list:
    wlist = []
    for col in COLUMNS:
        max_w = len(col["name"])
        for p in partitions:
            w = len(str(getattr(p, col["plike_attr"])))
            max_w = max(max_w, w)

        wlist.append(max_w)

    return wlist


def human(value: int) -> str:
    kB = 1024.
    MB = kB * 1024
    GB = MB * 1024
    TB = GB * 1024

    if value > TB:
        return f"{value / TB:.1f}TB"

    if value > GB:
        return f"{value / GB:.1f}GB"

    if value > MB:
        return f"{value / MB:.1f}MB"

    if value > kB:
        return f"{value / kB:.1f}kB"

    return f"{value}"


def warn(msg: str) -> None:
    print(f"{WARN_COLOR}[WARNING]{END_COLOR} {msg}")


def get_conf(filename):
    try:
        with open(filename) as f:
            return json.load(f)
    except FileNotFoundError:
        warn(f"Configuration file {filename} not found. Ignoring.")
        return {}
    except json.decoder.JSONDecodeError:
        warn(f"Can't read configuration file {filename}. Ignoring.")
        return {}


def colored(string: str, color: str) -> str:
    if color is None:
        return string

    return f"\033[38;5;{color}m{string}{END_COLOR}"


class DiskInfo:
    """Everything here."""

    DF_CMD = ["/bin/df", "-B1"]

    def __init__(self, conf=None):
        self._partitions = None
        self._conf = conf or {}

    def get_partitions_from_df(self) -> list:
        out, _ = run_command(self.DF_CMD)
        partitions = []
        for line in out:
            if not line:
                continue

            if self.is_excluded(line):
                continue

            partition = PartitionLike.parse_df_line(line)
            if partition is not None:
                partitions.append(partition)

        return partitions

    @property
    def partitions(self) -> list:
        if self._partitions is None:
            self._partitions = self.get_partitions_from_df()

        return self._partitions

    @property
    def max_col_widths(self) -> list:
        return get_max_widths(self.partitions)

    @property
    def head_color(self) -> Optional[str]:
        return self._conf.get("HEAD_COLOR")

    def print_headers(self) -> None:
        string = ""
        for col, w in zip(COLUMNS, self.max_col_widths):
            if col.get("is_number"):
                string = f"{string}{col['name']:>{w+1}s}  "
            else:
                string = f"{string}{col['name']:{w+1}s}  "

        string = f"{string}{END_COLOR}"

        print(colored(string, self.head_color))

    def print_rows(self) -> None:
        for partition in self.partitions:
            partition.width_list = self.max_col_widths
            print(partition)

    def get_fs_info(self):
        mount_info, _ = run_command(["mount"])
        d = {}
        for line in mount_info:
            aline = line.split()
            d[aline[2]] = line

        for p in self.partitions:
            line = d[p.mountpoint]
            aline = line.split()
            p.fs = aline[4]

            if p.fs == "btrfs":
                p.handle_btrfs(line)

    def is_excluded(self, line: str) -> bool:
        for patt in self._conf.get("EXCLUDES", []):
            if re.search(patt, line):
                return True

        return False


class PartitionLike:

    def __init__(self, device=None, size=None, used=None, mountpoint=None) -> None:
        self.device = device
        self._total_size = size
        self._used_space = used
        self.mountpoint = mountpoint
        self.width_list = None
        self.fs = None
        self._compress_percent = None
        self.btrfs_subvolume_id = "-"

    @staticmethod
    def parse_df_line(line: str) -> Optional[PartitionLike]:
        if line.startswith("Filesystem "):
            return None

        if "/" not in line:
            return None

        dev, size, used, _, _, mountpoint = line.split()

        return PartitionLike(device=dev, size=int(size), used=int(used), mountpoint=mountpoint)

    @property
    def total_size(self) -> str:
        if not isinstance(self._total_size, int):
            return "0"

        return human(self._total_size)

    @total_size.setter
    def total_size(self, value) -> None:
        if isinstance(value, int):
            self._total_size = value

    @property
    def used_space(self) -> str:
        if not isinstance(self._used_space, int):
            return "0"

        return human(self._used_space)

    @property
    def fill_percent(self) -> str:
        perc = 100. * self._used_space / self._total_size
        return f"{perc:.1f}%"

    @property
    def compress_percent(self) -> str:
        if self._compress_percent:
            return f"{self._compress_percent:.1f}%"
        return "-"

    @used_space.setter
    def used_space(self, value) -> None:
        if isinstance(value, int):
            self._used_space = value

    def handle_btrfs(self, line: str) -> None:
        self.get_btrfs_subvolid(line)
        self.run_compsize()
        self.get_quota()

    def run_compsize(self) -> None:
        if self.mountpoint == "/":  # ignore root
            return

        cmd = ["sudo", "compsize", "-xb", self.mountpoint]
        out, _ = run_command(cmd)
        for line in out:
            if "TOTAL" in line:
                _, _, du, unc, _ = line.split()
                self._total_size = int(du)
                self._compress_percent = 100 - 100. * int(du) / int(unc)

    def get_btrfs_subvolid(self, line):
        match = re.search(r"(?<=subvolid=)\d+", line)
        self.btrfs_subvolume_id = match.group(0)

    def get_quota(self) -> None:
        if self.mountpoint == "/":  # ignore /
            return

        cmd = ["sudo", "btrfs", "qgroup", "show", "--raw", "-r", self.mountpoint]
        lines, err = run_command(cmd)

        if err:
            return

        for line in lines:
            aline = line.split()
            if aline[0] == f"0/{self.btrfs_subvolume_id}":
                _, usage, _, limit = aline
                self._used_space = int(usage)
                if limit != "none":
                    self._total_size = int(limit)

    def __str__(self) -> str:
        if self.width_list is not None:
            wlist = self.width_list
        else:
            wlist = [len(c["name"]) for c in COLUMNS]

        string = ""
        for col, w in zip(COLUMNS, wlist):
            attr = col.get("plike_attr")
            value = getattr(self, attr)
            if col.get("is_number"):
                string = f"{string}{value:>{w+1}s}  "
            else:
                string = f"{string}{value:{w+1}s}  "

        return string


def main():
    conf_fn = os.path.join(os.environ.get("HOME", ""), ".btdf.json")
    conf = get_conf(conf_fn)
    info = DiskInfo(conf)
    info.get_fs_info()
    info.print_headers()
    info.print_rows()


if __name__ == "__main__":
    main()
