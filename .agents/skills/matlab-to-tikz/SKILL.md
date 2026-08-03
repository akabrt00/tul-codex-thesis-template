---
name: matlab-to-tikz
description: Convert MATLAB plots, .fig files, plotting scripts, .mat data, tables, CSV exports, or described numerical results into polished, editable TikZ/PGFPlots figures for LaTeX theses and TUL presentations. Invoke automatically when the user asks to create, convert, restyle, repair, or insert a MATLAB graph, diagram, plot, subplot, curve, scatter plot, bar chart, error-bar chart, heatmap, or publication-quality scientific figure; also use when replacing MATLAB screenshots or raster graphs with vector LaTeX output.
---

# MATLAB to TikZ

## Establish the target

Read `PROJECT_CONTEXT.md`, the nearest `AGENTS.md`, and the registered document entry point. Use `$local-tool-router` before running MATLAB, Python, or LaTeX. Use `$tul-thesis` or `$tul-presentation` when inserting or compiling the result.

Determine the intended document, figure width, language, units, caption, label, series meaning, uncertainty definition, and whether exact visual reproduction or a clearer redesign is wanted. Infer routine styling from the document, but never invent units, data, uncertainty, or scientific meaning.

Store document-owned figure material below `<document>/figures/<slug>/`. Keep generated `.tex`, manifest, and compact data files together with portable relative paths. If input data are externally sourced evidence, register and cite them through `$manage-project-sources`; do not move expert originals into the document tree.

## Select the conversion path

1. For a `.fig`, run `scripts/export_matlab_figure.m` in MATLAB to export supported series and metadata, then run `scripts/manifest_to_pgfplots.py`.
2. For an existing `.m` plotting script, run it reproducibly with `matlab -batch`, save the resulting figure as `.fig`, and use the same exporter. Prefer a small wrapper over modifying the user's original analysis.
3. For `.mat`, table, CSV, or numeric arrays, inspect variable names, dimensions, units, missing values, and ordering. Export only the plotted values to a documented table and construct PGFPlots directly.
4. If `matlab2tikz` is already installed, it may provide a comparison candidate, but do not install it or trust its output without cleanup and compilation. Prefer the bundled data-first route for maintainability.
5. If MATLAB is unavailable, work from user-provided exported data or readable text formats. Do not pretend that a binary `.fig` or proprietary `.mat` was converted.

The bundled exporter supports ordinary line, stair, scatter, bar, and error-bar series. Reconstruct unsupported objects such as surfaces, heatmaps, contours, polar axes, 3-D views, annotations, or complex subplot layouts deliberately from the source script/data. State any property that could not be preserved automatically.

## Export reproducibly

Invoke MATLAB non-interactively from the skill directory added to its path. Use absolute paths only in the command invocation; generated files must contain relative portable paths.

```powershell
matlab -batch "addpath('.agents/skills/matlab-to-tikz/scripts'); export_matlab_figure('input.fig','prace/figures/example/data')"
py .agents/skills/matlab-to-tikz/scripts/manifest_to_pgfplots.py `
  prace/figures/example/data/manifest.json `
  prace/figures/example/plot.tex
```

Record the MATLAB release, relevant toolboxes, script entry point, parameters, units, solver settings, random seed, and transformations whenever they affect the result. Preserve full-precision plotted data. Downsample only for a measured file-size or compilation problem, document the method, and verify that extrema, discontinuities, uncertainty, and conclusions remain unchanged.

## Design the figure

Read `references/figure-quality.md` for styling and accessibility rules. Treat generated TikZ as a draft:

- use `pgfplots` axes rather than drawing scientific plots manually;
- use document text fonts and real mathematical notation;
- encode series with both color and line/marker style;
- put quantities and units in axis labels, not unexplained scale factors;
- keep legends concise and place them where they do not hide data;
- use grid lines sparingly and remove decorative effects;
- keep data in external tables when there are more than a few points;
- use stable `\label{fig:<slug>}` and a factual caption in the document.

Add only the required preamble support, normally `\usepackage{pgfplots}` and one project-wide `\pgfplotsset{compat=<installed version>}`. Do not silently change the scientific values while improving presentation.

## Insert and verify

Insert the generated file with `\input{figures/<slug>/plot.tex}` inside the registered document. Compile from a clean auxiliary state using the document skill. Inspect the log and rendered PDF at final size, checking clipping, font consistency, Czech characters, decimal formatting, axes, units, legend, markers, line weights, grayscale distinction, caption, cross-reference, and page placement.

Compare exported values against MATLAB or the original data using point counts, ranges, representative samples, and uncertainty columns. For visual fidelity, compare the MATLAB rendering and final PDF, but prefer thesis readability over copying MATLAB defaults.

Report input files, conversion route, generated files, supported and reconstructed objects, data checks, build result, and any remaining semantic or visual question.
