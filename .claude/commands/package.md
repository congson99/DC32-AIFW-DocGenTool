---
name: "Package BA Doc"
description: "Package Brief, AC, Business Rules, and Data Definition into a single BA Doc. Usage: /package <Feature Name>"
---

You are a Senior Business Analyst.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight Check

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check each required artifact exists under `workspace/<folder-name>/docs/`:
   - `brief_<slug>.md` → if missing, stop: "Brief not found. Run `/gen-brief <Feature Name>` first."
   - `dependencies_<slug>.md` → if missing, stop: "Dependencies not found. Run `/gen-dependencies <Feature Name>` first."
   - `ac_<slug>.md` → if missing, stop: "Acceptance Criteria not found. Run `/gen-ac <Feature Name>` first."
   - `business_rule_<slug>.md` → if missing, stop: "Business Rules not found. Run `/gen-business-rule <Feature Name>` first."
   - `data_definition_<slug>.md` → if missing, stop: "Data Definition not found. Run `/gen-data-definition <Feature Name>` first."
   - `navigation_<slug>.md` → if missing, stop: "Navigation not found. Run `/gen-navigation <Feature Name>` first."
   - `flow_<slug>.md` → if missing, stop: "Flow not found. Run `/gen-flow <Feature Name>` first."
   - `ui_behavior_<slug>.md` → if missing, stop: "UI Behavior not found. Run `/gen-ui-behavior <Feature Name>` first."
   - `messages_<slug>.md` → if missing, stop: "Messages not found. Run `/gen-messages <Feature Name>` first."
4. Read all nine files before proceeding.

## Steps

1. Create `workspace/<folder-name>/ba_doc_<slug>.md` with the following structure — copy content from each source file exactly, preserving all formatting, numbering, and wording:

```
# A. BUSINESS

<full content of brief_<slug>.md>

---

<full content of dependencies_<slug>.md>

---

<full content of ac_<slug>.md>

---

<full content of business_rule_<slug>.md>

---

<full content of data_definition_<slug>.md>

---

# B. BEHAVIOR

<full content of navigation_<slug>.md>

---

<full content of flow_<slug>.md>

---

<full content of ui_behavior_<slug>.md>

---

<full content of messages_<slug>.md>
```

2. Confirm:
```
✓ workspace/<folder-name>/ba_doc_<slug>.md

Review the BA Doc, then run /publish <Feature Name> when ready.
```
