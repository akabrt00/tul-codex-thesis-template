# Promotion record

Create one stable JSON record for each coherent transfer into the main thesis. Allocate the next unused `PROM-NNNN` after the highest existing ID and never renumber or reuse an ID.

```json
{
  "promotion_id": "PROM-0001",
  "status": "draft|verified|stale|superseded",
  "experiment_ids": ["EXP-0012", "EXP-0013"],
  "source_files": ["experiments/EXP-0012/record.tex"],
  "data_files": ["experiments/EXP-0012/data/measurement.csv"],
  "figure_files": ["experiments/EXP-0012/figures/force-curve/plot.tex"],
  "target_document_key": "main",
  "target_section": "sec:results-force",
  "purpose": "Why this selection belongs in the thesis",
  "selected_methods": [],
  "selected_results": [],
  "selected_limitations": [],
  "excluded_material": [
    {
      "item": "run 1",
      "reason": "sensor stabilization period; retained in diary"
    }
  ],
  "transformations": ["chronological notes synthesized into method and results"],
  "external_citation_keys": [],
  "verified_values": [],
  "verified_at": "YYYY-MM-DD",
  "open_questions": []
}
```

Require the record to answer:

- Which exact experiments and files support the main text?
- What was selected, transformed, combined, or excluded, and why?
- Which numerical values, units, uncertainty, and figure versions were verified?
- Where was the material inserted?
- What change would make this promotion stale?

The promotion record is project audit metadata. It does not replace citations, captions, explanations of exclusions, or visible methodological disclosure required in the thesis.
