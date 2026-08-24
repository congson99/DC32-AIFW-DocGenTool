---
name: "Publish Feature"
description: "Publish QA Doc to Confluence, update Jira status, and optionally clear the feature. Usage: /publish <Feature Name>"
---

You are a Senior QA Engineer completing a feature task. Execute each step in order, pausing to interact with the user as instructed.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight

1. Scan the `### 4.2 QA` subsection under `## 4. Task Automation` in `project/project_config.md` for unfilled placeholders (pattern `<...>`):
   - If any placeholders are found → stop and inform the user:
     ```
     project/project_config.md — Task Automation (4.2 QA) has unfilled placeholders:
       - <placeholder 1>
       ...
     Please complete section 4.2 before running /publish.
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
7. Check `workspace/<folder-name>/input/env_<slug>.md` for a `**Review:** ✓ Completed` line — if missing (never reviewed) or present but not marked completed, stop: "Doc review not completed for this feature. Run `/review <Feature Name>` first and resolve every finding before publishing."
8. Read `workspace/<folder-name>/input/env_<slug>.md` and check for an "AI Doc folder" entry under "Confluence output pages" — if missing or still a placeholder, stop: "`AI Doc folder` is not set in env_<slug>.md. Add a Confluence page link to publish role-specific AI Docs under."

---

## Step 1 — Publish QA Doc

Publish the contents of `workspace/<folder-name>/qa_doc_<slug>.md` to the Confluence page listed under "Confluence output pages: QA Doc" in `env_<slug>.md`. This always runs — it is not configurable via Task Automation.

Before the converted content, insert a native Confluence Table of Contents macro so the page opens with a full-level heading outline, no bullets or numbers — same as `dev/BA`'s `/publish` does for the BA Doc. Use `contentFormat: "html"` and prepend this node ahead of the rest of the body:
```html
<div data-type="extension" data-extension-key="toc" data-extension-type="com.atlassian.confluence.macro.core" data-parameters='{"macroParams":{"minLevel":{"value":"1"},"maxLevel":{"value":"6"},"style":{"value":"none"}}}'></div>
```

---

## Step 2 — Publish Role-Specific AI Docs (Test Scenarios & Test Cases)

Determine which roles apply to this feature:
- Read the `**Platforms:**` line from `env_<slug>.md` — cached there by `/investigate` from the Source BA Doc's own `## 1. Brief` section, so it already reflects this specific feature's BA-confirmed platform scope (not just a project-wide default). It's a comma-separated subset of `BE`, `FE`, `Mobile`, `Auto Test` — `Auto Test` is included in this same field even though it isn't a deployment platform, since it's simpler to set it alongside BE/FE/Mobile than as a separate switch.
- If `env_<slug>.md` has no such line (e.g. `/investigate` ran before this field existed, or the Source BA Doc had none to cache) → fall back to the `**Platforms:**` line under `### 3.1 BA` in `project/project_config.md` as the project-wide default, and also list the child pages that already exist under the "AI Doc folder" page (from `env_<slug>.md`), noting which of `AI Doc for BE - <Feature Name>`, `AI Doc for FE - <Feature Name>`, `AI Doc for Mobile - <Feature Name>`, `AI Doc for Auto Test - <Feature Name>` are already present — an existing page is stronger evidence than the project default in this fallback case, since it reflects what was actually decided for this specific feature. Treat any role with an existing page as applicable even if it isn't in the project default. The applicable roles are the union of both checks in this fallback case.

| Role | Page title | Sections pushed |
|---|---|---|
| BE | `AI Doc for BE - <Feature Name>` | Test Cases only, **filtered** to the Test Cases whose `Scope` includes `BE` — no Test Scenarios section on this page. |
| FE | `AI Doc for FE - <Feature Name>` | Test Scenarios (full, unfiltered), Test Cases **filtered** to the Test Cases whose `Scope` includes `FE`. |
| Mobile | `AI Doc for Mobile - <Feature Name>` | Test Scenarios (full, unfiltered), Test Cases **filtered** to the Test Cases whose `Scope` includes `Mobile`. |
| Auto Test | `AI Doc for Auto Test - <Feature Name>` | Test Cases only, full/unfiltered (automation needs coverage across every platform) — no Test Scenarios section on this page. |

