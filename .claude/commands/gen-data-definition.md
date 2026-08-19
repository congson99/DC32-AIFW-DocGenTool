---
name: "Generate Data Definition"
description: "Generate Data Definition for a feature. Usage: /gen-data-definition <Feature Name>"
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
7. Check `workspace/<folder-name>/docs/ac_<slug>.md` exists:
   - If missing → stop and inform user: "Acceptance Criteria not found. Run `/gen-ac <Feature Name>` first to generate it."
   - If exists → read it before proceeding.
8. Check `workspace/<folder-name>/docs/business_rule_<slug>.md` exists:
   - If missing → stop and inform user: "Business Rules not found. Run `/gen-business-rule <Feature Name>` first to generate it."
   - If exists → read it before proceeding.
9. Check for existing downstream documents in `workspace/<folder-name>/`:
    - Look for: `docs/navigation_<slug>.md`, `docs/flow_<slug>.md`, `docs/ui_behavior_<slug>.md`, `docs/messages_<slug>.md`, `ba_doc_<slug>.md`
    - If any exist → warn the user:
      > "The following downstream documents already exist and will become outdated if Data Definition is regenerated:
      > [list each file found]
      > Regenerating Data Definition will delete these files. Continue? (yes/no)"
    - **no** → stop. Do not generate.
    - **yes** → delete the listed downstream files, then continue.
10. Read `framework/styles/style_general.md` — general writing style rules.
11. Read `framework/styles/style_data_definition.md` — style rules specific to Data Definition.
12. Read `framework/rules/rule_data_definition.md` — writing quality rules for Data Definition content.

## Steps

1. Analyze all loaded context (idea file, brief, AC, Business Rules) to identify. If information needed is missing from all of these, ask the user a focused question rather than inventing it:

   - All data objects involved in this feature
   - Parent-child relationships between objects
   - Field names
   - Data types
   - Required or optional status
   - Editability
   - Default values
   - Allowed values
   - Formats
   - Field-level validation rules

   Ignore:

   - UI components
   - Screen layout
   - API contracts
   - Database tables or column names
   - Processing steps
   - Messages and responses
   - Business Rules already documented elsewhere

2. Determine the feature type based on the brief and AC:
   - **Input feature** (Create, Edit, Update): include all columns — Field, Type, Required, Editable, Default, Values, Format, Description.
   - **View / Read-only feature** (View detail, Display): omit the Editable, Required, Default, and Values columns.
   - **Mixed feature** (a screen that both displays and allows editing): treat as Input feature — include all columns; apply `Editable = No` for display-only fields.

3. For each object, build the Field Definition table using the columns determined in step 2:
   - One row per field
   - Include only fields used or affected by this feature.
   - Do not include unrelated fields from the full object definition.
   - Infer `Editable` from the source; if unclear, apply the Editable Column Rules
   - Leave cells blank when the source provides no information for that column

4. For each object, build the Field Validation Rules section:
   - Group rules under each field name
   - Only include fields that have at least one rule
   - Omit the section entirely if no fields have rules
   - Do not repeat object-level business rules.
   - Include only field-level rules.

5. Define child objects as separate object sections following their parent.

6. Create `workspace/<folder-name>/docs/data_definition_<slug>.md` using the format defined in `framework/styles/style_data_definition.md`.
   - If no data objects or fields were identified, still create the file with the section heading but write: `No data definition identified for this feature.`

7. Confirm:
```
✓ workspace/<folder-name>/docs/data_definition_<slug>.md

Review the Data Definition and edit if needed, then run /gen-navigation <Feature Name> to continue.
```
