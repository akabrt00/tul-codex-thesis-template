# Defense-presentation workspace instructions

- Use `$tul-presentation` for all TUL Beamer and defense-presentation work.
- Initialize this directory only with `scripts/init-project.ps1`; never copy back into `templates/upstream/`.
- Treat `main.tex` as the default entry point unless `PROJECT_CONTEXT.md` specifies another file.
- Keep the public closing frame before backup slides intended for questions.
- Store expert evidence in `zdroje/`, not in this directory. Cite it by `citacni_klic` and retain the internal `SRC-NNNN` mapping in the registry.
- Use `$matlab-to-tikz` when a MATLAB or numerical plot is actually being created, converted, restyled, repaired, or inserted. Adapt line weight, labels, and density for projection while keeping the values consistent with the thesis.
- Use `$create-project-visuals` when a thesis visual will actually be reused, adapted, inserted, or audited for projection. Prefer simplified, legible redraws over dense screenshots while preserving attribution and meaning.
- Use `$verify-scientific-calculations` for material new results shown on slides; routine arithmetic and trivial checks need no `CALC-NNNN` record.
- Use `$review-agent-output` at an explicit review or handoff checkpoint, not after every iterative slide edit. Rendering checks cannot approve scientific meaning, selection, or presentation clarity.
- Use `$diagnose-tul-latex` for environment or build failures without replacing the project compile script or installing anything without approval.
- Use `$prepare-defense` for selecting the defense story and `$mock-defense` for rehearsal; keep this workspace's `$tul-presentation` skill focused on technical slide realization and validation.
- Compile with `scripts/compile-presentation.ps1` and visually inspect title, representative content, figures/tables, closing, and backup slides.
- Verify aspect ratio, clipping, legibility, footer numbering, and handout page size when applicable.
