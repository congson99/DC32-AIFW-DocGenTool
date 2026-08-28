---
name: "Generate Dependencies"
description: "Generate Dependencies for a feature, listing prerequisite features, modules, external systems, or configurations it depends on and why. Usage: /gen-dependencies <Feature Name>"
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
4. Check `workspace/<folder-name>/input/investigation_<slug>.md` exists:
   - If missing → stop and inform user: "Investigation file not found. Run `/investigate <Feature Name>` first to generate it."
5. Read `workspace/<folder-name>/input/investigation_<slug>.md` before proceeding.
6. Check `workspace/<folder-name>/docs/brief_<slug>.md` exists:
   - If missing → stop and inform user: "Brief not found. Run `/gen-brief <Feature Name>` first to generate it."
7. Read every context file listed in `workspace/<folder-name>/input/context_<slug>.md` before proceeding — this is the main source for knowing what other features/modules exist in the domain.
8. Check for existing downstream documents in `workspace/<folder-name>/`:
   - Look for: `docs/ac_<slug>.md`, `docs/business_rule_<slug>.md`, `docs/data_definition_<slug>.md`, `docs/navigation_<slug>.md`, `docs/flow_<slug>.md`, `docs/ui_behavior_<slug>.md`, `docs/messages_<slug>.md`, `ba_doc_<slug>.md`
   - If any exist → warn the user:
     > "The following downstream documents already exist and will become outdated if Dependencies is regenerated:
     > [list each file found]
     > Regenerating Dependencies will delete these files. Continue? (yes/no)"
   - **no** → stop. Do not generate.
   - **yes** → delete the listed downstream files, then continue.
9. Read `framework/styles/style_general.md` — general writing style rules.
10. Read `framework/styles/style_dependencies.md` — style rules specific to Dependencies.
11. Read `framework/rules/rule_dependencies.md` — writing quality rules for Dependencies content.
12. Check `project/reference/sample-doc/` for `.md` files:
    - If files exist → for each one, find the section matching this document's own heading (`## 2. Dependencies` through the next `## ` heading, or end of file) and read it as a style/tone/detail-level reference for how this project writes a Dependencies section.
    - If the folder is empty, does not exist, or no file has a matching section → skip.

## Steps

1. Using the investigation file (Overview, Process Flow, Entities & Fields) and the loaded context files, identify any prerequisite feature, module, external system, or configuration that must already exist, be completed, or be in place before this feature can function — per `framework/rules/rule_dependencies.md`. Apply any matching section loaded from `project/reference/sample-doc/` as a style/tone reference — match its phrasing conventions and level of detail, but do not copy its wording verbatim, and let `framework/styles/style_dependencies.md` govern the structural format.
2. If it is unclear from the investigation file and context whether a prerequisite exists, ask the user directly rather than assuming — do not invent a dependency and do not assume there are none.
3. Create `workspace/<folder-name>/docs/dependencies_<slug>.md` using the format defined in `framework/styles/style_dependencies.md`.

4. Confirm:
```
✓ workspace/<folder-name>/docs/dependencies_<slug>.md

Review the dependencies and edit if needed, then run /gen-ac <Feature Name> to continue.
```
