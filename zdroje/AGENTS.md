# Expert-source instructions

- Invoke `$manage-project-sources` automatically for every add, import, download, classification, extraction, citation, lookup, evidence question, or audit operation. Never require the user to know or type the skill name.
- On each source-related active turn, check `00_prichozi/` and the search-layer state. Process pending sources and rebuild stale indexes before relying on them; do not claim unattended background monitoring.
- Scan and manage only `zdroje/`. Always ignore `templates/`, `prace/`, `obhajoba/`, build outputs, and repository skills.
- Never offer TUL templates, their manuals, logos, examples, or classes as expert evidence or citations.
- Preserve each stable internal ID `SRC-NNNN`. Never reuse or renumber an ID, including reserved retired IDs.
- Give every expert source a separate `citacni_klic`; default it to the local source filename without its extension.
- Keep originals unchanged. Put derivatives under `90_zpracovane/` and link them to both the source ID and citation key.
- Extract PDF text with `scripts/extract-pdf-text.ps1` so every text file maps to exactly one PDF page and the manifest records the mapping.
- For every active local PDF, maintain a content map, an entry in `INDEX_ZDROJU.md`, and page records in the generated search index.
- Treat maps and search results only as navigation. Verify the original page before using a claim or citation.
- If the registered sources do not support the requested claim, report the evidence gap and recommend a suitable new primary or authoritative source instead of fabricating support.
- Run `scripts/audit-sources.ps1` after material changes.
