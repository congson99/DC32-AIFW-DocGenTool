---
name: "Generate Doc"
description: "Run gen-brief through gen-messages and package sequentially, without pausing for review between steps. Usage: /gen-doc <Feature Name>"
---

You are a Senior Business Analyst running the full BA document generation pipeline for a feature, back-to-back.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight Check

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check `workspace/<folder-name>/input/env_<slug>.md` exists:
   - If missing → stop and inform user: "Run `/start <Feature Name>` first to set up the environment."
4. Check `workspace/<folder-name>/input/idea_<slug>.md` exists:
   - If missing → stop and inform user: "Idea file not found. Run `/investigate <Feature Name>` first to generate it."

## Pipeline

Run the following commands in order, back-to-back, using `<Feature Name>` as the argument for each. For each one, read and follow its full instructions from its command file:

1. `.claude/commands/gen-brief.md` → `brief_<slug>.md`
2. `.claude/commands/gen-dependencies.md` → `dependencies_<slug>.md`
3. `.claude/commands/gen-ac.md` → `ac_<slug>.md`
4. `.claude/commands/gen-business-rule.md` → `business_rule_<slug>.md`
5. `.claude/commands/gen-data-definition.md` → `data_definition_<slug>.md`
6. `.claude/commands/gen-navigation.md` → `navigation_<slug>.md`
7. `.claude/commands/gen-flow.md` → `flow_<slug>.md`
8. `.claude/commands/gen-ui-behavior.md` → `ui_behavior_<slug>.md`
9. `.claude/commands/gen-messages.md` → `messages_<slug>.md`
10. `.claude/commands/package.md` → `ba_doc_<slug>.md`

Rules while running the pipeline:
- Do not stop between steps to ask for review or confirmation of a generated file — feed each freshly generated file forward as input context to the next step, exactly as that step's own instructions already expect, and move on immediately.
- Only pause if a step's own instructions call for asking the user something genuinely necessary to proceed (e.g. a missing detail it cannot derive from the idea file, brief, or prior generated artifacts, or a conflict it's instructed to surface). Ask that question, wait for the answer, then resume the pipeline from that same step.
- If a step's own pre-flight check fails (e.g. an unexpected missing prerequisite file) → stop the whole pipeline and report exactly which file is missing and which command produces it.
- Do not skip a step's own internal checks (placeholder checks, conflict checks, reference-folder lookups, etc.) — run each command exactly as its file specifies, just without the "pause for user review before continuing" behavior described for it in README.md.

## Final Report

Once all 10 steps complete:

```
✓ brief_<slug>.md
✓ dependencies_<slug>.md
✓ ac_<slug>.md
✓ business_rule_<slug>.md
✓ data_definition_<slug>.md
✓ navigation_<slug>.md
✓ flow_<slug>.md
✓ ui_behavior_<slug>.md
✓ messages_<slug>.md
✓ ba_doc_<slug>.md

Feature "<Feature Name>" fully generated and packaged.
```

If any questions were asked mid-pipeline, note which sections were affected before the final report.

Then ask the user: "Run `/publish <Feature Name>` now? (yes/no)"
- **no** → stop here and remind: "Review ba_doc_<slug>.md, then run /publish <Feature Name> when ready."
- **yes** → immediately follow the full instructions in `.claude/commands/publish.md` now, using the same `<Feature Name>`, continuing straight into its Pre-flight Check and Steps.
