import os
import sys
import glob
import time
import argparse
import subprocess as sp


def parse_args(args=sys.argv[1:]):

    parser = argparse.ArgumentParser()

    parser.add_argument("file_name",
                        help="LaTeX file to process.",
                        metavar="FN",
                        type=str,
                        nargs=1)

    parser.add_argument("--bib",
                        help="Run BibTeX too. Default: don't.",
                        action="store_true",
                        default=False)

    parser.add_argument("--view",
                        help="Open PDF in viewer. Default: don't.",
                        action="store_true",
                        default=False)

    return parser.parse_args(args)


def wait_and_exit():
    input("Enter to exit: ")  # wait for input
    exit()


def do(command):
    try:
        sp.run(command, shell=True, check=True)
    except sp.CalledProcessError:
        wait_and_exit()


def check_tex(fn):
    """Check for some possible errors, before going head-on to compile."""

    # Pre-parse:
    line_num = 0
    errors = False
    with open(f'{fn}.tex') as f:
        for line in f:
            line_num += 1
                
            # Some errors:
            if "begin{tabular}" in line:
                if "begin{tabular}{" not in line:
                    print(f'Missing column specification in tabular environment (line {line_num})')
                    errors = True
    
    if errors:
        time.sleep(10)
        sys.exit()


def main(opts):
    # Check common errors:
    fn = opts.file_name[0].replace('.tex', '')  # just in case
    check_tex(fn)

    # Compile:
    do(f"pdflatex -halt-on-error {fn}.tex")

    # BibTeX:
    if opts.bib:
        do(f'bibtex {fn}')
        do(f'pdflatex -halt-on-error {fn}.tex')

    # Compile again:
    do(f'pdflatex -halt-on-error {fn}.tex')

    # View, and return control:
    if opts.view:
        do(f'evince {fn}.pdf &')

    # Clean up:
    for ext in ['toc', 'dvi', 'log', 'out', 'mat', 'aux', 'mtc*', 'maf']:
        file_list = glob.glob(f'{fn}.{ext}')
        for filename in file_list:
            os.remove(filename)


if __name__ == "__main__":
    options = parse_args()
    main(options)
