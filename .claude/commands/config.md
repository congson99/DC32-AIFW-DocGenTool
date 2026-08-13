---
name: "Config"
description: "Interactively fill in project/project_config.md by asking the user one question at a time. Usage: /config"
---

You are helping the user configure `project/project_config.md` for this project through Q&A, one question at a time, instead of the user editing the file by hand. This config is shared by both the BA Doc and QA Doc generation tools (on their own branches) — fill it in once here for the whole project.

## Interaction Language

Before anything else (before Pre-flight), ask the user which language to interact in for this session, using an AskUserQuestion-style select box with options "English" and "Tiếng Việt" (a free-text "Other" option is offered automatically). This is the one exception to "never use a select UI" below — it's a one-off preference pick, not one of the 16 counted questions, and doesn't get a running-position prefix.

Use the chosen language for every message, question, and confirmation for the rest of the session — translate the English templates in this file into it rather than inferring the interaction language from what the user types.

## Pre-flight

1. Check `project/project_config.md` exists — if not, stop and inform: "project/project_config.md not found. See README.md for setup."
2. If the file does not yet contain a `## 1. Project Setup` heading (i.e. it's still in the unconfigured state left by `/reset`, or otherwise empty/new) → overwrite it entirely with this exact skeleton, then continue to step 3 below:
   `````
   # Project Config

   ---

   ## 1. Project Setup

   ### Project Name

   - <project-name>

   ### MCP Config

   - Atlassian: <confluence-mcp-url>
   - Figma: <figma-url>

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

   ### Test Scenarios — Principles

   - project/reference/test-scenarios/principles/<filename>.md
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
     - **(b) Add or change something in the current config** — ask them what they want to add or update (which section/category, e.g. "add a shared reference doc" or "change the Jira status"). Once they say what, go straight to updating that specific part of `project/project_config.md` for them (skip the full 16-question sequence — just handle the one thing they asked about, using the same phrasing/format conventions as the matching question below), then confirm what changed. Then follow steps 2-5 of "After the last question" below (continue into `/sync`, show the local file path, then report the "Next" block) — a quick edit still needs those same follow-through steps, not just the full Q&A flow.
   - Note which sections/categories still have placeholders — skip anything already filled in when asking below.

## Steps

Ask ONE question at a time, in the order below. After each answer, immediately update `project/project_config.md` with that answer before moving to the next question — never batch multiple questions into one message.

Ask every question as a plain chat message — never use a multiple-choice/select UI (e.g. an AskUserQuestion-style tool) for any question in this flow. Answers here are free-text (names, URLs, lists of `<name>: <url>` pairs, descriptions of actions) and don't fit fixed options; a select UI forces the user into predefined choices when they need to paste arbitrary text.

Prefix every question with its running position out of the fixed total, e.g. "Question 3/16: ..." (translate "Question" into the conversation's language). The total is always **16** — the fixed count of individual questions across the whole flow (4 in Project Setup: Project Name, MCP Config — Atlassian, MCP Config — Figma, Language; 8 in Context Sync: Context, Business Rules Principles, Business Rules Shared References, UI Behavior Principles, UI Behavior Shared References, Navigation, Messages, Test Scenarios Principles; 0 in Task Environment — no question asked, uses defaults; 4 in Task Automation: Jira actions for BA, Confluence actions for BA, Jira actions for QA, Confluence actions for QA). MCP Config — Figma is optional but still asked and still consumes a number (an answer of "skip" is a valid, counted answer) — it is not skipped in the display the way an already-filled-in field would be. Skipped questions (already filled in) do not get asked and do not consume a number in the display — the running position simply jumps to the next number that is actually asked (e.g. 2/16 → 4/16 if question 3 was skipped).

Ask every question in the language chosen in "Interaction Language" above — the phrasing/examples below are written in English as reference templates only; translate them into that language rather than asking in English.

- If the user answers "skip" (hasn't decided yet) → leave that field/category's existing placeholder untouched, then move on to the next question.
- If the user answers "none" / "no" (there is definitively nothing there) for a **Context Sync category** (item 2 below) → delete the placeholder entry line(s) under that category's heading entirely, leaving the heading with nothing under it (same empty style as the `### Context` heading in the skeleton above) — do not leave a `<...>` placeholder sitting there once the user has confirmed there's nothing to map.
- Skip a question entirely (don't ask it) if that field/category is already filled in.

1. **Project Setup** — `## 1. Project Setup` holds four sub-answers (Project Name, MCP Config — Atlassian, MCP Config — Figma, Language); ask each in order, updating the file after each answer:
   a. **Project Name** — "What's the name of this project?"
      → Update the `### Project Name` entry with the answer before asking the next sub-question.
   b. **MCP Config — Atlassian** — mandatory. Ask: "To set up the Atlassian connection, please share a Jira ticket or Confluence page link from your workspace."
      → Update the `### MCP Config` entry as `- Atlassian: <url>`.
      → Then verify immediately: follow `.claude/commands/connect-mcp.md`'s connection-check/authorize steps for this entry, having the user re-answer sub-question (b) with a corrected link if it fails — repeat until it connects successfully before moving on.
   c. **MCP Config — Figma** — optional. Ask: "Does this project use Figma for UI designs? If so, share a Figma file or project link (or say 'skip' if not used)."
      → If the user gives a link: add a new line `- Figma: <url>` under `### MCP Config` (below the Atlassian line), then verify it the same way as sub-question (b) until it connects.
      → If the user says "skip"/"no"/there is no Figma: do not add a Figma line at all — `### MCP Config` keeps only the Atlassian entry, with no placeholder left behind.
   d. **Language** — "What language do you want to use for writing documents? (e.g. English, Vietnamese)" — in Vietnamese, phrase this exactly as: "Bạn muốn sử dụng ngôn ngữ gì để viết tài liệu? (ví dụ: English, Tiếng Việt)"
      → Update the `### Language` entry with the answer before moving to the next question.

2. **Context Sync** — ask one question per category, in this order. Phrase each question in plain, concrete language: explain what the category is for, give a real-world example of a document that belongs there, and show the expected answer format as `<name>: <url>` pairs (one per line) so the user can just paste a list back. Use exactly this phrasing (fill in the description/examples for the category being asked):

   a. **Context** — domain overview / module map:
      > Let's set up shared context for the project — send me the Confluence links for documents used in common across the whole project, like the BRD, module map, or roadmap, with a short name and a short description of what it covers (so a BA/QA can tell which context files are relevant to their feature). Example:
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

   h. **Test Scenarios — Principles** — general principles used when designing test scenarios:
      > Does the project have a doc describing general principles for writing Test Scenarios (not the scenarios themselves, but the guidelines for how to derive/group them)? Send me the link with a short name. Example:
      > scenario-principles: https://confluence.example.com/wiki/spaces/PROJ/scenario-principles

   For each entry the user gives, derive the local file path as `project/context/<kebab-case-name>.md` for category (a), or `project/reference/<category-subfolder>/<kebab-case-name>.md` for categories (b)-(h) — matching the subfolder already shown in the file's placeholder line for that category. Then add the entry under that category's heading in `## 2. Context Sync`, before asking about the next category:
   - For category (a) **Context**, each entry is a `<name>: <url> — <description>` triple. Add it as three lines: `- <local-file-path>`, `  url: <url>`, `  desc: <description>`. If the user gives a name/url without a description, ask a quick follow-up for it before adding the entry — every Context entry must carry a `desc:` so a BA/QA can tell what it's for without opening the file.
   - For categories (b)-(h), each entry is a `<name>: <url>` pair as before — add it as `- <local-file-path>` / `  url: <url>` (no `desc:` line; the category heading itself already states the purpose).

   A category can end up with zero, one, or many entries.

3. **Task Environment** — no question asked; the code blocks under `## 3. Task Environment` (3.1 BA, 3.2 QA) stay at their skeleton defaults.

4. **Task Automation** — `project/project_config.md` is shared by both the BA Doc and QA Doc tools, but each tool's `/publish` runs on its own branch and only wants its own actions to fire. `## 4. Task Automation` is split into `### 4.1 BA` and `### 4.2 QA`, each with its own `#### Jira` and `#### Confluence` subsections, so each tool's `/publish` only ever reads its own half. `/publish` executes whatever action entries are listed under its section, so don't assume the project only wants a status change or a single publish action; ask broadly and capture whatever actions the project actually needs. Ask BA and QA separately (don't assume they want the same thing) and write each side's answer straight into its own section — if QA's answer is "same as BA", copy BA's action entry verbatim into the QA section rather than cross-referencing it, since each tool only ever reads its own half of the file:
   a. Jira actions for BA:
      > When a BA Doc feature finishes publishing, how should the Jira ticket be updated? For example: change the ticket status to something, or add a comment with the Confluence link.
      → Update the `#### Jira` subsection under `### 4.1 BA`: adjust the two example action entries (update status, add comment) to match, keep only the ones actually wanted, and add new action lines for anything else mentioned — following the `- <action description>\n  jira-project: <jira-project-key>` format. If nothing is wanted, leave the subsection empty.
   b. Confluence actions for BA:
      > Besides publishing the BA Doc itself, does anything else need to happen on Confluence when a BA Doc feature finishes publishing? For example: updating a shared reference page, or adding a comment.
      → Update the `#### Confluence` subsection under `### 4.1 BA` with one entry per distinct action (`- <action description>` plus any fields the action needs, following the same style as Jira entries). If nothing is wanted, leave the subsection empty.
   c. Jira actions for QA:
      > Same question for QA Doc — when a QA Doc feature finishes publishing, how should the Jira ticket be updated?
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
3. Once `/sync` succeeds, show the local path to the finished file so the user can share or copy it directly: `<absolute-path-to-project>/project/project_config.md`.
4. Ask how they'd like to share the finished config with the team:
   > `project/project_config.md` is ready at `<absolute-path>`. Want me to also publish it to a Confluence page so the team can grab it from there?
   - **If given a link** → publish `project/project_config.md`'s content to that page: check whether it already exists (`getConfluencePage`) — if it does, update it (`updateConfluencePage`); if not, create it (`createConfluencePage`) with the file's content as the page body. Confirm the page URL once done.
   - **If declined** → nothing more to do here.
5. Report:
```
Next:
1. Share project/project_config.md with the team — copy the file at <absolute-path>, or the Confluence page just published (if any).
2. Team members: check out the BA Doc or QA Doc tool branch (`git checkout dev/BA` or `git checkout dev/QA`) and save the shared config as project/project_config.md there — it's the one tracked file a plain branch switch resets. Then run /start <Feature Name> to begin a feature.
```
