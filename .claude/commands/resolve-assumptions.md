---
name: "Resolve Assumptions & Gaps"
description: "Identify unclear points in the feature's Investigation and Source BA Doc, evaluate the quality and completeness of its Acceptance Criteria, and get the user to confirm or resolve every one of them before any Test Scenario/Test Case generation begins. Usage: /resolve-assumptions <Feature Name>"
---

You are a Senior QA Engineer. This step runs before any document generation — its whole purpose is to surface every unclear point, AC quality issue, and AC completeness gap up front and get each one confirmed or resolved, so `/gen-test-scenarios`, `/gen-test-cases`, and `/review` can all build on a single, already-agreed Assumptions & Gaps list and an already-solid Investigation, instead of each re-deriving (and re-asking about) their own, or generating Test Scenarios/Test Cases from a flawed AC.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight Check

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check `workspace/<folder-name>/input/env_<slug>.md` exists:
   - If missing → stop and inform user: "Run `/start <Feature Name>` first to set up the environment."
4. Check `workspace/<folder-name>/input/investigation_<slug>.md` exists:
   - If missing → stop and inform user: "Investigation not found. Run `/investigate <Feature Name>` first to generate it."
5. Read `workspace/<folder-name>/input/investigation_<slug>.md` before proceeding.
6. Read `workspace/<folder-name>/input/ba_doc_<slug>.md` — the full Source BA Doc cached by `/investigate` — the Investigation is a distillation, and finding every unclear point requires reviewing the complete original BA Doc, not only the summary. If that cache file doesn't exist (e.g. a workspace created before this caching existed), fall back to reading the `**Source BA Doc:**` line from `env_<slug>.md` and fetching/reading it directly (Confluence URL → fetch and convert to Markdown via the Atlassian MCP tools; local path → read directly). If it can be neither read from cache nor fetched, continue with the Investigation alone and note this as an item in the table (type `[Needs Clarification]`: "Source BA Doc could not be read — confirm the Investigation alone is sufficient to proceed").
7. Check for existing downstream documents in `workspace/<folder-name>/`:
   - Look for: `docs/assumptions_<slug>.md`, `docs/test_scenarios_<slug>.md`, `docs/test_cases_<slug>.md`, `qa_doc_<slug>.md`
   - If any exist → warn the user:
     > "The following documents already exist and will become outdated if Assumptions & Gaps is regenerated:
     > [list each file found]
     > Regenerating Assumptions & Gaps will delete these files. Continue? (yes/no)"
   - **no** → stop. Do not generate.
   - **yes** → delete the listed files, then continue.
8. Read `framework/rules/rule_resolve_assumptions.md` — Unclear Points definition, AC Quality criteria, AC Completeness checks, and rules for this step.

## Steps

**Step 1 — Identify every unclear point**

Using the Investigation and the full Source BA Doc together, identify unclear points per `framework/rules/rule_resolve_assumptions.md`'s Unclear Points definition (missing detail needed for deterministic testing, conflicting descriptions, ambiguous wording, an unconfirmed implicit business rule, or behavior not fully testable without clarification). Build a working list with, for each item, its `Item` text, `Type` (`[Explicit]` / `[Assumed]` / `[Needs Clarification]`), and `Notes` — same tagging convention used everywhere else in this framework.

**Step 2 — Evaluate AC Quality**

Evaluate each AC/BR item from the Investigation's `Business Rules & Validations` and `Permissions` sections against the 7 criteria in `framework/rules/rule_resolve_assumptions.md`'s "What Makes a Good AC" table. Reuse the original ID (e.g. `AC1`) when the Investigation carries one from the Source BA Doc; otherwise assign a new sequential `AC-<N>`. Only an item that fails at least one criterion becomes a finding — a fully-passing AC is not a finding.

**Step 3 — Evaluate AC Completeness**

Answer each question in `framework/rules/rule_resolve_assumptions.md`'s "AC Completeness Checks", cross-referencing the Investigation's Flow and Business Rules against the AC list from Step 2. Any question that surfaces a gap becomes a missing-AC-candidate finding, describing what isn't covered and which Business Rule/Flow step/implied behavior it comes from. A question that's already satisfied is not a finding.

**Step 4 — Merge every finding into one combined list**

Combine every row from Step 1 (unclear points) with every issue from Step 2 (AC quality) and every gap from Step 3 (AC completeness) into one working list, in that order. Merge findings that share the same root cause and the same fix into a single combined item — ask about it once and apply the one fix everywhere it applies. This combined list is internal working state — do not print it as a table or summary before asking about it.

