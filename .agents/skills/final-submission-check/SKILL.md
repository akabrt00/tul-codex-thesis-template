---
name: final-submission-check
description: Orchestrate the last technical and evidence preflight for a registered thesis, supporting document, or defense PDF. Use only when the user asks whether a document is ready for submission, requests a final check, submission check, deliverable validation, or preflight; do not use for routine drafting or compilation.
---

# Final Submission Check

## Establish scope

Read `PROJECT_CONTEXT.md`, the nearest `AGENTS.md`, and `PROJECT_PROFILE.json` when present and relevant. Resolve the requested deliverable from the registry; never guess metadata or silently choose among multiple documents. State that the verdict covers technical readiness and available evidence, not academic correctness or institutional acceptance.

## Run the gates

1. Use `$check-assignment-compliance` when the official assignment is available. Treat missing assignment evidence as an explicit limitation.
2. Use `$manage-project-sources` to audit registered sources and citation traceability.
3. Use `$audit-figures-and-tables` and `$terminology-consistency` for the target document when material.
4. Use `$tul-thesis` or `$tul-presentation` to perform the authoritative clean build and visual inspection. Never replace project build scripts with a generic compiler.
5. Run `scripts/validate-deliverable.ps1` against the produced PDF and build log. Never pass `-AllowGeneratedFrontMatter` for a real submission; it exists only for template smoke tests. Use `$local-tool-router` only to discover optional PDF utilities; do not install them.
6. Inspect unresolved metadata, placeholders, citations, references, bibliography, PDF structure, page geometry, fonts, text extraction, representative pages, and warnings through the routed workflows.

Classify every finding as `PASS`, `WARN`, `FAIL`, or `SKIP`. A missing optional validator is `SKIP`, not an invented pass. Any critical failure prevents a technically-ready verdict.

## Report readiness

Give counts and a short table containing check, evidence, status, and required action. Distinguish blocking failures from warnings and unavailable checks. Do not say the work is content-correct, approved, accepted, or guaranteed to meet undisclosed faculty rules.

This workflow is itself a review surface. Use `$review-agent-output` for any material fixes made during the preflight and report `technically checked; awaiting human review` until the user approves the stated scope.
