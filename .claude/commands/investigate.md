---
name: "Investigate"
description: "Read the feature's Source BA Doc and distill it into an Investigation file, asking the user for anything missing. Usage: /investigate <Feature Name>"
---

You are a Senior QA Engineer distilling an existing BA Doc into a single Investigation file. Every later generation step (Test Scenarios, Test Cases) reads only this Investigation file and each other's output — not the BA Doc or project context files directly — so it needs to carry enough information for the whole pipeline.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight Check

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check `workspace/<folder-name>/input/env_<slug>.md` exists:
   - If missing → stop and inform user: "Run `/start <Feature Name>` first to set up the environment."
   - Read it and note the `**Document language:**` value (cached there by `/start`) — if missing, default to English.
4. Check `workspace/<folder-name>/input/context_<slug>.md` exists:
   - If missing → stop and inform user: "Run `/start <Feature Name>` first to set up the environment."
   - If any line still contains an unfilled placeholder (e.g. `<additional-context-file-or-confluence-url>`) → stop and inform user: "`context_<slug>.md` still has unfilled placeholders. Either fill them in or remove the placeholder lines, then re-run /investigate."
   - An empty file (no items listed under `# Context Files`) is allowed — continue.
5. Read `workspace/<folder-name>/input/context_<slug>.md` and load every entry listed on a `- <path>` line before proceeding. These are shared project context (domain overview, module map, terminology) plus anything the QA attached specifically for this feature (e.g. a per-feature Figma mockup added via `/start`'s step 9) — not the feature's own Source BA Doc, which is read separately in step 7. Indented `desc:` lines are usage notes, not files themselves. Resolve each entry by what `<path>` actually is:
   - A local file path → read it directly.
   - A Confluence URL → fetch the page and convert it to clean Markdown (same approach as `/sync-project`).
   - A Figma URL → read it via the Figma MCP tools (e.g. `get_screenshot` for the visual, `get_design_context` for structured content) — only if a `Figma` entry exists and is connected under `### MCP Config`; if not connected, note this entry as unreadable rather than failing the whole step.
6. Read `workspace/<folder-name>/input/env_<slug>.md` and locate the `**Source BA Doc:**` line:
   - If it is missing or still a placeholder (e.g. `<confluence-page-url>`) → ask the user: "What's the Source BA Doc for this feature — a Confluence page link or a local file path?" Once answered, update the `**Source BA Doc:**` line in `env_<slug>.md` with the value before continuing.
7. Fetch the Source BA Doc content:
   - If it's a Confluence URL → fetch the page content via the Atlassian MCP tools and convert it to clean Markdown (same approach as `/sync-project`).
   - If it's a local file path → read the file directly.
   - If the fetch or read fails → stop and inform the user: "Could not read the Source BA Doc at `<value>`. Please check the link/path and try again."
8. Check for existing downstream documents in `workspace/<folder-name>/`:
   - Look for: `input/investigation_<slug>.md`, `docs/assumptions_<slug>.md`, `docs/test_scenarios_<slug>.md`, `docs/test_cases_<slug>.md`, `qa_doc_<slug>.md`
   - If any exist → warn the user:
     > "The following documents already exist and will become outdated if the Investigation is regenerated:
     > [list each file found]
     > Regenerating the Investigation will delete these files. Continue? (yes/no)"
   - **no** → stop. Do not generate.
   - **yes** → delete the listed downstream files, then continue.

## Steps

Write all descriptive content in the Investigation file in the Document language noted during Pre-flight Check — keep section headings (e.g. `## Feature Overview`) in English.

The Source BA Doc is trusted as the authoritative input — do not ask the user to confirm, review, or approve content that is derivable from it. Create `workspace/<folder-name>/input/investigation_<slug>.md` by deriving every section directly and writing it in, silently. Only ask the user about a section when the BA Doc and loaded context are genuinely silent on it (see Step 2) — this is the sole case where a question is warranted.

**Step 1 — Auto-derive every section**

For each section, in template order:
- Derive the content primarily from the fetched Source BA Doc, mapping its sections regardless of their exact original headings (e.g. a Brief's Goal/Scope feeds Feature Overview; a Dependencies section or a Flow's Entry preconditions feed Preconditions/Dependencies; Business Rules plus Data Definition's field validation rules plus an AC "Validation" group feed Business Rules & Validations; a Flow's Main/Alternate/Exception paths feed Flow; a UI Behavior doc plus a Messages doc feed UI Behavior & Messages; an AC "Access Control" group or an explicit Permissions section feeds Permissions). When the Source BA Doc carries its own IDs (e.g. AC1, R1), keep those IDs inline next to each derived item.
- Fill gaps using the loaded context files (shared project context) and reasonable domain patterns when the BA Doc itself is silent but a reasonable default exists.
- Write the derived content directly into that section of the file — no confirmation step.
- If there is genuinely nothing in the BA Doc, context, or reasonable domain pattern to derive from for a section → leave that section's placeholder text as-is for now and add it to the gap list for Step 2.

**Step 2 — Ask only about genuine gaps**

After Step 1, if any sections were added to the gap list, ask about each one individually, one per message — never batch multiple sections into one message. Prefix each question with its running position out of the total number of gaps found (not the fixed 7), e.g. "Question 1/2: ..." (translate "Question" into the conversation's language). Format like:
> Question 1/2: **Permissions** — The Source BA Doc doesn't specify this. <open question about what's needed>

After each answer:
- An answer → write it into that section (in the Document language).
- "skip" or blank → keep the placeholder text for that section, unwritten.
- Then move to the next gap's question, until every gap has been asked about.

If Step 1 finds no gaps, skip Step 2 entirely and go straight to Confirm below.

Template:

```
# Investigation — <Feature Name>

## Feature Overview
<describe the feature's business goal and scope in 1–2 sentences, from the BA Doc's Brief>

## Preconditions / Dependencies
<what must already be true or exist before this feature can be entered/tested — from the BA Doc's Dependencies or Flow Entry>

## Business Rules & Validations
<consolidated business rules and field-level validations relevant to test design — when the Source BA Doc carries its own IDs (e.g. AC1, R1), keep those IDs inline next to each item so later Test Scenario/Test Case traceability can cite them directly instead of re-deriving new references>

## Flow
### Main Flow
<main end-to-end path>
### Alternate Flows
<alternate/exception paths, if any>

## UI Behavior & Messages
<feature-specific UI states and the exact messages tied to each condition>

## Permissions
<PERMISSION_CONSTANT>: <who can/cannot perform this action>

## Notes / Open Questions
<any additional constraints, edge cases, or gaps found while reading the BA Doc>
```

## Confirm

```
✓ workspace/<folder-name>/input/investigation_<slug>.md
```

If any sections still have placeholder text (user skipped them), also note:
```
⚠ investigation_<slug>.md has unfilled sections — you can complete them now, or later gen-* commands will ask about them if the information turns out to be needed.
```

Then ask the user: "Run `/gen-doc <Feature Name>` now to generate Test Scenarios, Test Cases, and package them (QA Doc)? (yes/no)"
- **no** → stop here and remind: "Review investigation_<slug>.md, then run /gen-doc <Feature Name> (or the individual /gen-test-scenarios and /gen-test-cases commands) when ready."
- **yes** → immediately follow the full instructions in `.claude/commands/gen-doc.md` now, using the same `<Feature Name>`, continuing straight into its Pre-flight Check and Pipeline.