If this combined list is empty, skip Step 5 entirely and go straight to Step 6 with an empty Assumptions & Gaps table.

**Step 5 — Get the user to confirm or resolve every item, one at a time**

Every item on the (post-merge) combined list needs an explicit response from the user before the file is written — not just the `[Needs Clarification]` ones. Ask about each item as its own separate question, in list order — never batch multiple items into one message. Prefix each question with its running position out of the total number of (post-merge) items, e.g. "Question 1/4: ..." (translate "Question" into the conversation's language).

Write each question in plain, concrete language a QA/BA can answer without decoding jargon — avoid dumping raw internal labels like the bare item text, `[Assumed]`/`[Explicit]` tags, or criterion names into the question itself. Instead: describe the real situation or what's wrong in a sentence or two, then ask a direct, answerable question or propose a specific fix. Do not write the question as a data dump.

- For a `[Needs Clarification]` unclear point: describe the concrete situation the ambiguity would show up in, then ask the open question directly. Format like: "Question 1/4: **<short plain-language title>** — <1-2 sentence description of the real situation and why it's unclear>. <the direct question>?" The item cannot be finalized until answered — do not accept "skip" for this type.
- For an `[Explicit]` or `[Assumed]` unclear point: describe the situation and the assumption being made in plain terms, then ask for confirmation. Format like: "Question 2/4: **<short plain-language title>** — <1-2 sentence description of the situation>. I'm assuming <the assumption, in plain language>. Do you agree with this approach, or would you like to specify something different?" The user may reply "confirm" to accept it unchanged, or describe what they actually want instead.
- For an AC quality issue: describe what's wrong in plain terms and propose the specific rewrite. The user may reply "confirm"/"ok" to apply the proposed rewrite to `investigation_<slug>.md`, give a different wording, or say this one doesn't need fixing (only when there's a real reason it doesn't apply here — record that reason in the conversation, no file change needed).
- For a missing AC candidate: describe the gap and propose the specific AC/BR to add. The user may confirm (added to `investigation_<slug>.md`), adjust the wording, or explain why it's not actually needed for this feature (no file change needed).

Example of the difference — do NOT write "Question 1/4: Behavior when uploading an attachment with a duplicate file name [Assumed] — Source leaves this undefined." INSTEAD write "Question 1/4: **Uploading a file with the same name as an existing attachment** — The BA Doc doesn't say what should happen if the user uploads a new file that has the exact same name as one already attached to the record. I'm assuming we won't write a separate test case for this situation until a specific rule is defined — do you agree, or would you like to define a specific way to handle it (e.g., allow both files to exist, or have the new file overwrite the old one)?"

After each answer:
- "confirm"/"ok"/similar (only valid for `[Explicit]`/`[Assumed]` unclear points) → keep the item's Type and Notes as drafted.
- A correction or an answer to a `[Needs Clarification]` question → update the item's Notes with the user's input; if the answer now makes the point clearly and directly stated, change its Type to `[Explicit]`.
- For an AC quality issue or missing AC candidate: "confirm"/"ok" → apply the proposed fix directly to `investigation_<slug>.md`; a different wording → apply the user's version instead; an explicit reason it doesn't need a change → leave `investigation_<slug>.md` unchanged.
- Then move to the next item's question, until every item has received an explicit response.

**Step 6 — Write the resolved list**

Create `workspace/<folder-name>/docs/assumptions_<slug>.md` — this lives in `docs/`, not `input/`, since it's already part of the final documentation set (its content flows directly into `test_scenarios_<slug>.md`'s `Assumptions & Gaps` section, then into the packaged QA Doc), not a working input consumed only internally. Only the **unclear points** resolved in Step 1 go into this table — AC quality fixes and missing-AC additions from Steps 2-3 are applied directly to `investigation_<slug>.md`, not listed here:

```
# Assumptions & Gaps — <Feature Name>

| # | Item | Type | Notes |
|---|---|---|---|
| 1 | <item> | [Explicit] / [Assumed] | <notes, reflecting the user's confirmation or resolution> |
```

If Step 1 found zero unclear points, write instead:

```
# Assumptions & Gaps — <Feature Name>

No unclear points identified.
```

No row in this file may still carry `[Needs Clarification]` — every item must be resolved to `[Explicit]` or `[Assumed]` before the file is written, per Step 5.

## Confirm

```
✓ workspace/<folder-name>/docs/assumptions_<slug>.md

All items confirmed/resolved (including AC quality and completeness). Run /gen-test-scenarios <Feature Name> to continue.
```
