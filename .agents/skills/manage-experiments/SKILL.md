---
name: manage-experiments
description: Automatically create, structure, index, update, audit, and synthesize complete experimental and practical records, then promote selected verified findings into a main thesis with traceability. Use whenever the user describes a laboratory session, trial, measurement, sample, apparatus setup, parameter change, failure, deviation, observation, raw result, experimental diary, technological log, EXP-NNNN record, comparison of experiments, or asks to select methods, values, graphs, photographs, findings, or conclusions from practical records for the main document.
---

# Manage Experiments

## Establish the record system

Read `PROJECT_CONTEXT.md`, the nearest `AGENTS.md`, and the registered deliverables. Identify the main thesis key and the independently compiled practical, experimental, or technological diary key. If the diary is not registered or initialized, use `$setup-tul-project` and `$tul-thesis` before creating records. Never store experiments under `templates/` or treat upstream example material as project data.

Keep experiment-owned material below `<diary-document>/experiments/`. Treat the diary as the complete practical source of truth and the main thesis as a selective synthesis. External expert sources still belong in `zdroje/` and use `$manage-project-sources`; project-created measurements, apparatus settings, intermediate calculations, and observations belong with the experiment.

## Capture rough input completely

Accept informal statements such as “dnes jsme měřili vzorek B, ale tenzometr ze začátku kmital.” Extract supplied facts without polishing away uncertainty, failures, deviations, or chronology. Ask at most three closely related questions at once and only when missing information materially affects repeatability, interpretation, safety, units, sample identity, or data linkage.

Before asking for a file location, search the project read-only for plausible data, MATLAB exports, photographs, and existing sample or apparatus identifiers. Create the incomplete record from known facts first so nothing is lost. In the first follow-up, prioritize no more than three decisions: confirm an ambiguous date, identify the sample/test purpose, and resolve the most likely data file or exclusion reason. Put every remaining unknown into `open_questions` and ask it later in small groups instead of presenting a questionnaire.

Create the next stable record with `scripts/new-experiment-record.ps1`. Never renumber or reuse an `EXP-NNNN` identifier. Use the script only inside a registered document under `prace/`.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File `
  .agents/skills/manage-experiments/scripts/new-experiment-record.ps1 `
  -DocumentDir prace/dokumenty/technologicky-denik `
  -Title "Měření vzorku B" -Date 2026-08-03
```

Fill the generated `record.tex` and `metadata.json` from confirmed information. Preserve unknown values explicitly as unknown. Link rather than silently copy large raw datasets. Record:

- date, aim, operator context when relevant, sample/material identity, and preparation;
- apparatus, sensors, calibration, software, versions, parameters, units, tolerances, and random seeds;
- reproducible procedure and chronological deviations from it;
- raw and processed data paths, scripts, photographs, figures, checksums when material, and processing steps;
- observations separated from interpretation;
- failures, anomalies, discarded runs, reasons for exclusions, changes, and follow-up questions;
- candidate claims or visuals for the thesis without automatically promoting them.

After the first real record, ensure the diary's registered `main.tex` contains exactly one `\input{experiments/index.tex}` at the intended content location. The scaffolding script deliberately does not edit `main.tex`. Use `$tul-thesis` for that document edit and compilation.

Use `$matlab-to-tikz` for experiment plots and `$create-project-visuals` for apparatus or process visuals. Never generatively alter evidence-bearing images or data.

## Maintain status and auditability

Use only these lifecycle states: `recorded`, `incomplete`, `candidate`, `selected`, `promoted`, `superseded`, or `rejected-for-main`. A rejected experiment remains in the diary with its reason. Update `EXPERIMENT_INDEX.md` and metadata together whenever the title, status, date, or promotion state changes.

Before relying on a record, verify that its metadata, LaTeX entry, index row, input line, data paths, figures, units, and sample identifiers agree. Report missing files, unresolved placeholders, contradictory settings, duplicate IDs, or conclusions unsupported by data. Do not repair scientific ambiguity by guessing.

## Promote findings into the main thesis

Read `references/promotion-record.md` before transferring content. Promotion is a separate, user-requested operation; never let routine diary capture edit the main thesis.

1. Resolve every requested experiment ID and inspect its complete record, linked data, scripts, figures, anomalies, and status.
2. Confirm the target section and intended purpose in the main thesis.
3. Verify numerical values, units, sample identity, processing, exclusions, and uncertainty against original files. Use expert sources for theory or comparison, not as substitutes for project measurements.
4. Separate reproducible method, observed results, interpretation, and limitations. Do not copy chronological diary prose into the thesis unchanged.
5. Select only material that supports the stated thesis purpose. Preserve failed or negative results when they materially affect validity, method development, or interpretation.
6. Create or update a stable `PROM-NNNN` JSON record under `<diary-document>/experiments/promotions/` before editing the main thesis.
7. Insert the synthesis using `$tul-thesis`, cite external sources, and retain experiment IDs in comments, provenance records, captions, or nearby project metadata without exposing unnecessary internal clutter to the reader.
8. Compile and visually inspect both affected documents. Mark a promotion `verified` only after the target text, figures, references, and values resolve correctly.

When later experiment changes affect promoted content, mark the promotion stale and report the main sections requiring review. Never silently overwrite a previous result or erase the earlier experimental state.

## Finish

Report experiment and promotion IDs, files created or updated, known and missing metadata, linked data and figures, validation performed, content promoted to the main thesis, and any unresolved scientific, provenance, privacy, or reproducibility issue.
