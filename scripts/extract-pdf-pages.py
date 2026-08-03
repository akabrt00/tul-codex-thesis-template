"""Extract a PDF into one UTF-8 text file per physical page."""

from __future__ import annotations

import argparse
from pathlib import Path

from pypdf import PdfReader


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("input_pdf", type=Path)
    parser.add_argument("output_directory", type=Path)
    args = parser.parse_args()

    reader = PdfReader(args.input_pdf)
    args.output_directory.mkdir(parents=True, exist_ok=True)
    for number, page in enumerate(reader.pages, start=1):
        output = args.output_directory / f"page-{number:04d}.txt"
        output.write_text(page.extract_text() or "", encoding="utf-8")

    print(len(reader.pages))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
