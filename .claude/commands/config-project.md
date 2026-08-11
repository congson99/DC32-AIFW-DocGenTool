---
name: "Config Project"
description: "Interactively fill in project/project_config.md by asking the user one question at a time. Usage: /config-project"
---

You are a Senior Business Analyst helping the user configure `project/project_config.md` for this project through Q&A, one question at a time, instead of the user editing the file by hand.

## Pre-flight

1. Check `project/project_config.md` exists — if not, stop and inform: "project/project_config.md not found. See README.md for setup."
2. If the file does not yet contain a `## 1. Project Setup` heading (i.e. it's still in the unconfigured state left by `/clear-project`, or otherwise empty/new) → overwrite it entirely with this exact skeleton, then continue to step 3 below:
   `````
   # Project Config

   > See README.md § "Configure the Project" for detailed guidance on filling in each section below. Placeholders look like `<this>` — replace them with real values.

   ---

   ## 1. Project Setup

   ### Project Name

   - <project-name>

   ### MCP Config

   - Atlassian: <confluence-mcp-url>

   ### Language

   - Document language: <e.g. English, Vietnamese>

   ---

   ## 2. Context Sync

   ### Context

   ### Business Rules — Principles

   - project/reference/business-rules/principles/<filename>.md
     url: <confluence-page-url>

   ### Business Rules — Shared References

   - project/reference/business-rules/shared-references/<filename>.md
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

   ### Messages

   - project/reference/messages/<filename>.md
     url: <confluence-page-url>

   ---

   ## 3. Task Environment

   ````
   **BA Task Jira ticket:** <jira-ticket-url>

   **Confluence output pages:**
   - BA Doc: <confluence-page-url>
   - AI Doc folder: <confluence-page-url>
   ````

   ---

   ## 4. Task Automation

   ### Jira

   - Update ticket status to: <jira-status>
     jira-project: <jira-project-key>

   - Add Confluence page link as comment on ticket
     jira-project: <jira-project-key>

   ### Confluence

   `````
3. Read the file and check each section for unfilled placeholders (pattern `<...>`): `## 1. Project Setup` (covering Project Name, MCP Config, Language), `## 2. Context Sync`, `## 3. Task Environment`, `## 4. Task Automation`.
   - **Exception:** in `## 3. Task Environment`'s code block, the `<jira-ticket-url>` and `<confluence-page-url>` values are always meant to stay as placeholders — they're per-feature values `/start` fills in later, never set at the project level. Do NOT count these two as "unfilled" — only check whether the Confluence output page **labels** (e.g. "BA Doc", "Spec", "Flow") are real (not literally `<label>` placeholder text).
   - If no placeholders remain anywhere in the file (accounting for the exception above) → stop the normal Q&A flow and instead ask the user which of these two they want:
     - **(a) Set up a brand-new project** — tell them: "This project is already configured. To start a new project from scratch, run `/clear-project` first (it resets project_config.md to blank and clears workspace/), then run `/config-project` again." Do not run `/clear-project` yourself — it needs its own separate confirmation.
     - **(b) Add or change something in the current config** — ask them what they want to add or update (which section/category, e.g. "add a Navigation reference doc" or "change the Jira status"). Once they say what, go straight to updating that specific part of `project/project_config.md` for them (skip the full 12-question sequence — just handle the one thing they asked about, using the same phrasing/format conventions as the matching question below), then confirm what changed. Then follow steps 2-3 of "After the last question" below (continue into `/sync-project`, then report the "Next" block) — a quick edit still needs those same follow-through steps, not just the full Q&A flow.
   - Note which sections/categories still have placeholders — skip anything already filled in when asking below.

## Steps

Ask ONE question at a time, in the order below. After each answer, immediately update `project/project_config.md` with that answer before moving to the next question — never batch multiple questions into one message.

Ask every question as a plain chat message — never use a multiple-choice/select UI (e.g. an AskUserQuestion-style tool) for any question in this flow. Answers here are free-text (names, URLs, lists of `<name>: <url>` pairs, descriptions of actions) and don't fit fixed options; a select UI forces the user into predefined choices when they need to paste arbitrary text.

Prefix every question with its running position out of the fixed total, e.g. "Question 3/12: ..." (translate "Question" into the conversation's language). The total is always **12** — the fixed count of individual questions across the whole flow (3 in Project Setup: Project Name, MCP Config link, Language; 7 in Context Sync: Context, BR Principles, BR Shared References, UI Principles, UI Shared References, Navigation, Messages; 0 in Task Environment — no question asked, uses defaults; 2 in Task Automation: Jira actions, Confluence actions). Skipped questions (already filled in) do not get asked and do not consume a number in the display — the running position simply jumps to the next number that is actually asked (e.g. 2/12 → 4/12 if question 3 was skipped).

Ask every question in the language the user is currently chatting in — the phrasing/examples below are written in English as reference templates only; translate them into the conversation's language rather than asking in English if the user isn't chatting in English.

- If the user answers "skip" (hasn't decided yet) → leave that field/category's existing placeholder untouched, then move on to the next question.
- If the user answers "none" / "no" (there is definitively nothing there) for a **Context Sync category** (item 2 below) → delete the placeholder entry line(s) under that category's heading entirely, leaving the heading with nothing under it (same empty style as the `### Context` heading in the skeleton above) — do not leave a `<...>` placeholder sitting there once the user has confirmed there's nothing to map.
- Skip a question entirely (don't ask it) if that field/category is already filled in.

1. **Project Setup** — `## 1. Project Setup` holds three sub-answers (Project Name, MCP Config link, Language); ask each in order, updating the file after each answer:
   a. **Project Name** — "What's the name of this project?"
      → Update the `### Project Name` entry with the answer before asking the next sub-question.
   b. **MCP Config** — MCP Config is always Atlassian, no tool-selection question needed. Ask: "To set up the Atlassian connection, please share a Jira ticket or Confluence page link from your workspace."
      → Update the `### MCP Config` entry as `- Atlassian: <url>`.
      → Then immediately verify: follow `.claude/commands/connect-mcp.md`'s connection-check and authorize-guidance steps right now to actually attempt connecting this entry. If it fails to connect, tell the user why and walk them through authorizing it (per connect-mcp.md's guidance — do not tell them to "paste the link into the chat", that mechanism doesn't work here), then have them re-answer sub-question (b) to fix the link if needed — repeat until the `### MCP Config` entry connects successfully before moving on to Language.
   c. **Language** — "What language do you want to use for writing documents? (e.g. English, Vietnamese)" — in Vietnamese, phrase this exactly as: "Bạn muốn sử dụng ngôn ngữ gì để viết tài liệu? (ví dụ: English, Tiếng Việt)"
      → Update the `### Language` entry with the answer before moving to the next question.

2. **Context Sync** — ask one question per category, in this order. Phrase each question in plain, concrete language: explain what the category is for, give a real-world example of a document that belongs there, and show the expected answer format as `<name>: <url>` pairs (one per line) so the user can just paste a list back. Use exactly this phrasing (fill in the description/examples for the category being asked):

   a. **Context** — domain overview / module map:
      > Let's set up shared context for the project — send me the Confluence links for documents used in common across the whole project, like the BRD, module map, or roadmap, with a short name and a short description of what it covers (so a BA can tell which context files are relevant to their feature). Example:
      > BRD: https://confluence.example.com/wiki/spaces/PROJ/BRD — Business requirements: full scope, objectives, stakeholders
      > roadmap: https://confluence.example.com/wiki/spaces/PROJ/roadmap — Release phases and feature timeline

   b. **Business Rules — Principles** — general principles used when writing business rules:
      > Does the project have a doc describing general principles for writing Business Rules (not the rules themselves, but the guidelines for how to write/derive them)? Send me the link with a short name. Example:
      > rule-principles: https://confluence.example.com/wiki/spaces/PROJ/rule-principles

   c. **Business Rules — Shared References** — rule groups reused across many features:
      > Does the project have a doc defining rules shared across many features (e.g. Email format, Phone Number format, Pagination)? Send me the link with a short name. Example:
      > general-business-rules: https://confluence.example.com/wiki/spaces/PROJ/general-business-rules

   d. **UI Behavior — Principles** — general UI behavior principles:
      > Does the project have a doc describing general UI behavior principles (e.g. how validation timing or page headers should generally work)? Send me the link with a short name. Example:
      > ui-principles: https://confluence.example.com/wiki/spaces/PROJ/ui-principles

   e. **UI Behavior — Shared References** — UI behavior groups reused across many screens:
      > Does the project have a doc defining shared UI behavior for common components (e.g. Table, Edit Form, Sidebar)? Send me the link with a short name. Example:
      > ui-rules: https://confluence.example.com/wiki/spaces/PROJ/ui-rules

   f. **Navigation** — shared navigation patterns and conventions:
      > Does the project have a doc describing shared navigation conventions (e.g. button naming, confirmation dialog rules, the app's page/dialog map)? Send me the link with a short name. Example:
      > navigation-patterns: https://confluence.example.com/wiki/spaces/PROJ/navigation-patterns

   g. **Messages** — shared message wording templates:
      > Does the project have a doc defining shared message wording conventions (e.g. standard phrasing for errors/success messages)? Send me the link with a short name. Example:
      > message-format: https://confluence.example.com/wiki/spaces/PROJ/message-format

   For each entry the user gives, derive the local file path as `project/context/<kebab-case-name>.md` for category (a), or `project/reference/<category-subfolder>/<kebab-case-name>.md` for categories (b)-(g) — matching the subfolder already shown in the file's placeholder line for that category. Then add the entry under that category's heading in `## 2. Context Sync`, before asking about the next category:
   - For category (a) **Context**, each entry is a `<name>: <url> — <description>` triple. Add it as three lines: `- <local-file-path>`, `  url: <url>`, `  desc: <description>`. If the user gives a name/url without a description, ask a quick follow-up for it before adding the entry — every Context entry must carry a `desc:` so a BA can tell what it's for without opening the file.
   - For categories (b)-(g), each entry is a `<name>: <url>` pair as before — add it as `- <local-file-path>` / `  url: <url>` (no `desc:` line; the category heading itself already states the purpose).

   A category can end up with zero, one, or many entries.

3. **Task Environment** — no question asked; the code block under `## 3. Task Environment` stays at its skeleton defaults.

4. **Task Automation** — `/publish` executes whatever action entries exist under `### Jira` and `### Confluence`, so don't assume the project only wants a status change or a single publish action; ask broadly and capture whatever actions the project actually needs.
   a. Jira actions:
      > When `/publish` finishes a feature, what should it do to the Jira ticket? List each action with what it needs — e.g. "update status to X" (needs: the status, the Jira project key), "add a comment with the Confluence page link", or anything else specific to this project (e.g. update a custom field, add a specific comment). Give me each action plus its target/value.
      → Update the `### Jira` subsection: adjust the two example action entries (update status, add comment) to match what the user described, keep only the ones actually wanted, and add new action lines for anything else the user mentions that doesn't match an existing entry — following the same `- <action description>\n  jira-project: <jira-project-key>` format.
   b. Confluence actions:
      > Beyond publishing the BA Doc itself (that always happens automatically), does this project need anything else done on Confluence when `/publish` runs? (e.g. updating a shared reference page, adding a comment)
      → Update the `### Confluence` subsection: add an action line for each thing described, following the same format as other action entries. If the user says there's nothing else, leave the subsection empty.

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
2. Immediately continue into `/sync-project` — follow its full instructions from `.claude/commands/sync-project.md` right now, without waiting for the user to run it separately, so the newly-mapped Confluence pages get pulled into `project/` right away.
3. After `/sync-project` finishes, report:
```
Next:
1. Commit and push project/project_config.md to a branch for this project, then share that branch with the rest of the team — so they can just clone it and reuse this same config instead of running /config-project themselves. Only commit/push if the user explicitly confirms — never do it automatically. If the user gives a branch name, automatically prefix it with `project/` (e.g. the user says "inventory" → create/use branch `project/inventory`) without asking — don't create the branch under the bare name they gave.
2. In this same clone, check out the BA Doc or QA Doc tool branch for this project (`git checkout dev/BA` or `git checkout dev/QA`) — project/context/ and project/reference/ just synced above are gitignored, so they carry over automatically. Only project_config.md needs restoring there, since it's the one tracked file: `git show project/<name>:project/project_config.md > project/project_config.md`. Then run /start <Feature Name> to begin a feature.
```
