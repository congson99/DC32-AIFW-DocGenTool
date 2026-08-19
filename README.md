# DC32 AI Framework - Project Configuration Tool

v1.2

---

## Table of Contents

1. [Overview](#1-overview)
2. [How to Start](#2-how-to-start)
   - 2.1. [Prepare Context](#21-prepare-context)
   - 2.2. [Setup Environment](#22-setup-environment)
3. [Available Commands](#3-available-commands)

---

## 1. Overview

**Project Configuration Tool** is a tool built specifically for the **DC32 AI Framework**. It helps the team leader build the `project_config` file once per project — this file is then used throughout the project by both the BA Doc and QA Doc generation tools.

---

## 2. How to Start

1. See [Prepare Context](#21-prepare-context) and have those ready before setup.
2. See [Setup Environment](#22-setup-environment) to set up your environment.
3. Run `/config`, then follow the chat prompts to fill in `project/project_config.md`. Only needs to be done once for the whole project.
4. Share the Confluence page `/config` publishes `project/project_config.md` to at the end, so the BA/QA doc-gen tools can use the same configuration.

---

### 2.1. Prepare Context

- **Confluence space** — a dedicated Confluence space to host this project's context and reference docs going forward.
- **Figma** (optional) — a link to the project's Figma file, if the team uses Figma for UI designs. Lets the QA tool reference actual screens when writing Test Cases.
- **Context** — docs that apply to the whole project, not one specific feature. Example: the BRD (Business Requirements Document), a module map, or a release roadmap.
- **Sample Doc** — one or more already-finished, high-quality BA Docs, used as a style/tone/detail-level reference for every generated section — not one specific category.
- **Business Rules — Principles** — a doc explaining *how* business rules should be written in general (not the rules themselves, just the writing guidelines).
- **Business Rules — Shared References** — a doc listing rules that repeat across many features, e.g. "email must match this format," "pagination shows 20 rows per page."
- **Data Definition — Shared References** — a doc listing field definitions for entities reused across many features, e.g. Warehouse's or Supplier's fields — lets a feature that just displays or references that entity reuse the fields instead of re-guessing them.
- **UI Behavior — Principles** — a doc explaining general UI conventions, e.g. when validation errors should appear, or what every page header should include.
- **UI Behavior — Shared References** — a doc describing how common, reused components should behave, e.g. how every Table, Edit Form, or Sidebar in the app works.
- **Navigation** — a doc covering shared navigation rules, e.g. button naming, when confirmation dialogs appear, or a map of the app's pages/dialogs.
- **Flow** — a doc covering shared flow conventions, e.g. what a feature's default entry point is, or when a rejection path becomes its own Alternate Flow.
- **Messages** — a doc with standard wording for messages, e.g. the exact phrasing used for error and success messages.
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
| `/update-config` | Update one or more specific parts of an already-configured project_config.md, one at a time |
| `/connect-mcp` | Connect to MCP servers listed in project_config.md |
| `/connect-local-mcp` | Set up a project-scoped Atlassian MCP server, separate from the global one, for one or more Jira/Confluence instances |
| `/check-mcp` | Show every MCP connection currently available in this session and what it's connected to |
| `/sync` | Fetch Confluence pages into local project files |
| `/reset` | Delete synced context/reference files and reset project_config.md to its unconfigured state |
