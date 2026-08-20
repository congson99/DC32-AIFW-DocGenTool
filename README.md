# DC32 BA Documentation Claude Tool

v1.0

---

## Table of Contents

1. [Overview](#1-overview)
2. [BA Documentation Set](#2-ba-documentation-set)
3. [Quick Start](#3-quick-start)
4. [Setup Environment](#4-setup-environment)
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
1. See [Setup Environment](#4-setup-environment) to set up your environment.
2. Run `/sync <confluence-page-url>` here, using the Confluence link for this project's `project_config.md` — it pulls the file down and fetches `project/context/`/`project/reference/` from Confluence in one go.
3. Run `/start <Feature Name>`, then follow the chat prompts to generate the BA documentation set.

> If your project doesn't have a `project_config.md` yet, go to https://github.com/congson99/DC32-AIFW-DocGenTool, find the branch for the Project Configuration Tool version you need, and clone it to create one for your project.

---

## 4. Setup Environment

1. **Install VS Code** — install [VS Code](https://code.visualstudio.com/), or any other IDE that supports the Claude Code extension (e.g. JetBrains IDEs).
2. **Clone this branch and open it in VS Code**
   - Go to https://github.com/congson99/DC32-AIFW-DocGenTool, find the branch for the **BA Documentation Tool** version you need, and clone it.
   - Open VS Code
   - Go to **File → Open Folder**
   - Select the cloned folder
3. **Install the Claude Code extension in VS Code**
   - Go to **Extensions** (Ctrl+Shift+X / Cmd+Shift+X)
   - Search for **Claude Code**
   - Click **Install**
   - Click the **Claude** icon in the VS Code sidebar (or use the keyboard shortcut shown after install) to open the panel

---

## 5. Available Commands

### Main flow (per feature)

Run in this order to produce a complete BA Doc for one feature.

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
| `/gen-doc <Feature Name>` | Shortcut: run gen-brief through gen-messages, package, and review back-to-back, without pausing for review between steps |
| `/package <Feature Name>` | Package all nine sections (Brief through Messages) into a single BA Doc |
| `/review <Feature Name>` | Review the packaged BA Doc for unclear points, AC/Business Rule quality, completeness, and cross-document consistency — shown in chat, with every finding resolved before publishing |
| `/publish <Feature Name>` | Publish BA Doc to Confluence and update Jira status |

### Flow helper

Not a generation step itself — call it any time during the flow above to see where a feature stands.

| Command | Purpose |
|---|---|
| `/check <Feature Name>` | Show which BA documents have been generated for a feature and suggest the next step |

### Not in the flow — project setup & maintenance

Operate on the whole project rather than a single feature. Run as needed, independent of where any feature is in the flow above.

| Command | Purpose |
|---|---|
| `/sync [project-config-confluence-url]` | Fetch the latest content from Confluence into project/context/ and project/reference/ based on project/project_config.md — optionally pass the Confluence URL project_config.md was published to, to pull/refresh it first |
| `/connect-mcp` | Connect to the MCP servers (Atlassian, Figma) listed in project/project_config.md |
| `/connect-local-mcp` | Set up a project-scoped Atlassian MCP server (separate from the global one), for one or more Jira/Confluence instances |
| `/check-mcp` | Show every MCP connection currently available in this session and what it's connected to |
| `/clear-workspace` | Delete all feature folders in workspace/ |
| `/reset` | Delete all synced context/reference files, reset project_config.md to its unconfigured state, and clear all feature folders in workspace/ |

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
│   ├── project_config.md                  ← project config (not committed; configure via /config on dev/config, or pull it with /sync — see Quick Start above)
│   ├── status.md                          ← local bookkeeping: last /sync (not committed, not shared)
│   ├── context/                           ← domain overview, modules, user stories (not committed)
│   └── reference/                         ← spec sheets, Confluence exports (not committed)
│       ├── business-rules/
│       │   ├── principles/                ← general principles for writing Business Rules
│       │   └── shared-references/         ← rule groups reused across many features
│       ├── data-definition/
│       │   └── shared-references/         ← field definitions (name, type, description) for entities reused across many features, e.g. Warehouse, Supplier
│       ├── navigation/                    ← shared navigation patterns
│       ├── ui-behavior/
│       │   ├── principles/                ← general UI behavior principles
│       │   └── shared-references/         ← UI behavior groups reused across many screens
│       ├── messages/                      ← shared message templates and wording conventions
│       ├── flow/                          ← shared flow patterns and conventions
│       └── sample-doc/                    ← one or more complete example BA Docs, used by every gen-* command as a style/tone/detail-level reference for its own section
└── workspace/                             ← per-feature working area (not committed)
    └── <feature-name>/
        ├── input/                         ← env_<slug>.md, context_<slug>.md, idea_<slug>.md
        ├── docs/                          ← generated BA doc sections (Brief through Messages)
        └── ba_doc_<slug>.md               ← final packaged document
```
