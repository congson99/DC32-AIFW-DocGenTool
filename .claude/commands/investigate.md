---
name: "Investigate"
description: "Investigate project context to generate the Idea file for a feature, asking the user for anything missing. Usage: /investigate <Feature Name>"
---

You are a Senior Business Analyst distilling a feature's raw context into a single Idea file. Every later generation step (Brief through Messages) reads this Idea file and each other's output as its primary source — so it needs to carry enough information for the whole pipeline. (`/gen-dependencies` is the one exception: it also re-reads the project context files directly, since it needs the full module map to spot prerequisites — not just what made it into the Idea file.)

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
5. Read `workspace/<folder-name>/input/context_<slug>.md` and load every file listed on a `- <path>` line — read each one before proceeding. Indented `desc:` lines are just usage notes describing what that file covers; they are not files themselves and should not be loaded.
6. Check for existing downstream documents in `workspace/<folder-name>/`:
   - Look for: `input/idea_<slug>.md`, `docs/brief_<slug>.md`, `docs/dependencies_<slug>.md`, `docs/ac_<slug>.md`, `docs/business_rule_<slug>.md`, `docs/data_definition_<slug>.md`, `docs/navigation_<slug>.md`, `docs/flow_<slug>.md`, `docs/ui_behavior_<slug>.md`, `docs/messages_<slug>.md`, `ba_doc_<slug>.md`
   - If any exist → warn the user:
     > "The following documents already exist and will become outdated if the Idea file is regenerated:
     > [list each file found]
     > Regenerating the Idea file will delete these files. Continue? (yes/no)"
   - **no** → stop. Do not generate.
   - **yes** → delete the listed downstream files, then continue.
7. Check for a **sibling feature's** own Data Definition covering this feature's subject entity (the entity named in the Feature name, e.g. "Warehouse" in "Update Warehouse"): scan every `workspace/*/docs/data_definition_*.md` from other features for a `### <Entity>` section whose name matches. (The project-level entity glossary, if this project has one, was already loaded in step 5 as part of `context_<slug>.md` — no separate scan needed for that; it's ground truth like any other context file. This step is only about reusing a sibling feature's own generated doc, which is a different kind of source — see Step 1's handling below.)
   - If found → load it as a candidate source for the **Entities & Fields** draft in Step 1, alongside whatever the entity glossary already provided.
   - If not found → nothing extra to load here; Step 1 drafts Entities & Fields from context files (including any entity glossary) and domain patterns, as before.
8. Read `framework/rules/rule_brief.md`'s "Out of Scope" and "In Scope" sections — apply their relevance bar when drafting this idea file's own **Scope** section in Step 1, so it doesn't need redoing later when `/gen-brief` re-applies the same rule to produce the actual Brief.

## Steps

Write all descriptive content in the idea file in the Document language noted during Pre-flight Check — keep section headings (e.g. `## Overview`) in English.

Create `workspace/<folder-name>/input/idea_<slug>.md` by going through every section of the template, one section at a time — never fill a section into the file without the user confirming it first, no matter how clearly it seems derivable from context. Nothing gets written silently, including `## Overview`.

**Step 0 — Free-form description**

Before asking about any individual section, ask the user one open question first, in the language they're currently chatting in: something like "Bạn hãy mô tả tính năng này, mình sẽ đọc hiểu và tổng hợp lại vào file idea cho bạn" (translate appropriately if the user is chatting in a different language). Let the user answer freely, in whatever structure they want — do not constrain them to the template's sections.

Once they respond, ask a short follow-up in the same open style — something like "Bạn còn muốn bổ sung gì thêm không?" (translate appropriately) — and keep asking after each answer until the user explicitly says there's nothing more (e.g. "không", "hết rồi", "no"). Do not move on to Step 1 until they do; treat every round of additions as part of the same free-form description, not a new question.

Once the user confirms there's nothing more to add, treat the full free-form description (all rounds combined) as an additional source alongside the loaded context files: read it together with the context files, cross-referencing the normalized feature name against known features, modules, tickets, and descriptions. This combined understanding (user's description + context) feeds the draft for every section below — the user's own words take priority over context or domain-pattern guesses wherever they overlap or conflict.

**Step 1 — Section-by-section draft and confirm**

