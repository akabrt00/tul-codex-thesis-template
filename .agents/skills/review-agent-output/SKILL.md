---
name: review-agent-output
description: Route every material agent-created or agent-modified thesis output through explicit human review. Use after drafting or changing academic prose, calculations, interpretations, citations, figures, tables, experiment promotions, formal metadata, document structure, presentation content, or other work whose correctness, meaning, or appearance cannot be established by a technical check alone; also use before claiming that work is complete, approved, ready for a supervisor, or ready for submission.
---

# Review Agent Output

## Separate technical and human validation

Treat every material agent output as an agent draft until a person explicitly reviews its defined scope. A successful command, compilation, citation resolution, numerical cross-check, or clean PDF proves only the corresponding technical property. It never proves that the argument is sensible, the description matches reality, the interpretation is honest, or the result is suitable for the thesis.

Use these human-review states only:

- `awaiting-human-review`;
- `human-approved`;
- `changes-requested`;
- `needs-supervisor-review`;
- `superseded`.

Never set `human-approved` from your own judgment. Require an explicit user decision covering the stated scope. Approval of one section, figure, calculation, or version does not approve later changes or other artifacts.

## Prepare a review

1. Identify exactly what changed and which document, sections, figures, calculations, citations, pages, or files are affected.
2. Run relevant technical checks and state their limits. Use `$tul-thesis`, `$tul-presentation`, `$verify-scientific-calculations`, `$manage-project-sources`, or visual inspection as applicable.
3. Read `references/review-checklist.md` and select only the human checks relevant to the change.
4. In an initialized user project, create a stable review record with `scripts/new-review-record.ps1`. Do not create student review records while merely maintaining the uninitialized reusable template; use the Git diff or pull request as that maintenance review surface.
5. Present a short review handoff in the user's language: what to inspect, where to inspect it, what was technically verified, what remains a human judgment, and any risky or uncertain item.
6. Say `technically checked; awaiting human review`, not `done`, when approval is missing.

Example:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  .agents/skills/review-agent-output/scripts/new-review-record.ps1 `
  -DocumentKey main -Scope "Section 3.2 and Figure 3.4" `
  -TechnicalStatus passed-with-warnings `
  -ArtifactPaths "prace/main.tex","prace/main.pdf" `
  -HumanChecks "Does the apparatus description match reality?","Does the conclusion follow from the shown data?"
```

## Record a human decision

When the user explicitly approves, rejects, or escalates a defined review, run `scripts/set-review-decision.ps1` with the review ID and preserve a concise version of the user's statement. If the statement is ambiguous about scope, ask one short clarification rather than broadening approval.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  .agents/skills/review-agent-output/scripts/set-review-decision.ps1 `
  -ReviewId REV-0001 -Decision approved `
  -UserStatement "Schvaluji oddíl 3.2 a obrázek 3.4 v této verzi."
```

After later material edits, create a new review record or mark the prior one `superseded`; do not silently retain approval for changed content.

## Finish

Report the review ID, exact scope, technical status, human-review state, locations to inspect, and the next decision required from the user. Never imply that the agent, a plugin, Wolfram, MATLAB, a compiler, or another model can replace the author's or supervisor's judgment.
