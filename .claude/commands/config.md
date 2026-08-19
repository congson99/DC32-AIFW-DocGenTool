---
name: "Config"
description: "Interactively fill in project/project_config.md by asking the user one question at a time. Usage: /config"
---

You are helping the user configure `project/project_config.md` for this project through Q&A, one question at a time, instead of the user editing the file by hand. This config is shared by both the BA Doc and QA Doc generation tools (on their own branches) — fill it in once here for the whole project.

## Interaction Language

Before anything else (before Pre-flight), check whether this chat already has prior conversation turns before `/config` was invoked (i.e. this isn't the very first message in the session):
- **No prior context** (this is the first thing said in the chat) → ask which language to interact in for this session, using an AskUserQuestion-style select box with options "English" and "Tiếng Việt" (a free-text "Other" option is offered automatically). This is the one exception to "never use a select UI" below — it's a one-off preference pick, not one of the 18 counted questions, and doesn't get a running-position prefix.
- **Prior context exists** → don't ask; just continue in whatever language that prior conversation was already in.

Use the resulting language (asked or inferred) for every message, question, and confirmation for the rest of the session — translate the English templates in this file into it rather than re-inferring the interaction language from what the user types on every subsequent message.

## Pre-flight

1. Check `project/project_config.md` exists — if not (e.g. a fresh clone, since `project/` is entirely gitignored), create it: make the `project/`, `project/context/`, and `project/reference/` (with its `business-rules/principles/`, `business-rules/shared-references/`, `data-definition/shared-references/`, `ui-behavior/principles/`, `ui-behavior/shared-references/`, `navigation/`, `flow/`, `messages/`, `sample-doc/` subfolders) directories if missing, then write `project/project_config.md` with the same unconfigured placeholder content `/reset` uses:
   ```
   # Project Config

   > This file has not been configured yet. Run `/config` to set it up.
   ```
   Then continue straight to step 2 below (its "no `## 1. Project Setup` heading" check will catch this freshly-created file and expand it into the full skeleton).
2. If the file does not yet contain a `## 1. Project Setup` heading (i.e. it's still in the unconfigured state left by `/reset`, or otherwise empty/new) → overwrite it entirely with this exact skeleton, then continue to step 3 below:
   `````
   # Project Config

   ---

   ## 1. Project Setup

   ### Project Name

   - <project-name>

   ### MCP Config

   - Atlassian (<site-slug>): <confluence-mcp-url>
   - Figma: <figma-url>

   ### Language

   - Document language: <e.g. English, Vietnamese>

   ---

   ## 2. Context Sync

   ### Context

   ### Sample Doc

   - project/reference/sample-doc/<filename>.md
     url: <confluence-page-url>

   ### Business Rules — Principles

   - project/reference/business-rules/principles/<filename>.md
     url: <confluence-page-url>

   ### Business Rules — Shared References

   - project/reference/business-rules/shared-references/<filename>.md
     url: <confluence-page-url>

   ### Data Definition — Shared References

   - project/reference/data-definition/shared-references/<filename>.md
     url: <confluence-page-url>

   ### UI Behavior — Principles

   - project/reference/ui-behavior/principles/<filename>.md
     url: <confluence-page-url>

   ### UI Behavior — Shared References

   - project/reference/ui-behavior/shared-references/<filename>.md
     url: <confluence-page-url>

   ### Navigation

   - project/reference/navigation/<filename>.md
     url: <confluence-page-url>

   ### Flow

   - project/reference/flow/<filename>.md
     url: <confluence-page-url>

   ### Messages

   - project/reference/messages/<filename>.md
     url: <confluence-page-url>

   ---

   ## 3. Task Environment

   ### 3.1 BA

   ````
   **Task Jira ticket:** <jira-ticket-url>

   **Confluence output page:**
   - BA Doc: <confluence-page-url>
   - AI Doc folder: <confluence-page-url>
   ````

   ### 3.2 QA

   ````
   **Task Jira ticket:** <jira-ticket-url>

   **Source BA Doc:** <confluence-page-url>

   **Confluence output page:**
   - QA Doc: <confluence-page-url>
   - AI Doc folder: <confluence-page-url>
   ````

   ---

   ## 4. Task Automation

   ### 4.1 BA

   #### Jira

   - Update ticket status to: <jira-status>
     jira-project: <jira-project-key>

   - Add Confluence page link as comment on ticket
     jira-project: <jira-project-key>

   #### Confluence

   ### 4.2 QA

   #### Jira

   - Update ticket status to: <jira-status>
     jira-project: <jira-project-key>

   - Add Confluence page link as comment on ticket
     jira-project: <jira-project-key>

   #### Confluence

   `````
3. Read the file and check each section for unfilled placeholders (pattern `<...>`): `## 1. Project Setup` (covering Project Name, MCP Config, Language), `## 2. Context Sync`, `## 3. Task Environment`, `## 4. Task Automation`.
   - **Exception:** in `## 3. Task Environment`'s code blocks (3.1 BA and 3.2 QA), the `<jira-ticket-url>` and `<confluence-page-url>` values are always meant to stay as placeholders — they're per-feature values `/start` (and `/investigate`, for Source BA Doc in 3.2) fill in later, never set at the project level. Do NOT count these as "unfilled" — only check whether the Confluence output page **labels** (e.g. "BA Doc", "QA Doc") are real (not literally `<label>` placeholder text).
   - If no placeholders remain anywhere in the file (accounting for the exception above) → stop the normal Q&A flow and instead ask the user which of these two they want:
     - **(a) Set up a brand-new project** — tell them: "This project is already configured. To start a new project from scratch, run `/reset` first (it resets project_config.md to blank and clears workspace/), then run `/config` again." Do not run `/reset` yourself — it needs its own separate confirmation.
     - **(b) Add or change something in the current config** — tell them: "Run `/update-config` — it lists everything currently configured and lets you update specific parts one at a time." Do not handle the update yourself here; `.claude/commands/update-config.md` owns this flow end to end (listing all 18 items with current values, looping over whichever the user picks, then the same `/sync`/publish follow-through).
   - Otherwise (some placeholders remain — this file isn't fully configured):
     - **At least one question has already been answered** (i.e. this isn't a freshly-created blank skeleton — some placeholders are filled in, others aren't) → before asking anything, summarize progress against the 18-question list from the "Steps" section below (list which questions are already answered, e.g. by name — "Project Name, MCP Config — Atlassian" — and which remain), then ask the user as a plain chat message whether they want to:
       - **Start over** — overwrite `project/project_config.md` with the blank skeleton from step 2 above (discarding what's filled in), then begin the Q&A from Question 1/18.
       - **Continue** — keep everything already filled in and resume the Q&A at the next unanswered question, same as the normal skip behavior below.
     - **Nothing has been answered yet** (freshly-created/still-blank skeleton) → skip this check entirely, go straight into the Q&A at Question 1/18, no prompt.
   - Note which sections/categories still have placeholders — skip anything already filled in when asking below.

## Steps

Ask ONE question at a time, in the order below. After each answer, immediately update `project/project_config.md` with that answer before moving to the next question — never batch multiple questions into one message.

Ask every question as a plain chat message — never use a multiple-choice/select UI (e.g. an AskUserQuestion-style tool) for any question in this flow, with one exception: the **Language** sub-question (1.d) below, which has a genuine small fixed set of options. Every other question's answers are free-text (names, URLs, lists of `<name>: <url>` pairs, descriptions of actions) and don't fit fixed options; a select UI forces the user into predefined choices when they need to paste arbitrary text.

Prefix every question with its running position out of the fixed total, e.g. "Question 3/18: ..." (translate "Question" into the conversation's language). The total is always **18** — the fixed count of individual questions across the whole flow (4 in Project Setup: Project Name, MCP Config — Atlassian, MCP Config — Figma, Language; 10 in Context Sync: Context, Sample Doc, Business Rules Principles, Business Rules Shared References, Data Definition Shared References, UI Behavior Principles, UI Behavior Shared References, Navigation, Flow, Messages; 0 in Task Environment — no question asked, uses defaults; 4 in Task Automation: Jira actions for BA, Confluence actions for BA, Jira actions for QA, Confluence actions for QA). MCP Config — Figma is optional but still asked and still consumes a number (an answer of "skip" is a valid, counted answer) — it is not skipped in the display the way an already-filled-in field would be. Skipped questions (already filled in) do not get asked and do not consume a number in the display — the running position simply jumps to the next number that is actually asked (e.g. 2/18 → 4/18 if question 3 was skipped).

Ask every question in the language chosen in "Interaction Language" above — the phrasing/examples below are written in English as reference templates only; translate them into that language rather than asking in English.

- If the user answers "skip" (hasn't decided yet) → leave that field/category's existing placeholder untouched, then move on to the next question.
- If the user answers "none" / "no" (there is definitively nothing there) for a **Context Sync category** (item 2 below) → delete the placeholder entry line(s) under that category's heading entirely, leaving the heading with nothing under it (same empty style as the `### Context` heading in the skeleton above) — do not leave a `<...>` placeholder sitting there once the user has confirmed there's nothing to map.
- Skip a question entirely (don't ask it) if that field/category is already filled in.

1. **Project Setup** — `## 1. Project Setup` holds four sub-answers (Project Name, MCP Config — Atlassian, MCP Config — Figma, Language); ask each in order, updating the file after each answer:
   a. **Project Name** — "What's the name of this project?"
      → Update the `### Project Name` entry with the answer before asking the next sub-question.
   b. **MCP Config — Atlassian** — mandatory. Ask: "To set up the Atlassian connection, please share a Jira ticket or Confluence page link from your workspace."
      → Update the `### MCP Config` entry as `- Atlassian (<slug>): <url>`, where `<slug>` is derived from the site's hostname (see `.claude/commands/connect-local-mcp.md`), not freely chosen. If the project ever needs a second Jira/Confluence site, that's added later via `/connect-local-mcp` (which appends another `- Atlassian (<slug>): <url>` line here) — no need to mention this during the Q&A unless the user asks.
      → Then verify immediately: follow `.claude/commands/connect-mcp.md`'s connection-check/authorize steps for this entry, having the user re-answer sub-question (b) with a corrected link if it fails — repeat until it connects successfully before moving on.
   c. **MCP Config — Figma** — optional. Ask: "Does this project use Figma for UI designs? If so, share a Figma file or project link (or say 'skip' if not used)."
      → If the user gives a link: add a new line `- Figma: <url>` under `### MCP Config` (below the Atlassian line), then verify it the same way as sub-question (b) until it connects.
      → If the user says "skip"/"no"/there is no Figma: do not add a Figma line at all — `### MCP Config` keeps only the Atlassian entry, with no placeholder left behind.
   d. **Language** — ask this one as an AskUserQuestion-style select box (the one exception noted above), with options "English", "Tiếng Việt" (a free-text "Other" option is offered automatically) — unlike the Interaction Language pick in Pre-flight, this is still one of the 18 counted questions, so it still gets the running-position prefix ("Question 4/18: ...") like every other question here, just rendered as a select box instead of plain text. Question text: "What language do you want to use for writing documents?" — if the session language picked in Pre-flight is Vietnamese, translate this into Vietnamese yourself rather than asking in English.
      → Update the `### Language` entry with the answer before moving to the next question.

2. **Context Sync** — ask one question per category, in this order. Phrase each question in plain, concrete language: explain what the category is for, give a real-world example of a document that belongs there, and show the expected answer format as `<name>: <url>` pairs (one per line) so the user can just paste a list back. Use exactly this phrasing (fill in the description/examples for the category being asked):

   a. **Context** — domain overview / module map:
      > Let's set up shared context for the project — send me the Confluence links for documents used in common across the whole project, like the BRD, module map, or roadmap. Just paste the links (one per line) — I'll open each one and figure out a short name and description myself, then show you what I found so you can confirm or correct it. Example:
      > https://confluence.example.com/wiki/spaces/PROJ/BRD
      > https://confluence.example.com/wiki/spaces/PROJ/roadmap

   b. **Sample Doc** — one or more already-finished, high-quality BA Docs used as a style/tone/detail-level reference:
      > Does the project have any already-finished BA Doc(s) that are a great example of the tone, phrasing, and level of detail you want new features to follow? These act as a style reference for every generated section (Brief through Messages), not just one category. Send me the link(s) — one per line — and I'll open each one and figure out a short name and description myself (e.g. which kind of feature it exemplifies), then show you what I found so you can confirm or correct it. Example:
      > https://confluence.example.com/wiki/spaces/PROJ/create-purchase-order-ba-doc

   c. **Business Rules — Principles** — general principles used when writing business rules:
      > Does the project have a doc describing general principles for writing Business Rules (not the rules themselves, but the guidelines for how to write/derive them)? Send me the link with a short name. Example:
      > rule-principles: https://confluence.example.com/wiki/spaces/PROJ/rule-principles

   d. **Business Rules — Shared References** — rule groups reused across many features:
      > Does the project have a doc defining rules shared across many features (e.g. Email format, Phone Number format, Pagination)? Send me the link with a short name. Example:
      > general-business-rules: https://confluence.example.com/wiki/spaces/PROJ/general-business-rules

   e. **Data Definition — Shared References** — field definitions for entities reused across many features:
      > Does the project have a doc listing field definitions for entities that show up across many features (e.g. Warehouse, Supplier, Customer — their fields, types, and a short description of each)? This lets a feature that just displays or references an entity reuse its already-defined fields instead of re-guessing them from scratch. Send me the link with a short name. Example:
      > entity-glossary: https://confluence.example.com/wiki/spaces/PROJ/entity-glossary

   f. **UI Behavior — Principles** — general UI behavior principles:
      > Does the project have a doc describing general UI behavior principles (e.g. how validation timing or page headers should generally work)? Send me the link with a short name. Example:
      > ui-principles: https://confluence.example.com/wiki/spaces/PROJ/ui-principles

   g. **UI Behavior — Shared References** — UI behavior groups reused across many screens:
      > Does the project have a doc defining shared UI behavior for common components (e.g. Table, Edit Form, Sidebar)? Send me the link with a short name. Example:
      > ui-rules: https://confluence.example.com/wiki/spaces/PROJ/ui-rules

   h. **Navigation** — shared navigation patterns and conventions:
      > Does the project have a doc describing shared navigation conventions (e.g. button naming, confirmation dialog rules, the app's page/dialog map)? Send me the link with a short name. Example:
      > navigation-patterns: https://confluence.example.com/wiki/spaces/PROJ/navigation-patterns

   i. **Flow** — shared flow patterns and conventions:
      > Does the project have a doc describing shared flow conventions (e.g. what a feature's default entry point is, when a rejection path becomes its own Alternate Flow)? Send me the link with a short name. Example:
      > flow-conventions: https://confluence.example.com/wiki/spaces/PROJ/flow-conventions

   j. **Messages** — shared message wording templates:
      > Does the project have a doc defining shared message wording conventions (e.g. standard phrasing for errors/success messages)? Send me the link with a short name. Example:
      > message-format: https://confluence.example.com/wiki/spaces/PROJ/message-format

   For each entry the user gives, derive the local file path as `project/context/<kebab-case-name>.md` for category (a), `project/reference/sample-doc/<kebab-case-name>.md` for category (b), or `project/reference/<category-subfolder>/<kebab-case-name>.md` for categories (c)-(j) — matching the subfolder already shown in the file's placeholder line for that category. Then add the entry under that category's heading in `## 2. Context Sync`, before asking about the next category:
   - For categories (a) **Context** and (b) **Sample Doc**, the user gives only links (one or more), not name/description pairs. For each link, fetch the Confluence page's content (using the Atlassian connector resolved in sub-question 1.b) and derive from it: a short kebab-case **name** (from the page title) and a one-sentence **description** of what it covers — for (a), what the document is about; for (b), which kind of feature the sample exemplifies (e.g. "a straightforward Create/Edit form" vs. "a multi-step approval workflow"), so a BA/QA can tell which sample to expect the closest style match from without opening every file. Write the derived name and description in the **document language** (the `### Language` value from sub-question 1.d) — not the language this chat happens to be conducted in, since these values end up inside `project_config.md` as reference material for whoever generates documents from it. Then show the user everything derived, across all links given in this answer, in one message (this confirmation message itself is still in the chat's interaction language, only the derived name/description content is in the document language) and ask them to confirm or correct any of it before adding anything:
     ```
     Here's what I found:
     - <name-1>: <derived description> (<url-1>)
     - <name-2>: <derived description> (<url-2>)
     Look right, or do you want to fix any of the names/descriptions?
     ```
     - **Confirmed as-is** → add each as three lines: `- <local-file-path>`, `  url: <url>`, `  desc: <description>`.
     - **User corrects one or more** → use their corrected name/description for those entries, keep the derived ones for the rest, then add all of them.
     - **A link fails to fetch** (page not accessible, bad URL, etc.) → don't block the others; report which link failed and ask the user to give its name and description manually instead, then add it with those.
   - For categories (c)-(j), each entry is a `<name>: <url>` pair as before — add it as `- <local-file-path>` / `  url: <url>` (no `desc:` line; the category heading itself already states the purpose).

   A category can end up with zero, one, or many entries.

3. **Task Environment** — no question asked; the code blocks under `## 3. Task Environment` (3.1 BA, 3.2 QA) stay at their skeleton defaults.

4. **Task Automation** — `project/project_config.md` is shared by both the BA Doc and QA Doc tools, but each tool's `/publish` runs on its own branch and only wants its own actions to fire. `## 4. Task Automation` is split into `### 4.1 BA` and `### 4.2 QA`, each with its own `#### Jira` and `#### Confluence` subsections, so each tool's `/publish` only ever reads its own half. `/publish` executes whatever action entries are listed under its section, so don't assume the project only wants a status change or a single publish action; ask broadly and capture whatever actions the project actually needs. Ask BA and QA separately (don't assume they want the same thing) and write each side's answer straight into its own section — if QA's answer is "same as BA", copy BA's action entry verbatim into the QA section rather than cross-referencing it, since each tool only ever reads its own half of the file:
   a. Jira actions for BA:
      > When a BA Doc feature is finished and published, how should its Jira BA Task ticket be handled? For example: change the ticket status to Done, or add a comment with the Confluence link.
      → Update the `#### Jira` subsection under `### 4.1 BA`: adjust the two example action entries (update status, add comment) to match, keep only the ones actually wanted, and add new action lines for anything else mentioned — following the `- <action description>\n  jira-project: <jira-project-key>` format. If nothing is wanted, leave the subsection empty.
   b. Confluence actions for BA:
      > Besides publishing the BA Doc itself, does anything else need to happen on Confluence when a BA Doc feature finishes publishing? For example: updating a shared reference page, or adding a comment.
      → Update the `#### Confluence` subsection under `### 4.1 BA` with one entry per distinct action (`- <action description>` plus any fields the action needs, following the same style as Jira entries). If nothing is wanted, leave the subsection empty.
   c. Jira actions for QA:
      > Same question for QA Doc — when a QA Doc feature is finished and published, how should its Jira QA Task ticket be handled?
      → Update the `#### Jira` subsection under `### 4.2 QA` the same way as sub-question (a).
   d. Confluence actions for QA:
      > Same question for QA Doc — besides publishing the QA Doc itself, does anything else need to happen on Confluence when a QA Doc feature finishes publishing?
      → Update the `#### Confluence` subsection under `### 4.2 QA` the same way as sub-question (b).

Throughout, when updating the file:
- Follow the exact structure and format already present (e.g. Context Sync entries stay in the `- <local-file-path>` / `  url: <confluence-page-url>` pair format).
- Do not alter guidance comments, headings, or overall structure — only replace placeholder values with real ones.

## After the last question

1. Confirm:
```
✓ Updated project/project_config.md

Filled in: <list each section/category that was updated>
Still placeholder (skipped): <list anything left unfilled, or "none">
```
2. Immediately continue into `/sync` — follow its full instructions from `.claude/commands/sync.md` right now, without waiting for the user to run it separately, so the newly-mapped Confluence pages get pulled into `project/` right away.
3. Once `/sync` succeeds, show the local path to the finished file so the user can share or copy it directly: `project/project_config.md` (the path relative to the repo root — never show the full absolute filesystem path).
4. Publishing the config to Confluence is mandatory, not optional — always ask for the page link, don't frame it as a yes/no offer:
   > `project/project_config.md` is ready. Send me the Confluence page link where I should publish it so the team can grab it from there.
   → Once given a link, publish `project/project_config.md`'s content to that page: check whether it already exists (`getConfluencePage`) — if it does, update it (`updateConfluencePage`); if not, create it (`createConfluencePage`) with the file's content as the page body. Confirm the page URL once done.
5. Report, as a plain message — not a fenced code block (nothing here needs to be copy-pasted verbatim) and not a numbered list (there's only ever this one item, so don't prefix it with "1."):
   > Next, team members can download the matching tool at https://github.com/congson99/DC32-AIFW-DocGenTool, point their project config file to this Confluence page: `<confluence-page-url just published>`, then run `/start <Feature Name>` to begin a feature.
