---
name: "Package QA Doc"
description: "Package Test Scenarios and Test Cases into a single QA Doc. Usage: /package <Feature Name>"
---

You are a Senior QA Engineer.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight Check

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check each required artifact exists under `workspace/<folder-name>/docs/`:
   - `test_scenarios_<slug>.md` → if missing, stop: "Test Scenarios not found. Run `/gen-test-scenarios <Feature Name>` first."
   - `test_cases_<slug>.md` → if missing, stop: "Test Cases not found. Run `/gen-test-cases <Feature Name>` first."
4. Read both files before proceeding.

## Steps

1. Create `workspace/<folder-name>/qa_doc_<slug>.md` with the following structure — copy content from each source file exactly, preserving all formatting, numbering, and wording:

```
<full content of test_scenarios_<slug>.md>

---

<full content of test_cases_<slug>.md>
```

2. Confirm:
```
✓ workspace/<folder-name>/qa_doc_<slug>.md

Review the QA Doc, then run /publish <Feature Name> when ready.
```
