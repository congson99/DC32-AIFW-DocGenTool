---
name: "Generate Test Scenarios"
description: "Generate Test Scenarios for a feature from its Investigation file and Source BA Doc. Usage: /gen-test-scenarios <Feature Name>"
---

You are a Senior QA Engineer.

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
4a. Check `workspace/<folder-name>/docs/assumptions_<slug>.md` exists:
   - If missing → stop and inform user: "Assumptions & Gaps not found. Run `/resolve-assumptions <Feature Name>` first — every unclear point must be confirmed or resolved before generating Test Scenarios."
5. Read `workspace/<folder-name>/input/investigation_<slug>.md` and `workspace/<folder-name>/docs/assumptions_<slug>.md` before proceeding.
6. Read the `**Source BA Doc:**` line from `env_<slug>.md` and re-fetch/re-read the full document (Confluence URL → fetch and convert to Markdown via the Atlassian MCP tools; local path → read directly) — the Investigation is a distillation, and full scenario coverage requires reviewing the complete original BA Doc, not only the summary. If it can no longer be fetched or read, continue with the Investigation alone.
7. Check for existing downstream documents in `workspace/<folder-name>/`:
   - Look for: `docs/test_cases_<slug>.md`, `qa_doc_<slug>.md`
   - If any exist → warn the user:
     > "The following downstream documents already exist and will become outdated if Test Scenarios is regenerated:
     > [list each file found]
     > Regenerating Test Scenarios will delete these files. Continue? (yes/no)"
   - **no** → stop. Do not generate.
   - **yes** → delete the listed downstream files, then continue.
8. Check `project/reference/test-scenarios/principles/` for `.md` files:
   - If files exist → read all of them. Apply these principles when analyzing the feature (Steps 1-2 below). Do not copy principle content into the output.
   - If the folder is empty or does not exist → skip.
9. Check `project/reference/test-scenarios/shared-references/` for `.md` files:
   - If files exist → read all of them and note what each defines (e.g. shared permission-denial scenarios, shared search/pagination scenarios). Reuse these instead of redefining the same scenario from scratch when relevant.
   - If the folder is empty or does not exist → skip.
10. Read `framework/styles/style_general.md` — general writing style rules.
11. Read `framework/styles/style_test_scenarios.md` — style rules specific to Test Scenarios.
12. Read `framework/rules/rule_test_scenarios.md` — writing quality rules for Test Scenarios content.

## Steps

1. Carry the already-resolved Assumptions & Gaps table forward from `assumptions_<slug>.md` as-is into the output's own top-level `Assumptions & Gaps` section (see `framework/styles/style_test_scenarios.md` for its exact heading/numbering) — do not re-derive it and do not ask the user about it again; that pass already happened in `/resolve-assumptions`. If a genuinely new unclear point specific to scenario writing surfaces while doing Step 2 (not already covered by an existing row), add it to the table with the appropriate tag, continuing the numbering from the current highest `#`; if it is `[Needs Clarification]`, ask the user directly, one focused question at a time, and resolve it before generating any scenario that depends on it.

2. Derive scenarios per `framework/rules/rule_test_scenarios.md`'s Groups & Coverage rules, in the fixed group order (Happy Path → Alternative Flows → Validation → Business Rule → System Error → Edge Cases → State-Based → Security), omitting groups with nothing to cover. Apply any principles loaded from `test-scenarios/principles/`, and reuse any matching shared scenarios from `test-scenarios/shared-references/` instead of redefining them — a shared scenario group is relevant if the feature involves a field it governs (e.g. a phone number field → Phone Number validation scenarios apply), **or** if the feature has a structural characteristic it governs even when no single field triggers it (e.g. any list/search screen returning multiple records → shared Pagination scenarios apply, regardless of which fields are shown). Check relevance against both the feature's fields and its overall behavior/screen type — don't only pattern-match on fields.

3. **Final duplicate check (blocking):** before writing the file, compare every scenario's primary observable outcome against every other scenario. Merge or remove any that duplicate an outcome already covered — do not proceed to Step 4 until this is done.

4. Create `workspace/<folder-name>/docs/test_scenarios_<slug>.md` using the format defined in `framework/styles/style_test_scenarios.md`.

5. Confirm:
```
✓ workspace/<folder-name>/docs/test_scenarios_<slug>.md

Review the Test Scenarios and edit if needed, then run /gen-test-cases <Feature Name> to continue.
```
