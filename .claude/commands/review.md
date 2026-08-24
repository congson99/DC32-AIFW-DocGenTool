---
name: "Review"
description: "Review the packaged QA Doc for unclear points, AC/BDD quality, completeness, coverage, and consistency against the Source BA Doc and project context/reference material — shown directly in chat, with every finding resolved with the user (doc edited, or explicitly confirmed as-is) before the feature can move on to /publish. Usage: /review <Feature Name>"
---

You are a Senior QA Engineer reviewing the feature's fully generated spec for quality, completeness, coverage, and fidelity to its own source (the Source BA Doc and the project's context/reference material) — this is a review pass over already-generated artifacts, not a regeneration of them. It runs after `/package`, as the final quality gate before publishing.

This review produces no file. Every finding is shown directly in the chat and must be resolved with the user, one at a time, before the command finishes — `/publish` will refuse to run until it has.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight Check

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check `workspace/<folder-name>/input/env_<slug>.md` exists:
   - If missing → stop and inform user: "Run `/start <Feature Name>` first to set up the environment."
   - Read it and note the `**Document language:**` value — if missing, default to English.
4. Check `workspace/<folder-name>/input/investigation_<slug>.md` exists:
   - If missing → stop and inform user: "Investigation not found. Run `/investigate <Feature Name>` first to generate it."
   - Read it before proceeding.
5. Check `workspace/<folder-name>/docs/assumptions_<slug>.md` exists:
   - If missing → stop and inform user: "Assumptions & Gaps not found. Run `/resolve-assumptions <Feature Name>` first."
   - Read it before proceeding — this is the already-confirmed Section 1 starting point, not something to re-derive from scratch.
6. Check `workspace/<folder-name>/docs/test_scenarios_<slug>.md` and `workspace/<folder-name>/docs/test_cases_<slug>.md` exist — if either is missing, stop: "`<file>` not found. Run `/package <Feature Name>` first to generate it and package the QA Doc."
7. Read both before proceeding.
8. Read the `**Source BA Doc:**` line from `env_<slug>.md` and re-fetch/re-read the full document (Confluence URL → fetch and convert to Markdown via the Atlassian MCP tools; local path → read directly) — this is the ground-truth check for whether the Investigation drifted from it. If it can no longer be fetched or read, continue with the Investigation alone and note this as a finding needing the user's confirmation that reviewing without it is acceptable.
9. Read `workspace/<folder-name>/input/context_<slug>.md` and load every file it lists — same as `/investigate` does.
10. Check each of these `project/reference/` subfolders for `.md` files and read any found — this is project-wide ground truth/conventions to check the spec against, not new content to extract: `test-scenarios/principles/`, `test-scenarios/shared-references/`, `test-cases/principles/`, `test-cases/shared-references/`. Skip any subfolder that's empty or doesn't exist.
11. Read `framework/styles/style_general.md` — general writing style rules.
12. Read `framework/styles/style_review.md` — chat output format for the review.
13. Read `framework/rules/rule_review.md` — review rules and quality criteria.

## Steps

Write all descriptive content (Notes, Issues, questions asked to the user, and the final summary) in the Document language noted during Pre-flight Check. Keep section headings, table headers, status legend symbols (`✅`/`⚠️`/`❌`), and ID prefixes (`AC`, `BDD`, `S`, `TC`) in English, per `framework/styles/style_general.md` and `framework/styles/style_review.md`.

**Step 1 — Run all five review dimensions and build one combined findings list**

Using the Investigation, the Source BA Doc, the Test Scenarios/Test Cases, and the project context/reference material loaded in Pre-flight, together:

1. **Unclear points** — carry forward `assumptions_<slug>.md`'s table as already resolved (do not re-ask it). Identify any genuinely *new* unclear point per `framework/rules/rule_review.md`'s Unclear Points definition that surfaces only now (from re-reading the full Source BA Doc, or from the Test Scenarios/Test Cases themselves) — tag each `[Explicit]` / `[Assumed]` / `[Needs Clarification]`.
2. **AC Quality** — evaluate each AC/BR item from the Investigation's `Business Rules & Validations` and `Permissions` sections against the 7 criteria in `framework/rules/rule_review.md`'s "What Makes a Good AC" table. Reuse the original ID (e.g. `AC1`) when the Investigation carries one from the Source BA Doc; otherwise assign a new sequential `AC-<N>`.
3. **AC Completeness** — answer each completeness question in `framework/styles/style_review.md`'s Section 3 table, cross-referencing the Investigation's Flow and Business Rules against the AC list from dimension 2. List missing AC candidates with their source.
4. **BDD Quality & Coverage** — evaluate each Test Scenario (`S1`, `S2`, …) against the 6 criteria in `framework/rules/rule_review.md`'s "What Makes a Good Test Scenario (BDD)" table (keep its existing ID — do not renumber). Then build the BDD Coverage Matrix: for each AC from dimension 2, list which scenario(s) map to it, whether happy-path and negative/alt-flow coverage both exist, and the resulting status (`Full`/`Partial`/`Not Covered`). List missing scenario candidates for any gap found.
5. **Cross-Document & Source/Project Consistency** — run the Cross-Document Consistency Checks and the Source & Project Consistency Checks from `framework/rules/rule_review.md`. Flag anything the Source BA Doc states that the Investigation/Test Scenarios/Test Cases dropped or contradict, anything that ignores a `project/reference/test-scenarios/` or `project/reference/test-cases/` convention without a stated reason, and any terminology/ID mismatch between the Test Scenarios and Test Cases themselves.

