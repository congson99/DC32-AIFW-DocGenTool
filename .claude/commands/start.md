---
name: "Setup QA Environment"
description: "Initialize feature folder and env file before generating QA artifacts. Usage: /start <Feature Name>"
---

You are a Senior QA Engineer setting up the working environment for a new feature.

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

6. Read `project/project_config.md` and locate the `### 3.2 QA` subsection under `## 3. Task Environment`. It contains a single fenced code block.

   Create `workspace/<folder-name>/input/env_<slug>.md` with:
   - Line 1: `**Feature name:** <normalized Feature name>`
   - Line 2: blank
   - Line 3: `**Document language:** <resolved Document language from step 5>`
   - Line 4: blank
   - Line 5 onwards: the contents of that code block, verbatim, without any modification.
   - If `project/project_config.md` does not exist or that code block is not found → create the file with only: `**Feature name:** <normalized Feature name>` and `**Document language:** English`

   Create `workspace/<folder-name>/input/context_<slug>.md` with:
   - `# Context Files` as the header, followed by one entry for every file found in `project/context/` (recursively):
     - `- <path>`
     - `  desc: <description>` — look up the matching entry (by local file path) under `## 2. Context Sync` → `### Context` in `project/project_config.md` and copy its `desc:` value. If no matching entry or no `desc:` is found, omit this line.
   - This is just a starting default — the BA can add, remove, or edit entries afterward for anything specific to this feature.
   - If `project/context/` contains no files → create the file with only `# Context Files` and a blank line.

7. Confirm:
```
✓ workspace/<folder-name>/input/env_<slug>.md
✓ workspace/<folder-name>/input/context_<slug>.md
```

There are 2 interactive questions in this flow (env fill-in, context fill-in). Prefix each with its running position out of the fixed total, e.g. "Question 1/2: ..." (translate "Question" into the language chosen in "Interaction Language" above) — same convention as `/config-project`. If a question is skipped entirely (e.g. step 8 has no placeholders left), it does not consume a number — the other question simply keeps its own fixed position (still "1/2" or "2/2" as listed below, since the total here is always the 2 questions defined below, not a dynamically shrinking count).

8. Help fill in `env_<slug>.md`: scan it for any line still containing a placeholder (`<jira-ticket-url>` or `<confluence-page-url>`). If any are found, ask the user for all of them together in a single message, using each line's own label as the prompt, e.g.:
   > "Question 1/2: A few things to fill in for `env_<slug>.md`:
   > - Jira ticket:
   > - Source BA Doc:
   > - <next label>:
   >
   > Reply with each value, or 'skip' for any you don't have yet."
   - Do not hardcode label names — read them from whatever `env_<slug>.md` actually contains (the labels come from the project's own `### 3.2 QA` template under `## 3. Task Environment`, which can differ per project).
   - After the user responds, update each corresponding line in `env_<slug>.md` with the given value; leave placeholder lines untouched for anything skipped.
   - If no placeholders remain in the file, skip this step silently.

9. Help fill in `context_<slug>.md`: show the user the auto-populated entries (path + `desc:` for each file found in `project/context/`), then ask in plain language, without technical terms like "path" or "desc": "Question 2/2: Besides the files already added automatically, do you have any other documents related to this feature — for example, flow, user journey, or data definition docs — that you'd like included for reference? If so, give me the link and a short description of what it's about."
   - For each document the user provides, get both a link/location and a short description from them — do not invent a description yourself.
   - Append each as `- <path>` / `  desc: <description>` to `context_<slug>.md`.
   - If the user says "no" or "skip" → leave the file as generated.

10. Ask the user: "Run `/investigate <Feature Name>` now to generate the Test Basis file? (yes/no)"
    - **no** → stop here and remind: "Review env_<slug>.md and context_<slug>.md, then run /investigate <Feature Name> when ready."
    - **yes** → immediately follow the full instructions in `.claude/commands/investigate.md` now, using the same `<Feature Name>`, continuing straight into its Pre-flight Check and Steps.
