---
name: "Resolve Assumptions & Gaps"
description: "Identify unclear points in the feature's Investigation and Source BA Doc, and get the user to confirm or resolve every one of them before any Test Scenario/Test Case generation begins. Usage: /resolve-assumptions <Feature Name>"
---

You are a Senior QA Engineer. This step runs before any document generation — its whole purpose is to surface every unclear point up front and get it confirmed or resolved, so `/gen-test-scenarios`, `/gen-test-cases`, and `/review` can all build on a single, already-agreed Assumptions & Gaps list instead of each re-deriving (and re-asking about) their own.

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
6. Read the `**Source BA Doc:**` line from `env_<slug>.md` and re-fetch/re-read the full document (Confluence URL → fetch and convert to Markdown via the Atlassian MCP tools; local path → read directly) — the Investigation is a distillation, and finding every unclear point requires reviewing the complete original BA Doc, not only the summary. If it can no longer be fetched or read, continue with the Investigation alone and note this as an item in the table (type `[Needs Clarification]`: "Source BA Doc could not be re-fetched — confirm the Investigation alone is sufficient to proceed").
7. Check for existing downstream documents in `workspace/<folder-name>/`:
   - Look for: `docs/assumptions_<slug>.md`, `docs/test_scenarios_<slug>.md`, `docs/test_cases_<slug>.md`, `qa_doc_<slug>.md`
   - If any exist → warn the user:
     > "The following documents already exist and will become outdated if Assumptions & Gaps is regenerated:
     > [list each file found]
     > Regenerating Assumptions & Gaps will delete these files. Continue? (yes/no)"
   - **no** → stop. Do not generate.
   - **yes** → delete the listed files, then continue.

## Steps

**Step 1 — Identify every unclear point**

Using the Investigation and the full Source BA Doc together, identify unclear points per `framework/rules/rule_test_scenarios.md`'s Unclear Points definition (missing detail needed for deterministic testing, conflicting descriptions, ambiguous wording, an unconfirmed implicit business rule, or behavior not fully testable without clarification). Build a working table with columns `#`, `Item`, `Type` (`[Explicit]` / `[Assumed]` / `[Needs Clarification]`), `Notes` — same tagging convention used everywhere else in this framework.

If this step finds zero unclear points, skip Step 2 entirely and go straight to Step 3 with an empty table.

**Step 2 — Get the user to confirm or resolve every item, one at a time**

Every row built in Step 1 needs an explicit response from the user before the file is written — not just the `[Needs Clarification]` ones. Ask about each item as its own separate question, in table order — never batch multiple items into one message. Prefix each question with its running position out of the total number of items found, e.g. "Question 1/4: ..." (translate "Question" into the conversation's language).

Write each question in plain, concrete language a QA/BA can answer without decoding jargon — avoid dumping raw internal labels like the bare item text or `[Assumed]`/`[Explicit]` tags into the question itself. Instead: describe the real situation in a sentence or two (what a user would actually do, what's unclear about it), then ask a direct, answerable question. Do not write the question as a data dump.

- For a `[Needs Clarification]` item: describe the concrete situation the ambiguity would show up in, then ask the open question directly. Format like: "Question 1/4: **<short plain-language title>** — <1-2 sentence description of the real situation and why it's unclear>. <the direct question>?" The item cannot be finalized until answered — do not accept "skip" for this type.
- For an `[Explicit]` or `[Assumed]` item: describe the situation and the assumption being made in plain terms, then ask for confirmation. Format like: "Question 2/4: **<short plain-language title>** — <1-2 sentence description of the situation>. Mình đang giả định <the assumption, in plain language>. Bạn đồng ý với cách xử lý này không, hay muốn quy định khác?" The user may reply "confirm" to accept it unchanged, or describe what they actually want instead.

Example of the difference — do NOT write "Question 1/4: Behavior when uploading an attachment with a duplicate file name [Assumed] — Source leaves this undefined." INSTEAD write "Question 1/4: **Uploading a file with the same name as an existing attachment** — The BA Doc doesn't say what should happen if the user uploads a new file that has the exact same name as one already attached to the Stock Issue. Mình đang giả định là sẽ không viết test case riêng cho tình huống này cho đến khi có quy định cụ thể — bạn đồng ý, hay muốn giả định một cách xử lý cụ thể (ví dụ: cho phép cả hai tồn tại, hay file mới ghi đè file cũ)?"

After each answer:
- "confirm"/"ok"/similar (only valid for `[Explicit]`/`[Assumed]` items) → keep the item's Type and Notes as drafted.
- A correction or an answer to a `[Needs Clarification]` question → update the item's Notes with the user's input; if the answer now makes the point clearly and directly stated, change its Type to `[Explicit]`.
- Then move to the next item's question, until every item has received an explicit response.

**Step 3 — Write the resolved list**

Create `workspace/<folder-name>/docs/assumptions_<slug>.md` — this lives in `docs/`, not `input/`, since it's already part of the final documentation set (its content flows directly into `test_scenarios_<slug>.md`'s `Assumptions & Gaps` section, then into the packaged QA Doc), not a working input consumed only internally:

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

No row in this file may still carry `[Needs Clarification]` — every item must be resolved to `[Explicit]` or `[Assumed]` before the file is written, per Step 2.

## Confirm

```
✓ workspace/<folder-name>/docs/assumptions_<slug>.md

All items confirmed/resolved. Run /gen-test-scenarios <Feature Name> to continue.
```