From all five dimensions, build one combined, ordered list of every item that needs a decision: every new unclear point row, every AC/BDD criterion marked `⚠️`/`❌`, every missing-AC/scenario candidate, every coverage gap (`Partial`/`Not Covered`), every cross-document mismatch, and every source/project consistency mismatch. A row scored fully `✅`/`Full` is not a finding and does not enter this list.

This list is internal working state, not something to show the user yet — do not print it as a table or summary in the chat now. The user's first look at any finding is its own question in Step 2, one at a time; dumping the full list here would defeat that.

Before numbering, merge findings that share the same root cause and the same fix into a single combined item — ask about it once and apply the one fix everywhere it applies. Do not merge findings that only happen to touch the same AC/scenario but have distinct causes or need different fixes. "Total" in Step 2's numbering counts items after merging, not raw findings before it.

If the combined list is empty, skip Step 2 entirely and go straight to Step 3.

**Step 2 — Resolve every finding with the user, one at a time**

Every item on the (post-merge) combined list needs an explicit response from the user before the review can finish. Ask about each item as its own separate question, in list order — never batch genuinely distinct items into one message, and never list or summarize the remaining/upcoming items while asking about the current one. Prefix each question with its running position out of the total number of (post-merge) items, e.g. "Question 1/6: ..." (translate "Question" into the conversation's language) — send only that single question, wait for the user's reply, apply the resulting fix everywhere the merged item applies, then move to the next.

Write each question in plain, concrete language a QA/BA can answer without decoding jargon — avoid dumping raw internal labels or criterion names into the question itself. Describe the real situation in a sentence or two (what a user would actually do, what's unclear or wrong about it), then ask a direct, answerable question or propose a specific fix for the user to confirm.

- For a `[Needs Clarification]` unclear point: describe the concrete situation the ambiguity would show up in, then ask the open question directly. The item cannot be finalized until answered — do not accept "skip".
- For an `[Explicit]` or `[Assumed]` unclear point: describe the situation and the assumption being made in plain terms, then ask for confirmation. The user may reply "confirm" to accept it unchanged, or describe what they actually want instead.
- For an AC/BDD quality issue: describe what's wrong in plain terms and propose the specific rewrite. The user may reply "confirm"/"ok" to apply the proposed rewrite, give a different wording, or say this one doesn't need fixing (only when there's a real reason it doesn't apply here — record that reason).
- For a missing AC/scenario candidate or coverage gap: describe the gap and propose the specific AC/Test Scenario to add. The user may confirm, adjust the wording, or explain why it's not actually needed for this feature.
- For a cross-document mismatch: describe both sides in plain terms and propose which side should change (or how both should be reconciled). The user may confirm, pick the other side, or give a different resolution.
- For a source/project consistency mismatch: describe what the Source BA Doc or project context/reference material says versus what the spec currently says, then propose correcting the spec to match it (the default, since that material is the feature's own ground truth) — unless the user gives a specific, feature-level reason the deviation is intentional, in which case record that reason instead.

After each answer:
- "confirm"/"ok"/similar → apply the drafted resolution: for an unclear point, keep its Type/Notes as drafted; for a quality issue, coverage gap, or missing candidate, apply the proposed fix directly to `investigation_<slug>.md` or `test_scenarios_<slug>.md` as appropriate; for a consistency mismatch, apply the proposed reconciliation to the side(s) that need it.
- A correction, a different fix, or an answer to an open question → apply the user's version to the relevant file instead, or update the item's notes if no edit is implied.
- An explicit reason the item doesn't need a change (e.g. it depends on a feature that doesn't exist yet in this project, or it's a framework-level concern out of scope for this feature) → keep the file unchanged, but record the reason — this still counts as resolved. Do not accept a bare "skip" with no reason for anything except a genuinely optional item.
- Then move to the next item's question, until every item on the combined list has received an explicit response.

No item may remain undecided once this step ends — every one must have either an applied fix or a recorded reason it was left as-is. If any Investigation or Test Scenarios edit was applied during this step, re-check whether it affects `test_cases_<slug>.md` or `qa_doc_<slug>.md`'s consistency and note any follow-up needed in the final summary.

**Step 3 — Show the review in chat**

Present the full review directly in the chat response, using the structure defined in `framework/styles/style_review.md` — same sections and tables as before, but as the chat message itself, not a file. Every finding shown here reflects its *post-resolution* state (the fix already applied, or the recorded reason it was left as-is) — this is a record of what was found and decided, not a pending checklist.

**Step 4 — Overall Summary and completion marker**

Roll up AC Quality, AC Completeness, BDD Quality, BDD Coverage, Cross-Document Consistency, and Source & Project Consistency into the Overall Summary table per `framework/styles/style_review.md`.

Update `workspace/<folder-name>/input/env_<slug>.md`: find a `**Review:**` line if one already exists and replace it, otherwise append one after the `**Document language:**` line — set it to `**Review:** ✓ Completed — all findings resolved.` This is the marker `/check` and `/publish` use to confirm this step happened, since no review file is written.

## Confirm

After showing the full review and the Overall Summary:

```
✓ All findings resolved for <Feature Name> — see review above.

Run /publish <Feature Name> when ready.
```
