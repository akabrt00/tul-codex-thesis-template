# Expert-source instructions

- Use `$manage-project-sources` for every add, import, download, classification, extraction, citation, lookup, or audit operation.
- Scan and manage only `zdroje/`. Always ignore `templates/`, `prace/`, `obhajoba/`, build outputs, and repository skills.
- Never offer TUL templates, their manuals, logos, examples, or classes as expert evidence or citations.
- Preserve each stable internal ID `SRC-NNNN`. Never reuse or renumber an ID, including reserved retired IDs.
- Give every expert source a separate `citacni_klic`; default it to the local source filename without its extension.
- Keep originals unchanged. Put derivatives under `90_zpracovane/` and link them to both the source ID and citation key.
- Extract PDF text with `scripts/extract-pdf-text.ps1` so every text file maps to exactly one PDF page and the manifest records the mapping.
- Run `scripts/audit-sources.ps1` after material changes.

