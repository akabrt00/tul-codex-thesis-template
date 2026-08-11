---
name: verify-scientific-calculations
description: Create traceable calculation records and independently cross-check material scientific results, including thesis or experiment results, statistics, fitted parameters, derived scientific values, calculations behind figures or tables, argument-changing results, and nontrivial symbolic or numerical work that must be reproduced. Do not start the full workflow for simple arithmetic, routine sum checks, trivial unit conversions, short sanity checks, or internal helper calculations that will not become project results.
---

# Verify Scientific Calculations

## Decide whether the result is material

Use a `CALC-NNNN` record when the result enters a thesis, experiment, figure, table, argument, conclusion, or other durable project evidence, or when nontrivial symbolic or numerical work must be reproducible.

For simple arithmetic, routine sum checks, trivial unit conversions, short sanity checks, and internal helper calculations, use the narrowest deterministic tool and report the check briefly. Do not create a calculation record or require an independent workflow unless the result later becomes material.

## Establish a traceable calculation

For a material result, read `PROJECT_CONTEXT.md`, the nearest `AGENTS.md`, and the registered target document. Create the next stable record under the target document with `scripts/new-calculation-record.ps1`. Never renumber `CALC-NNNN` records.

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

Before handing a calculation or interpretation to a person or reaching another review boundary, use `$review-agent-output` and include related results in one suitable review scope. Link the resulting `REV-NNNN` in the calculation metadata. Never mark the result academically correct or human-approved on the strength of software output alone.

## Finish

Report the calculation ID, inputs and units, assumptions, primary and independent methods, numerical or symbolic agreement, remaining uncertainty, files created, external-data exposure, and human-review status.
