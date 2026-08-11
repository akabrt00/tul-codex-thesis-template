---
name: audit-figures-and-tables
description: Audit existing figures, graphs, photographs, diagrams, and tables across a thesis or presentation for numbering, references, captions, provenance, units, legibility, scientific integrity, and explanatory context. Use when the user asks to inspect or audit visuals already present; creation, sourcing, or redesign of a specific visual belongs to create-project-visuals.
---

# Audit Figures and Tables

## Inventory existing objects

Resolve the target deliverable and enumerate its figures and tables from source and rendered output. Use `$tul-thesis` or `$tul-presentation` for document-aware inspection. Do not modify `templates/upstream/`.

For each object check:

- unique numbering, label, caption, and reference from nearby text;
- whether the text explains its purpose and interprets the important content;
- axes, units, legends, uncertainty, scale bars, terminology, and readable text size;
- page placement, clipping, contrast, resolution, and consistency at final size;
- provenance, permission, source citation, and correct classification as original, reproduced, adapted, or AI-generated;
- whether graphical choices distort data or omit necessary context.

Use `$manage-project-sources` to verify reproduced or adapted material and `$verify-scientific-calculations` for plotted or tabulated derived values. Use `$create-project-visuals` only after an audit identifies a needed extraction, adaptation, or redesign.

## Report before changing

Return an inventory with object, location, severity, finding, evidence, and action. Separate missing evidence or misleading presentation from cosmetic preference. Diagnose only unless the user asked for correction. Route material changes through the appropriate document and visual skills, then `$review-agent-output`.
