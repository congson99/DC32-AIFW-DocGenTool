---
name: "Generate Messages"
description: "Generate Messages for a feature. Usage: /gen-messages <Feature Name>"
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
   - If exists → read it before proceeding.
7. Check `workspace/<folder-name>/docs/ac_<slug>.md` exists:
   - If missing → stop and inform user: "Acceptance Criteria not found. Run `/gen-ac <Feature Name>` first to generate it."
   - If exists → read it before proceeding.
8. If `workspace/<folder-name>/docs/business_rule_<slug>.md` exists → read it as additional context.
9. If `workspace/<folder-name>/docs/data_definition_<slug>.md` exists → read it as additional context.
10. If `workspace/<folder-name>/docs/navigation_<slug>.md` exists → read it as additional context, to reuse the exact page/dialog names it defines for the UI Display column.
11. If `workspace/<folder-name>/docs/flow_<slug>.md` exists → read it as additional context.
12. If `workspace/<folder-name>/docs/ui_behavior_<slug>.md` exists → read it as additional context, to keep field-state wording (disabled/read-only/hidden) consistent between the two documents.
13. Check for existing downstream documents in `workspace/<folder-name>/`:
    - Look for: `ba_doc_<slug>.md`
    - If any exist → warn the user:
      > "The following downstream documents already exist and will become outdated if Messages is regenerated:
      > [list each file found]
      > Regenerating Messages will delete these files. Continue? (yes/no)"
    - **no** → stop. Do not generate.
    - **yes** → delete the listed downstream files, then continue.
14. Check if `project/reference/messages/` exists and contains any `.md` files:
    - If files exist → read all of them as shared message standards or wording templates. Apply them when writing message text.
    - If the folder is empty or does not exist → skip, proceed normally.
15. Read `framework/styles/style_general.md` — general writing style rules.
16. Read `framework/styles/style_messages.md` — style rules specific to Messages.
17. Read `framework/rules/rule_messages.md` — writing quality rules for Messages content.
18. Check `project/reference/sample-doc/` for `.md` files:
    - If files exist → for each one, find the section matching this document's own heading (`## 9. Messages` through the next `## ` heading, or end of file) and read it as a style/tone/detail-level reference for how this project writes Messages.
    - If the folder is empty, does not exist, or no file has a matching section → skip.

## Steps

1. Analyze all loaded source (investigation file, brief, AC, business rules, data definition, navigation, flow, UI Behavior) to identify message cases. If information needed is missing from all loaded sources, ask the user a focused question rather than inventing it:

   - Permission errors (from Access Control in AC)
   - Validation errors (required fields, invalid references, format, range, attachment, item list)
   - Confirmation dialogs
   - Business errors (auto-generation failures, business constraint violations)
   - System errors (processing failures, persistence failures, system failures)
   - Success messages

   For each case, determine:
   - The triggering condition (Case)
   - Message Type: `Validation Error`, `Error`, `Success`, or `Confirmation`
   - Source: `BE`, `FE`, or `BE / FE`
   - Where the message appears in the UI (UI Display) — reuse the exact page/dialog names from `navigation_<slug>.md` when the message is tied to a specific page or dialog
   - The exact message wording (Message) — use source wording when provided

2. Order rows:
   - Permission errors first
   - Validation errors in field order (top to bottom, left to right as they appear in the UI)
   - Confirmation dialogs
   - Business errors
   - System errors
   - Success messages last

3. Create `workspace/<folder-name>/docs/messages_<slug>.md` using the format defined in `framework/styles/style_messages.md`. Apply any matching section loaded from `project/reference/sample-doc/` as a style/tone reference — match its phrasing conventions and level of detail, but do not copy its wording verbatim, and let `framework/styles/style_messages.md` govern the structural format.
   - If no messages were identified, still create the file with the section heading but write: `No messages identified for this feature.`

4. Confirm:
```
✓ workspace/<folder-name>/docs/messages_<slug>.md

Review the Messages and edit if needed, then run /package <Feature Name> to continue.
```