Filtering by `Scope` reads each Test Case's `Scope` value from `test_cases_<slug>.md`'s `Classification & Traceability` table (see `framework/rules/rule_test_cases.md`'s Scope Guideline) — a Test Case is included on a given role's page only when that role's platform name appears in its `Scope` list (e.g. a Test Case with `Scope: BE, FE, Mobile` is included on all three of BE, FE, and Mobile; one with `Scope: BE` only is included on BE alone). If a role's filtered set is empty this run, skip creating/updating that role's Test Cases section entirely and note "no matching Test Cases this run" for that role in the Summary instead of pushing an empty section.

For each applicable role (BE/FE/Mobile/Auto Test, whichever apply per above):
1. Check whether a child page with that exact title already exists under the "AI Doc folder" page.
   - **Exists** → read its current content and find the highest existing top-level `## N. <Title>` heading number on that page. Append whichever sections that role gets (per the table above) as the next sequential number(s) — two for FE/Mobile (Test Scenarios, then Test Cases), one for BE/Auto Test (Test Cases only). E.g. an FE page with 5 existing sections gets Test Scenarios as `## 6` and Test Cases as `## 7`; a BE or Auto Test page with 5 existing sections gets Test Cases as `## 6`. Do not touch, renumber, or remove any of that page's existing content.
   - **Does not exist** → create it as a new child page under the "AI Doc folder" page. For FE/Mobile: Test Scenarios as `## 1. Test Scenarios`, Test Cases as `## 2. Test Cases`. For BE/Auto Test: Test Cases alone as `## 1. Test Cases`.
2. Source the pushed content from `workspace/<folder-name>/docs/test_scenarios_<slug>.md` (FE/Mobile only) and `workspace/<folder-name>/docs/test_cases_<slug>.md` (all four, each filtered per the table above), renumbering only each file's own top-level heading to whatever number applies on that page per step 1 (their remaining `###` subheadings and all `S<N>`/`TC-<N>` IDs stay exactly as-is). Drop four things when assembling a role-specific page: `test_scenarios_<slug>.md`'s `Assumptions & Gaps` section (that's for the full QA Doc only, mirroring how BA's own AI Doc pages don't carry BA's Assumptions data either), and from `test_cases_<slug>.md` — the `### Classification & Traceability` table, the now-redundant `### Detailed Test Cases` heading itself (with nothing else left under `## N. Test Cases` besides the `TC-<N>` entries, that subheading adds nothing), and the `### Coverage Summary` table (also a QA-internal metric, not something a role-specific page needs) — so a role-specific page's Test Cases section goes straight from the `## N. Test Cases` heading into the filtered `TC-<N>` entries and ends there, with nothing after the last one.
3. Track success or failure per page for the Summary — omit a role's row entirely from the Summary if it wasn't applicable this run (same convention as BA's own AI Doc step).

---

## Step 3 — Execute Task Automation

Read `project/project_config.md` and locate the `### 4.2 QA` subsection under `## 4. Task Automation`. Parse all action entries within its `#### Jira` and `#### Confluence` subsections (stop at the next `### ` heading or end of file) — do not execute anything listed under `### 4.1 BA`.

For each action listed, execute it using the appropriate MCP tools and any relevant values from `env_<slug>.md`. Track the result of each action for the Summary.

**Section numbering on split pages:** When an action publishes only a subset of QA Doc sections (e.g. "Publish section Test Cases ... to its own confluence output page") to its own standalone Confluence page that starts fresh (no prior content on that page), renumber the section headings sequentially starting from `1` in the order they appear on that page — do not carry over their original QA Doc numbering (e.g. `2. Test Cases` becomes `1. Test Cases`). When an action instead appends sections to a page that already has content, read that page's current highest top-level section number first and number the newly appended sections to continue sequentially from it, per that action's own description. This applies only to the heading number published to Confluence; the numbering inside `workspace/<folder-name>/` source files and the full `qa_doc_<slug>.md` stays unchanged.

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
| Publish QA Doc | <result> |
| AI Doc for BE | <result, or omit this row entirely if BE wasn't applicable> |
| AI Doc for FE | <result, or omit this row entirely if FE wasn't applicable> |
| AI Doc for Mobile | <result, or omit this row entirely if Mobile wasn't applicable> |
| AI Doc for Auto Test | <result, or omit this row entirely if Auto Test wasn't applicable> |
| <action 1 from Task Automation> | <result> |
| <action 2 from Task Automation> | <result> |
| ... | ... |
| Feature folder | <cleared / kept> |
```

Only include a role's row if it was actually applicable this run (per Step 2) — same convention as BA's own AI Doc rows.
