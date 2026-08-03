# Defense-presentation workspace instructions

- Use `$tul-presentation` for all TUL Beamer and defense-presentation work.
- Initialize this directory only with `scripts/init-project.ps1`; never copy back into `templates/upstream/`.
- Treat `main.tex` as the default entry point unless `PROJECT_CONTEXT.md` specifies another file.
- Keep the public closing frame before backup slides intended for questions.
- Store expert evidence in `zdroje/`, not in this directory. Cite it by `citacni_klic` and retain the internal `SRC-NNNN` mapping in the registry.
- Use `$matlab-to-tikz` for MATLAB and numerical plots. Adapt line weight, labels, and density for projection while keeping the plotted values consistent with the thesis.
- Compile with `scripts/compile-presentation.ps1` and visually inspect title, representative content, figures/tables, closing, and backup slides.
- Verify aspect ratio, clipping, legibility, footer numbering, and handout page size when applicable.
