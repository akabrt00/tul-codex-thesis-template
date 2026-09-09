---
name: setup-tul-project
description: Set up a TUL thesis template for a new user or project, including complete beginners moving from Word who do not know Git, GitHub, LaTeX, repositories, terminals, or chat organization. Use for first-time orientation and onboarding, creating or updating the local author profile, choosing faculty and work type, initializing the primary thesis or defense slides, adding independently compiled supporting documents such as an experimental diary, registering deliverables, and handing work off to role-separated MAIN, EXPERIMENTY, research, or defense chats.
---

# Set up a TUL project

## Orient a beginner

Match the user's language. Unless the user demonstrates technical experience, use plain language and teach only what is needed for the current decision. Do not begin with a lecture, commands, internal file structure, or unexplained codes.

Start with the user's intended result and available inputs. If these are missing, ask in ordinary language, for example: „Co chceš vytvořit a co už máš? Stačí zadání, rozepsaný text nebo popis nápadu.“ If the user already supplied them, inspect them instead of asking again. Briefly explain that the agent handles project files and the user guides the content. Explain storage, document internals, and review requirements when the relevant action arises.

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

## Reach the first useful result

The sections below are conditional stages, not a questionnaire to finish before helping. Extract known information from supplied inputs, summarize your interpretation, and ask only what the next action requires. Confirm extracted official metadata before using it in document initialization; never infer the generated declaration variant.

Choose a small useful result that advances the user's request:

- With an assignment, identify its explicit requirements and propose a working structure with a purpose for each chapter, using `$plan-thesis-structure`. Keep requirements distinguishable from your suggestions and retain the input location. Follow project source rules when registering or citing supplied documents.
- With only an idea, clarify its intended outcome and prepare a provisional scope and next step. Label assumptions; do not invent an official assignment, evidence, or results.
- With existing text, preserve it and route the requested edit or review to the relevant workflow. Do not initialize a replacement document merely to demonstrate the template.
- If the user explicitly wants setup only, complete that scope without adding unsolicited academic content.

Before the minimum profile is confirmed, a first proposal may be shown in chat. Do not initialize a formal document or mark the project initialized to produce a preview. A missing optional detail, undecided storage, or unavailable compiler need not block a useful content proposal. Explain any real limit on producing a PDF without installing tools automatically.

When the required profile and toolchain are ready, initialize only the requested documents, incorporate the agreed starter content, and build and visually verify the first working PDF through the authoritative project workflow. Open or link the actual output. Distinguish verified output from an unbuilt draft; never present empty template boilerplate as completed substantive work.

Continue the already requested first task after setup instead of stopping at a file inventory or requiring a new chat. Keep ordinary proposals `agent-draft`; use the existing human-review workflow at its defined boundaries. A proposal is not the user's approval of its content.

## Choose storage and sharing

Before configuring GitHub or external storage, ask how the user wants to protect and share the project. Present ordinary choices without forcing one service:

- a private Git repository such as GitHub for versioned text, scripts, configuration, and suitable small assets;
- an institution-managed Google Drive, or another user-selected online store that the current Codex can actually access, for authorized shared data, large photographs or videos, exchange packages, and additional archive copies;
- both, with an explicit division of responsibility;
- local-only work for now, with a separate backup the user controls.

Explain that Git history and online file storage solve different problems. An online store such as Google Drive is not a substitute for Git commits, and an actively edited repository including `.git/` should not be treated as an ordinary synchronized folder. Prefer a dedicated online-storage folder for shared inputs, exported archives, or `predavani/` ZIP packages. Access to a university or commercial account may change, so the user should decide how long-term copies will be retained.

Do not block initialization when the user is undecided. Record only the confirmed non-sensitive storage policy in `PROJECT_CONTEXT.md`; do not store access tokens, private share links, credentials, or machine-specific synchronized paths.

