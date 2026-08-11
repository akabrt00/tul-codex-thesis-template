---
name: external-tool-router
description: Select and safely route work to optional external APIs, MCP servers, plugins, or connected services while preserving privacy, provenance, reproducibility, and a local fallback. Use when a task explicitly involves Wolfram, an external scientific API, MCP, cloud analysis, a connector, or choosing between external and local computation; installed local executables alone belong to local-tool-router.
---

# External Tool Router

## Decide whether external processing is justified

Read the task, project constraints, and available tool capabilities. Identify the concrete benefit of an external service: authoritative retrieval, symbolic computation, specialized database access, or an operation unavailable locally. Do not use an external tool merely because it is installed.

Discover only the external capability needed for the current decision. Prefer a compact capability summary or structured result over loading broad service catalogs or large raw responses.

Use `$local-tool-router` for installed MATLAB, Python, R, LaTeX, document, or media tools. Prefer a reproducible local route when it satisfies the task, especially for unpublished or sensitive data. Use `$verify-scientific-calculations` for derived scientific values regardless of engine.

## Apply the data boundary

Before sending unpublished, personal, confidential, licensed, or otherwise sensitive material outside the local workflow:

1. state the service and exact data categories to be sent;
2. explain the concrete purpose and the local alternative;
3. obtain explicit confirmation for that disclosure scope.

Minimize payloads and remove unrelated identifiers. Never expose credentials in prompts, logs, or reports. If a requested plugin is installed but not callable in the current task, say so and continue with a suitable local fallback; do not claim tool use.

## Preserve reproducibility and evidence boundaries

Record the service, query or expression, inputs, relevant options, response date, and derived artifacts when the output enters project work. Treat computational output as project evidence, not an expert citation. Use `$manage-project-sources` for factual, standards-based, or literature claims and verify authoritative originals.

Cross-check material results independently when possible. Route any inserted prose, calculation, figure, table, or presentation change through the applicable project skill and `$review-agent-output`. Report which external and local tools were actually used, what data left the local workflow, fallback limitations, and remaining human review.
