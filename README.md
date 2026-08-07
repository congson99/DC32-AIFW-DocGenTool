# DC32 QA Documentation Claude Tool

v2.1

---

## Table of Contents

1. [Overview](#1-overview)
2. [QA Documentation Set](#2-qa-documentation-set)
3. [Quick Start](#3-quick-start)
4. [Setup Environment](#4-setup-environment-one-time-only)
5. [Available Commands](#5-available-commands)
6. [Folder Structure](#6-folder-structure)

---

## 1. Overview

**DC32 QA Documentation Claude Tool** is a tool built specifically for the **DC32 AI Framework**. It helps the QA generate a complete QA documentation set from existing project documents, refined through Q&A with the QA. Finally, it pushes the finished content to a Confluence page so the framework's next steps can proceed.

> The QA Documentation Set consists of Test Scenarios and Test Cases, dedicated to the framework.

> Confluence is the primary source for reading and writing documents, via an MCP connection. Figma (optional) can also be connected to supply UI references for Test Cases.

---

## 2. QA Documentation Set

1. **Test Scenarios** — high-level test conditions derived from the feature's business flow, covering main, alternative, and exception paths to be validated.
2. **Test Cases** — detailed, step-by-step test procedures with input data, execution steps, and expected results, derived from the Test Scenarios.

---

## 3. Quick Start

Pick the path that matches your role:

**QA generating docs for a project that's already configured**
1. See [Setup Environment](#4-setup-environment-one-time-only) to set up your environment.
2. Run `/start <Feature Name>`, then follow the chat prompts to generate the QA documentation set.

**QA Lead setting up a brand-new project**
1. See [Setup Environment](#4-setup-environment-one-time-only) to set up your environment.
2. Run `/config-project`, then follow the chat prompts to fill in `project/project_config.md`. Only needs to be done once for the whole project.
3. Push the completed `project/project_config.md` to the repo so every QA on the project can pull the same configuration.

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

### QA Doc Gen Flow Commands

Used as part of the regular per-feature QA document generation flow.

| Command | Purpose |
|---|---|
| `/start <Feature Name>` | Initialize feature folder, env file, and context file |
| `/investigate <Feature Name>` | Read the feature's Source BA Doc and distill it into a Test Basis file, asking the user for anything missing |
| `/gen-test-scenarios <Feature Name>` | Generate Test Scenarios from the Test Basis |
| `/gen-test-cases <Feature Name>` | Generate Test Cases from the Test Scenarios |
| `/gen-doc <Feature Name>` | Run gen-test-scenarios, gen-test-cases, and package back-to-back |
| `/package <Feature Name>` | Package Test Scenarios and Test Cases into a single QA Doc |
| `/publish <Feature Name>` | Publish QA Doc to Confluence and update Jira status |

### Other Commands

Used independently, as needed — project configuration and maintenance, not part of the QA doc gen flow.

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
│       ├── test-scenarios/                ← principles + shared references for Test Scenarios
│       └── test-cases/                    ← principles + shared references for Test Cases
└── workspace/                             ← per-feature working area (not committed)
    └── <feature-name>/
        ├── input/                         ← env_<slug>.md, context_<slug>.md, test_basis_<slug>.md
        ├── docs/                          ← generated QA doc sections (Test Scenarios, Test Cases)
        └── qa_doc_<slug>.md               ← final packaged document
```
