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

1. Create `workspace/<folder-name>/qa_doc_<slug>.md` with the following structure — copy content from each source file exactly, preserving all formatting, numbering, and wording, with one exception: `test_cases_<slug>.md` is always authored on its own as `## 2. Test Cases` (per `framework/styles/style_test_cases.md`), but `test_scenarios_<slug>.md` may itself be either one top-level section (`## 1. Test Scenarios`, when it has no `Assumptions & Gaps`) or two (`## 1. Assumptions & Gaps` + `## 2. Test Scenarios`). Renumber `Test Cases`'s heading here to continue sequentially from whatever `test_scenarios_<slug>.md`'s last top-level number actually is — `## 2. Test Cases` becomes `## 3. Test Cases` when `test_scenarios_<slug>.md` has both sections, or stays `## 2. Test Cases` when it has only `Test Scenarios`. Do not touch any other numbering (scenario `S<N>` IDs, Test Case `TC-<N>` IDs, `###` subheadings) — only this one top-level heading number shifts.

```
<full content of test_scenarios_<slug>.md>

---

<full content of test_cases_<slug>.md, with its top-level heading renumbered as described above>
```

2. Confirm:
```
✓ workspace/<folder-name>/qa_doc_<slug>.md

Review the QA Doc, then run /publish <Feature Name> when ready.
```
