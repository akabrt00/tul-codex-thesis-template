---
name: review-supervisor-feedback
description: Parse, locate, plan, implement when requested, and verify actionable feedback from a thesis supervisor, opponent, committee, or annotated review document. Use when the user provides reviewer comments, a report, annotated PDF, or asks to address supervisor or opponent feedback; do not use for a general chapter review without external comments.
---

# Review Supervisor Feedback

## Preserve the reviewer meaning

Read the feedback in its original context and identify its author and version when known. Split it into atomic items without weakening, merging, or reinterpreting the request. For ambiguous or high-impact comments, present your interpretation and obtain confirmation before a material rewrite.

## Track each item

Maintain a task-local table with stable IDs and these fields: original comment, requested outcome, affected location, proposed action, required source or data, status, and verification evidence. Use statuses `new`, `clarification-needed`, `planned`, `in-progress`, `verification-needed`, `addressed`, and `not-addressed`.

Use `$tul-thesis` to locate and edit thesis content, `$manage-project-sources` for factual changes or new evidence, `$verify-scientific-calculations` for numerical claims, and `$create-project-visuals` for material visual changes. Do not invent a source, measurement, or reviewer intent.

## Verify resolution

Changing text does not close an item. Compare the result with the original comment, compile and inspect affected output through the document skill, and record concrete evidence. Mark `addressed` only when the requested outcome is actually present; otherwise expose the remaining gap.

If material content changes, use `$review-agent-output`. Reviewer feedback and the agent's verification do not substitute for the author's review or the supervisor's acceptance.
