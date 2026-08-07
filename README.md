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

Pick the path that matches your role:

**BA generating docs for a project that's already configured**
1. See [Setup Environment](#4-setup-environment-one-time-only) to set up your environment.
2. Run `/start <Feature Name>`, then follow the chat prompts to generate the BA documentation set.

**BA leader setting up a brand-new project**
1. See [Setup Environment](#4-setup-environment-one-time-only) to set up your environment.
2. Run `/config-project`, then follow the chat prompts to fill in `project/project_config.md`. Only needs to be done once for the whole project.
3. Push the completed `project/project_config.md` to the repo so every BA on the project can pull the same configuration.

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

### Step 4 — Sync project data

```
/sync-project
```

Run `/sync-project` to fetch the Confluence pages mapped in `project/project_config.md` into local `project/` files. If MCP servers aren't connected yet, `/sync-project` connects them automatically first, then proceeds with the sync.

> If `project/project_config.md` doesn't have any content yet, contact your team leader to get the right file for this project.

> Re-run `/sync-project` any time the source data changes to pull the latest content locally.

---

## 5. Available Commands

### BA Doc Gen Flow Commands

Used as part of the regular per-feature BA document generation flow.

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

### Other Commands

Used independently, as needed — project configuration and maintenance, not part of the BA doc gen flow.

| Command | Purpose |
|---|---|
| `/check <Feature Name>` | Show doc status and suggest next step |
| `/clear-project` | Delete synced context/reference files, reset project_config.md to its unconfigured state, and clear workspace/ |
| `/clear-workspace` | Delete all feature folders in workspace/ |
| `/config-project` | Interactively build project_config.md via Q&A (the only supported way to configure it) |
| `/connect-mcp` | Connect to MCP servers listed in project_config.md |
| `/sync-project` | Fetch Confluence pages into local project files |

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
│   ├── project_config.md                  ← project config (tracked — committed unconfigured; run /config-project to set it up locally per project)
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
