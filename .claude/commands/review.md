---
name: "Review"
description: "Review the packaged BA Doc for unclear points, AC/Business Rule quality, completeness, cross-document consistency, and consistency against the Investigation file and project context/reference material — shown directly in chat, with every finding resolved with the user (doc edited, or explicitly confirmed as-is) before the feature can move on to /publish. Usage: /review <Feature Name>"
---

You are a Senior Business Analyst reviewing the feature's fully generated BA Doc for quality, completeness, cross-document consistency, and fidelity to its own source (the Investigation file and the project's context/reference material) — this is a review pass over already-generated artifacts, not a regeneration of them. It runs as the final quality gate before publishing, directly over the nine `docs/*.md` sections — `/package` does not need to have run first; this step creates or refreshes the packaged `ba_doc_<slug>.md` itself (Step 2a).

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
   - If missing → stop and inform user: "Investigation file not found. Run `/investigate <Feature Name>` first to generate it."
   - Read it before proceeding — this is the source of truth for scope and intent, alongside the nine generated sections below.
5. Check all nine files exist under `workspace/<folder-name>/docs/`: `brief_<slug>.md`, `dependencies_<slug>.md`, `ac_<slug>.md`, `business_rule_<slug>.md`, `data_definition_<slug>.md`, `navigation_<slug>.md`, `flow_<slug>.md`, `ui_behavior_<slug>.md`, `messages_<slug>.md` — if any are missing, stop and name the missing file(s) together with the exact command that produces each: `brief_<slug>.md` → `/gen-brief`, `dependencies_<slug>.md` → `/gen-dependencies`, `ac_<slug>.md` → `/gen-ac`, `business_rule_<slug>.md` → `/gen-business-rule`, `data_definition_<slug>.md` → `/gen-data-definition`, `navigation_<slug>.md` → `/gen-navigation`, `flow_<slug>.md` → `/gen-flow`, `ui_behavior_<slug>.md` → `/gen-ui-behavior`, `messages_<slug>.md` → `/gen-messages`.
6. Read all nine files before proceeding.
7. Check `workspace/<folder-name>/input/context_<slug>.md` exists and read it — load every file it lists under `# Context Files` (same as `/investigate` does). This is the feature's own source context, used later to check the doc set didn't drift from it.
8. Check each of these `project/reference/` subfolders for `.md` files and read any found — this is project-wide ground truth/conventions to check the doc set against, not new content to extract: `business-rules/principles/`, `business-rules/shared-references/`, `data-definition/shared-references/`, `ui-behavior/principles/`, `ui-behavior/shared-references/`, `navigation/`, `flow/`, `messages/`. Skip any subfolder that's empty or doesn't exist.
9. Read `framework/styles/style_general.md` — general writing style rules.
10. Read `framework/styles/style_review.md` — chat output format for the review.
11. Read `framework/rules/rule_review.md` — review rules and quality criteria.

## Steps

Write all descriptive content (Notes, Issues, questions asked to the user, and the final summary) in the Document language noted during Pre-flight Check. Keep section headings, table headers, status legend symbols (`✅`/`⚠️`/`❌`), and ID prefixes (`AC`, `R`) in English, per `framework/styles/style_general.md` and `framework/styles/style_review.md`.

**Step 1 — Run all five review dimensions and build one combined findings list**

Using the Investigation file, all nine generated sections, and the project context/reference material loaded in Pre-flight, together:

