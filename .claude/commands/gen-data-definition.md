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
4. Check `workspace/<folder-name>/input/investigation_<slug>.md` exists:
   - If missing → stop and inform user: "Investigation file not found. Run `/investigate <Feature Name>` first to generate it."
5. Read `workspace/<folder-name>/input/investigation_<slug>.md` before proceeding.
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
13. Check `project/reference/data-definition/shared-references/` for `.md` files:
    - If files exist → read all of them and note the field definitions (name, type, description) they give for each entity. These are ground truth for that entity's fields — reuse them for any object in this feature that matches an entity defined there, instead of re-deriving its fields from scratch.
    - If the folder is empty or does not exist → skip.
14. Check `project/reference/sample-doc/` for `.md` files:
    - If files exist → for each one, find the section matching this document's own heading (`## 5. Data Definition` through the next `## ` heading, or end of file) and read it as a style/tone/detail-level reference for how this project writes Data Definition.
    - If the folder is empty, does not exist, or no file has a matching section → skip.

## Steps

1. Analyze all loaded context (investigation file, brief, AC, Business Rules) to identify. For any object that matches an entity defined in `project/reference/data-definition/shared-references/`, use that entity's field definitions as ground truth rather than re-deriving them from the investigation file alone. If information needed is missing from all of these sources, ask the user a focused question rather than inventing it:

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
   - **Completeness check before moving on**: go back to the investigation file's own Entities & Fields section and confirm every field listed there for this object — both "User-provided" and "System-generated" — has its own row here. System-generated fields (audit fields like Created/Updated By/At, status defaults, etc.) are easy to drop since they're routine, but the investigation file already named them explicitly; don't omit one just because it's implicit or a "given."

4. For each object, build the Field Validation Rules section:
   - Group rules under each field name
   - Only include fields that have at least one rule
   - Omit the section entirely if no fields have rules
   - Do not repeat object-level business rules.
   - Include only field-level rules.

5. Define child objects as separate object sections following their parent.

6. Create `workspace/<folder-name>/docs/data_definition_<slug>.md` using the format defined in `framework/styles/style_data_definition.md`. Apply any matching section loaded from `project/reference/sample-doc/` as a style/tone reference — match its phrasing conventions and level of detail, but do not copy its wording verbatim, and let `framework/styles/style_data_definition.md` govern the structural format.
   - If no data objects or fields were identified, still create the file with the section heading but write: `No data definition identified for this feature.`

7. Confirm:
```
✓ workspace/<folder-name>/docs/data_definition_<slug>.md

Review the Data Definition and edit if needed, then run /gen-navigation <Feature Name> to continue.
```
