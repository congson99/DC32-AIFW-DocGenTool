# DC32 Project Config Claude Tool

v1.0

---

## Table of Contents

1. [Overview](#1-overview)
2. [Quick Start](#2-quick-start)
3. [Setup Environment](#3-setup-environment-one-time-only)
4. [Available Commands](#4-available-commands)
5. [Handoff to the Documentation Tools](#5-handoff-to-the-documentation-tools)
6. [Folder Structure](#6-folder-structure)

---

## 1. Overview

**DC32 Project Config Claude Tool** is a tool built specifically for the **DC32 AI Framework**. It's used once per project to configure `project/project_config.md` and sync its mapped Confluence content locally, before either the BA or QA documentation generation tools are used.

> This tool does not generate BA or QA documents itself — see [Handoff to the Documentation Tools](#5-handoff-to-the-documentation-tools).

> Confluence is the primary source for reading and writing documents, via an MCP connection. Figma (optional) can also be connected to supply UI references for the QA tool's Test Cases.

---

## 2. Quick Start

**Team leader setting up a brand-new project**
1. See [Setup Environment](#3-setup-environment-one-time-only) to set up your environment.
2. Run `/config-project`, then follow the chat prompts to fill in `project/project_config.md`. Only needs to be done once for the whole project.
3. Run `/sync-project` to pull the mapped Confluence content into local `project/context/` and `project/reference/` files.
4. Push the completed `project/project_config.md` to a branch for this project (e.g. `project/<name>`) so the BA/QA doc-gen tools can pull the same configuration instead of running `/config-project` themselves.

---

## 3. Setup Environment (one-time only)

### Step 1 — Install VS Code

Install [VS Code](https://code.visualstudio.com/), or any other IDE that supports the Claude Code extension (e.g. JetBrains IDEs).

### Step 2 — Clone this branch and open it in VS Code

1. Clone the branch: `git clone -b dev/project-config <repository-url>`
2. Open VS Code
3. Go to **File → Open Folder**
4. Select the cloned folder

### Step 3 — Install the Claude Code extension in VS Code

1. Go to **Extensions** (Ctrl+Shift+X / Cmd+Shift+X)
2. Search for **Claude Code**
3. Click **Install**
4. Click the **Claude** icon in the VS Code sidebar (or use the keyboard shortcut shown after install) to open the panel

---

## 4. Available Commands

| Command | Purpose |
|---|---|
| `/config-project` | Interactively build project_config.md via Q&A (the only supported way to configure it) |
| `/connect-mcp` | Connect to MCP servers listed in project_config.md |
| `/sync-project` | Fetch Confluence pages into local project files |
| `/clear-project` | Delete synced context/reference files and reset project_config.md to its unconfigured state |

---

## 5. Handoff to the Documentation Tools

`project/project_config.md` is the only file this tool produces that's tracked by git — `project/context/` and `project/reference/` are gitignored on every branch, including this one.

Once configured and synced, in the **same clone**:
1. Commit and push `project/project_config.md` to a branch for this project (e.g. `project/<name>`).
2. Check out the BA Doc or QA Doc tool branch (`git checkout dev/BA` or `git checkout dev/QA`) — `project/context/` and `project/reference/` just synced above are gitignored, so they carry over automatically; only `project_config.md` needs restoring there, since it's the one tracked file: `git show project/<name>:project/project_config.md > project/project_config.md`. That tool branch doesn't carry `/sync-project` or `/config-project` itself — those commands live only on this branch.

---

## 6. Folder Structure

```
AI-FW-Doc-Generation/
├── CLAUDE.md                              ← project instructions for Claude
├── .claude/
│   └── commands/                          ← slash command definitions (see Available Commands)
├── framework/                             ← reusable rules and styles, domain-agnostic
│   └── framework_config.md                ← edit_framework setting (do not modify)
└── project/                               ← project-level context
    ├── project_config.md                  ← project config (tracked — committed unconfigured; run /config-project to set it up locally per project)
    ├── context/                           ← domain overview, modules, user stories (not committed)
    └── reference/                         ← spec sheets, Confluence exports (not committed)
        ├── business-rules/                ← principles + shared references for Business Rules
        ├── navigation/                    ← shared navigation patterns
        ├── ui-behavior/                   ← principles + shared references for UI Behavior
        ├── messages/                      ← shared message templates and wording conventions
        └── test-scenarios/                ← principles for Test Scenarios (QA-specific)
```
