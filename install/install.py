import argparse
import os
from pathlib import Path
import subprocess as sp
import sys

from entities import ConfigFile
from operations import ok, bold, colorize, ko


def parse_args(args: list | None = None) -> argparse.Namespace:
    if args is None:
        args = sys.argv[1:]

    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-f", "--force",
        help="Overwrite existing files.",
        action="store_true",
    )

    return parser.parse_args(args)


def do(*fragments: str) -> None:
    print(colorize(bold(">"), color="blue"), *fragments)


def title(text: str) -> None:
    print(colorize(f"====== {text}", color="dark_turquoise"))


def run(cmd: str) -> str:
    args = cmd.split()
    proc = sp.run(args, capture_output=True)

    return proc.stdout.decode("utf-8").rstrip()  # remove newline at end


def check_zsh(opts: argparse.Namespace) -> bool:
    title("Checking Zsh")
    shell = os.environ["SHELL"]
    shell_is_zsh = shell == "/usr/bin/zsh"
    zsh = run("which zsh")

    if not zsh:
        ko("Zsh not installed. Install before proceeding.")
        return False

    if shell_is_zsh:
        ok("Shell is already Zsh")
    else:
        ko("Zsh is not the default shell.")
        run(f"chsh {zsh}")
        do("Zsh made the default shell. The change will only take effect AFTER you log-in again.")

    config_files = (
        ConfigFile(
            reference=Path("../zsh/zinit/.zshrc"),
            destination=Path.home() / ".zshrc",
        ),
        ConfigFile(
            reference=Path("../zsh/alias.zsh"),
            destination=Path.home() / ".alias.zsh",
        ),
    )

    for config_file in config_files:
        config_file.deploy()

    return True


def main(opts: argparse.Namespace) -> None:
    check_zsh(opts)


if __name__ == "__main__":
    options = parse_args()
    main(options)
    title("vim")
    title("alacritty")
    title("spaceship")
    title("dot files?")
    title("tmux")
