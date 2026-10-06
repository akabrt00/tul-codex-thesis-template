---
name: diagnose-tul-latex
description: Diagnose TUL LaTeX environment and build failures without confusing generic LaTeX compilation with the repository's required workflow. Use for missing XeLaTeX, Biber, MakeIndex, fonts, packages, classes, bibliography failures, unresolved references, encoding errors, compilation hangs, broken PDFs, Tectonic or latexmk routing questions, newly installed LaTeX plugins, or requests to check whether a machine is ready to build a TUL thesis, supporting document, or defense presentation.
---

# Diagnose TUL LaTeX

## Preserve the authoritative build

Read `PROJECT_CONTEXT.md`, the nearest `AGENTS.md`, and the applicable `$tul-thesis` or `$tul-presentation` skill. Diagnose before changing files. Do not install, update, or replace TeX distributions, packages, fonts, Perl, or runtimes without explicit approval.

For TUL theses and formal documents, the repository command remains authoritative:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-thesis.ps1 -ProjectDir <document-directory> -MainTex main.tex -Clean
```

It enforces XeLaTeX → Biber → MakeIndex → XeLaTeX → XeLaTeX. For TUL presentations, use `scripts/compile-presentation.ps1`. Do not replace these workflows with Tectonic, a single compiler pass, or generic `latexmk` merely because an optional plugin offers them.

## Route the diagnosis

Read `references/routing.md` and proceed from narrowest evidence to broader checks:

1. Inspect the failing command, exit stage, log, and generated files.
2. Run `scripts/check-environment.ps1` and `$local-tool-router` when environment state is relevant.
3. When the installed LaTeX plugin exposes `$latex-doctor`, use it as an additional environment and smoke-test report. If the plugin is not callable in this chat, continue with project scripts and say so.
4. Use the plugin's generic `$latex-compile` only for independent simple `.tex` smoke tests, never as proof that the TUL multi-pass build is correct.
5. Classify the cause: missing runtime, missing package or font, wrong engine, bibliography/index stage, encoding, file path, document source, timeout, or rendering defect.
6. Propose the smallest repair. Implement it only when the user asked for a fix.

Compilation success proves that a PDF was generated, not that its academic content or visual result is correct. Render and inspect material pages through `$tul-thesis` or `$tul-presentation`, then route content approval through `$review-agent-output`.

## Finish

Report the failing stage, evidence, likely cause, what was and was not tested, whether optional plugin tools were actually callable, safe repair options, and any remaining human review. Never recommend that every student install a second TeX distribution when the existing one is usable.
