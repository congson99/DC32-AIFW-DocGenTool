# DC32 BA Documentation Claude Tool

v1.0

---

## Table of Contents

1. [Overview](#1-overview)
2. [BA Documentation Set](#2-ba-documentation-set)
3. [Quick Start](#3-quick-start)
4. [Setup Environment](#4-setup-environment-one-time-only)
5. [Available Commands](#5-available-commands)
6. [Folder Structure](#6-folder-structure)

---

## 1. Overview

**DC32 BA Documentation Claude Tool** is a tool built specifically for the **DC32 AI Framework**. It helps the BA generate a complete BA documentation set from existing project documents, refined through Q&A with the BA. Finally, it pushes the finished content to a Confluence page so the framework's next steps can proceed.

> The BA Documentation Set has a fixed structure, dedicated to the framework.

> Confluence is the only supported source for reading and writing documents, via an MCP connection.

---

## 2. BA Documentation Set

1. **Brief** — high-level summary of the feature, including its business goal, scope, and objectives.
2. **Dependencies** — prerequisite features, modules, external systems, or configurations required before implementing or using the feature.
3. **Acceptance Criteria (AC)** — business conditions that define when the feature is considered complete and acceptable.
4. **Business Rules** — business constraints, policies, and processing rules governing system behavior.
5. **Data Definition** — business entities, data fields, relationships, and field-level validation rules.
6. **Navigation** — user navigation paths between pages, dialogs, and screens throughout the feature.
7. **Flow** — end-to-end business workflow covering main, alternative, and exception scenarios.
8. **UI Behavior** — user interface behavior based on user actions, permissions, system states, and business rules.
9. **Messages** — validation, confirmation, warning, success, and error messages presented to users.

---

## 3. Quick Start

**BA generating docs for a project that's already configured**
1. See [Setup Environment](#4-setup-environment-one-time-only) to set up your environment.
2. Get `project/project_config.md` for this project — either check out `dev/project-config` in the same clone and run `/config` there yourself, or ask your team lead for the branch it was pushed to (e.g. `project/<name>`) and restore it: `git show project/<name>:project/project_config.md > project/project_config.md`.
3. Run `/sync` here to fetch `project/context/` and `project/reference/` from Confluence.
4. Run `/start <Feature Name>`, then follow the chat prompts to generate the BA documentation set.

> This branch does not include `/config` or `/connect-mcp` — those commands live on the `dev/project-config` branch, since setting up a project is a one-time, project-level task independent of generating docs for any particular feature. `/sync` exists on this branch too, so refreshing Confluence content doesn't require switching branches.

---

## 4. Setup Environment (one-time only)

### Step 1 — Install VS Code

Install [VS Code](https://code.visualstudio.com/), or any other IDE that supports the Claude Code extension (e.g. JetBrains IDEs).

### Step 2 — Clone the project's branch and open it in VS Code

Clone the branch corresponding to your project, then open the folder in VS Code:

1. Clone the branch: `git clone -b <branch-name> <repository-url>`
2. Open VS Code
3. Go to **File → Open Folder**
4. Select the cloned folder

### Step 3 — Install the Claude Code extension in VS Code

1. Go to **Extensions** (Ctrl+Shift+X / Cmd+Shift+X)
2. Search for **Claude Code**
3. Click **Install**
4. Click the **Claude** icon in the VS Code sidebar (or use the keyboard shortcut shown after install) to open the panel

### Step 4 — Get project_config.md

This branch has no `/config` command of its own, so `project_config.md` must first be configured on `dev/project-config`. In the same clone:

1. `git checkout dev/project-config`
2. Run `/config` (if not already done for this project) — this fills in `project/project_config.md`.
3. `git checkout dev/BA` (back to this branch) — `project/context/` and `project/reference/` are gitignored, so they carry over automatically.
4. Restore `project_config.md` here, since it's the one tracked file a plain branch switch would otherwise reset to this branch's own blank copy: `git show dev/project-config:project/project_config.md > project/project_config.md`.
5. Run `/sync` here any time you want to pull the latest `project/context/` and `project/reference/` content from Confluence — this branch has its own `/sync`, so no branch switch is needed for that.

> If someone else already configured and pushed `project_config.md` to a `project/<name>` branch, skip straight to step 4 using that branch name instead.

---

## 5. Available Commands

| Command | Purpose |
|---|---|
| `/start <Feature Name>` | Initialize feature folder, env file, and context file |
| `/investigate <Feature Name>` | Generate the Idea file from project context, asking the user for anything missing |
| `/gen-brief <Feature Name>` | Generate Brief from the Idea file |
| `/gen-dependencies <Feature Name>` | Generate Dependencies |
| `/gen-ac <Feature Name>` | Generate Acceptance Criteria |
| `/gen-business-rule <Feature Name>` | Generate Business Rules |
| `/gen-data-definition <Feature Name>` | Generate Data Definition |
| `/gen-navigation <Feature Name>` | Generate Navigation |
| `/gen-flow <Feature Name>` | Generate Flow |
| `/gen-ui-behavior <Feature Name>` | Generate UI Behavior |
| `/gen-messages <Feature Name>` | Generate Messages |
| `/gen-doc <Feature Name>` | Run gen-brief through gen-messages and package back-to-back |
| `/package <Feature Name>` | Package all artifacts into a single BA Doc |
| `/publish <Feature Name>` | Publish BA Doc to Confluence and update Jira status |
| `/check <Feature Name>` | Show doc status and suggest next step |
| `/clear-workspace` | Delete all feature folders in workspace/ |
| `/sync` | Fetch the latest content from Confluence into project/context/ and project/reference/ |

---

## 6. Folder Structure

```
AI-FW-Doc-Generation/
├── CLAUDE.md                              ← project instructions for Claude
├── .claude/
│   └── commands/                          ← slash command definitions (see Available Commands)
├── framework/                             ← reusable rules and styles, domain-agnostic
│   ├── rules/                             ← writing/content rules, one file per doc type
│   └── styles/                            ← format rules, one file per doc type + style_general.md
├── project/                               ← project-level context
│   ├── project_config.md                  ← project config (tracked — committed unconfigured; configure via /config on dev/project-config, then restore it here)
│   ├── context/                           ← domain overview, modules, user stories (not committed)
│   └── reference/                         ← spec sheets, Confluence exports (not committed)
│       ├── business-rules/                ← principles + shared references for Business Rules
│       ├── navigation/                    ← shared navigation patterns
│       ├── ui-behavior/                   ← principles + shared references for UI Behavior
│       └── messages/                      ← shared message templates and wording conventions
└── workspace/                             ← per-feature working area (not committed)
    └── <feature-name>/
        ├── input/                         ← env_<slug>.md, context_<slug>.md, idea_<slug>.md
        ├── docs/                          ← generated BA doc sections (Brief through Messages)
        └── ba_doc_<slug>.md               ← final packaged document
```
