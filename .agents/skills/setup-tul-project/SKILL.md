---
name: setup-tul-project
description: Set up a TUL thesis template for a new user or project, including complete beginners moving from Word who do not know Git, GitHub, LaTeX, repositories, terminals, or chat organization. Use for first-time orientation and onboarding, creating or updating the local author profile, choosing faculty and work type, initializing the primary thesis or defense slides, adding independently compiled supporting documents such as an experimental diary, registering deliverables, and handing work off to role-separated MAIN, EXPERIMENTY, research, or defense chats.
---

# Set up a TUL project

## Orient a beginner

Match the user's language. Unless the user demonstrates technical experience, use plain language and teach only what is needed for the current decision. Do not begin with a lecture, commands, internal file structure, or unexplained codes.

At the start, briefly explain that:

- the user should work in a personal project copy and the agent will verify that assumption before publishing or writing personal data into tracked files;
- the agent will handle most file and LaTeX operations while the user controls content and confirms personal or official data;
- the editable sources produce a PDF for reading and submission.

When Git metadata exists, inspect the `origin` URL. If it still points to the original template repository, explain the difference between the original, a personal repository, and a local-only copy before writing personal data into tracked files. Recommend **Use this template** and a private repository to a beginner. Do not create, publish, or reconnect a repository without the user's authorization.

Use these dialogue rules:

- ask at most three closely related questions at once when possible;
- accept ordinary answers such as „Fakulta textilní“ or „bakalářská práce“ and translate them to internal codes only after confirming the interpretation;
- explain a code such as `FT` or `BP` after the human-readable name, not instead of it;
- accept „nevím“, „nejsem si jistý“ and „doplním později“ for optional metadata without repeatedly asking;
- when a script requires a provisional value, explain why, propose one clearly marked value, and obtain confirmation;
- summarize the intended human-visible result before running initialization;
- do not require the user to type terminal commands when the agent can safely perform the operation.

## Inspect the state

Read `AGENTS.md`, `PROJECT_CONTEXT.md`, `PROJECT_PROFILE.example.json`, and the nearest workspace instructions. Read `PROJECT_PROFILE.json` when it exists, but never stage or commit it.

Treat `setup_state: template` as uninitialized. Do not force onboarding for a read-only question. Preserve an existing profile and initialized document unless the user explicitly asks to replace it.

## Collect the minimum profile

Ask only for missing values and keep the conversation in small groups. Ask with human-readable names and normalize the confirmed answers internally. Require these values before initializing the primary document:

- full name and optional preferred form of address;
- faculty or unit, normalized after confirmation to `FS`, `FT`, `FP`, `EF`, `FA`, `FM`, `FZS`, or `CXI`;
- work type, normalized after confirmation to `BP`, `DP`, `Dis`, `Teze`, `Autoref`, `Hab`, `SP`, or `Proj`;
- language: `CZ` or `EN`;
- submission year.
- generated TUL title-page/declaration variant: ask in plain language whether to use the male or female variant, then normalize to `male` or `female`. Never infer it from the user's name.

Use these name mappings when the user answers without codes:

- Fakulta strojní → `FS`; Fakulta textilní → `FT`; Fakulta přírodovědně-humanitní a pedagogická → `FP`;
- Ekonomická fakulta → `EF`; Fakulta umění a architektury → `FA`; Fakulta mechatroniky, informatiky a mezioborových studií → `FM`;
- Fakulta zdravotnických studií → `FZS`; Ústav pro nanomateriály, pokročilé technologie a inovace → `CXI`;
- bakalářská práce → `BP`; diplomová práce → `DP`. For less common work types, state the interpreted code and ask for confirmation.

Then collect what is already known: Czech and English title, programme code and names, branch or specialization, and supervisor or consultant. Allow unknown optional values to remain empty. Explain that the selected `male` or `female` variant creates the working title and declaration pages. The official IS STAG introductory-pages PDF normally arrives later and will replace this generated variant before submission. Never guess official institutional metadata.

Ask which outputs are needed:

1. primary thesis or formal work;
2. defense presentation;
3. independently compiled supporting documents, each with a stable lowercase slug and purpose.

Examples of supporting documents include `technologicky-denik`, `merici-protokol`, and `projektova-zprava`.

## Protect personal data

Explain that `PROJECT_PROFILE.json` is ignored by Git, while initialized `.tex` documents may be tracked and can contain the author's name. If the repository may be public, obtain confirmation before copying personal data into tracked files. Never write secrets or unnecessary personal identifiers.

