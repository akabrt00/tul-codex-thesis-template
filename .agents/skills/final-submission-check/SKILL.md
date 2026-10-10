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
5. Run `scripts/validate-deliverable.ps1` against the produced PDF and build log. Select `-DocumentKind Semester` for the registered semester 1.1 template; it checks `TitulniStrana` and BibTeX instead of ThesisStart/STAG. Never pass `-AllowGeneratedFrontMatter` for a real submission; it exists only for template smoke tests. Use `$local-tool-router` only to discover optional PDF utilities; do not install them.
6. Inspect unresolved metadata, placeholders, citations, references, bibliography, PDF structure, page geometry, fonts, text extraction, representative pages, and warnings through the routed workflows.

Classify every finding as `PASS`, `WARN`, `FAIL`, or `SKIP`. A missing optional validator is `SKIP`, not an invented pass. Any critical failure prevents a technically-ready verdict.

## Report readiness

Give counts and a short table containing check, evidence, status, and required action. Distinguish blocking failures from warnings and unavailable checks. Do not say the work is content-correct, approved, accepted, or guaranteed to meet undisclosed faculty rules.

This workflow is itself a review surface. Use `$review-agent-output` for any material fixes made during the preflight and report `technically checked; awaiting human review` until the user approves the stated scope.

## AI declaration and author verification gate

Run `scripts/check-ai-evidence.ps1 -DocumentKey <registered-key> -Submission -DeclarationPath <plain-UTF8-declaration> -PdfPath <final-PDF> -ReportJson .ci-artifacts/ai-evidence.json`. Reconcile the full ledger manually, including any substantive use omitted from it. The plain-text declaration must match the actual assessed output and applicable form; do not create a claim of no use from an empty ledger. The script checks record structure and full-text PDF presence only. Any FAIL blocks the evidence gate; WARN and missing optional PDF extraction remain unresolved for a human. It never verifies institutional approval, declaration truthfulness or author understanding.

Read `AI_NA_TUL.md` and reconcile `POUZITI_AI.md` with actual work and the target output. Check tool identification, available version, exact affected parts and manner of use, plus teacher/publisher instructions. Check that the required declaration is present in the submitted document/PDF, not only in the ledger. Never modify official IS STAG pages to add it. Ordinary spelling/typography is exempt unless otherwise required in advance. Check explicit description, justification and labeling of AI-generated simulation/test/training data. Report a required missing or misleading declaration or known prohibited-system/protected-data violation as `FAIL`; report unresolved system approval, restrictions or author verification as `WARN` and do not assert full policy compliance. Ask the author to independently verify facts/sources and explain autonomous steps; mark this pending until actual confirmation. Agent checks cannot produce a human-verification PASS. Do not infer compliance from a keyword search or AI detector.
