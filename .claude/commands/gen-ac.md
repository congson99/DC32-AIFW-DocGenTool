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
12. Check `project/reference/sample-doc/` for `.md` files:
    - If files exist → for each one, find the section matching this document's own heading (`## 3. Acceptance Criteria` through the next `## ` heading, or end of file) and read it as a style/tone/detail-level reference for how this project writes AC.
    - If the folder is empty, does not exist, or no file has a matching section → skip.

## Steps

1. Analyze all loaded context (idea file, brief) to identify. If information needed for a section below is missing from both, ask the user a focused question rather than inventing it:
   - Feature scope and business rules
   - User roles and permission levels
   - Input fields and validation requirements
   - Processing logic and side effects
   - Data that must be saved or updated
   - Expected system responses (success and error)

   This step runs before `/gen-business-rule` and `/gen-data-definition` in the pipeline, so don't rely on either to surface something the idea file already states — cross-check directly against the idea file's own **Entities & Fields** and **Business Rules & Validation** sections now:
   - **Every field listed as "User-provided"** in Entities & Fields gets its own required-field Validation AC by default (grouped per `rule_ac.md`'s Granularity Rules where the same-type check applies), unless the idea file explicitly marks that field optional. Do not skip a field just because Business Rules & Validation didn't separately restate it as required.
   - **Every field listed as "System-generated"** in Entities & Fields gets a matching Processing AC that sets it (grouped only when the values are always identical at the same time, per `rule_ac.md`'s Granularity Rules — otherwise keep them separate, e.g. "sets X to the current user" and "sets Y to the current timestamp" are two ACs, not one).
   - **Every uniqueness or duplicate-prevention constraint** mentioned in Business Rules & Validation gets its own rejection AC in the Validation group (e.g. "The system rejects the request when another `<Entity>` already has the same `<Field>`") — don't let it live only in the eventual Business Rule or Message.

2. **Mandatory Notification & Audit/History check — do not skip this step, and do not fold it into Step 1's silent analysis.** Regardless of what the idea file and brief say (including if they say nothing at all), explicitly ask the user two separate yes/no questions before moving on:
   - "Does this feature need to send a Notification to any role/user when it completes? If yes, who gets notified and on what event?"
   - "Does this feature need to record an entry in an activity/audit log? If yes, what fields should it capture (e.g. actor, timestamp, before/after values)?"

   This is required by `rule_ac.md`'s Clarification Required section — source silence means "ask", never "skip". Answers apply per feature; do not infer from a decision already made for a different feature without asking again.
   - **Yes to Notification** → add a Processing AC per notified role/event.
   - **Yes to Audit/History** → add a Processing AC recording it, and check whether any existing feature in this project already defines that log's structure (e.g. an "Activity Log" feature) — if one exists, reference it per `rule_ac.md`; if none exists yet, write the AC without the reference and note in the confirmation message (Step 5) that the reference is pending a future Activity Log feature.
   - **No to either** → create no AC for it, but the question must still have been asked.

3. Select only the AC groups relevant to this feature, using the group list defined in `framework/styles/style_ac.md`.

4. Create `workspace/<folder-name>/docs/ac_<slug>.md` using the format defined in `framework/styles/style_ac.md`. Apply any matching section loaded from `project/reference/sample-doc/` as a style/tone reference — match its phrasing conventions and level of detail, but do not copy its wording verbatim, and let `framework/styles/style_ac.md` govern the structural format.

5. Confirm:
```
✓ workspace/<folder-name>/docs/ac_<slug>.md

Review the ACs and edit if needed, then run /gen-business-rule <Feature Name> to continue.
```
