# Tool selection guide

Use this guide only after inspecting the repository and running the capability scan.

| Task | Usually prefer | Choose it when |
|---|---|---|
| Matrix computation, simulation, control, optimization | MATLAB | MATLAB is available and the task or existing assets benefit from its numerical environment or toolboxes |
| General automation, data pipelines, ML, file processing | Python | The project already uses Python or its ecosystem best matches the task |
| Statistical modelling and established analysis scripts | R | The work depends on R packages, reports, or existing `.R`/`.Rmd` files |
| Web tooling and JavaScript/TypeScript | Node.js | The repository contains the matching package manager and lockfile |
| .NET applications | `dotnet` | The project contains `.sln`, `.csproj`, or `.fsproj` files |
| Typeset technical documents | LaTeX | The project uses `.tex` sources and a local TeX engine is available |
| Document conversion | Pandoc | A supported semantic conversion is needed and layout fidelity is acceptable |
| Audio/video inspection or conversion | FFmpeg/ffprobe | Codec-level media work is required |
| Isolated services/builds | Docker | The repository already defines containers or isolation is a stated requirement |

Selection priorities, in order:

1. Existing project conventions and native formats.
2. Correctness and ability to verify the result.
3. Reproducibility in a non-interactive run.
4. Availability without installing or modifying the system.
5. Simplicity and maintainability.

Do not silently switch ecosystems. If two tools are genuinely comparable, use the existing stack; otherwise briefly state the tradeoff that determined the choice.

