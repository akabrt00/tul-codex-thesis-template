---
name: tul-presentation
description: Create, edit, compile, and visually validate Technical University of Liberec presentations using the bundled TULpresentation LaTeX Beamer template. Use for TUL slides, defense presentations, lecture decks, conference presentations, printable handouts, faculty-specific branding, Czech or English TUL presentation output, or any work involving tulpresentation.cls, TULtitleframe, or TULendframe.
---

# TUL Presentation

## Protect the master

Read `PROJECT_CONTEXT.md` and `references/template-notes.md`. Treat `templates/upstream/TUL/TULpresentation/` as immutable upstream material. Its historical ID `SRC-0001` is reserved for migration traceability only; it is not an expert source and must never be cited.

Initialize `obhajoba/` with `scripts/init-project.ps1`. Preserve bundled attribution and license files. Make all content edits only in the working copy and never copy changes back to upstream.

## Configure the presentation

Determine the TUL unit, language, color mode, aspect ratio, handout requirement, external-logo requirement, title, author, institute, email, phone, date, audience, duration, and desired output path. Ask only when an unresolved choice materially affects the result.

Use an explicit aspect option (`aspect169` or `aspect43`) rather than relying on defaults. Use documented faculty options and consult the caveats in `references/template-notes.md` for FUA/FA and handout paper size.

Keep the class, required TUL symbol, local TUL Mono font, and any selected external logo beside the main `.tex` file unless the working project already has a tested LaTeX path setup.

## Author slides

- Define `\TULextlogofile` before `\documentclass` when using `extlogo`.
- Set `\title`, `\author`, `\institute`, `\authorMail`, `\authorPhone`, and `\date`.
- Start with `\TULtitleframe` and finish the public deck with `\TULendframe`.
- Put backup answers after the end frame when preparing a defense.
- Use standard Beamer sections, frames, overlays, and notes without overriding the TUL visual identity unless explicitly requested.
- Keep slide density low, use legible figures, and avoid shrinking text to force content onto a frame.

## Build and verify

Use `$local-tool-router` to check XeLaTeX and dependencies. This template requires XeLaTeX because it uses `fontspec` and `polyglossia`.

Use `$diagnose-tul-latex` for environment or build failures. Keep content selection and defense narrative in `$prepare-defense`; this skill owns technical Beamer realization and validation.

Compile with `scripts/compile-presentation.ps1`, which runs XeLaTeX twice from a clean auxiliary state when requested. Never install missing packages without approval.

If the build reports a missing `beamer.cls`, report the missing Beamer package; do not patch `tulpresentation.cls` to bypass it. Check the log for missing Inter/TUL Mono fonts, missing graphics, overfull boxes, undefined references, and option warnings.

Render the latest PDF to images and inspect the title frame, a dense representative frame, figure/table frames, section transitions, and final frame. Verify aspect ratio, clipping, typography, contrast, page count, and handout sheet size. Deliver only the working source and verified PDF, never generated files from the master directory.

Use `$review-agent-output` after material slide-content changes. Rendering success does not approve scientific meaning, slide selection, or presentation clarity on the author's behalf.
