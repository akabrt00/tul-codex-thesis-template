# TULpresentation reference

## Master and license

- Historical source ID (reserved, no longer citable): `SRC-0001`
- Master: `templates/upstream/TUL/TULpresentation/` (immutable, non-citable)
- README/manual version: 2.3 (May 2025)
- `tulpresentation.cls` header: 2.2 dated 2025-04-28
- License stated by README and class header: CC BY; retain attribution and bundled license material

## Required environment and files

- Compile with XeLaTeX.
- Required LaTeX features include Beamer, polyglossia, fontspec, pgfpages for handouts, graphbox, graphicx, xcolor, TikZ, and ifthen.
- Require the system font Inter.
- Keep `TULMono-Bold.otf`, `tulpresentation.cls`, and `symbol-tul-wh.pdf` with the working main file.
- Keep the selected external-logo PDF when using `extlogo`.

## Class options

- Unit: default `TUL`; documented faculty/institute choices are `FS`, `FT`, `FP`, `EF`, `FM`, `FZS`, and `CXI`.
- FUA compatibility: the class source mixes `FA` and `FUA` declarations. Test the chosen option; prefer `FA` if `FUA` is passed through to Beamer or rejected.
- Language: Czech by default; `EN` changes TUL branding text. Also set polyglossia's default language to English for English content.
- Color: default unit color; `bw` changes title/header/footer branding to black.
- Aspect: `aspect43` or `aspect169`. The manual example explicitly uses `aspect169`; class code otherwise defaults to 4:3.
- `handout`: Beamer handout with two slides per sheet.
- `extlogo`: inserts `\TULextlogofile` in the title-frame lower-right corner.

## User commands

```tex
\newcommand{\TULextlogofile}{external-logo.pdf} % before documentclass, only with extlogo
\documentclass[FM,aspect169]{tulpresentation}
\title{Presentation title}
\author{Author}
\institute{Unit TUL}
\newcommand{\authorMail}{name@example.cz}
\newcommand{\authorPhone}{+420 ...}
\date{\today}
...
\TULtitleframe
...
\TULendframe
```

## Known caveats

- The bundled class repeats some option declarations and processes options twice. Treat unknown-option messages as significant.
- `handout` currently configures pgfpages with `letterpaper`, although the README describes two slides on A4. Inspect the resulting media size before printing; change only the working copy after an explicit decision.
- The manual filename contains the typo `manual-tulpresentaion.tex`; preserve it in the master.
- Validation on 2026-08-03 found XeLaTeX but could not compile because the local MiKTeX installation lacked `beamer.cls`. This is an environment dependency, not evidence of a class defect.
- The bundled 30-page example PDF is 16:9 (453.54 × 255.12 pt). Visual inspection confirmed the purple TUL title frame, content hierarchy, branded footer, and backup slides after the public ending; validate frame numbering when backup slides are present.
