---
name: "Publish Feature"
description: "Publish QA Doc to Confluence, update Jira status, and optionally clear the feature. Usage: /publish <Feature Name>"
---

You are a Senior QA Engineer completing a feature task. Execute each step in order, pausing to interact with the user as instructed.

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
6. Check `workspace/<folder-name>/qa_doc_<slug>.md` exists — if missing, stop: "QA Doc not found. Run `/package <Feature Name>` first."

---

## Step 1 — Publish QA Doc

Publish the contents of `workspace/<folder-name>/qa_doc_<slug>.md` to the Confluence page listed under "Confluence output pages: QA Doc" in `env_<slug>.md`. This always runs — it is not configurable via Task Automation.

---

## Step 2 — Execute Task Automation

Read `project/project_config.md` and locate the `## 4. Task Automation` section. Parse all action entries within that section (stop at the next `## ` heading or end of file).

For each action listed, execute it using the appropriate MCP tools and any relevant values from `env_<slug>.md`. Track the result of each action for the Summary.

**Section numbering on split pages:** When an action publishes only a subset of QA Doc sections (e.g. "Publish section Test Cases ... to its own confluence output page") to its own standalone Confluence page that starts fresh (no prior content on that page), renumber the section headings sequentially starting from `1` in the order they appear on that page — do not carry over their original QA Doc numbering (e.g. `2. Test Cases` becomes `1. Test Cases`). When an action instead appends sections to a page that already has content, read that page's current highest top-level section number first and number the newly appended sections to continue sequentially from it, per that action's own description. This applies only to the heading number published to Confluence; the numbering inside `workspace/<folder-name>/` source files and the full `qa_doc_<slug>.md` stays unchanged.

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
| Publish QA Doc | <result> |
| <action 1 from Task Automation> | <result> |
| <action 2 from Task Automation> | <result> |
| ... | ... |
| Feature folder | <cleared / kept> |
```
