# DC32 AI Framework - Project Configuration Tool

v1.0

---

## Table of Contents

1. [Overview](#1-overview)
2. [How to Start](#2-how-to-start)
   2.1. [Prepare Context](#21-prepare-context)
   2.2. [Setup Environment](#22-setup-environment)
3. [Available Commands](#3-available-commands)
4. [Folder Structure](#4-folder-structure)

---

## 1. Overview

**Project Configuration Tool** is a tool built specifically for the **DC32 AI Framework**. It helps the team leader build the `project_config` file once per project — this file is then used throughout the project by both the BA Doc and QA Doc generation tools.

> It only supports reading and syncing data from Confluence pages.

---

## 2. How to Start

1. See [Prepare Context](#21-prepare-context) and have those ready before setup.
2. See [Setup Environment](#22-setup-environment) to set up your environment.
3. Run `/config`, then follow the chat prompts to fill in `project/project_config.md`. Only needs to be done once for the whole project.
4. Share the completed `project/project_config.md` with the team — save/send the file directly, or publish it to a Confluence page (`/config` offers to do this automatically) — so the BA/QA doc-gen tools can use the same configuration instead of running `/config` themselves.

---

### 2.1. Prepare Context

- **Confluence space** — a dedicated Confluence space to host this project's context and reference docs going forward.
- **Atlassian connection** (mandatory) — a link to any Jira ticket or Confluence page in your workspace, just to establish the connection.
- **Figma** (optional) — a link to the project's Figma file, if the team uses Figma for UI designs. Lets the QA tool reference actual screens when writing Test Cases.
- **Context** — docs that apply to the whole project, not one specific feature. Example: the BRD (Business Requirements Document), a module map, or a release roadmap.
- **Business Rules — Principles** — a doc explaining *how* business rules should be written in general (not the rules themselves, just the writing guidelines).
- **Business Rules — Shared References** — a doc listing rules that repeat across many features, e.g. "email must match this format," "pagination shows 20 rows per page."
- **UI Behavior — Principles** — a doc explaining general UI conventions, e.g. when validation errors should appear, or what every page header should include.
- **UI Behavior — Shared References** — a doc describing how common, reused components should behave, e.g. how every Table, Edit Form, or Sidebar in the app works.
- **Navigation** — a doc covering shared navigation rules, e.g. button naming, when confirmation dialogs appear, or a map of the app's pages/dialogs.
- **Messages** — a doc with standard wording for messages, e.g. the exact phrasing used for error and success messages.
- **Test Scenarios — Principles** — a doc explaining how test scenarios should be structured or grouped (not the scenarios themselves, just the guidelines).
- **Project Config page** — an empty Confluence page named **"Project Config for Doc Gen Tool"**, where `/config` will publish the finished `project_config.md`.

---

### 2.2. Setup Environment

1. **Install VS Code** — install [VS Code](https://code.visualstudio.com/), or any other IDE that supports the Claude Code extension (e.g. JetBrains IDEs).
2. **Clone this branch and open it in VS Code**
   - Go to https://github.com/congson99/DC32-AIFW-DocGenTool, find the branch for the **Project Configuration Tool** version you need, and clone it.
   - Open VS Code
   - Go to **File → Open Folder**
   - Select the cloned folder
3. **Install the Claude Code extension in VS Code**
   - Go to **Extensions** (Ctrl+Shift+X / Cmd+Shift+X)
   - Search for **Claude Code**
   - Click **Install**
   - Click the **Claude** icon in the VS Code sidebar (or use the keyboard shortcut shown after install) to open the panel

---

## 3. Available Commands

| Command | Purpose |
|---|---|
| `/config` | Interactively build project_config.md via Q&A (the only supported way to configure it) |
| `/connect-mcp` | Connect to MCP servers listed in project_config.md |
| `/sync` | Fetch Confluence pages into local project files |
| `/reset` | Delete synced context/reference files and reset project_config.md to its unconfigured state |

---

## 4. Folder Structure

```
AI-FW-Doc-Generation/
├── CLAUDE.md                              ← project instructions for Claude
├── .claude/
│   └── commands/                          ← slash command definitions (see Available Commands)
├── framework/                             ← reusable rules and styles, domain-agnostic
│   └── framework_config.md                ← edit_framework setting (do not modify)
└── project/                               ← project-level context
    ├── project_config.md                  ← project config (tracked — committed unconfigured; run /config to set it up locally per project)
    ├── context/                           ← domain overview, modules, user stories (not committed)
    └── reference/                         ← spec sheets, Confluence exports (not committed)
        ├── business-rules/
        │   ├── principles/                ← general principles for writing Business Rules
        │   └── shared-references/         ← rule groups reused across many features
        ├── navigation/                    ← shared navigation patterns
        ├── ui-behavior/
        │   ├── principles/                ← general UI behavior principles
        │   └── shared-references/         ← UI behavior groups reused across many screens
        ├── messages/                      ← shared message templates and wording conventions
        └── test-scenarios/
            └── principles/                ← general principles for designing Test Scenarios
```
