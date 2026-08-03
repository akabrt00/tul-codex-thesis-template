# Thesis workspace instructions

- Use `$tul-thesis` for all LaTeX thesis and formal-document work.
- Initialize this directory only with `scripts/init-project.ps1`; never copy back into `templates/upstream/`.
- Treat `main.tex` as the default entry point unless `PROJECT_CONTEXT.md` specifies another file.
- Keep the primary work at `prace/main.tex`. Create independently compiled supporting documents only with `scripts/init-project.ps1 -Target Document -DocumentName <slug>` under `prace/dokumenty/<slug>/main.tex`.
- Register every supporting document in the `PROJECT_CONTEXT.md` deliverables table before adding substantive content.
- Keep class, style, font, logo, bibliography, chapter, figure, and table dependencies inside this working tree.
- Store expert evidence in `zdroje/`, not in this directory. Cite it by `citacni_klic` and retain the internal `SRC-NNNN` mapping in the registry.
- Use `$matlab-to-tikz` for MATLAB and numerical plots. Keep document-owned plot data and generated TikZ under `figures/<slug>/`, preserve relative paths, and verify both numerical fidelity and the rendered graph.
- Compile with `scripts/compile-thesis.ps1`. A valid build follows XeLaTeX → Biber → MakeIndex → XeLaTeX → XeLaTeX.
- Inspect the final log and rendered PDF before reporting completion. Do not claim resolved citations when Biber failed or timed out.