When the user chooses Google Drive or another online store, use `$external-tool-router`. Verify that a connector for that exact service is callable in the current chat before claiming that Codex can browse, upload, or organize its files. If it is unavailable, offer a manual transfer or local export workflow instead of implying access. Before sending unpublished, personal, confidential, licensed, or otherwise sensitive data, name the exact categories and destination, explain a local alternative, and obtain explicit confirmation. Never upload or share a file merely because a connector is available.

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

Use the user's stated goal to identify the needed outputs; ask only if ambiguous. Do not present all output types as a mandatory menu:

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

Recommend focused chats after delivering the first useful result; changing chats is not a prerequisite for continuing the current request.

Read `references/task-prompts.md` after the requested documents and their registered keys are known. Explain that chats share one workspace but keep separate conversational context.

When both a main thesis and a practical, experimental, or technological diary exist, recommend these two persistent chats:

1. `MAIN – hlavní práce` for selective, polished thesis content;
2. `EXPERIMENTY – praktický deník` for complete practical records, including failed attempts and intermediate data.

Offer `OTÁZKY A REŠERŠE` as an optional read-mostly thinking and evidence space. Offer `OBHAJOBA` only when presentation work starts. Do not make a beginner maintain unnecessary chats.

Provide each recommended chat title and an exact opening prompt with the correct registered document key. Create chats only when the user explicitly asks or accepts the offer and the current environment supports it. Before creating, check for an existing matching chat when possible. If chat tools are unavailable, explain how to create them manually. Never imply that a new chat creates a repository, branch, or duplicate document.

## Update durable context

Set `setup_state` in `PROJECT_CONTEXT.md` to `initialized` only after document initialization succeeds. Replace template markers with confirmed non-sensitive project facts. Register every output in the deliverables table with a unique key, role, document type, entry point, status, and purpose.

Keep personal author data in `PROJECT_PROFILE.json`; do not duplicate it in `PROJECT_CONTEXT.md`. Record durable structural decisions and the reason for them.

When confirmed, also record the division between the versioned repository, shared data storage, and additional backups. Use portable logical descriptions rather than local Drive paths or private URLs.

Maintain a short `Current work` section in `PROJECT_CONTEXT.md`: the current task, last actual output and its relative path when present, validation/review status, unresolved input, and next useful action. Save only non-sensitive state, not a conversation transcript. Keep `setup_state: template` if work has reached only a preliminary proposal.

For „chci pokračovat“ or a new chat, read this state and inspect the referenced files before acting. Summarize where work stands and resume the recorded task within its authorization. If state is missing, stale, conflicting, or the next step needs a decision, ask one focused question instead of restarting onboarding or inventing progress.

## Verify and hand off

Run `scripts/validate-skills.ps1`, `scripts/audit-sources.ps1`, and a relevant environment check. Compile initialized documents only when their required metadata and toolchain are ready. Report missing components without installing anything.

Treat LaTeX and Wolfram plugins as optional accelerators that may require a fresh chat after installation. Do not make onboarding depend on them. Use `$review-agent-output` for material tracked metadata or initialized document content, explain the exact review scope in beginner language, and never record approval without the user's explicit decision.

Lead the closing response with the actual result and a link to it when available, what was checked, and the next useful step. Report a blocked PDF honestly and show any useful proposal already prepared. Keep explanations brief and include only applicable items from this list; do not turn the handoff into another introductory manual:

- the profile path and its ignored status;
- every created document key and entry point;
- what metadata is still missing;
- the checks performed;
- a short beginner explanation of what the main source file, generated PDF, local profile, and Git history each do;
- the selected backup and sharing policy, including what stays in Git and what may use the chosen online or institution-managed storage;
- two or three example requests the user can make next without using file paths or terminal commands;
- recommended focused chat titles and exact opening prompts from `references/task-prompts.md`;
- an exact prompt for a new focused chat.

Recommend role-separated fresh chats after onboarding so document work starts with clean context. Create no chat without explicit user agreement.

When only the primary document exists, recommend `MAIN – hlavní práce`. When a practical record also exists, recommend both `MAIN – hlavní práce` and `EXPERIMENTY – praktický deník`; keep the additional chats optional.
