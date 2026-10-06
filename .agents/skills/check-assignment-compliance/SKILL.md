---
name: check-assignment-compliance
description: Compare an existing thesis with its official assignment and declared goals, producing an evidence-linked compliance matrix. Use when the user asks whether all assignment points or thesis goals were fulfilled, or asks to compare the work with the assignment; do not use for prospective outline planning.
---

# Check Assignment Compliance

## Require the authoritative assignment

Read `PROJECT_CONTEXT.md`, the registered thesis, and the official assignment or IS STAG material. Locate it through `$manage-project-sources` when registered. If it is missing or ambiguous, request it and stop before making a compliance verdict. Never reconstruct an assignment from the thesis or memory.

## Build the matrix

1. Transcribe each requirement faithfully and assign a stable local ID.
2. Separate compound requirements without changing their meaning.
3. Map each requirement to concrete thesis sections, pages, figures, tables, data, or appendices using `$tul-thesis` for document inspection.
4. Record the supporting evidence and distinguish a mention from actual fulfillment.
5. Compare declared objectives with methods, results, discussion, and conclusion; verify that the conclusion returns to every objective.

Use only these states: `fulfilled`, `partially-fulfilled`, `unclear`, and `not-found`. Include requirement, location, evidence, state, gap, and next action. Do not rewrite the official requirement to match what the student completed.

## Handle evidence and changes

Use `$manage-project-sources` for factual verification and expose unsupported claims or missing evidence. If the user asks only for a check, report findings without editing. If the user requests fixes, route document changes through `$tul-thesis` and then `$review-agent-output`; no edited sentence alone proves that a requirement was fulfilled.
