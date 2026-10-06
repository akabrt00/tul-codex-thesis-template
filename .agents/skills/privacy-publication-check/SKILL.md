---
name: privacy-publication-check
description: Inspect a Git repository before public sharing for tracked personal data, secrets, private documents, sensitive attachments, publication restrictions, and source licensing risks. Use when the user asks whether the repository or project can be published, made public, shared, or checked for sensitive data; do not use for ordinary source ingestion.
---

# Privacy Publication Check

## Inspect the publication boundary

Read `PROJECT_CONTEXT.md`, `.gitignore`, Git tracked-file status, and the source registry. Inspect only the repository and user-authorized attachments. Check for:

- tracked `PROJECT_PROFILE.json`, `.env` files, credentials, tokens, private keys, connection strings, and machine-specific configuration;
- names, emails, telephone numbers, student identifiers, addresses, signatures, private comments, and unintended document metadata;
- unpublished reports, raw participant or company data, restricted appendices, official pages containing personal data, and source copies whose licenses prohibit redistribution;
- generated files or histories that expose confidential paths or values.

Use `$manage-project-sources` for license, provenance, and source-registry restrictions. This is a repository-wide publication audit, not a substitute for legal advice or institutional approval.

## Report without leaking

Never print a complete secret or sensitive value. Report category, safely localized file, tracked status, severity, and remediation; redact values and avoid copying personal data into the report. Distinguish `blocking`, `review-needed`, and `informational` findings.

Do not delete, rewrite history, revoke credentials, change repository visibility, or publish anything without explicit authorization. If the user asks for safe file changes, preserve recoverability, verify the tracked state afterward, and use `$review-agent-output` for material publication decisions.

## Do not expose protected inputs during the audit

Apply `AI_NA_TUL.md` before reading protected documents into an AI environment. Publication consent does not establish TUL approval of the processing system. If approval is unknown, prepare local checks or work from redacted/public metadata; never read protected contents merely to determine whether they are protected. Check that any published assessed output retains its required truthful AI declaration and synthetic-data labeling.
