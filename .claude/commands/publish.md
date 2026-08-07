---
name: "Publish Feature"
description: "Publish BA Doc to Confluence, update Jira status, and optionally clear the feature. Usage: /publish <Feature Name>"
---

You are a Senior Business Analyst completing a feature task. Execute each step in order, pausing to interact with the user as instructed.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight

1. Scan `## 4. Task Automation` in `project/project_config.md` for unfilled placeholders (pattern `<...>`):
   - If any placeholders are found → stop and inform the user:
     ```
     project/project_config.md — Task Automation has unfilled placeholders:
       - <placeholder 1>
       ...
     Please complete section 4 before running /publish.
     ```

2. Derive folder name: kebab-case of Feature name (e.g. "Create PO" → `create-po`)
3. Derive file slug: replace `-` with `_` (e.g. `create-po` → `create_po`)
4. Read `workspace/<folder-name>/input/env_<slug>.md` — if missing, stop: "Environment file not found. Run `/start <Feature Name>` first."
5. Scan `workspace/<folder-name>/input/env_<slug>.md` for unfilled placeholders (pattern `<...>`):
   - If any placeholders are found → stop and inform the user:
     ```
     env_<slug>.md has unfilled placeholders:
       - <placeholder 1>
       ...
     Please fill these in before running /publish.
     ```
6. Check `workspace/<folder-name>/ba_doc_<slug>.md` exists — if missing, stop: "BA Doc not found. Run `/package <Feature Name>` first."

---

## Step 1 — Publish BA Doc

Publish the contents of `workspace/<folder-name>/ba_doc_<slug>.md` to the Confluence page listed under "Confluence output pages: BA Doc" in `env_<slug>.md`. This always runs — it is not configurable via Task Automation.

---

## Step 2 — Execute Task Automation

Read `project/project_config.md` and locate the `## 4. Task Automation` section. Parse all action entries within that section (stop at the next `## ` heading or end of file).

For each action listed, execute it using the appropriate MCP tools and any relevant values from `env_<slug>.md`. Track the result of each action for the Summary.

**Section numbering on split pages:** When an action publishes only a subset of BA Doc sections (e.g. "Publish sections Navigation, Flow, UI Behavior, Messages ... to Flow confluence output page") to its own standalone Confluence page, renumber the section headings sequentially starting from `1` in the order they appear on that page — do not carry over their original BA Doc numbering (e.g. `5. Navigation` becomes `1. Navigation`, `6. Flow` becomes `2. Flow`, etc.). This applies only to the heading number published to Confluence; the numbering inside `workspace/<folder-name>/` source files and the full `ba_doc_<slug>.md` stays unchanged.

---

## Step 3 — Clear Feature (optional)

Ask the user:
> "Do you want to clear the feature folder `workspace/<folder-name>/`? (yes/no)"

- **no** → skip.
- **yes** → delete the feature folder:
  1. Confirm with the user: "Delete `workspace/<folder-name>/` and all its contents? (yes/no)"
  2. If confirmed → delete the folder and all contents, confirm: "✓ Deleted workspace/<folder-name>/"
  3. If cancelled → note: "Feature folder kept."

---

## Summary

After all steps are complete, display:

```
## ✓ Published — <Feature Name>

| Step | Result |
|---|---|
| Publish BA Doc | <result> |
| <action 1 from Task Automation> | <result> |
| <action 2 from Task Automation> | <result> |
| ... | ... |
| Feature folder | <cleared / kept> |
```
