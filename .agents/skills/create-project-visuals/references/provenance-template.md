# Visual provenance record

Create `provenance.json` beside every document-ready visual. Use `null` or an empty list for inapplicable fields; do not invent values.

```json
{
  "visual_id": "fig-stable-slug",
  "status": "planned|draft|verified",
  "category": "original|reproduced|adapted|ai-generated-illustration",
  "purpose": "What this visual helps the reader understand",
  "target_document": "main",
  "target_section": "chapter or section label",
  "asset_files": ["figure.tex"],
  "source_ids": ["SRC-0006"],
  "citation_keys": ["example-key"],
  "source_pages": [12],
  "source_figure_labels": ["Fig. 3"],
  "license_or_reuse_basis": "verified statement or unresolved",
  "transformations": ["cropped", "labels translated", "redrawn in TikZ"],
  "semantic_invariants": ["relationships and values unchanged"],
  "generated_with_ai": false,
  "ai_role": null,
  "caption_intent": "Factual caption draft or purpose",
  "verified_against": ["registered original page 12"],
  "verification_date": "YYYY-MM-DD",
  "open_questions": []
}
```

Use caption attribution appropriate to the verified category and faculty rules:

- original project result: identify it as the author's own processing when required;
- exact reuse: state that it is reproduced/taken from the cited source;
- adaptation or redraw: state that it is adapted/processed according to the cited source;
- AI-generated raster: state that it is an illustrative AI-generated image and do not cite it as factual evidence.

The provenance record supports auditability; it does not replace the visible caption, bibliography entry, permission requirement, or source citation.
