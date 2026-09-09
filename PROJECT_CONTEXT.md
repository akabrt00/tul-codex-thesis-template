# Project context

`setup_state: template`

This tracked file describes the project, its deliverables, and durable decisions. Personal author data belongs in the Git-ignored `PROJECT_PROFILE.json`. During onboarding, replace the template markers below with concrete project information and set `setup_state` to `initialized`.

## Goal

- Primary outcome: `[not configured]`
- Intended audience: `[not configured]`
- Topic or assignment: `[not configured]`

## TUL document defaults

- Faculty or unit: `[not configured]`
- Primary work type: `[BP/DP/Dis/Teze/Autoref/Hab/SP/Proj]`
- Language: `[CZ/EN]`
- Main document: `prace/main.tex`
- Bibliography and citation requirements: follow the TUL policy summary in `zdroje/90_zpracovane/poznamky-a-souhrny/SRC-0003_SRC-0004_SRC-0005_citation-policy.md`; confirm the faculty-specific citation system during onboarding
- IS STAG introductory-pages PDF: `[not provided]`
- Working title-page mode: generated `male` or `female` variant selected during onboarding; replace with the official IS STAG PDF before final submission

## Deliverables

Register every independently compiled output. Use a stable lowercase key and keep paths relative to the repository root.

| Key | Role | Document type | Entry point | Status | Purpose |
|---|---|---|---|---|---|
| `main` | primary thesis | `[not configured]` | `prace/main.tex` | not initialized | Main academic work |

Additional formal documents belong under `prace/dokumenty/<slug>/main.tex`. Examples include a technological diary, measurement report, project report, or a separately compiled appendix. Defense slides belong in `obhajoba/main.tex`.

## Current work

- Current task: `[not started]`
- Last output and relative path: `[none]`
- Validation and human-review status: `[not applicable]`
- Missing input: `[not assessed]`
- Next useful action: understand the user's intended result and available inputs, then prepare the first useful proposal

Keep this checkpoint short and non-sensitive. Update it after meaningful progress, verify referenced files when resuming, and retain `setup_state: template` until a formal document is actually initialized.

## Scope

### In scope

- `[define during onboarding]`

### Out of scope

- `[define during onboarding]`

## Storage and collaboration

- Versioned repository and history: `[not configured: private Git hosting / local Git / other]`
- Shared or large data: `[not configured: institution-managed Google Drive / another supported online storage / local storage / other]`
- Additional backup policy: `[not configured]`
- External connector status: optional capability only; availability never authorizes upload or sharing
- Storage rule: keep `.git/` out of ordinary synchronized shared folders; record only portable logical locations, never credentials, private share links, or machine-specific paths

## Technical environment

- Primary format: LaTeX
- Scientific figures: editable TikZ/PGFPlots with traceable external data; use `$matlab-to-tikz` when a MATLAB or numerical graph is actually created or converted
- Visual workflow: ordinary planning may recommend a useful visual briefly; load `$create-project-visuals` only when creating, sourcing, adapting, inserting, or specifically auditing one
- Expected runtime: XeLaTeX, Biber, and MakeIndex
- Supported operating systems: Windows first; keep paths portable
- Expert inputs and source copies: `zdroje/`
- Source retrieval: registry → thematic content maps → page-level fulltext index → original-page verification
- Generated outputs: next to their registered document entry points unless configured otherwise
- Recommended chat topology: `MAIN – hlavní práce`; `EXPERIMENTY – praktický deník` when a practical record exists; optional `OTÁZKY A REŠERŠE` and `OBHAJOBA`
- Experimental workflow: complete records use stable `EXP-NNNN` IDs in a registered practical document; selected material reaches the main thesis only through a verified promotion record
- Calculation workflow: material scientific results use stable `CALC-NNNN` records, explicit assumptions, a reproducible primary method, an independent cross-check, and subsequent human review; routine arithmetic and trivial checks do not
- Review workflow: iterative agent output remains `agent-draft`; grouped review checkpoints are technically checked and remain `awaiting-human-review` until the author explicitly approves their stated scope
- Collaboration workflow: exchange between separate project copies uses verified packages under `predavani/`; integrity checks precede a target-by-target diff, and no package is applied as an automatic merge
- Storage workflow: the author chooses private Git hosting, institution-managed Google Drive or another online store supported by the current Codex, a combination, or local-only work; Git history and file-storage backups remain distinct, connector access is verified before it is claimed, and every external transfer has an explicit destination and data scope
- Optional accelerators: Wolfram may cross-check symbolic or numerical work and the LaTeX plugin may assist diagnostics; neither is required, neither replaces project scripts or expert sources, and sensitive data requires confirmation before external processing

## Commands

