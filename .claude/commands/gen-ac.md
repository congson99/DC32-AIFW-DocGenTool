---
name: "Generate Acceptance Criteria"
description: "Generate Acceptance Criteria for a feature. Usage: /gen-ac <Feature Name>"
---

You are a Senior Business Analyst.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight Check

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check `workspace/<folder-name>/input/env_<slug>.md` exists:
   - If missing → stop and inform user: "Run `/start <Feature Name>` first to set up the environment."
4. Check `workspace/<folder-name>/input/idea_<slug>.md` exists:
   - If missing → stop and inform user: "Idea file not found. Run `/investigate <Feature Name>` first to generate it."
5. Read `workspace/<folder-name>/input/idea_<slug>.md` before proceeding.
6. Check `workspace/<folder-name>/docs/brief_<slug>.md` exists:
   - If missing → stop and inform user: "Brief not found. Run `/gen-brief <Feature Name>` first to generate it."
   - If exists → read it before proceeding.
7. Check `workspace/<folder-name>/docs/dependencies_<slug>.md` exists:
   - If missing → stop and inform user: "Dependencies not found. Run `/gen-dependencies <Feature Name>` first to generate it."
8. Check for existing downstream documents in `workspace/<folder-name>/`:
   - Look for: `docs/business_rule_<slug>.md`, `docs/data_definition_<slug>.md`, `docs/navigation_<slug>.md`, `docs/flow_<slug>.md`, `docs/ui_behavior_<slug>.md`, `docs/messages_<slug>.md`, `ba_doc_<slug>.md`
   - If any exist → warn the user:
     > "The following downstream documents already exist and will become outdated if the AC is regenerated:
     > [list each file found]
     > Regenerating the AC will delete these files. Continue? (yes/no)"
   - **no** → stop. Do not generate.
   - **yes** → delete the listed downstream files, then continue.
9. Read `framework/styles/style_general.md` — general writing style rules.
10. Read `framework/styles/style_ac.md` — style rules specific to AC.
11. Read `framework/rules/rule_ac.md` — writing quality rules for AC content.

## Steps

1. Analyze all loaded context (idea file, brief) to identify. If information needed for a section below is missing from both, ask the user a focused question rather than inventing it:
   - Feature scope and business rules
   - User roles and permission levels
   - Input fields and validation requirements
   - Processing logic and side effects
   - Data that must be saved or updated
   - Expected system responses (success and error)

2. Select only the AC groups relevant to this feature, using the group list defined in `framework/styles/style_ac.md`.

3. Create `workspace/<folder-name>/docs/ac_<slug>.md` using the format defined in `framework/styles/style_ac.md`.

4. Confirm:
```
✓ workspace/<folder-name>/docs/ac_<slug>.md

Review the ACs and edit if needed, then run /gen-business-rule <Feature Name> to continue.
```