Create the profile with `scripts/setup-profile.ps1` and pass the confirmed variant through `-FrontMatterVariant male` or `-FrontMatterVariant female`. Pass user-provided values exactly. Do not use `-Force` unless the user explicitly approves replacing an existing profile. Parse the created JSON to verify it.

## Initialize the requested workspaces

Use `$tul-thesis` for thesis and formal-document initialization and `$tul-presentation` for defense slides.

- Primary work: run `scripts/init-project.ps1 -Target Thesis` only when `prace/main.tex` does not exist.
- Defense slides: run `scripts/init-project.ps1 -Target Presentation` only when `obhajoba/main.tex` does not exist.
- Supporting document: run `scripts/init-project.ps1 -Target Document -DocumentName <slug>`.

The initializer creates a minimal starter and fills known metadata from the profile. After copying, edit only the working copy. Review `\documentclass` options and all TUL metadata; keep official data visibly marked when the user has not supplied it. Prefer an official IS STAG introductory-pages PDF for current BP/DP workflows when available.

Require exactly one active `\ThesisStart` command in every initialized formal document. The initializer must activate the confirmed `male` or `female` variant; all alternatives remain commented. If no variant is confirmed, stop before initialization and ask the user instead of generating a document that begins with the abstract.

When the user later provides the official IS STAG introductory-pages PDF, explain that the copied PDF becomes a tracked project file and may contain personal data; obtain confirmation before adding it to a public repository. Then use `scripts/set-thesis-start.ps1 -ProjectDir prace -StagPdf <provided-pdf>`. This copies it to `prace/front-matter/stag-intro.pdf`, deactivates both generated variants, activates only the PDF command, records the portable path in `PROJECT_CONTEXT.md`, and updates the ignored local profile. Compile and visually verify the title/front matter after the switch. Never add a second active `\ThesisStart` line.

Use these entry points:

- `prace/main.tex` for the primary work;
- `prace/dokumenty/<slug>/main.tex` for each supporting document;
- `obhajoba/main.tex` for defense slides.

When a supporting document's confirmed purpose is a practical, laboratory, experimental, or technological diary, record that purpose in `PROJECT_CONTEXT.md` and use `$manage-experiments` for its records. Do not create a placeholder experiment during onboarding; create `EXP-0001` only when the user supplies the first real practical record.

Do not treat an ordinary chapter or a PDF appendix embedded in the primary work as a separate document. Create a supporting workspace only when it needs its own compilation, title metadata, page numbering, or independent output PDF.

## Plan focused chats

Read `references/task-prompts.md` after the requested documents and their registered keys are known. Explain that chats share one workspace but keep separate conversational context.

When both a main thesis and a practical, experimental, or technological diary exist, recommend these two persistent chats:

1. `MAIN – hlavní práce` for selective, polished thesis content;
2. `EXPERIMENTY – praktický deník` for complete practical records, including failed attempts and intermediate data.

Offer `OTÁZKY A REŠERŠE` as an optional read-mostly thinking and evidence space. Offer `OBHAJOBA` only when presentation work starts. Do not make a beginner maintain unnecessary chats.

Provide each recommended chat title and an exact opening prompt with the correct registered document key. Create chats only when the user explicitly asks or accepts the offer and the current environment supports it. Before creating, check for an existing matching chat when possible. If chat tools are unavailable, explain how to create them manually. Never imply that a new chat creates a repository, branch, or duplicate document.

## Update durable context

Set `setup_state` in `PROJECT_CONTEXT.md` to `initialized`. Replace template markers with confirmed non-sensitive project facts. Register every output in the deliverables table with a unique key, role, document type, entry point, status, and purpose.

Keep personal author data in `PROJECT_PROFILE.json`; do not duplicate it in `PROJECT_CONTEXT.md`. Record durable structural decisions and the reason for them.

## Verify and hand off

Run `scripts/validate-skills.ps1`, `scripts/audit-sources.ps1`, and a relevant environment check. Compile initialized documents only when their required metadata and toolchain are ready. Report missing components without installing anything.

Finish in the user's language with:

- the profile path and its ignored status;
- every created document key and entry point;
- what metadata is still missing;
- the checks performed;
- a short beginner explanation of what the main source file, generated PDF, local profile, and Git history each do;
- two or three example requests the user can make next without using file paths or terminal commands;
- recommended focused chat titles and exact opening prompts from `references/task-prompts.md`;
- an exact prompt for a new focused chat.

Recommend role-separated fresh chats after onboarding so document work starts with clean context. Create no chat without explicit user agreement.

When only the primary document exists, recommend `MAIN – hlavní práce`. When a practical record also exists, recommend both `MAIN – hlavní práce` and `EXPERIMENTY – praktický deník`; keep the additional chats optional.
