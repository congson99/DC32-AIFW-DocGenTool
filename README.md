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
2. Get `project/project_config.md` for this project — either check out `dev/config` in the same clone and run `/config` there yourself, or skip straight to step 3 and run `/sync <confluence-page-url>` here, using the page your team lead shares (the one `/config` published it to) — it pulls the file down automatically.
3. Run `/sync` here (skip if you already ran it with a URL in step 2) to fetch `project/context/` and `project/reference/` from Confluence.
4. Run `/start <Feature Name>`, then follow the chat prompts to generate the BA documentation set.

> This branch does not include `/config` — that command lives on the `dev/config` branch, since setting up a project is a one-time, project-level task independent of generating docs for any particular feature. `/reset`, `/sync`, `/connect-mcp`, `/connect-local-mcp`, and `/check-mcp` all exist on this branch too, so starting a new project, refreshing Confluence content, reconnecting an MCP server, setting up a dedicated per-site Atlassian connection, or checking what's currently connected doesn't require switching branches.

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

This branch has no `/config` command of its own, so `project_config.md` must first be configured on `dev/config`. `project/` is entirely gitignored on every branch, so the file is never tracked by git — it only carries over between branches in the same clone. In the same clone:

1. `git checkout dev/config`
2. Run `/config` (if not already done for this project) — this fills in `project/project_config.md`.
3. `git checkout dev/BA` (back to this branch) — `project/project_config.md`, `project/context/`, and `project/reference/` all carry over automatically since none of them are tracked.
4. Run `/sync` here any time you want to pull the latest `project/context/` and `project/reference/` content from Confluence, `/connect-mcp` to (re)connect the Atlassian/Figma MCP servers, `/connect-local-mcp` to set up a dedicated per-site Atlassian connection, or `/check-mcp` to see what's currently connected — this branch has its own copies of all four, so no branch switch is needed.

> If you're on a different clone/machine, there's no branch to pull `project_config.md` from — run `/sync <confluence-page-url>` here instead, using the page your team lead shares (the one `/config` published it to). It pulls `project_config.md` down automatically before syncing, skipping straight past steps 1-3 above.

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
| `/reset` | Delete all synced context/reference files, reset project_config.md to its unconfigured state, and clear all feature folders in workspace/ |
| `/sync [confluence-url]` | Fetch the latest content from Confluence into project/context/ and project/reference/ — pass the Confluence URL project_config.md was published to, to pull it down first if it's missing here |
| `/connect-mcp` | Connect to the MCP servers (Atlassian, Figma) listed in project/project_config.md |
| `/connect-local-mcp` | Set up a project-scoped Atlassian MCP server (separate from the global one), for one or more Jira/Confluence instances |
| `/check-mcp` | Show every MCP connection currently available in this session and what it's connected to |

---

## 6. Folder Structure

```
DC32-AIFW-DocGenTool/
├── CLAUDE.md                              ← project instructions for Claude
├── .claude/
│   └── commands/                          ← slash command definitions (see Available Commands)
├── framework/                             ← reusable rules and styles, domain-agnostic
│   ├── framework_config.md                ← edit_framework setting (do not modify)
│   ├── rules/                             ← writing/content rules, one file per doc type
│   └── styles/                            ← format rules, one file per doc type + style_general.md
├── project/                               ← project-level context
│   ├── project_config.md                  ← project config (not committed; configure via /config on dev/config — see Step 4 above)
│   ├── status.md                          ← local bookkeeping: last /sync (not committed, not shared)
│   ├── context/                           ← domain overview, modules, user stories (not committed)
│   └── reference/                         ← spec sheets, Confluence exports (not committed)
│       ├── business-rules/
│       │   ├── principles/                ← general principles for writing Business Rules
│       │   └── shared-references/         ← rule groups reused across many features
│       ├── navigation/                    ← shared navigation patterns
│       ├── ui-behavior/
│       │   ├── principles/                ← general UI behavior principles
│       │   └── shared-references/         ← UI behavior groups reused across many screens
│       ├── messages/                      ← shared message templates and wording conventions
│       └── flow/                          ← shared flow patterns and conventions (see note below)
└── workspace/                             ← per-feature working area (not committed)
    └── <feature-name>/
        ├── input/                         ← env_<slug>.md, context_<slug>.md, idea_<slug>.md
        ├── docs/                          ← generated BA doc sections (Brief through Messages)
        └── ba_doc_<slug>.md               ← final packaged document
```

> `gen-flow` reads `project/reference/flow/` if present, but `/config` on `dev/config` has no matching Context Sync category yet, so this folder currently has no supported way to get populated.
