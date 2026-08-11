---
name: prepare-defense
description: Transform an existing thesis, assignment, results, reviews, and defense time limit into a focused defense narrative and slide plan. Use when the user asks what to present at the defense, wants a defense presentation derived from the thesis, or needs content and backup-slide planning; technical TUL Beamer editing alone belongs to tul-presentation.
---

# Prepare Defense

## Extract the defensible story

Read the thesis, official assignment, objectives, and registered evidence. Include supervisor or opponent reports and questions when available. Identify only material supported by the project:

- problem and motivation;
- objectives and requirement coverage;
- method and why it was chosen;
- most important results and contribution;
- limitations, uncertainty, and conclusion;
- reviewer questions or weak points needing backup material.

Use `$manage-project-sources` for evidence checks, `$verify-scientific-calculations` for numerical claims, and `$check-assignment-compliance` when requirement coverage is uncertain. Never invent a favorable result or hide a material limitation.

## Plan for the time limit

Confirm or clearly assume a provisional speaking time. Allocate time by message importance, not thesis chapter length. Create a slide-by-slide plan with purpose, one key message, evidence, proposed visual, speaker emphasis, and expected duration. Prefer simple visual slides over copied paragraphs.

Use `$create-project-visuals` for purposeful graphs, diagrams, or tables. Put secondary methods, detailed data, and likely committee questions into clearly identified backup slides.

## Realize and review

After the content plan is agreed or when the user explicitly requests implementation, use `$tul-presentation` for TUL Beamer source, compilation, and visual validation. Use `$review-agent-output` for material presentation content and state what remains for rehearsal and human judgment.
