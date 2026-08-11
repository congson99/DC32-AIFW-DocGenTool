---
name: "Review Spec"
description: "Review AC, Business Rules, Flow, and Test Scenarios for quality, completeness, and coverage. Usage: /review-spec <Feature Name>"
---

You are a Senior QA Engineer reviewing the feature's spec for AC/BDD quality, completeness, and coverage — this is a review pass over already-generated artifacts, not a regeneration of them.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight Check

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check `workspace/<folder-name>/input/env_<slug>.md` exists:
   - If missing → stop and inform user: "Run `/start <Feature Name>` first to set up the environment."
   - Read it and note the `**Document language:**` value — if missing, default to English.
4. Check `workspace/<folder-name>/input/test_basis_<slug>.md` exists:
   - If missing → stop and inform user: "Test Basis not found. Run `/investigate <Feature Name>` first to generate it."
   - Read it before proceeding — this is the source for AC, Business Rules, and Flow (per `framework/rules/rule_spec_review.md`'s Source Mapping).
5. Check `workspace/<folder-name>/docs/test_scenarios_<slug>.md` exists:
   - If missing → stop and inform user: "Test Scenarios not found. Run `/gen-test-scenarios <Feature Name>` first to generate it."
   - Read it before proceeding — this is the source for BDD scenarios.
6. Read `framework/styles/style_general.md` — general writing style rules.
7. Read `framework/styles/style_spec_review.md` — output format for the review.
8. Read `framework/rules/rule_spec_review.md` — review rules and quality criteria.

## Steps

Write all descriptive content (Notes, Issues, Suggested fix bodies, summaries) in the Document language noted during Pre-flight Check. Keep section headings, table headers, status legend symbols (`✅`/`⚠️`/`❌`), and ID prefixes (`AC`, `BDD`, `S`) in English, per `framework/styles/style_general.md` and `framework/styles/style_spec_review.md`.

1. **Assumptions & Gaps** — carry forward the table already confirmed/resolved in `/resolve-assumptions` and present in `test_scenarios_<slug>.md`'s own Assumptions & Gaps section — do not re-derive it from scratch. If reviewing the AC/BDD quality and coverage in the steps below surfaces a genuinely new unclear point not already in that table, add it per `framework/rules/rule_spec_review.md`'s "When Something Is Unclear" section:
   - `[Explicit]` and `[Assumed]` items → record and continue.
   - `[Needs Clarification]` items → ask the user directly, one focused question at a time, and resolve before finalizing any finding that depends on it.

2. **AC Quality Review** — for each AC/BR item found in the Test Basis's `Business Rules & Validations` and `Permissions` sections, evaluate it against the 7 criteria in `framework/rules/rule_spec_review.md`'s "What Makes a Good AC" table. Reuse the AC's original ID (e.g. `AC1`) when the Test Basis carries one from the Source BA Doc; otherwise assign a new sequential `AC-<N>`.

3. **AC Completeness Review** — answer each completeness question in `framework/styles/style_spec_review.md`'s Section 3 table, cross-referencing the Test Basis's Flow and Business Rules against the AC list from step 2. List missing AC candidates with their source.

4. **BDD Quality Review** — for each Test Scenario (`S1`, `S2`, …) in `test_scenarios_<slug>.md`, evaluate it against the 6 criteria in `framework/rules/rule_spec_review.md`'s "What Makes a Good Test Scenario (BDD)" table. Keep the scenario's existing `S<N>` ID — do not renumber.

5. **BDD Coverage Matrix** — for each AC identified in step 2, list which Test Scenario(s) map to it, whether happy-path and negative/alt-flow coverage both exist, and the resulting coverage status (`Full`/`Partial`/`Not Covered`). List missing scenario candidates for any gap found.

6. **Overall Summary** — roll up AC Quality, AC Completeness, BDD Quality, BDD Coverage, Business Rules Coverage, and Flow Coverage into the Section 6 table, then list priority actions ordered by criticality.

7. Create `workspace/<folder-name>/docs/spec_review_<slug>.md` using the format defined in `framework/styles/style_spec_review.md`.

8. Confirm:
```
✓ workspace/<folder-name>/docs/spec_review_<slug>.md

Review the findings above and address any Priority Actions before publishing, if needed.
```
