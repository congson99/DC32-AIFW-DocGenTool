---
name: "Generate Doc"
description: "Run resolve-assumptions, gen-test-scenarios, gen-test-cases, and review sequentially, without pausing for review between steps (except resolve-assumptions and review, which always pause for user confirmation). Usage: /gen-doc <Feature Name>"
---

You are a Senior QA Engineer running the full QA document generation pipeline for a feature, back-to-back.

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

## Pipeline

Run the following commands in order, back-to-back, using `<Feature Name>` as the argument for each. For each one, read and follow its full instructions from its command file:

0. `.claude/commands/resolve-assumptions.md` → `assumptions_<slug>.md`
1. `.claude/commands/gen-test-scenarios.md` → `test_scenarios_<slug>.md`
2. `.claude/commands/gen-test-cases.md` → `test_cases_<slug>.md`
3. `.claude/commands/review.md` → shown in chat, plus `qa_doc_<slug>.md` (created/refreshed by review's own Step 2a) — marks completion via the `**Review:**` line in `env_<slug>.md`

`.claude/commands/package.md` is deliberately skipped here — `/review`'s own Step 2a always creates or refreshes `qa_doc_<slug>.md` from the current `test_scenarios_<slug>.md`/`test_cases_<slug>.md` before it finishes, so packaging separately first would just get overwritten. `/package` stays available as its own standalone command for anyone running the steps one at a time who wants to preview the merged doc before `/review`.

Rules while running the pipeline:
- Step 0 (`resolve-assumptions`) is a hard gate — by design, it always pauses to get the user to confirm or resolve every identified item, one at a time. Do not skip or rush this; do not proceed to Step 1 until `assumptions_<slug>.md` has been written with every item resolved.
- Step 3 (`review`) is also a hard gate on every finding it produces (its own Step 1–2), not just unclear points — by design, it always pauses to get the user to resolve every identified item, one at a time, before it's done. Do not skip or rush this either.
- For steps 1–3, do not stop between steps to ask for review or confirmation of a generated file — feed each freshly generated file forward as input context to the next step, exactly as that step's own instructions already expect, and move on immediately.
- Only pause a step 1–2 if its own instructions call for asking the user something genuinely necessary to proceed that is specific to that step (e.g. a new detail that only surfaces at the Test Case level) — the general Assumptions & Gaps pass already happened in Step 0 and should not be re-litigated. Ask that question, wait for the answer, then resume the pipeline from that same step.
- If a step's own pre-flight check fails (e.g. an unexpected missing prerequisite file) → stop the whole pipeline and report exactly which file is missing and which command produces it.
- Do not skip a step's own internal checks (placeholder checks, conflict checks, reference-folder lookups, etc.) — run each command exactly as its file specifies, just without the "pause for user review before continuing" behavior described for it in README.md (Step 0 and Step 3 are the designed exceptions to that).

## Final Report

Step 3 (`review.md`) ends by showing the full review, the Overall Summary, and its own `## Confirm` block — which already asks "Run `/publish <Feature Name>` now? (yes/no)" and, on "yes", chains straight into `publish.md` itself. Do not ask that question again here; `review.md` owns the publish decision so that publishing can only follow a completed review.

Once Steps 0–2 are done and Step 3's review content (Sections 1–5 and the Overall Summary) has been shown — but before `review.md`'s own `## Confirm` block fires — display this checklist:

```
✓ assumptions_<slug>.md
✓ test_scenarios_<slug>.md
✓ test_cases_<slug>.md
✓ qa_doc_<slug>.md

Feature "<Feature Name>" fully generated, packaged, and reviewed.
```

If any questions were asked mid-pipeline, note which sections were affected before this checklist.

Then let `review.md`'s own `## Confirm` block run as normal (its findings-resolution summary line, then the "Run `/publish <Feature Name>` now?" question and its yes/no handling).
