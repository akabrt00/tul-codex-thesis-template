# Thesis workspace instructions

- Use `$tul-thesis` for all LaTeX thesis and formal-document work.
- Initialize this directory only with `scripts/init-project.ps1`; never copy back into `templates/upstream/`.
- Treat `main.tex` as the default entry point unless `PROJECT_CONTEXT.md` specifies another file.
- Keep the primary work at `prace/main.tex`. Create independently compiled supporting documents only with `scripts/init-project.ps1 -Target Document -DocumentName <slug>` under `prace/dokumenty/<slug>/main.tex`.
- Register every supporting document in the `PROJECT_CONTEXT.md` deliverables table before adding substantive content.
- Keep class, style, font, logo, bibliography, chapter, figure, and table dependencies inside this working tree. Organized TULthesis keeps metadata/packages in `nastaveni/`, technical files in `sablona/`, and bibliography in `literatura/zdroje.bib`; semester 1.1 keeps `literatura.bib` next to `main.tex` and graphics in `podklady/`.
- Store expert evidence in `zdroje/`, not in this directory. Cite it by `citacni_klic` and retain the internal `SRC-NNNN` mapping in the registry.
- Use `$matlab-to-tikz` when creating, converting, restyling, repairing, or inserting a MATLAB or numerical plot. Keep document-owned plot data and generated TikZ under `figures/<slug>/`, preserve relative paths, and verify both numerical fidelity and the rendered graph.
- Use `$create-project-visuals` when a visual is actually being created, sourced, adapted, inserted, or audited. A brief recommendation during routine writing does not require loading it. Keep document-ready assets under `figures/<slug>/` with provenance, caption intent, and source-page links; never alter evidentiary imagery in a meaning-changing way.
- Use `$manage-experiments` for every practical or experimental record and for every transfer from a registered diary into the main thesis. Keep stable `EXP-NNNN` identifiers, complete raw history, file links, and explicit promotion records.
- Use `$verify-scientific-calculations` for material scientific results and preserve their `CALC-NNNN` records next to the registered document; routine arithmetic and trivial checks need no record.
- Use `$review-agent-output` for an explicit review, grouped handoff/checkpoint, final-submission workflow, or recorded human decision. Keep intermediate edits as `agent-draft`; a successful build never replaces the author's approval.
- Use `$diagnose-tul-latex` for environment or build failures without replacing the project compile script or installing anything without approval.
- Use `$final-submission-check` only for an explicit submission-readiness request; use `$check-assignment-compliance`, `$review-supervisor-feedback`, and `$review-thesis-chapter` for their distinct review scopes.
- Compile with `scripts/compile-thesis.ps1`. TULthesis follows XeLaTeX → Biber → MakeIndex → XeLaTeX → XeLaTeX. Semester 1.1 is detected from its style and uses pdfLaTeX → BibTeX (with citations) → pdfLaTeX → pdfLaTeX; validate it with `-DocumentKind Semester`. It uses exactly one `\TitulniStrana` instead of `\ThesisStart`.
- Inspect the final log and rendered PDF before reporting completion. Do not claim resolved citations when Biber failed or timed out.