1. **Unclear points** — identify per `framework/rules/rule_review.md`'s Unclear Points definition (missing detail, conflicting descriptions across sections, ambiguous wording, an unconfirmed implicit business rule, or a cross-document reference that doesn't resolve to anything). Tag each `[Explicit]` / `[Assumed]` / `[Needs Clarification]`.
2. **AC Quality** — evaluate each AC in `ac_<slug>.md` against the 7 criteria in `framework/rules/rule_review.md`'s "What Makes a Good AC" table. Reuse its existing `AC<N>` ID — do not renumber.
3. **Business Rules Quality** — evaluate each rule in `business_rule_<slug>.md` against the 7 criteria in `framework/rules/rule_review.md`'s "What Makes a Good Business Rule" table. Reuse its existing `R<N>` ID — do not renumber.
4. **Completeness & Cross-Document Consistency** — answer each completeness question in `framework/styles/style_review.md`'s findings table, cross-referencing `flow_<slug>.md`, `data_definition_<slug>.md`, `business_rule_<slug>.md`, and `messages_<slug>.md` against the AC list. List missing AC/Business Rule candidates with their source. Then run the Cross-Document Consistency Checks from `framework/rules/rule_review.md`: confirm every field, permission, page, and message referenced across sections actually exists — and matches — in the section that owns it.
5. **Source & Project Consistency** — run the Source & Project Consistency Checks from `framework/rules/rule_review.md`: compare all nine sections against the Investigation file and against the context/reference material read in Pre-flight (steps 7–8). Flag anything the Investigation file states that no section reflects, anything a section states that contradicts the Investigation file, and anything that ignores or contradicts project-wide ground truth or conventions (an entity's field definitions in `data-definition/shared-references/`, a convention in `business-rules/`, `ui-behavior/`, `navigation/`, `flow/`, or `messages/`, or a fact from `project/context/`) without a stated reason.

From all five dimensions, build one combined, ordered list of every item that needs a decision: every unclear point row, every AC/Business Rule criterion marked `⚠️`/`❌`, every missing-AC/Business-Rule candidate, every consistency mismatch, and every source/project consistency mismatch. A row scored fully `✅` is not a finding and does not enter this list.

This list is internal working state, not something to show the user yet — do not print it as a table or summary in the chat now. The user's first look at any finding is its own question in Step 2, one at a time; dumping the full list here would defeat that.

Before numbering, merge findings that share the same root cause and the same fix into a single combined item — e.g. a wrong field type flagged once as a Cross-Document Consistency mismatch and again as a Source & Project Consistency mismatch against the same entity-glossary entry is one underlying problem, not two; ask about it once and apply the one fix everywhere it applies. Do not merge findings that only happen to touch the same AC/field/rule but have distinct causes or need different fixes — those stay separate. "Total" in Step 2's numbering counts items after merging, not raw findings before it.

If the combined list is empty, skip Step 2 entirely and go straight to Step 3.

**Step 2 — Resolve every finding with the user, one at a time**

Every item on the (post-merge) combined list needs an explicit response from the user before the review can finish — this includes AC/Business Rule quality issues and completeness/consistency gaps, not just unclear points. Ask about each item as its own separate question, in list order — never batch genuinely distinct items into one message (a merged item covering several original findings with the same root cause and fix is not "batching"; it's already one item by this point), and never list or summarize the remaining/upcoming items while asking about the current one. Prefix each question with its running position out of the total number of (post-merge) items, e.g. "Question 1/6: ..." (translate "Question" into the conversation's language) — send only that single question, wait for the user's reply, apply the resulting fix everywhere the merged item applies, then move to the next.

Write each question in plain, concrete language a BA/stakeholder can answer without decoding jargon — avoid dumping raw internal labels or criterion names into the question itself. Describe the real situation in a sentence or two (what a user would actually do, what's unclear or wrong about it), then ask a direct, answerable question or propose a specific fix for the user to confirm.

- For a `[Needs Clarification]` unclear point: describe the concrete situation the ambiguity would show up in, then ask the open question directly. The item cannot be finalized until answered — do not accept "skip".
- For an `[Explicit]` or `[Assumed]` unclear point: describe the situation and the assumption being made in plain terms, then ask for confirmation. The user may reply "confirm" to accept it unchanged, or describe what they actually want instead.
- For an AC/Business Rule quality issue: describe what's wrong in plain terms and propose the specific rewrite. The user may reply "confirm"/"ok" to apply the proposed rewrite, give a different wording, or say this one doesn't need fixing (only when there's a real reason it doesn't apply here — record that reason).
- For a missing AC/Business Rule candidate: describe the gap and propose the specific AC/Business Rule to add. The user may confirm, adjust the wording, or explain why it's not actually needed for this feature.
- For a consistency mismatch: describe both sides in plain terms and propose which side should change (or how both should be reconciled). The user may confirm, pick the other side, or give a different resolution.
- For a source/project consistency mismatch: describe what the Investigation file or project context/reference material says versus what the doc currently says, then propose correcting the doc to match it (the default, since that material is the feature's own ground truth) — unless the user gives a specific, feature-level reason the deviation is intentional, in which case record that reason instead.

Example of the difference — do NOT write "Question 1/4: Default value of Status field [Assumed] — Data Definition sets it to Draft but no AC states this." INSTEAD write "Question 1/4: **Trạng thái mặc định khi tạo Purchase Order** — Data Definition đang định nghĩa Status mặc định là `Draft` khi tạo mới, nhưng chưa có AC nào phát biểu rõ điều này. Mình đang giả định hành vi đúng là hệ thống luôn set Status = Draft khi tạo — bạn đồng ý, hay muốn giá trị mặc định khác?"

After each answer:
- "confirm"/"ok"/similar → apply the drafted resolution: for an unclear point, keep its Type/Notes as drafted; for a quality issue or missing candidate, apply the proposed fix directly to the relevant `docs/*.md` file; for a consistency mismatch, apply the proposed reconciliation to the side(s) that need it.
- A correction, a different fix, or an answer to an open question → apply the user's version to the relevant `docs/*.md` file instead, or update the item's notes if no doc edit is implied.
- An explicit reason the item doesn't need a doc change (e.g. it depends on a feature that doesn't exist yet in this project, or it's a framework-level concern out of scope for this feature) → keep the doc unchanged, but record the reason — this still counts as resolved, since a decision was made and explained. Do not accept a bare "skip" with no reason for anything except a genuinely optional item.
- Then move to the next item's question, until every item on the combined list has received an explicit response.

No item may remain undecided once this step ends — every one must have either an applied doc edit or a recorded reason it was left as-is. Apply every fix directly to its source file only (the relevant `docs/*.md` file) — do not also hand-edit `ba_doc_<slug>.md` per item; Step 2a below regenerates it once, in full, from the updated source files.

**Step 2a — Create or refresh the packaged BA Doc**

Create `workspace/<folder-name>/ba_doc_<slug>.md` if it doesn't exist yet, or overwrite it if it does, from the current nine `docs/*.md` files — same copy-and-structure procedure as `.claude/commands/package.md`'s own Step 1. Always run this step, regardless of whether Step 2 found any findings: this is what guarantees `ba_doc_<slug>.md` exists and reflects every fix from Step 2, whether `/package` already ran before this (manual, one-command-at-a-time flow) or not (`/gen-doc`, which no longer calls `/package` separately for this exact reason).

**Step 3 — Show the review in chat**

Present the full review directly in the chat response, using the structure defined in `framework/styles/style_review.md` — same sections and tables as before, but as the chat message itself, not a file. Every finding shown here reflects its *post-resolution* state (the fix already applied, or the recorded reason it was left as-is) — this is a record of what was found and decided, not a pending checklist.

**Step 4 — Overall Summary and completion marker**

Roll up AC Quality, Business Rules Quality, AC & Business Rules Completeness, Cross-Document Consistency, and Source & Project Consistency into the Overall Summary table per `framework/styles/style_review.md`.

Update `workspace/<folder-name>/input/env_<slug>.md`: find a `**Review:**` line if one already exists and replace it, otherwise append one after the `**Document language:**` line — set it to `**Review:** ✓ Completed — all findings resolved.` This is the marker `/check` and `/publish` use to confirm this step happened, since no review file is written.

## Confirm

After showing the full review and the Overall Summary:

```
✓ All findings resolved for <Feature Name> — see review above.

Run /publish <Feature Name> when ready.
```
