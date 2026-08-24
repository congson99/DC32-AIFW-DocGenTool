---
name: "Generate Test Cases"
description: "Generate Test Cases for a feature from its Test Scenarios, Investigation, and Source BA Doc. Usage: /gen-test-cases <Feature Name>"
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
5. Read `workspace/<folder-name>/input/investigation_<slug>.md` before proceeding.
6. Check `workspace/<folder-name>/docs/test_scenarios_<slug>.md` exists:
   - If missing → stop and inform user: "Test Scenarios not found. Run `/gen-test-scenarios <Feature Name>` first to generate it."
   - If exists → read it before proceeding, including its `## 1. Assumptions & Gaps` section if present (the unified table — see `framework/styles/style_test_scenarios.md`).
7. Re-read the `**Source BA Doc:**` referenced in `env_<slug>.md` (same fetch/read approach as `/gen-test-scenarios`) for exact wording (messages, field names, entry points) when writing concrete steps and expected results. If it can no longer be fetched or read, continue with the Investigation and Test Scenarios alone and note this in Assumptions & Gaps.
8. Check for existing downstream documents in `workspace/<folder-name>/`:
   - Look for: `qa_doc_<slug>.md`
   - If any exist → warn the user:
     > "The following downstream documents already exist and will become outdated if Test Cases is regenerated:
     > [list each file found]
     > Regenerating Test Cases will delete these files. Continue? (yes/no)"
   - **no** → stop. Do not generate.
   - **yes** → delete the listed downstream files, then continue.
9. Check `project/reference/test-cases/principles/` for `.md` files:
   - If files exist → read all of them. Apply these principles when writing Test Cases (Steps below). Do not copy principle content into the output.
   - If the folder is empty or does not exist → skip.
10. Check `project/reference/test-cases/shared-references/` for `.md` files:
    - If files exist → read all of them (reusable test data/steps, written conventions). Reuse them instead of redefining the same behavior inline.
    - If the folder is empty or does not exist → skip.
11. Read `project/project_config.md` and locate `## 2. Context Sync` → `### Test Cases — UI References`. Parse its entries (format: `- <name>: <figma-url>`):
    - If any entries exist and a `Figma` entry is present and connected under `### MCP Config` → fetch each one live via the Figma MCP tools (`get_screenshot` for the visual, `get_design_context` for structured content), per `framework/rules/rule_test_cases.md`'s Common System Page Rules. Use these for any Test Case that needs a standardized system page (e.g. Error Page, No Permission Page, 404 Page) instead of inventing that page's appearance.
    - If the section has no entries, or Figma isn't configured/connected → skip; write UI-related Test Cases from the Investigation/Source BA Doc alone, without inventing screen details not stated there.
12. Read `framework/styles/style_general.md` — general writing style rules.
13. Read `framework/styles/style_test_cases.md` — style rules specific to Test Cases.
14. Read `framework/rules/rule_test_cases.md` — writing quality rules for Test Cases content.

## Steps

1. The `Assumptions & Gaps` table lives only in `test_scenarios_<slug>.md`'s `## 1. Assumptions & Gaps` (originally confirmed/resolved in `/resolve-assumptions` before any generation began, then possibly extended by `/gen-test-scenarios`) — `test_cases_<slug>.md` never gets its own copy. Identify any new unclear points specific to writing concrete Test Cases (per `framework/rules/rule_test_cases.md`'s Unclear Points) — these are the only items that can still be unresolved at this stage. For every `[Needs Clarification]` item found here, ask the user directly and resolve it before writing the Test Case(s) that depend on it. Once resolved, **edit `test_scenarios_<slug>.md` directly** to append each new row to its existing `Assumptions & Gaps` table, continuing the numbering from its current highest `#` — do not create a separate table in `test_cases_<slug>.md`. If this promotes the file from having no `Assumptions & Gaps` section to having one for the first time, add the `## 1. Assumptions & Gaps` heading and shift `Test Scenarios` from `## 1.` to `## 2.` per `style_test_scenarios.md`.

2. For each Test Scenario (`S1`, `S2`, …) in `test_scenarios_<slug>.md`, write at least one Test Case using concrete steps and data drawn from the Investigation and the Source BA Doc (exact message wording, real field names/sample values, BA-defined entry points per the Entry Point Rules). Group multiple data variations of the same scenario into Test Data rows within one Test Case rather than separate Test Cases, per the Duplicate Prevention rules.

3. Assign `Priority` (P0–P3) and `Automatable` (Yes/No/Partial) per `framework/rules/rule_test_cases.md`'s guidelines, and `Test Focus` per the applicable category.

4. Order Test Cases to match the Test Scenario order (`S1`, `S2`, …), grouping multiple Test Cases under the same scenario together.

5. Build the Coverage Summary by counting Test Scenarios, Acceptance Criteria, and Business Rules in the Investigation against how many are covered by the generated Test Cases — list any gap with its reason.

6. Create `workspace/<folder-name>/docs/test_cases_<slug>.md` using the format defined in `framework/styles/style_test_cases.md`.

7. Confirm:
```
✓ workspace/<folder-name>/docs/test_cases_<slug>.md

Review the Test Cases and edit if needed, then run /package <Feature Name> to continue.
```
