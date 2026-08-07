# Style: General

Applies to all generated documents.

## Language

- Read the `**Document language:**` line from the feature's own `workspace/<folder-name>/input/env_<slug>.md` (already resolved and cached there by `/start` — do not re-read `project/project_config.md` for this). If the line is missing (e.g. an older feature folder created before this field existed), default to English.
- Write all descriptive/prose content (goals, descriptions, rule text, message wording, etc.) in that language.
- Always keep the following in English regardless of the configured language: section headings (e.g. `## 1. Brief`), field labels (e.g. `**Goal:**`, `**Field**`, `**Case**`), fixed markers (`[Start]`, `[End]`), and ID prefixes (`AC`, `R`, `UI`).

## Voice

- Use active voice.
- Use present tense.
- Use **The system** for system behavior.
- Use **The user** for user actions.

## Writing Style

- Use concise and professional BA language.
- Prefer short sentences.
- Express one behavior or requirement per sentence.
- Avoid filler or duplicated statements.
- Keep terminology consistent throughout the document.

## Wording

- Avoid technical or backend wording unless provided in the source.
- Do not mention APIs, database tables, components, selectors, or architecture unless they are business-facing concepts.

## Markdown Formatting

- Use Markdown headings consistently.
- Leave one blank line between sections.
- Prefer tables for structured data.
- Use bullet lists for rules and scope items.
- Do not wrap the entire document in a code block unless requested.