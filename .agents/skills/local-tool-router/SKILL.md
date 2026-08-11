---
name: local-tool-router
description: Detect locally installed developer, scientific, document, media, and build tools and select the most suitable reproducible workflow. Use before computation, data analysis, simulation, optimization, signal or image processing, document/media conversion, compiling, or when a task may benefit from MATLAB, Simulink, Python, R, Julia, Octave, Wolfram, Node.js, .NET, LaTeX, Pandoc, FFmpeg, ImageMagick, Graphviz, Docker, or native build tools.
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

Treat `unavailable` as absent, `unverified` as discovered but not proven runnable, and `available` as successfully probed. The legacy Boolean `available` only means that a command was resolved. Do not infer that a license, toolbox, package, daemon, or network service is usable from executable discovery alone.

Use `-ProbeVersions` on Windows or `--probe-versions` on POSIX only when executable proof matters. On Windows, add `-Tool matlab,python` to scan only task-relevant IDs. Probes are bounded and skip heavyweight MATLAB startup by default. Use `-ProbeMatlab` separately when MATLAB version and license-session evidence are relevant; add `-IncludeMatlabToolboxes` only when the task depends on a toolbox. An installed toolbox is not proof that its license can be checked out.

Write a local cache only when useful:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .agents/skills/local-tool-router/scripts/detect-local-tools.ps1 -ProbeVersions -OutputPath .tool-capabilities.json
```

The cache is Git-ignored, machine-specific, and stale evidence. Regenerate it after moving machines, changing runtimes, installing plugins, or when its timestamp is no longer appropriate for the task.

## Choose the workflow

1. Inspect the repository for an existing stack, scripts, lockfiles, tests, and native file formats.
2. Match the task to the narrowest appropriate tool. Read `references/tool-selection.md` when several candidates fit.
3. Prefer the established project toolchain. Introduce a different tool only for a concrete benefit.
4. Check required packages, MATLAB toolboxes, licenses, services, or runtime versions without changing the machine. Never infer their presence from another user's report.
5. Discover MCP or plugin capabilities lazily for the required task. A local scanner cannot prove current-chat MCP availability.
6. Use non-interactive, reproducible commands. Save important scripts and parameters in the repository.
7. Verify the output with task-appropriate assertions or tests and report the exact tool used.

Never install software, contact an external API, start a daemon, or submit project data merely to discover capabilities. Do not store credentials or sensitive data in a capability report.

## MATLAB rules

- Select MATLAB for matrix-oriented numerical work, simulation, optimization, control, signal/image processing, statistics, or existing MATLAB/Simulink formats.
- Invoke repeatable jobs with `matlab -batch "command"` and allow the process to return a failing exit code.
- Treat Simulink and toolboxes as MATLAB capabilities that require a task-specific MATLAB probe; they are not independent command-line executables.
- Record units, solver choices, tolerances, random seeds, toolbox dependencies, and MATLAB release when they affect results.
- Prefer a simpler native utility or the project's existing Python/R stack for routine file manipulation, text processing, or lightweight tabular work.
- Do not install toolboxes or alter licenses. Explain a missing dependency and choose a safe fallback when possible.
- If MATLAB is unavailable or only unverified, select a suitable installed alternative or clearly identify the unmet requirement.
