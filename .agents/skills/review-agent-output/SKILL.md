---
name: review-agent-output
description: Prepare a defined bundle of agent-created thesis work for explicit human review while keeping technical checks separate from approval. Use for an explicit review request, a supervisor/opponent handoff, a named review checkpoint, final-submission review, an explicit user approval or rejection, or a larger closed package being handed to a person. Do not create a new review record for each small iterative draft edit; group related changes into one review scope.
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

## Choose the review boundary

During ordinary iterative drafting, keep changed work marked `agent-draft` and accumulate related edits. Do not create a `REV-NNNN` merely because a sentence, label, citation, value, or layout detail changed.

Create or update a review scope when at least one boundary is reached:

- the user explicitly requests a review;
- a defined package is about to be handed to a supervisor, opponent, or another reviewer;
- the user names a version or scope as a review checkpoint;
- a final-submission workflow reaches human review;
- the user explicitly approves, rejects, or escalates a defined scope;
- a larger closed bundle of agent changes is ready for human inspection.

Group closely related changes that should be judged together into one record. Keep unrelated documents or decisions separate when one approval would be ambiguous.

## Prepare a review

1. Identify exactly what changed and which document, sections, figures, calculations, citations, pages, or files are affected.
2. Run relevant technical checks and state their limits. Use `$tul-thesis`, `$tul-presentation`, `$verify-scientific-calculations`, `$manage-project-sources`, or visual inspection as applicable.
3. Read `references/review-checklist.md` and select only the human checks relevant to the change.
4. At a review boundary in an initialized user project, create one stable grouped review record with `scripts/new-review-record.ps1`. Do not create student review records while merely maintaining the uninitialized reusable template; use the Git diff or pull request as that maintenance review surface.
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

After later edits that materially change an approved scope, create a new grouped review record or mark the prior one `superseded`; do not silently retain approval. Minor iterative edits before approval stay within the open scope when they remain clearly covered.

## Finish

Report the review ID, exact scope, technical status, human-review state, locations to inspect, and the next decision required from the user. Never imply that the agent, a plugin, Wolfram, MATLAB, a compiler, or another model can replace the author's or supervisor's judgment.
