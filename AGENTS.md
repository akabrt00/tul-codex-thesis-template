# Project-wide instructions

- Read `PROJECT_CONTEXT.md` and the nearest applicable `AGENTS.md` before changing files.
- Read `PROJECT_PROFILE.json` when it exists. It is local, may contain personal data, and must remain ignored by Git.
- Discover repository skills under `.agents/skills/` and use a matching skill when applicable.
- When `PROJECT_CONTEXT.md` contains `setup_state: template` and the user wants to begin a real project, use `$setup-tul-project` before initializing or editing a document. Do not force onboarding for read-only questions.
- During onboarding, assume no prior Git, GitHub, LaTeX, or terminal experience unless the user demonstrates otherwise. Use plain language, explain jargon at the moment it becomes relevant, accept ordinary faculty and work-type names, and keep questions in small groups.
- Treat `templates/upstream/` as immutable vendor material. Never edit, compile, or use it as an expert/citable source.
- Work on the thesis only in `prace/`, on defense slides only in `obhajoba/`, and on expert sources only in `zdroje/`.
- Automatically use `$matlab-to-tikz` for MATLAB plots, `.fig`, `.mat`, plotting scripts, numeric plot data, and requests for publication-quality LaTeX graphs. Prefer editable PGFPlots with traceable external data over screenshots or opaque raster exports.
- Automatically use `$create-project-visuals` while planning, drafting, or reviewing content when a figure, diagram, image, screenshot, or graph could materially improve explanation. Accept rough descriptions, recommend the useful visual form, and route creation, source extraction, adaptation, or TikZ drawing without requiring the user to name a tool.
- Never add decorative academic visuals merely to fill space. For every used visual, preserve provenance, permissions, scientific meaning, a factual caption, and a stable cross-reference; clearly distinguish reproduced, adapted, original, and AI-generated material.
- For factual or citation-bearing work, search registered project sources first through `zdroje/INDEX_ZDROJU.md` and the page-level index. Verify the original page before citing; if support is missing, report the gap and recommend new evidence.
- Before creating or reviewing citations, read `zdroje/90_zpracovane/poznamky-a-souhrny/SRC-0003_SRC-0004_SRC-0005_citation-policy.md` and then apply any stricter faculty-specific rule recorded in `PROJECT_CONTEXT.md`.
- Register every independently compiled document and its entry point in `PROJECT_CONTEXT.md`. The primary thesis uses `prace/main.tex`; additional formal documents use `prace/dokumenty/<slug>/main.tex`.
- Prefer installed, task-appropriate tools; never install software, packages, fonts, or toolboxes without approval.
- Preserve user changes, avoid machine-specific absolute paths and secrets, and verify every material output.
- After first-time setup, summarize the created files and recommend a fresh focused chat with an exact opening prompt. Create a new chat only when the user explicitly asks.
- After initializing a primary thesis plus an experimental or practical supporting document, recommend two persistent focused chats over the same workspace: `MAIN – hlavní práce` for selective final prose and `EXPERIMENTY – praktický deník` for complete records. Offer `OTÁZKY A REŠERŠE` and later `OBHAJOBA` as optional chats. Explain that chats separate context but do not create separate repositories or duplicate files.