For each section, in template order:
1. Research and draft a proposed answer:
   - Base it primarily on what the user described in Step 0; fill in gaps using the loaded context files (other similar/related features found there) and reasonable domain patterns for this kind of action (e.g. a "View" screen on an entity that already has a "Create"/"Update" feature documented usually shares its fields; a list screen usually supports search/filter on its key identifying fields).
   - **Entities & Fields specifically**: if a context file loaded in step 5 already defines this feature's subject entity (e.g. an entity glossary), draft directly from it instead of inventing a field list — its fields are ground truth like any other context file, no special caveat needed. If instead (or in addition) Pre-flight step 7 found a sibling feature's own Data Definition for this entity, treat it as a candidate, not ground truth: if that sibling doc itself left anything unconfirmed (an item in its own Notes/Open Questions, or a field whose type/behavior was stated as an assumption rather than a fact), carry that flag into this draft too and say so plainly in the question (e.g. "Reusing Warehouse's fields from `create-warehouse`'s Data Definition: Name, Address, Manager, Status. Note: whether Manager is free-text or a reference to a User record was never confirmed there either — want to settle it now, or leave it open?"). Reusing a prior answer must never quietly convert "nobody confirmed this" into "this is fact."
   - **Business Rules & Validation specifically**: if the normalized feature name matches a deletion action on an entity (e.g. "Delete Warehouse"), proactively draft a question about referential integrity — whether the entity can be deleted while other records still reference it — using the loaded module map to name which modules/entities depend on it, rather than waiting for the user to bring it up.
   - **Scope specifically**: apply `framework/rules/rule_brief.md`'s "Out of Scope" relevance bar (loaded in Pre-flight step 8) — an Out of Scope item must be a closely related capability on the same object/workflow/task that a reader could plausibly expect to be in scope (e.g. a sibling action on the same entity, or another tab on the same page). Do not add an exclusion just because it's a system capability that touches the same data — if it's already obviously a different feature/module with no realistic ambiguity, leave it out entirely rather than stating the obvious. Prefer a short, empty-if-nothing-fits Out of Scope over padding it.
   - Present the draft as a starting point, not a final answer — make clear it's a guess the user should confirm, edit, or reject, not a stated fact.
   - If there is genuinely nothing reasonable to draft (nothing in the user's description, no related pattern anywhere in context, and no sensible domain default), skip the draft and just ask the open question instead.
2. Ask the user about that section as its own separate question — never batch multiple sections into one message.

Prefix every question with its running position out of the fixed total, e.g. "Question 2/8: ..." (translate "Question" into the conversation's language) — same convention as `/config-project` and `/start`. The total is the fixed number of sections in the template (currently 8: Overview, Scope, Entities & Fields, Process Flow, Search & Filters, Business Rules & Validation, Permissions, Notes/Open Questions).

Ask each question in the language the user is currently chatting in — but the drafted content itself must be written in the Document language noted during Pre-flight Check, since it goes straight into `idea_<slug>.md` if confirmed (only the question's surrounding phrasing/framing follows the chat language, not the draft content). Format like:
> Question 1/8: **Entities & Fields** — Based on <the pattern/source it's drawn from>, here's a draft (written in the Document language): <field>, <field>, <field>. Reply "confirm" (or "ok") to keep this as-is, give corrections/additions, or say "skip" to leave it for later.

After each answer:
- "confirm"/"ok"/similar → write the drafted content into that section as-is.
- Corrections or additions → merge them into the draft, favoring the user's input wherever it conflicts with the draft, then write the merged result.
- "skip" or blank → keep the original placeholder text for that section, unwritten.
- Then move on to the next section's question, until every section in the template has been asked about.

Template:

```
# Feature Idea — <Feature Name>

## Overview
<describe the feature goal in 1–2 sentences>

## Scope
- In scope: <bullet list>
- Out of scope: <bullet list>

## Entities & Fields
### <Entity>
- User-provided: <field>, <field>
- System-generated: <field>: <how generated or default value>

## Process Flow
1. <main step, from entry point to completion>
2. <step>

## Search & Filters
- Search target: <entity being searched>
- Search by: <field(s)>
- Matching rule: <e.g. partial match on name>

## Business Rules & Validation
- <rule or validation, e.g. required / must be > 0 / status transition constraint>

## Permissions
- <PERMISSION_CONSTANT>

## Notes / Open Questions
<any additional constraints, edge cases, or unresolved questions>
```

## Confirm

```
✓ workspace/<folder-name>/input/idea_<slug>.md
```

If any sections still have placeholder text (user skipped them), also note:
```
⚠ idea_<slug>.md has unfilled sections — you can complete them now, or later gen-* commands will ask about them if the information turns out to be needed.
```

Then ask the user: "Run `/gen-doc <Feature Name>` now to generate the full BA Doc (Brief through Package)? (yes/no)"
- **no** → stop here and remind: "Review idea_<slug>.md, then run /gen-doc <Feature Name> (or the individual /gen-* commands, starting with /gen-brief) when ready."
- **yes** → immediately follow the full instructions in `.claude/commands/gen-doc.md` now, using the same `<Feature Name>`, continuing straight into its Pre-flight Check and Pipeline.
