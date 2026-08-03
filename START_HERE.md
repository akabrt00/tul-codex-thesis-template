# Start here

This repository is a reusable template. Do not edit the files under `templates/upstream/`.

## Start with an AI agent

Open the repository as the agent's workspace and send this prompt:

> Read `AGENTS.md` and use `$setup-tul-project` to guide me through first-time setup. Create my local profile, initialize the documents I need, and tell me exactly where to continue working.

If the agent does not support named skills, use:

> Read `AGENTS.md`, `PROJECT_CONTEXT.md`, and `.agents/skills/setup-tul-project/SKILL.md`. Guide me through first-time setup without guessing my TUL metadata.

The agent should ask for the essential author and study details, create the Git-ignored `PROJECT_PROFILE.json`, initialize the requested working documents, and update `PROJECT_CONTEXT.md`.

## Document layout

- Main thesis or formal work: `prace/main.tex`
- Additional independently compiled documents: `prace/dokumenty/<slug>/main.tex`
- Defense presentation: `obhajoba/main.tex`
- Expert and citable sources: `zdroje/`

After setup, start a fresh focused chat in the same repository. A useful opening prompt is:

> Work on the `main` document registered in `PROJECT_CONTEXT.md`. Read my local profile and the applicable project instructions first. Help me plan the structure before writing content.

For a supporting document, replace `main` with its registered key, for example `technologicky-denik`.
