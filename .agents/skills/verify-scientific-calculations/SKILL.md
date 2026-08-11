---
name: verify-scientific-calculations
description: Create traceable scientific calculation records and cross-check equations, algebra, symbolic manipulation, numerical values, units, uncertainty, fits, statistics, and derived thesis results with independent methods. Use whenever an agent computes or validates a value, formula, conversion, derivative, integral, equation solution, model, regression, uncertainty, or comparison, especially when optional Wolfram tools, MATLAB, Python, spreadsheets, or calculator outputs may be used before inserting results into a thesis, experiment diary, table, graph, or presentation.
---

# Verify Scientific Calculations

## Establish a traceable calculation

Read `PROJECT_CONTEXT.md`, the nearest `AGENTS.md`, and the registered target document. Create the next stable record under the target document with `scripts/new-calculation-record.ps1`. Never renumber `CALC-NNNN` records.

Capture the purpose, exact inputs, symbols, units, assumptions, source files, requested output, primary method, independent method, software or plugin versions when available, and unresolved questions. Never invent a missing measurement, unit, boundary condition, material property, precision, or uncertainty.

## Choose tools without making them mandatory

- Use a callable Wolfram plugin for symbolic algebra, equation solving, calculus, unit-aware evaluation, special functions, or curated computational knowledge when it provides a concrete benefit.
- Before sending unpublished, personal, confidential, or large raw project data to an external plugin, explain that the data leaves the local workflow and obtain confirmation. Prefer local MATLAB or Python for sensitive data.
- Use `$local-tool-router` for locally installed MATLAB, Python, or another suitable reproducible engine.
- If Wolfram is installed but not callable in the current chat, report that limitation and continue locally; do not claim to have used it. A newly installed plugin may require a fresh chat or application reload.
- Keep the project usable without Wolfram, MATLAB, or any optional plugin.

Record the exact Wolfram query, Wolfram Language expression, MATLAB script, Python code, spreadsheet formula, or analytical derivation used. Preserve generated data and code beside the `CALC-NNNN` record.

## Cross-check independently

Read `references/verification-checklist.md`. Verify the result with a genuinely different route whenever material:

- symbolic result versus numerical substitution;
- Wolfram versus MATLAB or Python;
- analytical derivation versus numerical evaluation;
- fitted result versus residual and edge-case checks;
- reported value versus dimensional analysis and order-of-magnitude reasoning.

Do not describe two executions of the same formula or engine as independent verification. If only one method is available, state that the result has not been independently cross-checked.

Resolve or expose differences in assumptions, branches, domains, sign conventions, units, precision, rounding, and uncertainty. Preserve disagreement instead of selecting the convenient answer.

## Use results responsibly

A computational result is project evidence, not an expert citation. Wolfram, MATLAB, Python, or a calculator cannot replace a source for a theoretical, material, historical, or standards-based claim. Use `$manage-project-sources` for those claims.

Before inserting a calculation or interpretation into a formal document, use `$review-agent-output`. Link the resulting `REV-NNNN` in the calculation metadata. Never mark the result academically correct or human-approved on the strength of software output alone.

## Finish

Report the calculation ID, inputs and units, assumptions, primary and independent methods, numerical or symbolic agreement, remaining uncertainty, files created, external-data exposure, and human-review status.
