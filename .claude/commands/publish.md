---
name: "Publish Feature"
description: "Publish BA Doc to Confluence, update Jira status, and optionally clear the feature. Usage: /publish <Feature Name>"
---

You are a Senior Business Analyst completing a feature task. Execute each step in order, pausing to interact with the user as instructed.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight

1. Scan the `### 4.1 BA` subsection under `## 4. Task Automation` in `project/project_config.md` for unfilled placeholders (pattern `<...>`):
   - If any placeholders are found → stop and inform the user:
     ```
     project/project_config.md — Task Automation (4.1 BA) has unfilled placeholders:
       - <placeholder 1>
       ...
     Please complete section 4.1 before running /publish.
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
7. Check all nine files under `workspace/<folder-name>/docs/` exist (`brief_<slug>.md`, `dependencies_<slug>.md`, `ac_<slug>.md`, `business_rule_<slug>.md`, `data_definition_<slug>.md`, `navigation_<slug>.md`, `flow_<slug>.md`, `ui_behavior_<slug>.md`, `messages_<slug>.md`) — if any are missing, stop: "`<file>` not found. Run `/package <Feature Name>` again to regenerate the BA Doc and its source files."
8. Check `workspace/<folder-name>/input/env_<slug>.md` for a `**Review:** ✓ Completed` line — if missing (never reviewed) or present but not marked completed, stop: "Doc review not completed for this feature. Run `/review <Feature Name>` first and resolve every finding before publishing."
9. Read `workspace/<folder-name>/input/env_<slug>.md` and check for an "AI Doc folder" entry under "Confluence output pages" — if missing or still a placeholder, stop: "`AI Doc folder` is not set in env_<slug>.md. Add a Confluence page link to publish role-specific AI Docs under."

---

## Step 1 — Publish BA Doc

Publish the contents of `workspace/<folder-name>/ba_doc_<slug>.md` to the Confluence page listed under "Confluence output pages: BA Doc" in `env_<slug>.md`. This always runs — it is not configurable via Task Automation.

Before the converted content, insert a native Confluence Table of Contents macro so the page opens with a full-level heading outline, no bullets or numbers. Use `contentFormat: "html"` and prepend this node ahead of the rest of the body:
```html
<div data-type="extension" data-extension-key="toc" data-extension-type="com.atlassian.confluence.macro.core" data-parameters='{"macroParams":{"minLevel":{"value":"1"},"maxLevel":{"value":"6"},"style":{"value":"none"}}}'></div>
```

---

## Step 2 — Publish Role-Specific AI Docs

Read the `**Platforms:**` line in `env_<slug>.md` — this always contains a real, validated value (`/start` requires it, per-feature). Only the roles listed there get a page; this is the one part of Step 2 that Platforms makes configurable per feature — everything else about how each listed page is built is fixed, not configurable via Task Automation. For each role listed, create or update its child page under the "AI Doc folder" page (from `env_<slug>.md`), assembled from the already-generated files in `workspace/<folder-name>/docs/`:

| Role | Page title | Sections included, in order |
|---|---|---|
| BE | `AI Doc for BE - <Feature Name>` | Brief, Dependencies, Acceptance Criteria, Business Rules, Data Definition, Flow, Messages |
| FE | `AI Doc for FE - <Feature Name>` | Brief, Dependencies, Acceptance Criteria, Business Rules, Data Definition, Navigation, Flow, UI Behavior, Messages |
| Mobile | `AI Doc for Mobile - <Feature Name>` | Brief, Dependencies, Acceptance Criteria, Business Rules, Data Definition, Navigation, Flow, UI Behavior, Messages |

Do not touch a role's page at all if that role isn't listed in `**Platforms:**` — don't create it, and don't delete or update it if one happens to already exist from an earlier, differently-scoped run of this feature (leave it exactly as-is; note its existence in the Summary as a "not targeted by current Platforms — left untouched" remark rather than silently ignoring it).

For each included role page:
1. Concatenate the full content of each listed section's source file, in the order shown, separated by `---` — same assembly style as `/package`. BE's Flow section keeps its full content (Entry, Main Flow, Alternate Flows, Secondary Flows) exactly as generated — do not trim it down to a BE-only subset.
2. Renumber the `## N. <Title>` heading of each included section sequentially starting from `1`, in the order it appears on that page (e.g. for the BE page, Flow was `## 7. Flow` in the source file and becomes `## 6. Flow`, and Messages was `## 9. Messages` and becomes `## 7. Messages`). FE and Mobile include all nine sections in their original order, so their numbering is unchanged. This follows the same renumbering rule described under "Section numbering on split pages" in Step 3 below.
3. Check whether a child page with that exact title already exists under the "AI Doc folder" page:
   - **Exists** → update its content.
   - **Does not exist** → create it as a new child page under "AI Doc folder".
4. Track success or failure per page for the Summary.

---

## Step 3 — Execute Task Automation

Read `project/project_config.md` and locate the `### 4.1 BA` subsection under `## 4. Task Automation`. Parse all action entries within its `#### Jira` and `#### Confluence` subsections (stop at the next `### ` heading or end of file) — do not execute anything listed under `### 4.2 QA`.

For each action listed, execute it using the appropriate MCP tools and any relevant values from `env_<slug>.md`. Track the result of each action for the Summary.

**Section numbering on split pages:** When an action publishes only a subset of BA Doc sections (e.g. "Publish sections Navigation, Flow, UI Behavior, Messages ... to Flow confluence output page") to its own standalone Confluence page, renumber the section headings sequentially starting from `1` in the order they appear on that page — do not carry over their original BA Doc numbering (e.g. `5. Navigation` becomes `1. Navigation`, `6. Flow` becomes `2. Flow`, etc.). This applies only to the heading number published to Confluence; the numbering inside `workspace/<folder-name>/` source files and the full `ba_doc_<slug>.md` stays unchanged.

---

## Step 4 — Clear Feature (optional)

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
| AI Doc for BE | <result, or omit this row entirely if BE isn't in Platforms> |
| AI Doc for FE | <result, or omit this row entirely if FE isn't in Platforms> |
| AI Doc for Mobile | <result, or omit this row entirely if Mobile isn't in Platforms> |
| <action 1 from Task Automation> | <result> |
| <action 2 from Task Automation> | <result> |
| ... | ... |
| Feature folder | <cleared / kept> |
```

Only include a role's row if it was actually in `**Platforms:**` for this run.
