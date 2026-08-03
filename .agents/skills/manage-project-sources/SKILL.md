---
name: manage-project-sources
description: Automatically manage, index, search, and verify expert and citable project sources under zdroje/. Invoke without requiring the user to name this skill whenever a source file is attached, provided, or placed in zdroje/00_prichozi; when the user asks an evidence-seeking question; or when factual thesis writing, citation, bibliography, source recommendation, import, extraction, mapping, search, or audit is needed. Always exclude templates/ and upstream TUL assets.
---

# Manage Project Sources

## Operate implicitly

Do not require the user to name this skill, request indexing, understand the directory structure, or describe the technical workflow. Automatically invoke it during an active turn when:

- the user attaches or provides a source file for the project;
- a new file is present in `zdroje/00_prichozi/`;
- the user asks what their materials say, requests evidence, or asks a factual question related to the project;
- the user asks to draft or revise factual thesis text, citations, bibliography entries, tables, or figures based on sources;
- the source audit or search layer is missing or stale during such work.

At the start of a source-related turn, inspect the registry, incoming directory, source tree, and search-layer state. Process relevant unregistered or incomplete sources through the full lifecycle before relying on them, and rebuild a missing or stale page index. A file attachment or placement in `zdroje/00_prichozi/` authorizes ordinary in-project ingestion unless the user explicitly asks for read-only inspection; still stop for a material licensing, privacy, source-identity, or public-repository decision that cannot be resolved safely.

Do not ask routine technical questions that can be resolved from the project rules. For an informational question, answer from verified sources without editing thesis documents. When the user asks to write or revise a registered thesis document, automatically insert the supported citation and bibliography data as part of that requested edit. If local evidence is insufficient, return a source-gap recommendation; browse or acquire new material only when the request authorizes it.

This workflow is turn-triggered. Do not claim to monitor folders or process files while no agent task is active.

## Establish context

From the repository root, read `PROJECT_CONTEXT.md`, `zdroje/README.md`, `zdroje/REJSTRIK_ZDROJU.md`, and `zdroje/INDEX_ZDROJU.md`. Treat the category map, registry, and search tree as authoritative. Do not invent a parallel source directory.

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

## Build the searchable source layer

After extracting a source, read `references/source-map-template.md` and create its content map under `zdroje/90_zpracovane/poznamky-a-souhrny/`. Inspect the whole source before mapping it. Record:

- its scope and document structure;
- topics, synonyms, terminology, and page ranges;
- supported claims and the kind and strength of evidence;
- limitations, conflicts, age, and material the source does not support;
- suitable thesis sections or uses.

Update `zdroje/INDEX_ZDROJU.md` with concise thematic branches and a link to the source map. Do not place long quotations or full copyrighted text in either map.

The index is a retrieval aid derived from registered page extractions; it is not evidence by itself and inherits the source's privacy and licensing restrictions. Keep a newly added source in status `příchozí` while completing its registry row, page extraction, content map, and search-tree entry. Then change it to `aktivní`, immediately rebuild the page-level index with `scripts/build-source-search-index.ps1 -Force`, and run the source audit.

## Find or cite sources

Search in this order:

1. `REJSTRIK_ZDROJU.md` for bibliographic identity, authority, provenance, and purpose.
2. `INDEX_ZDROJU.md` and per-source maps for themes, terminology, likely sources, page ranges, and known limitations.
3. `scripts/search-sources.ps1 -Query '<terms>'` for page-level candidates. Try relevant synonyms, abbreviations, Czech/English variants, and narrower terms when needed.
4. Open every matching page text and relevant neighboring pages. For layout-dependent evidence such as tables, equations, diagrams, captions, or ambiguous extraction, visually inspect the corresponding original PDF page.
5. Compare independent or primary sources when the claim is important, disputed, recent, or safety-sensitive.

Never cite from a summary, map, search snippet, or AI memory alone. Treat them only as pointers to the registered original. Distinguish what the source states directly from the agent's inference, and report contradictions rather than silently resolving them.

Use `citacni_klic` in document citations and retain `SRC-NNNN` for internal traceability. For external-facing references, use authoritative bibliographic information or URL from the registry rather than a local path.

When the user asks to place supported text into a thesis, use the applicable thesis skill and citation policy. Cite immediately after the supported statement, include a page locator when required or helpful, and add or update the corresponding bibliography entry. Verify that the rendered citation and bibliography resolve correctly.

If local evidence is insufficient, do not fabricate a citation. Return a source-gap recommendation containing:

- the exact claim or question that remains unsupported;
- source IDs, topics, terms, and page ranges already checked;
- why the available evidence is missing, weak, outdated, secondary, or contradictory;
- the preferred new source type and authority level;
- suggested search terms, identifiers, institutions, databases, standards, manuals, datasets, or measurements.

Search externally or acquire a recommended source only when the user's request authorizes it. Register and index any retained new source before citing it.

## Audit sources

Check for:

- files missing from the registry;
- registry paths that do not exist;
- duplicate or malformed `SRC-NNNN` identifiers;
- missing, duplicate, or filename-inconsistent citation keys;
- duplicate URLs, DOI values, filenames, or checksums;
- derivatives without a source ID or registry link;
- active local PDFs without a page extraction, content map, search-tree entry, or page-level index record;
- stale or malformed global search-index records;
- modified or misplaced originals;
- long-term files left in `00_prichozi/`;
- incomplete provenance, dates, license restrictions, or status;
- active entries whose files have been moved to `99_archiv/`.
- any registry entry or search result pointing into `templates/`.

Report findings before making broad moves, renames, deletions, or deduplication changes. Never delete a source solely because it appears duplicated; preserve it until identity and authorization are clear.

## Finish

Report the source IDs added, searched, or used; exact pages verified; registry, map, and index changes; citations inserted; checks performed; and unresolved evidence, provenance, privacy, or licensing limitations.
