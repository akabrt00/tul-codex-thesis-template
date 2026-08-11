---
name: tul-thesis
description: Create, edit, compile, and visually validate Technical University of Liberec theses and formal documents using the bundled tulthesis LaTeX class and tul package. Use for bachelor or master theses, dissertations, dissertation theses or summaries, habilitation works, semester works, project reports, TUL title/front matter, IS STAG introductory pages, TUL faculty branding, BibLaTeX ISO 690 bibliographies, or any work involving tulthesis.cls, tul.sty, ThesisStart, TULtitle, or TUL document PDFs.
---

# TUL Thesis

## Protect the master

Read `PROJECT_CONTEXT.md` and `references/template-notes.md`. Treat `templates/upstream/TUL/TULthesis/` as immutable upstream material. Its historical ID `SRC-0002` is reserved for migration traceability only; it is not an expert source and must never be cited.

Initialize `prace/` with `scripts/init-project.ps1`. Preserve attribution, README files, class/style files, fonts, logos, bibliography examples, and license information. Never copy changes back to upstream.

## Configure the document

Determine the document type, TUL unit, language, color mode, one/two-sided output, font strategy, title in both languages, author, programme, branch, supervisor, consultants, year, IS STAG introductory PDF, bibliography style, and output path. Use the exact official names and codes supplied by the user or project context; do not guess institutional metadata.

Use supported class options and required metadata from `references/template-notes.md`. Do not assume that README features work when the bundled class header or option forwarding disagrees; test the actual working copy.

## Structure the content

- Keep exactly one active `\ThesisStart` command. Use the user-confirmed `male` or `female` variant for working PDFs; never infer the variant from a name and never leave all variants commented. When the official bachelor/master introductory-pages PDF from IS STAG is provided, warn that it becomes a tracked file containing possible personal data, then run `scripts/set-thesis-start.ps1` to copy it into the document and replace, not supplement, the generated variant.
- Keep Czech and English abstracts and keywords consistent. Apply `[wide]` consistently to all four environments when needed.
- Add acknowledgements, contents, abbreviation list, chapters, bibliography, and appendices in the institutional order required by the project.
- Use stable labels and cross-references for every numbered figure, table, equation, section, and appendix.
- Keep bibliography data in `.bib`; never fabricate missing authors, dates, DOI values, URLs, or access dates.
- Treat claimed ČSN ISO 690:2022 compliance as a requirement to verify, not as guaranteed by selecting `iso-numeric` or `iso-authoryear`.

## Build and verify

Use `$local-tool-router` to inspect XeLaTeX, Biber, MakeIndex, and available fonts/packages. For the bundled examples, use XeLaTeX.

Use `$diagnose-tul-latex` for environment or build failures. Optional generic LaTeX plugin compilers are supplementary diagnostics and never replace the repository's authoritative build sequence.

Compile with `scripts/compile-thesis.ps1`, which enforces this sequence:

1. `xelatex -interaction=nonstopmode -halt-on-error -file-line-error <main.tex>`
2. `biber <jobname>` when BibLaTeX generated a `.bcf`
3. `makeindex <jobname>.idx` when an index is used
4. XeLaTeX twice more

The script must work from a fully clean auxiliary state. Apply a reasonable timeout to Biber and report a hang rather than waiting indefinitely. Never install packages, fonts, Perl, or tool updates without approval.

Inspect the final log for missing files/fonts/packages, undefined citations/references, empty bibliography, duplicate labels, overfull boxes, font substitutions, and page-style warnings. Render the final PDF to images and visually inspect front matter, contents, representative chapters, figures/tables, bibliography, appendices, headers/footers, and page numbering. Confirm A4 media size and expected page count.

Before every reported build, verify that the source contains exactly one uncommented `\ThesisStart`. Treat zero active commands (PDF begins at the abstract) and multiple active commands as blocking document errors.

Deliver the working sources and verified PDF. Report any build stage that did not complete; a first-pass PDF is not a fully verified bibliography or cross-reference build.

For an explicit submission-readiness request, hand off to `$final-submission-check` and `scripts/validate-deliverable.ps1`. After material prose, calculation, citation, visual, metadata, or structure changes, use `$review-agent-output`; a successful build is not human approval.
