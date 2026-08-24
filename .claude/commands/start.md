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
2. Preserve any acronym already written in full uppercase within `project/context/` (if any files exist there) — e.g., if a context file uses `SKU` or `API` as an acronym, keep that exact token uppercase when it appears in the feature name (case-insensitive match). If `project/context/` has no files, or no acronym is found for a given word, leave it in normal title case — do not invent or hardcode acronyms here.
   - Example: if a context file defines `SKU` as an acronym, `create sku` → `Create SKU`. Otherwise a word just gets normal title case, e.g. `create product category` → `Create Product Category`.
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

There are 3 interactive questions in this flow (env fill-in, Figma design links, context fill-in). Prefix each with its running position out of the fixed total, e.g. "Question 1/3: ..." (translate "Question" into the language chosen in "Interaction Language" above) — same convention as `/config-project`. If a question is skipped entirely (e.g. step 8 has no placeholders left), it does not consume a number — the other questions simply keep their own fixed position (still "1/3", "2/3", or "3/3" as listed below, since the total here is always the 3 questions defined below, not a dynamically shrinking count).

8. Help fill in `env_<slug>.md`: scan it for any line still containing a placeholder (`<jira-ticket-url>` or `<confluence-page-url>`). If any are found, ask the user for all of them together in a single message: a short conversational lead-in asking for the links, then the labels as a plain bullet list inside a fenced code block (so the user can copy/paste it), then a closing line telling them to leave any blank they don't have yet. Say "leave it blank", never "skip". Format like:
   > "Question 1/3: Could you share the links for the following:
   >
   > ```
   > - <label 1>:
   > - <label 2>:
   > - <label 3>:
   > ```
   >
   > Leave any of them blank if you don't have it yet."
   - Do not hardcode label names — read them from whatever `env_<slug>.md` actually contains (the labels come from the project's own `### 3.2 QA` template under `## 3. Task Environment`, which can differ per project). Phrase each label in plain, conversational terms describing what it is (e.g. `**Task Jira ticket:**` → "Jira ticket for this task"; `**Source BA Doc:**` → "Confluence page (or local path) for the Source BA Doc") — don't paste the raw field label verbatim, and don't append extra qualifiers or examples that aren't already part of the label itself.
   - After the user responds, update each corresponding line in `env_<slug>.md` with the given value; leave placeholder lines untouched for anything left blank.
   - If no placeholders remain in the file, skip this step silently.

9. Help collect design references for this feature — this is a per-feature list of specific design pages/frames, not the project's whole Figma file (from `### MCP Config`, which can hold thousands of pages and isn't something to search blindly). Ask in plain language, with the options laid out as a clear bullet list (not crammed into one sentence) so the user can scan them at a glance:
   > "Question 2/3: Does this feature have its own UI design? If so, you can give me one of the following:
   >
   > - A Confluence page with the UI specification
   > - A link to each specific Figma page/frame, with your own short description
   > - A link to each specific Figma page/frame, without a description (I'll take a look and summarize it myself, then check with you)
   > - A link to the Figma page that already contains this feature's design (I'll look through it and find the specific frames that belong to this feature)
   > - Screenshots/wireframes/mockups of the feature (you can attach the images directly)
   >
   > If there's no design reference for this feature, just say so."
   - **User says no/skip** → do not create a Design References section at all; move on to step 10.
   - **User gives a Confluence page with the UI specification** → fetch the page via the Atlassian MCP tools and derive a short one-sentence description of what it covers, in the Document language; if the Atlassian MCP isn't connected in this session, ask the user for a short description instead (or suggest running `/connect-mcp` first). Show the derived description back to the user for confirmation the same way as the Figma no-description case below before saving.
   - **User gives specific Figma page/frame link(s) with their own description** → use their description as-is, no need to fetch anything.
   - **Figma MCP not connected in this session** (needed for the two modes below) → tell the user plainly that you can't look at Figma links yourself right now, and ask them to either paste a description alongside each link (so nothing needs fetching), or run `/connect-mcp` first if this project has a Figma connection configured.
   - **User gives specific page/frame link(s) without a description** → for each, call the Figma MCP tools (`get_metadata` for the node's name, `get_screenshot` for the visual) to derive a short one-sentence description of what that screen/frame is, in the Document language. Show everything derived, across all links given in this answer, in one message and ask the user to confirm or correct it before saving anything:
     ```
     Here's what I found:
     - <name-1>: <derived description> (<url-1>)
     - <name-2>: <derived description> (<url-2>)
     Does this look right, or is there anything you'd like to adjust?
     ```
     (translate this confirmation message into the session's interaction language)
   - **User gives a Figma page link** (a page-level node containing this feature's design, not an individual frame) → call `get_metadata` with that page's node-id to list the frames within that page, then look for ones whose names plausibly relate to this feature (matching the Feature Name or its known synonyms/keywords). Propose the shortlist you found to the user and ask them to confirm which ones are actually right, or point you to the correct frame directly if your guesses are off — do not save anything from a page link until the user has confirmed specific frames from it. Once confirmed, derive a description for each the same way as the no-description case above.
   - **User attaches screenshots/wireframes/mockups directly** (images, not links) → save each image into `workspace/<folder-name>/input/` (e.g. `design_<slug>_<n>.<ext>`, preserving the original image format), then look at the image directly to derive a short one-sentence description of what it shows, in the Document language. Show everything derived, across all images given in this answer, in one message and ask the user to confirm or correct it before saving — same confirmation style as the Figma no-description case above.
   - Whatever gets confirmed (from any of the five modes) is appended to `workspace/<folder-name>/input/context_<slug>.md` under its own section, added after `# Context Files` if not already present:
     ```
     # Design References

     - <confluence-or-figma-url-or-local-image-path>
       desc: <description>
     ```
   - After each round of additions, ask again in the same open style — something like "Any other design pages for this feature?" (translate appropriately) — and keep asking until the user explicitly says there's nothing more (e.g. "không", "hết rồi", "no"). Do not move on to step 10 until they do.

10. Help fill in `context_<slug>.md`: show the user the auto-populated entries (path + `desc:` for each file found in `project/context/`), then ask in plain language, without technical terms like "path" or "desc": "Question 3/3: Besides the files already added automatically, do you have any other documents related to this feature — for example, flow, user journey, or data definition docs — that you'd like included for reference? If so, give me the link and a short description of what it's about."
    - For each document the user provides, get both a link/location and a short description from them — do not invent a description yourself. Append each as `- <path>` / `  desc: <description>` to `context_<slug>.md` under `# Context Files`, then ask again in the same open style — something like "Any other documents?" (translate appropriately) — and keep asking after each addition until the user explicitly says there's nothing more (e.g. "không", "hết rồi", "no"). Do not move on to step 11 until they do.
    - If the user says "no"/"skip" on the first ask → leave the file as generated, no follow-up loop needed.

11. Immediately follow the full instructions in `.claude/commands/investigate.md` now, using the same `<Feature Name>`, continuing straight into its Pre-flight Check and Steps.
