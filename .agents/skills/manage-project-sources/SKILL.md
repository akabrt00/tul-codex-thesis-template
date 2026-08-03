---
name: manage-project-sources
description: Manage the complete lifecycle of expert and citable project sources under zdroje/, including assigning stable SRC identifiers and citation keys, classifying originals, recording provenance, extracting PDFs with page mapping, creating traceable derivatives, locating citations, and auditing the registry. Use whenever Codex adds, downloads, imports, organizes, converts, extracts, summarizes, cites, retrieves, or checks expert sources; always exclude templates/ and upstream TUL assets.
---

# Manage Project Sources

## Establish context

From the repository root, read `PROJECT_CONTEXT.md`, `zdroje/README.md`, and `zdroje/REJSTRIK_ZDROJU.md`. Treat the category map and registry as authoritative. Do not invent a parallel source directory.

Restrict every scan, search, duplicate check, suggestion, and citation lookup to `zdroje/`. Ignore all content under `templates/`, `prace/`, `obhajoba/`, `.agents/`, and generated build directories. Never register or cite TUL classes, manuals, logos, example PDFs, fonts, or other upstream template assets.

Read `references/command-recipes.md` when calculating checksums or auditing paths and duplicates.

Determine whether the request is to add, acquire, process, find, cite, or audit sources. A request to answer or explain something without building project materials does not by itself require saving a local copy.

## Add or acquire a source

1. Confirm that saving the material is within the task scope and allowed by its license, privacy constraints, and terms. Store only a registry link when a local copy is unnecessary or prohibited.
2. Search the registry and source tree for duplicates by URL/DOI, title, filename, and checksum when available. Reuse an existing entry instead of duplicating it.
3. Allocate the next unused sequential ID after the highest registered or reserved `SRC-NNNN`. Never renumber existing entries or reuse retired/reserved IDs. The current first available ID is documented in the registry.
4. Select the category using `zdroje/README.md`. Use `00_prichozi/` only when classification genuinely requires later review.
5. Preserve the acquired or user-provided original. Copy it into the selected category; do not modify or remove the external original. Use `SRC-NNNN_short-description.ext` when renaming is safe.
6. Set `citacni_klic` independently from the internal ID. Default it to the saved source filename without its extension and verify uniqueness before use.
7. Calculate SHA-256 with an available native tool when practical. Do not install a hashing utility.
8. Add the complete registry row only after the local file is safely present. For link-only sources, set the status and local-path field to `pouze odkaz` and create a stable citation key from authoritative metadata.
9. Verify that the registered path, citation key, URL, date, and checksum match the saved material.

When web research produces several candidates, register only sources actually used or intentionally retained for the project. Prefer original publications, official documentation, standards bodies, datasets, and other primary sources.

## Process a source

1. Keep the original unchanged.
2. Place every derivative in the matching `zdroje/90_zpracovane/` subdirectory.
3. Start each derivative filename with the original source ID and citation key. Preserve meaningful extensions and avoid ambiguous names such as `final` or `new`.
4. Add derivative paths to the original registry row. When combining multiple originals, list every contributing source ID in the derivative's header or companion note and in each relevant registry row.
5. Record non-obvious transformations, parameters, OCR language, software version, units, and assumptions in the derived file or an adjacent note.
6. Validate that the derivative can be traced back to every original.

For PDF text extraction, run `scripts/extract-pdf-text.ps1`. Require one text file per source PDF page and a manifest mapping page number to the derived file. Never merge pages into an unstructured text file when the result may support quotation, review, or citation.

## Find or cite sources

Search `REJSTRIK_ZDROJU.md` first by ID, citation key, title, author, URL, and purpose. Then inspect the registered local path. Do not change files during a find-only request and never search `templates/` for citable evidence.

Use `citacni_klic` in document citations and retain `SRC-NNNN` for internal traceability. For external-facing references, use authoritative bibliographic information or URL from the registry rather than a local path.

## Audit sources

Check for:

- files missing from the registry;
- registry paths that do not exist;
- duplicate or malformed `SRC-NNNN` identifiers;
- missing, duplicate, or filename-inconsistent citation keys;
- duplicate URLs, DOI values, filenames, or checksums;
- derivatives without a source ID or registry link;
- modified or misplaced originals;
- long-term files left in `00_prichozi/`;
- incomplete provenance, dates, license restrictions, or status;
- active entries whose files have been moved to `99_archiv/`.
- any registry entry or search result pointing into `templates/`.

Report findings before making broad moves, renames, deletions, or deduplication changes. Never delete a source solely because it appears duplicated; preserve it until identity and authorization are clear.

## Finish

Report the source IDs added or used, their locations, registry changes, derivatives created, verification performed, and unresolved provenance or licensing limitations.
