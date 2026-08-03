---
name: setup-tul-project
description: Set up a cloned TUL thesis template for a new user or project. Use for first-time onboarding, creating or updating the local author profile, choosing faculty and work type, initializing the primary thesis or defense slides, adding independently compiled supporting documents such as a technological diary, registering deliverables, or handing work off to a fresh focused AI chat.
---

# Set up a TUL project

## Inspect the state

Read `AGENTS.md`, `PROJECT_CONTEXT.md`, `PROJECT_PROFILE.example.json`, and the nearest workspace instructions. Read `PROJECT_PROFILE.json` when it exists, but never stage or commit it.

Treat `setup_state: template` as uninitialized. Do not force onboarding for a read-only question. Preserve an existing profile and initialized document unless the user explicitly asks to replace it.

## Collect the minimum profile

Ask only for missing values and keep the conversation in small groups. Require these values before initializing the primary document:

- full name and optional preferred form of address;
- faculty or unit code: `FS`, `FT`, `FP`, `EF`, `FA`, `FM`, `FZS`, or `CXI`;
- work type: `BP`, `DP`, `Dis`, `Teze`, `Autoref`, `Hab`, `SP`, or `Proj`;
- language: `CZ` or `EN`;
- submission year.

Then collect what is already known: Czech and English title, programme code and names, branch or specialization, supervisor, consultant, and IS STAG introductory-pages PDF. Allow unknown optional values to remain empty. Never guess official institutional metadata.

Ask which outputs are needed:

1. primary thesis or formal work;
2. defense presentation;
3. independently compiled supporting documents, each with a stable lowercase slug and purpose.

Examples of supporting documents include `technologicky-denik`, `merici-protokol`, and `projektova-zprava`.

## Protect personal data

Explain that `PROJECT_PROFILE.json` is ignored by Git, while initialized `.tex` documents may be tracked and can contain the author's name. If the repository may be public, obtain confirmation before copying personal data into tracked files. Never write secrets or unnecessary personal identifiers.

Create the profile with `scripts/setup-profile.ps1`. Pass user-provided values exactly. Do not use `-Force` unless the user explicitly approves replacing an existing profile. Parse the created JSON to verify it.

## Initialize the requested workspaces

Use `$tul-thesis` for thesis and formal-document initialization and `$tul-presentation` for defense slides.

- Primary work: run `scripts/init-project.ps1 -Target Thesis` only when `prace/main.tex` does not exist.
- Defense slides: run `scripts/init-project.ps1 -Target Presentation` only when `obhajoba/main.tex` does not exist.
- Supporting document: run `scripts/init-project.ps1 -Target Document -DocumentName <slug>`.

After copying, edit only the working copy. Configure `\documentclass` options and TUL metadata from the profile. Keep official data empty or visibly marked when the user has not supplied it. Prefer an official IS STAG introductory-pages PDF for current BP/DP workflows when available.

Use these entry points:

- `prace/main.tex` for the primary work;
- `prace/dokumenty/<slug>/main.tex` for each supporting document;
- `obhajoba/main.tex` for defense slides.

Do not treat an ordinary chapter or a PDF appendix embedded in the primary work as a separate document. Create a supporting workspace only when it needs its own compilation, title metadata, page numbering, or independent output PDF.

## Update durable context

Set `setup_state` in `PROJECT_CONTEXT.md` to `initialized`. Replace template markers with confirmed non-sensitive project facts. Register every output in the deliverables table with a unique key, role, document type, entry point, status, and purpose.

Keep personal author data in `PROJECT_PROFILE.json`; do not duplicate it in `PROJECT_CONTEXT.md`. Record durable structural decisions and the reason for them.

## Verify and hand off

Run `scripts/validate-skills.ps1`, `scripts/audit-sources.ps1`, and a relevant environment check. Compile initialized documents only when their required metadata and toolchain are ready. Report missing components without installing anything.

Finish with:

- the profile path and its ignored status;
- every created document key and entry point;
- what metadata is still missing;
- the checks performed;
- an exact prompt for a new focused chat.

Recommend a fresh chat after onboarding so document work starts with clean context. Do not create a new chat unless the user explicitly asks. Example:

> Work on the `main` document registered in `PROJECT_CONTEXT.md`. Read `AGENTS.md`, `PROJECT_CONTEXT.md`, and my local profile first. Help me plan the document structure before writing content.
