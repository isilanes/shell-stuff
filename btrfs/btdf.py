from __future__ import annotations
from typing import Optional
import subprocess as sp


COLUMNS = [
    {
        "name": "Device",
        "plike_attr": "device",
    },
    {
        "name": "Size",
        "plike_attr": "total_size",
    },
    {
        "name": "Used",
        "plike_attr": "used_space",
    },
    {
        "name": "Mounted on",
        "plike_attr": "mountpoint",
    },
]


def run_command(cmd: list) -> str:
    proc = sp.Popen(cmd, stdout=sp.PIPE)
    out, _ = proc.communicate()
    if not isinstance(out, str):
        out = out.decode("utf-8")

    return out


def get_max_widths(partitions) -> list:
    wlist = []
    for col in COLUMNS:
        max_w = len(col["name"])
        for p in partitions:
            w = len(str(getattr(p, col["plike_attr"])))
            max_w = max(max_w, w)
        wlist.append(max_w)

    return wlist


class DFInfo:

    CMD = ["/bin/df", "-B1"]

    def __init__(self):
        self._partitions = None

    def run(self) -> list:
        out = run_command(self.CMD)
        partitions = []
        for line in out.split("\n"):
            partition = PartitionLike.parse_df_line(line)
            if partition is not None:
                partitions.append(partition)

        self._partitions = partitions

    @property
    def partitions(self) -> list:
        if self._partitions is None:
            self.run()

        return self._partitions


class PartitionLike:

    def __init__(self, device=None, size=None, used=None, mountpoint=None) -> None:
        self.device = device
        self.total_size = size
        self.used_space = used
        self.mountpoint = mountpoint
        self.width_list = None

    @staticmethod
    def parse_df_line(line: str) -> Optional[PartitionLike]:
        if line.startswith("Filesystem "):
            return None

        if "/" not in line:
            return None

        dev, size, used, _, _, mountpoint = line.split()

        return PartitionLike(device=dev, size=size, used=used, mountpoint=mountpoint)

    def __str__(self) -> str:
        string = ""

        if self.width_list is not None:
            wlist = self.width_list
        else:
            wlist = [len(c["name"]) for c in COLUMNS]

        for col, w in zip(COLUMNS, wlist):
            attr = col["plike_attr"]
            value = getattr(self, attr)
            string = f"{string}{value:{w+2}s}"

        return string


def main():
    df_info = DFInfo()
    plist = df_info.partitions

    plist_widths = get_max_widths(plist)

    string = ""
    for col, w in zip(COLUMNS, plist_widths):
        string = f"{string}{col['name']:{w+2}s}"

    print(string)

    for partition in plist:
        partition.width_list = plist_widths
        print(partition)


if __name__ == "__main__":
    main()
