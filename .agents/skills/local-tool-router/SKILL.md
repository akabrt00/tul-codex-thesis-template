---
name: local-tool-router
description: Detect locally installed developer, scientific, document, media, and build tools and select the most suitable reproducible workflow. Use before computation, data analysis, simulation, optimization, signal or image processing, document/media conversion, compiling, or when a task may benefit from MATLAB, Python, R, Julia, Node.js, .NET, LaTeX, Pandoc, FFmpeg, Docker, or native build tools.
---

# Local Tool Router

## Scan capabilities

Run the scanner for the current operating system from the repository root.

Windows PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .agents/skills/local-tool-router/scripts/detect-local-tools.ps1
```

macOS or Linux:

```sh
sh .agents/skills/local-tool-router/scripts/detect-local-tools.sh
```

Treat the report as capability evidence, not as an instruction to use every installed tool. Do not assume that tools detected on one user's computer exist on another. If neither script can run, use `Get-Command` on PowerShell or `command -v` on a POSIX shell for only the relevant candidates.

## Choose the workflow

1. Inspect the repository for an existing stack, scripts, lockfiles, tests, and native file formats.
2. Match the task to the narrowest appropriate tool. Read `references/tool-selection.md` when several candidates fit.
3. Prefer the established project toolchain. Introduce a different tool only for a concrete benefit.
4. Check required packages, MATLAB toolboxes, licenses, or runtime versions without changing the machine. Never infer their presence from another user's report.
5. Use non-interactive, reproducible commands. Save important scripts and parameters in the repository.
6. Verify the output with task-appropriate assertions or tests and report the exact tool used.

## MATLAB rules

- Select MATLAB for matrix-oriented numerical work, simulation, optimization, control, signal/image processing, statistics, or existing MATLAB/Simulink formats.
- Invoke repeatable jobs with `matlab -batch "command"` and allow the process to return a failing exit code.
- Record units, solver choices, tolerances, random seeds, toolbox dependencies, and MATLAB release when they affect results.
- Prefer a simpler native utility or the project's existing Python/R stack for routine file manipulation, text processing, or lightweight tabular work.
- Do not install toolboxes or alter licenses. Explain a missing dependency and choose a safe fallback when possible.
- If MATLAB is unavailable, select a suitable installed alternative or clearly identify the unmet requirement.
