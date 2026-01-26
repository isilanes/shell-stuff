from colored import style, fore


def ok(*fragments: str) -> None:
    print(green(bold("✔")), *fragments)


def green(s: str) -> str:
    return colorize(s, color="green")


def bold(s: str) -> str:
    return f"{style("bold")}{s}{style("reset")}"


def colorize(s: str, color: str) -> str:
    return f"{fore(color)}{s}{style("reset")}"


def hi(s: str) -> str:
    return colorize(s, color="light_yellow")


def ko(*fragments: str) -> None:
    print(red(bold("✖")), *fragments)


def red(s: str) -> str:
    return colorize(s, color="red")
