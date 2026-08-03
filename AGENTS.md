# Project-wide instructions

- Read `PROJECT_CONTEXT.md` and the nearest applicable `AGENTS.md` before changing files.
- Read `PROJECT_PROFILE.json` when it exists. It is local, may contain personal data, and must remain ignored by Git.
- Discover repository skills under `.agents/skills/` and use a matching skill when applicable.
- When `PROJECT_CONTEXT.md` contains `setup_state: template` and the user wants to begin a real project, use `$setup-tul-project` before initializing or editing a document. Do not force onboarding for read-only questions.
- During onboarding, assume no prior Git, GitHub, LaTeX, or terminal experience unless the user demonstrates otherwise. Use plain language, explain jargon at the moment it becomes relevant, accept ordinary faculty and work-type names, and keep questions in small groups.
- Treat `templates/upstream/` as immutable vendor material. Never edit, compile, or use it as an expert/citable source.
- Work on the thesis only in `prace/`, on defense slides only in `obhajoba/`, and on expert sources only in `zdroje/`.
- Source handling is implicit. On any source-related active turn, automatically use `$manage-project-sources` when the user attaches or provides a document, places a file in `zdroje/00_prichozi/`, asks an evidence-seeking question, or requests factual thesis text or citations. Never require the user to know or name the skill.
- Before relying on project evidence, detect unregistered incoming files and missing or stale source indexes, then process or rebuild them as needed. This runs during an active agent turn, not as an unattended background watcher.
- For factual or citation-bearing work, search registered project sources first through `zdroje/INDEX_ZDROJU.md` and the page-level index. Verify the original page before citing; if support is missing, report the gap and recommend new evidence.
- Keep ordinary source questions read-only with respect to thesis documents. Insert supported text and citations into a thesis only when the user asks to write, revise, or update that document.
- Before creating or reviewing citations, read `zdroje/90_zpracovane/poznamky-a-souhrny/SRC-0003_SRC-0004_SRC-0005_citation-policy.md` and then apply any stricter faculty-specific rule recorded in `PROJECT_CONTEXT.md`.
- Register every independently compiled document and its entry point in `PROJECT_CONTEXT.md`. The primary thesis uses `prace/main.tex`; additional formal documents use `prace/dokumenty/<slug>/main.tex`.
- Prefer installed, task-appropriate tools; never install software, packages, fonts, or toolboxes without approval.
- Preserve user changes, avoid machine-specific absolute paths and secrets, and verify every material output.
- After first-time setup, summarize the created files and recommend a fresh focused chat with an exact opening prompt. Create a new chat only when the user explicitly asks.
