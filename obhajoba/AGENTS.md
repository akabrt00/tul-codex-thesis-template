# Defense-presentation workspace instructions

- Use `$tul-presentation` for all TUL Beamer and defense-presentation work.
- Initialize this directory only with `scripts/init-project.ps1`; never copy back into `templates/upstream/`.
- Treat `main.tex` as the default entry point unless `PROJECT_CONTEXT.md` specifies another file.
- Keep the public closing frame before backup slides intended for questions.
- Store expert evidence in `zdroje/`, not in this directory. Cite it by `citacni_klic` and retain the internal `SRC-NNNN` mapping in the registry.
- Compile with `scripts/compile-presentation.ps1` and visually inspect title, representative content, figures/tables, closing, and backup slides.
- Verify aspect ratio, clipping, legibility, footer numbering, and handout page size when applicable.

