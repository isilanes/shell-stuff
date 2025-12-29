import argparse
import os
import subprocess as sp
import sys
from pathlib import Path, PosixPath

from colored import fore, style


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


def bold(s: str) -> str:
    return f"{style("bold")}{s}{style("reset")}"


def colorize(s: str, color: str) -> str:
    return f"{fore(color)}{s}{style("reset")}"


def green(s: str) -> str:
    return colorize(s, color="green")


def red(s: str) -> str:
    return colorize(s, color="red")


def hi(s: str) -> str:
    return colorize(s, color="light_yellow")


def ok(*fragments: str) -> None:
    print(green(bold("✔")), *fragments)


def ko(*fragments: str) -> None:
    print(red(bold("✖")), *fragments)


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

    files = (
        (Path("../zsh/zshrc"), Path.home() / ".zshrc"),
        (Path("../zsh/alias.zsh"), Path.home() / ".alias.zsh"),
    )

    for orig, dest in files:
        if dest.is_file() and not opts.force:
            ok("File", hi(str(dest)), "already exists")
            continue

        if not orig.is_file():
            ko("Tried to install file", hi(str(orig)), "but it does not exist!")
            return False

        orig.copy(dest)
        ok("Installed file", hi(str(dest)), "successfully")

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
