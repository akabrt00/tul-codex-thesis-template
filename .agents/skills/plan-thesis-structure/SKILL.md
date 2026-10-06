---
name: plan-thesis-structure
description: Design an evidence-led thesis outline from the confirmed topic, official assignment, objectives, project context, expected methods, and available sources. Use when the user asks for a thesis outline, chapter plan, or help dividing a bachelor or master thesis; do not use to judge whether an already written thesis fulfills its assignment.
---

# Plan Thesis Structure

## Ground the plan

Read `PROJECT_CONTEXT.md`, the official assignment, declared objectives, registered deliverables, and known practical workflow. Never invent an assignment, method, result, institutional requirement, or expert claim. If a missing input would materially change the hierarchy, expose the gap rather than hiding it behind a generic outline.

Use `$manage-project-sources` to inspect existing evidence and identify source gaps. Use `$manage-experiments` when practical records, measurements, or technological diaries shape the structure. Planning is prospective; use `$check-assignment-compliance` later to evaluate completed coverage.

## Design the hierarchy

Build a meaningful chapter and section hierarchy rather than merely `Introduction / Theory / Practice / Conclusion`. For each proposed chapter state:

- purpose and contribution to the argument;
- key questions it must answer;
- required evidence, data, experiments, calculations, or visuals;
- connection to assignment requirements and objectives;
- dependencies on earlier chapters;
- known risks, missing inputs, and likely source gaps.

Keep the theoretical part proportional to what the methods and discussion require. Distinguish planned evidence from evidence already available.

## Hand off

Provide the outline, a requirement-to-chapter map, and the next small writing or evidence task. Do not generate unsupported academic prose. If the user asks to apply the structure to document files, route that material change through `$tul-thesis` and `$review-agent-output`.
