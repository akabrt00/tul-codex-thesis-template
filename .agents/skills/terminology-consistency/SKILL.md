---
name: terminology-consistency
description: Audit terminology, abbreviations, titles, keywords, and Czech-English equivalents across multiple project documents or distant thesis sections. Use for project-wide, bilingual, abstract-versus-body, thesis-versus-presentation, or cross-document consistency checks; do not trigger for ordinary proofreading or a single local wording issue.
---

# Terminology Consistency

## Define the comparison set

Read the registered deliverables and identify the exact documents or sections being compared. Include titles, abstracts, keywords, nomenclature, first abbreviation definitions, thesis body, appendices, and presentation only when in scope.

Build a candidate term map from actual project usage. Check:

- competing Czech names for one concept;
- inconsistent Czech and English equivalents;
- abbreviations used before definition or expanded inconsistently;
- conflicts among official title, abstracts, keywords, headings, figures, tables, and slides;
- different capitalization, symbols, subscripts, units, or grammatical forms that alter meaning.

Do not normalize an expert term from language intuition alone. Use `$manage-project-sources` to verify technical meaning and official terminology; preserve a documented project-specific choice when valid.

## Report and repair safely

Return preferred term, variants, locations, evidence or rationale, severity, and proposed resolution. Distinguish harmless inflection from true conceptual inconsistency. Diagnose only unless the user asked to change files.

For requested changes, use `$tul-thesis` and `$tul-presentation` as applicable, avoid broad blind replacement, inspect every changed context, rebuild affected outputs, and finish with `$review-agent-output`.
