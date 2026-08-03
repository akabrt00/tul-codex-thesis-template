# TULthesis reference

## Master and license

- Historical source ID (reserved, no longer citable): `SRC-0002`
- Master: `templates/upstream/TUL/TULthesis/` (immutable, non-citable)
- README/manual version: 2.3 (2025)
- `tulthesis.cls` header: 2.1 dated 2024-02-08
- License stated by README and class/style headers: CC BY; retain author attribution and license information

## Class options

- Work type: `BP` (default), `DP`, `Dis`, `Teze`, `Autoref`, `Hab`, `SP`, or `Proj`.
- Base structure: `report` (default) or `article` for shorter works.
- Unit: default TUL, or `FS`, `FT`, `FP`, `EF`, `FA`, `FM`, `FZS`, `CXI`. Use `FA` for the Faculty of Arts and Architecture because `tulthesis.cls` forwards `FA`.
- Language: Czech default or `EN`.
- Appearance: `bw`, `bwtitles`, `sfheadings`, and standard class options such as `twoside`.
- `fonts` enables fontspec-based TUL font setup. The bundled `tul.sty` declares `localfonts`, but the bundled `tulthesis.cls` does not explicitly forward that option; test before relying on it.
- `nopdf` suppresses Hyperref loading through the class.

Require `titlesec` 2.10.2 or newer. Core dependencies include `tul.sty`, ifthen, tabularray, pdfpages, graphicx, xcolor, fancyhdr, titlesec, and Hyperref unless `nopdf` is used.

## Preamble metadata

```tex
\documentclass[FM,BP]{tulthesis}
\TULtitle{Český název}{English title}
\TULauthor{Author}
\TULprogramme{code}{Český program}{English programme}
\TULbranch{code}{Český obor}{English branch}
\TULsupervisor{Supervisor}
\TULconsultant{Optional consultant}
\TULyear{2026}
```

`\TULprogramme` is not required for habilitation works. `\TULbranch` may repeat for combined branches and is required for habilitation. `\TULthesisType{CZ}{EN}` defines a custom work type.

## Front matter and environments

- `\ThesisStart{male}` or `\ThesisStart{female}` generates class front matter.
- `\ThesisStart{introductory-pages.pdf}` inserts IS STAG pages. For current BP/DP workflows, prefer the official STAG PDF when available.
- Use `abstractCZ`, `keywordsCZ`, `abstractEN`, `keywordsEN`, `acknowledgement`, and `abbrList`.
- `[wide]` is available for abstracts, keywords, and acknowledgement.
- The manual describes older one-page abbreviation limitations, but the bundled class now uses long `tabularray`; still test multipage lists visually.

## Bibliography

The bundled manual demonstrates BibLaTeX with Biber and `biblatex-iso690`, normally `style=iso-numeric`; FZS notes mention `iso-authoryear` with `\parencite`. Use `\printbibliography[...,heading=bibintoc]` to include the bibliography in the contents.

The bundled notes state that the output was aligned with the older ČSN ISO 690 implementation while the manual references ČSN ISO 690:2022. Verify current faculty/university requirements and the installed style version before claiming compliance.

## Validation findings from 2026-08-03

- A clean build in an isolated working copy succeeded in the required order: XeLaTeX, Biber, MakeIndex, XeLaTeX, XeLaTeX.
- The completed output has 26 A4 pages. Visual inspection confirmed the TUL/FM title page, populated contents, resolved numeric citations, conclusion, appendices, page numbers, and readable body layout.
- Remaining log messages are layout/font warnings from the upstream example (font-size substitutions, selected overfull/underfull boxes, and `fancyhdr` head-height warnings); there are no unresolved citations or references after the full build.
- The local `latexmk` executable could not run because its required Perl engine was missing. Use explicit XeLaTeX/Biber/MakeIndex passes as fallback.
