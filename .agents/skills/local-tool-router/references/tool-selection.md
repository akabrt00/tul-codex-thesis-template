# Tool selection guide

Use this guide only after inspecting the repository and running the capability scan.

| Task | Usually prefer | Choose it when |
|---|---|---|
| Matrix computation, simulation, control, optimization | MATLAB | MATLAB is available and the task or existing assets benefit from its numerical environment or toolboxes |
| Existing Simulink model | MATLAB and Simulink | A relevant license is usable; work on a copy and record release, solver, duration, timestep, tolerances, parameters, and toolboxes |
| Symbolic algebra, calculus, units, special functions | Local Wolfram or callable Wolfram MCP | The backend is actually callable and provides a concrete benefit; its result is computational evidence, not an expert citation |
| General automation, data pipelines, ML, file processing | Python | The project already uses Python or its ecosystem best matches the task |
| MATLAB-compatible numerical fallback | Octave | Existing code is compatible and MATLAB is unavailable; disclose compatibility limits |
| Statistical modelling and established analysis scripts | R | The work depends on R packages, reports, or existing `.R`/`.Rmd` files |
| Web tooling and JavaScript/TypeScript | Node.js | The repository contains the matching package manager and lockfile |
| .NET applications | `dotnet` | The project contains `.sln`, `.csproj`, or `.fsproj` files |
| Typeset technical documents | LaTeX | The project uses `.tex` sources and the project-required engine and passes are available |
| Document conversion | Pandoc | A supported semantic conversion is needed and layout fidelity is acceptable |
| Audio/video inspection or conversion | FFmpeg/ffprobe | Codec-level media work is required |
| Raster conversion and inspection | ImageMagick | Pixel-level conversion or metadata inspection is needed and scientific meaning will be preserved |
| Graph layout | Graphviz | A reproducible node-edge layout is more suitable than manual placement |
| Isolated services/builds | Docker | The repository already defines containers or isolation is a stated requirement and the daemon is usable |

Selection priorities, in order:

1. Existing project conventions and native formats.
2. Correctness and ability to verify the result.
3. Reproducibility in a non-interactive run.
4. Availability without installing or modifying the system.
5. Simplicity and maintainability.

Do not use one absolute tool ranking. Do not silently switch ecosystems. If two tools are genuinely comparable, use the existing stack; otherwise briefly state the tradeoff that determined the choice.

For remote capabilities, prefer current-chat MCP discovery over a hand-written registry. Use an external HTTP API only when explicitly supported, authorized, and safe for the data. Never probe a remote service solely to populate the local capability cache.