- Environment check: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-environment.ps1`
- Initialize main thesis: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Thesis`
- Initialize another document: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Document -DocumentName <slug>`
- Initialize defense slides: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Presentation`
- Replace generated title pages with IS STAG PDF: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\set-thesis-start.ps1 -ProjectDir .\prace -StagPdf <provided-pdf>`
- Build a document: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-thesis.ps1 -ProjectDir <document-directory> -MainTex main.tex -Clean`
- Build defense slides: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-presentation.ps1 -ProjectDir .\obhajoba -MainTex main.tex -Clean`
- Validate a built deliverable: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate-deliverable.ps1 -ProjectDir <document-directory> -DocumentKind <Thesis|Document|Presentation>`
- Lint project-owned files: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\lint-project.ps1`
- Create a handoff package: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\new-handoff-package.ps1 -Name <name> -SourcePaths <paths>`
- Verify and archive a handoff package: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-handoff-package.ps1 -PackagePath <package-directory> [-CreateZip]`

## Quality criteria

- Every material output must compile from a clean auxiliary state.
- Citations, cross-references, page size, fonts, layout, and final PDF must be verified.
- Every expert source must be traceable through `zdroje/REJSTRIK_ZDROJU.md`.
- Every additional document must have a unique key, directory, purpose, and entry point in the deliverables table.
- Every handed-off or checkpointed material agent output must receive explicit human review after technical checks; passing compilation or automated validation is not approval of meaning, evidence, or academic quality.
- Every material scientific result must retain assumptions, units, reproducible inputs, an independent cross-check, and a link to its grouped human-review decision.

## Constraints and safety

- Never edit `templates/upstream/`.
- Never commit `PROJECT_PROFILE.json`, secrets, or machine-specific absolute paths.
- Do not guess official faculty, programme, branch, supervisor, or assignment metadata.
- Preserve originals in `zdroje/` and place derivatives only under `zdroje/90_zpracovane/`.

## Durable decisions

- 2026-08-03: Personal onboarding data is stored in Git-ignored `PROJECT_PROFILE.json`; project structure and non-sensitive decisions remain in this tracked file.
- 2026-08-03: `prace/main.tex` is the primary thesis entry point. Independently compiled supporting documents use `prace/dokumenty/<slug>/main.tex`.
- 2026-08-03: Evidence work is local-first. Search maps and indexes locate candidates, but only verified registered source pages may support thesis claims; missing support becomes an explicit source gap.
- 2026-08-03: Citation defaults are based on registered primary TUL sources `SRC-0003` to `SRC-0005`; faculty-specific requirements take precedence and must be confirmed rather than guessed.
- 2026-08-03: MATLAB and numerical plots should be converted to editable PGFPlots/TikZ with preserved data and verified rendering instead of inserted as screenshots when practical.
- 2026-08-03: Visuals are purpose-led rather than decorative. Each used figure must be traceable as original, reproduced, adapted, or AI-generated; evidence-bearing imagery may not be generatively altered.
- 2026-08-03: Long-running work should use role-separated chats over one shared workspace. The main chat curates final thesis content; the experimental chat preserves complete practical records; question/research and defense chats remain optional and focused.
- 2026-08-03: The experimental diary is the complete practical source of truth. The main thesis contains only selected, verified synthesis, with every promoted method, value, graph, and conclusion traceable back to experiment IDs and files.
- 2026-08-04: Every initialized formal document must contain exactly one active `\ThesisStart`. Onboarding selects the temporary generated `male` or `female` variant; the primary thesis later switches to the official IS STAG introductory PDF for submission.
- 2026-08-11: Agent output follows a two-gate workflow: technical validation followed by explicit human review. The agent may never approve its own work or equate a successful build with academic correctness.
- 2026-08-11: Wolfram and LaTeX plugins are optional accelerators. Local reproducible fallbacks remain supported, project compile scripts are authoritative, and plugin output is not an expert citation.
- 2026-08-11: Final submission readiness uses a deterministic PASS/WARN/FAIL preflight after the authoritative clean build. Technical readiness is explicitly separate from academic correctness and institutional acceptance.
- 2026-08-31: Collaboration across separate project copies uses portable handoff packages with relative target paths, SHA-256 integrity checks, sensitive-file blocking, and mandatory review before integration. Package integrity never substitutes for content review.
- 2026-09-02: The public collaboration example starts with wholly synthetic data. A real thesis excerpt may replace it only after a separate privacy, confidentiality, provenance, and redistribution review.
- 2026-09-03: Onboarding presents storage as a human decision. Private Git hosting is suitable for versioned project history, while Google Drive or another online store that the current Codex can actually access may hold authorized shared data, large media, handoff ZIPs, or additional archives. Missing connector access falls back to manual transfer or local export, and connector availability never implies permission to upload.
