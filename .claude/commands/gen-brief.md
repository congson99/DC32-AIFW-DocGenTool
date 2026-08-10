---
name: "Generate Brief"
description: "Generate Brief for a feature from its Idea file. Usage: /gen-brief <Feature Name>"
---

You are a Senior Business Analyst.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"
- If the idea file doesn't contain enough information to determine In Scope / Out of Scope → ask one focused clarifying question before generating.

## Pre-flight Check

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check `workspace/<folder-name>/input/env_<slug>.md` exists:
   - If missing → stop and inform user: "Run `/start <Feature Name>` first to set up the environment, then fill in the placeholders before running /gen-brief."
   - If exists but still contains unfilled placeholders (e.g. `<jira-ticket-url>`) → warn the user but continue generating.
4. Check `workspace/<folder-name>/input/idea_<slug>.md` exists:
   - If missing → stop and inform user: "Idea file not found. Run `/investigate <Feature Name>` first to generate it."
5. Read `workspace/<folder-name>/input/idea_<slug>.md` before proceeding. If it still has unfilled placeholder sections needed to write the Brief (e.g. Overview, Scope), ask the user a focused question for that information rather than inventing content.
6. Check for existing downstream documents in `workspace/<folder-name>/`:
   - Look for: `docs/ac_<slug>.md`, `docs/business_rule_<slug>.md`, `ba_doc_<slug>.md`
   - If any exist → warn the user:
     > "The following downstream documents already exist and will become outdated if the Brief is regenerated:
     > [list each file found]
     > Regenerating the Brief will delete these files. Continue? (yes/no)"
   - **no** → stop. Do not generate.
   - **yes** → delete the listed downstream files, then continue.
7. Read `framework/styles/style_general.md` — general writing style rules.
8. Read `framework/styles/style_brief.md` — style rules specific to Brief.
9. Read `framework/rules/rule_brief.md` — writing quality rules for brief content.

## Steps

1. Create `workspace/<folder-name>/docs/brief_<slug>.md` using the format defined in `framework/styles/style_brief.md`, filling in:
   - **Feature name** — from `$ARGUMENTS` directly (no modification)
   - **Goal** — one sentence derived from the idea file's Overview
   - **In Scope** — derived from the idea file's Scope section
   - **Out of Scope** — derived from the idea file's Scope section

2. Confirm:
```
✓ workspace/<folder-name>/docs/brief_<slug>.md

Review the brief and edit if needed, then run /gen-ac <Feature Name> to continue.
```

