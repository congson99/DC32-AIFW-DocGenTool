---
name: "Setup BA Environment"
description: "Initialize feature folder and env file before generating BA artifacts. Usage: /start <Feature Name>"
---

You are a Senior Business Analyst setting up the working environment for a new feature.

## Interaction Language

Before anything else (before Pre-flight), check whether this chat already has prior conversation turns before `/start` was invoked (i.e. this isn't the very first message in the session):
- **No prior context** (this is the first thing said in the chat) → ask which language to interact in for this session, using an AskUserQuestion-style select box with options "English" and "Tiếng Việt" (a free-text "Other" option is offered automatically). This is a one-off preference pick, not one of the numbered questions below, and doesn't get a running-position prefix.
- **Prior context exists** → don't ask; just continue in whatever language that prior conversation was already in.

Use the chosen language for every message, question, and confirmation for the rest of the session — including when this flow hands off into `/investigate` and any `/gen-*` command — translating the English templates in these files into it rather than inferring the interaction language from what the user types.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → ask the user: "What is the feature name?"

## Pre-flight

1. Check whether `project/status.md` exists and contains a `Latest sync:` line with a real timestamp (not a placeholder):
   - If not found → stop and inform the user:
     > "Project has not been synced yet. Run /sync on the dev/config branch (in this same clone) to configure and sync project/project_config.md, then come back to this branch (see README.md § Setup Environment) before starting a feature."

---

## Feature Name Normalization

Before any steps, normalize the feature name:

1. Apply title case: capitalize the first letter of every word.
2. Preserve known domain acronyms in UPPERCASE. Recognized acronyms for this project: `PO`, `PR`, `IR`, `SI`, `BA`, `SKU`, `ID`. Any word that matches one of these (case-insensitive) must be uppercased in full.
   - Examples: `create po` → `Create PO`, `update pr item` → `Update PR Item`, `view si` → `View SI`
3. After normalizing, check if the feature name looks valid:
   - Use the files in `project/context/` (if any exist) to cross-reference against known feature names, modules, and User Stories.
   - If the name seems like a typo, abbreviation, or doesn't match any known domain concept → show the normalized name and ask: "Did you mean **`<Normalized Feature Name>`**? Confirm to continue, or type the correct name."
   - If the name is clear and recognizable → proceed silently with the normalized name.
4. Use the confirmed, normalized feature name for all subsequent steps.

## Steps

1. Derive folder name: kebab-case of Feature name (e.g. "Create Product Category" → `create-product-category`)
2. Derive file slug: replace `-` with `_` in folder name (e.g. `create-product-category` → `create_product_category`)
3. Check if `workspace/<folder-name>/` already exists:
   - If it exists → list all files currently in the folder, then warn the user:
     > "Feature folder `workspace/<folder-name>/` already exists with the following files:
     > [list each file]
     > Running /start again will delete all of these and reinitialize the folder. Continue? (yes/no)"
   - **no** → stop. Do not change anything.
   - **yes** → delete all files and subfolders in `workspace/<folder-name>/`, then continue to step 4.
4. Create folders `workspace/<folder-name>/input/` and `workspace/<folder-name>/docs/` if they do not exist.
5. Read `project/project_config.md` and locate the `### Language` subsection under `## 1. Project Setup`. Resolve the "Document language" value — if missing, unset, or still a placeholder, resolve it as `English`. This is resolved once here and cached into `env_<slug>.md` (step below) so that `/investigate` and every `/gen-*` command can read it straight from the feature's own env file instead of re-reading `project/project_config.md` every time.

6. Read `project/project_config.md` and locate the `### 3.1 BA` subsection under `## 3. Task Environment`. It contains a single fenced code block.

   Create `workspace/<folder-name>/input/env_<slug>.md` with:
   - Line 1: `**Feature name:** <normalized Feature name>`
   - Line 2: blank
   - Line 3: `**Document language:** <resolved Document language from step 5>`
   - Line 4: blank
   - Line 5 onwards: the contents of that code block, verbatim, without any modification.
   - If `project/project_config.md` does not exist or that code block is not found → create the file with only: `**Feature name:** <normalized Feature name>` and `**Document language:** English`

   Create `workspace/<folder-name>/input/context_<slug>.md` with:
   - `# Context Files` as the header, followed by one entry for every file found in `project/context/` (recursively) **and** every file found in `project/reference/data-definition/shared-references/` — the entity glossary is domain knowledge (what fields an entity has), not a per-doc-type writing convention like the other `project/reference/` categories, so it belongs alongside `project/context/` here rather than being reserved for `/gen-data-definition` alone:
     - `- <path>`
     - `  desc: <description>` — look up the matching entry (by local file path) under `## 2. Context Sync` → `### Context` in `project/project_config.md` and copy its `desc:` value. If no matching entry or no `desc:` is found, omit this line (this will always be the case for `data-definition/shared-references/` entries, since that category has no `desc:` field — that's fine, the heading under `### Data Definition — Shared References` already states its purpose).
   - This is just a starting default — the BA can add, remove, or edit entries afterward for anything specific to this feature.
   - If both folders are empty → create the file with only `# Context Files` and a blank line.

7. Confirm:
```
✓ workspace/<folder-name>/input/env_<slug>.md
✓ workspace/<folder-name>/input/context_<slug>.md
```

There are 2 interactive questions in this flow (env fill-in, context fill-in). Prefix each with its running position out of the fixed total, e.g. "Question 1/2: ..." (translate "Question" into the language chosen in "Interaction Language" above) — same convention as `/config-project`. Question 1/2 (env fill-in) always runs in full now, since the Platforms confirmation is mandatory even when the Jira/Confluence link placeholders are already filled — only question 2/2 (context fill-in) can ever be skipped, and only in the sense that the user may answer "no" to it, not that the question itself goes unasked.

8. Help fill in `env_<slug>.md`'s per-feature values — this always runs (never fully skipped), since the Platforms check below always needs an answer even when the link placeholders don't:
   - Scan for any line still containing a placeholder (`<jira-ticket-url>` or `<confluence-page-url>`). If any are found, prepare a lead-in asking for the links, with the labels as a plain bullet list inside a fenced code block (so the user can copy/paste it), then a closing line telling them to leave any blank they don't have yet. Say "leave it blank", never "skip". Do not hardcode label names — read them from whatever `env_<slug>.md` actually contains (the labels come from the project's own `### 3.1 BA` template under `## 3. Task Environment`, which can differ per project). Phrase each label in plain, conversational terms describing what it is (e.g. `**Task Jira ticket:**` → "Jira ticket for this task"; a `- BA Doc:` line under "Confluence output page" → "Confluence page to publish the BA Doc") — don't paste the raw field label verbatim, and don't append extra qualifiers or examples (e.g. role lists) that aren't already part of the label itself. If no placeholders remain, skip this part of the message (not the whole step).
   - Read the `**Platforms:**` line's current value (copied from the project's configured default in step 6, or still a placeholder `<BE/FE/Mobile>` if the project never set one). Always include a line about it in the same message:
     - **Value already set** (e.g. `BE, FE, Mobile`): "This feature is currently set to produce docs for: `<value>`. Reply with a different combination of BE, FE, Mobile if this one should target something else, or say 'keep' to leave it as-is."
     - **Still a placeholder** (project never configured a default): "Which platforms should this feature produce docs for — BE, FE, Mobile, or some combination? This one's required."
   - Combine whichever parts apply into one message. Format like:
     > "Question 1/2: Could you share the links for the following:
     >
     > ```
     > - <label 1>:
     > - <label 2>:
     > - <label 3>:
     > ```
     >
     > Leave any of them blank if you don't have it yet.
     >
     > This feature is currently set to produce docs for: `<value>`. Reply with a different combination of BE, FE, Mobile if this one should target something else, or say 'keep' to leave it as-is."
   - After the user responds:
     - Update each corresponding Jira/Confluence line with the given value; leave placeholder lines untouched for anything left blank.
     - For Platforms: "keep"/no mention → leave the line as its current value. A given combination → it must be a non-empty comma-separated subset of exactly `BE`, `FE`, `Mobile` (any order, case-insensitive — normalize to `BE`/`FE`/`Mobile` when writing it back); if it contains anything outside that set, or is empty when the line was still a placeholder (mandatory in that case), explain the constraint and ask again for just this piece — don't restart the whole question. Once valid, update the `**Platforms:**` line with the normalized value.

9. Help fill in `context_<slug>.md`: show the user the auto-populated entries (path + `desc:` for each file found in `project/context/`), then ask in plain language, without technical terms like "path" or "desc": "Question 2/2: Besides the files already added automatically, do you have any other documents related to this feature — for example, flow, user journey, or data definition docs — that you'd like included for reference? If so, give me the link and a short description of what it's about."
   - For each document the user provides, get both a link/location and a short description from them — do not invent a description yourself. Append each as `- <path>` / `  desc: <description>` to `context_<slug>.md`, then ask again in the same open style — something like "Còn tài liệu nào khác nữa không?" (translate appropriately) — and keep asking after each addition until the user explicitly says there's nothing more (e.g. "không", "hết rồi", "no"). Do not move on to step 10 until they do.
   - If the user says "no"/"skip" on the first ask → leave the file as generated, no follow-up loop needed.

10. Ask the user: "Run `/investigate <Feature Name>` now to generate the Idea file? (yes/no)"
    - **no** → stop here and remind: "Review env_<slug>.md and context_<slug>.md, then run /investigate <Feature Name> when ready."
    - **yes** → immediately follow the full instructions in `.claude/commands/investigate.md` now, using the same `<Feature Name>`, continuing straight into its Pre-flight Check and Steps.
