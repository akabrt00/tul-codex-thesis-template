---
name: create-project-visuals
description: Automatically recommend, source, extract, adapt, redraw, create, insert, and verify useful academic visuals from rough user descriptions or document content. Use while planning, drafting, or reviewing a thesis, formal document, or presentation whenever a figure, image, diagram, schematic, flowchart, process illustration, screenshot, photograph, extracted PDF figure, or graph could improve understanding; route data plots to PGFPlots or matlab-to-tikz, draw deterministic technical visuals in TikZ, manage sourced images with page-level provenance, and use image generation only for clearly illustrative non-evidence raster assets.
---

# Create Project Visuals

## Interpret rough intent

Read `PROJECT_CONTEXT.md`, the nearest `AGENTS.md`, and the target document context. Accept ordinary descriptions such as “tady vysvětluji, jak stroj funguje” without requiring the user to choose an image type or tool.

Extract a compact visual brief from the available context: teaching purpose, intended claim, audience, placement, required labels, language, physical or logical relationships, source basis, and final size. Infer routine layout and styling. Ask only when missing scientific meaning, units, uncertainty, identity, permissions, or a major design choice could change the result.

During planning or review, recommend a visual only when it materially improves explanation, comparison, navigation, or evidence. State its purpose, proposed form, likely placement, and required source/data. Do not add an image merely to decorate or fill space.

## Choose the best form

Read `references/visual-decision-tree.md` when more than one form is plausible. Prefer, in order:

1. A graph or table for quantitative relationships. Use `$matlab-to-tikz` for MATLAB or numerical plots and prefer editable PGFPlots with preserved data.
2. TikZ for processes, architectures, causal flows, classifications, timelines, apparatus schematics, and other deterministic technical diagrams.
3. A verified existing project-source figure when the original visual itself matters and reuse is permitted.
4. A purpose-made illustration or photograph only when shape, appearance, or scene is the teaching point and a diagram is insufficient.
5. No visual when text or a small table communicates the idea more precisely.

Use `$imagegen` for new or edited raster illustrations, not for repo-native TikZ/vector work. Treat generated imagery as illustrative, never as measurements, experimental evidence, historical proof, microscopy, product conformance, or a factual depiction that has not been independently verified.

## Find and adapt a source figure

Use `$manage-project-sources` and `$pdf` when a suitable visual may exist in registered materials or an attached document.

1. Locate the source through the registry, thematic map, page index, captions, figure numbers, and nearby text.
2. Inspect the original page visually and verify that the figure supports the intended explanation. Do not separate a visual from qualifications in its caption or surrounding text.
3. Record the source ID, citation key, page, original figure/table number, caption, creator, publication, URL/DOI when applicable, license or reuse basis, and the exact planned transformation.
4. Prefer an embedded vector or original-resolution image. Otherwise render or crop the page at sufficient resolution. Preserve the registered original unchanged and keep source derivatives traceable under `zdroje/90_zpracovane/`.
5. Put the document-ready asset under `<document>/figures/<slug>/` only with an adjacent `provenance.json` based on `references/provenance-template.md`.
6. Label use accurately: reproduced, cropped, translated, color-adjusted, annotated, or redrawn/adapted. Cite the source in the caption and bibliography under the applicable faculty rules.

Do not use generative fill, object removal, beautification, or content synthesis on evidence-bearing visuals such as experimental photographs, microscopy, scans, plots, medical/technical imagery, or result screenshots. Allow only disclosed non-semantic operations such as lossless extraction, crop, rotation, resolution conversion, and carefully verified tonal adjustment. Prefer a TikZ redraw for a conceptual diagram when reuse rights are unclear or the source is illegible, but cite every source whose intellectual structure or factual content informed the redraw.

## Create an original TikZ visual

Base every node, relationship, dimension, label, and sequence on verified project facts or user-supplied content. Separate direct source statements from synthesis. Use consistent shapes, alignment, spacing, arrow meaning, typography, and restrained color. Keep labels short and explain detail in the caption or text.

Store code and supporting data under `<document>/figures/<slug>/`. Use relative paths, stable `\label{fig:<slug>}`, and `\input{figures/<slug>/figure.tex}` where practical. If the visual is based on sources, add page-level citations and provenance even though the drawing itself is original.

## Insert and verify

When the user only asks for recommendations, do not modify the document. When the user asks to write, revise, or prepare the target document and the visual brief is sufficiently determined, create and insert the visual as part of that work. Present a recommendation first when copyright, scientific interpretation, or a substantial creative choice requires confirmation.

Use `$tul-thesis` or `$tul-presentation` to insert, compile, and visually inspect the result. Verify:

- factual correspondence with the supporting text, data, and source page;
- correct provenance category and caption wording;
- citation and bibliography resolution;
- labels, units, legend, scale, orientation, and reading order;
- legibility at final page or projection size, including grayscale distinction;
- no clipping, overlap, pixelation, unreadable text, or misleading visual emphasis;
- exact agreement between a source-derived asset and the declared crop/adaptation.

Report the recommendation or created visual, why that form was chosen, files and source pages used, transformations, provenance category, verification performed, and any unresolved permission or scientific question.
