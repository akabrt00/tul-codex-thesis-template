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

## Deliverables

Register every independently compiled output. Use a stable lowercase key and keep paths relative to the repository root.

| Key | Role | Document type | Entry point | Status | Purpose |
|---|---|---|---|---|---|
| `main` | primary thesis | `[not configured]` | `prace/main.tex` | not initialized | Main academic work |

Additional formal documents belong under `prace/dokumenty/<slug>/main.tex`. Examples include a technological diary, measurement report, project report, or a separately compiled appendix. Defense slides belong in `obhajoba/main.tex`.

## Scope

### In scope

- `[define during onboarding]`

### Out of scope

- `[define during onboarding]`

## Technical environment

- Primary format: LaTeX
- Scientific figures: editable TikZ/PGFPlots with traceable external data; MATLAB conversions use the automatic `$matlab-to-tikz` workflow
- Expected runtime: XeLaTeX, Biber, and MakeIndex
- Supported operating systems: Windows first; keep paths portable
- Expert inputs and source copies: `zdroje/`
- Source retrieval: registry → thematic content maps → page-level fulltext index → original-page verification
- Generated outputs: next to their registered document entry points unless configured otherwise

## Commands

- Environment check: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check-environment.ps1`
- Initialize main thesis: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Thesis`
- Initialize another document: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Document -DocumentName <slug>`
- Initialize defense slides: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\init-project.ps1 -Target Presentation`
- Build a document: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-thesis.ps1 -ProjectDir <document-directory> -MainTex main.tex -Clean`
- Build defense slides: `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\compile-presentation.ps1 -ProjectDir .\obhajoba -MainTex main.tex -Clean`

## Quality criteria

- Every material output must compile from a clean auxiliary state.
- Citations, cross-references, page size, fonts, layout, and final PDF must be verified.
- Every expert source must be traceable through `zdroje/REJSTRIK_ZDROJU.md`.
- Every additional document must have a unique key, directory, purpose, and entry point in the deliverables table.

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
