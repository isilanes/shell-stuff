import argparse
import sys


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


def main(args: argparse.Namespace) -> None:
    print(args)


if __name__ == "__main__":
    args = parse_args()
    main(args)