# DC32 QA Documentation Claude Tool

v1.1

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

**QA generating docs for a project that's already configured**
1. See [Setup Environment](#4-setup-environment-one-time-only) to set up your environment.
2. Get `project/project_config.md` for this project — either check out `dev/config` in the same clone and run `/config` there yourself, or ask your team lead for the Confluence page it was published to and save its content here as `project/project_config.md`.
3. Run `/sync` here to fetch `project/context/` and `project/reference/` from Confluence.
4. Run `/start <Feature Name>`, then follow the chat prompts to generate the QA documentation set.

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
3. `git checkout dev/QA` (back to this branch) — `project/project_config.md`, `project/context/`, and `project/reference/` all carry over automatically since none of them are tracked.
4. Run `/sync` here any time you want to pull the latest `project/context/` and `project/reference/` content from Confluence, `/connect-mcp` to (re)connect the Atlassian/Figma MCP servers, `/connect-local-mcp` to set up a dedicated per-site Atlassian connection, or `/check-mcp` to see what's currently connected — this branch has its own copies of all four, so no branch switch is needed.

> If you're on a different clone/machine, there's no branch to pull `project_config.md` from — ask your team lead for the Confluence page `/config` published it to and save its content here as `project/project_config.md`, skipping straight to step 4.

---

## 5. Available Commands

| Command | Purpose |
|---|---|
| `/start <Feature Name>` | Initialize feature folder, env file, and context file |
| `/investigate <Feature Name>` | Read the feature's Source BA Doc and distill it into a Test Basis file, asking the user for anything missing |
| `/resolve-assumptions <Feature Name>` | Identify unclear points in the Test Basis/Source BA Doc and get the user to confirm or resolve every one of them before any generation begins |
| `/gen-test-scenarios <Feature Name>` | Generate Test Scenarios from the Test Basis |
| `/gen-test-cases <Feature Name>` | Generate Test Cases from the Test Scenarios |
| `/package <Feature Name>` | Package Test Scenarios and Test Cases into a single QA Doc |
| `/review <Feature Name>` | Review AC, Business Rules, Flow, and Test Scenarios for quality, completeness, and coverage — shown in chat, with every finding resolved before publishing |
| `/gen-doc <Feature Name>` | Run resolve-assumptions, gen-test-scenarios, gen-test-cases, package, and review back-to-back |
| `/publish <Feature Name>` | Publish QA Doc to Confluence and update Jira status |
| `/check <Feature Name>` | Show doc status and suggest next step |
| `/clear-workspace` | Delete all feature folders in workspace/ |
| `/reset` | Delete all synced context/reference files, reset project_config.md to its unconfigured state, and clear all feature folders in workspace/ |
| `/connect-mcp` | Connect to the MCP servers (Atlassian, Figma) listed in project/project_config.md |
| `/sync` | Fetch the latest content from Confluence into project/context/ and project/reference/ |
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
│       ├── ui-behavior/
│       │   ├── principles/                ← general UI behavior principles
│       │   └── shared-references/         ← UI behavior groups reused across many screens
│       ├── navigation/                    ← shared navigation patterns
│       ├── messages/                      ← shared message templates and wording conventions
│       ├── test-scenarios/
│       │   ├── principles/                ← general principles for designing Test Scenarios
│       │   └── shared-references/         ← reusable Test Scenario groups (see note below)
│       └── test-cases/
│           ├── principles/                ← general principles for writing Test Cases
│           └── shared-references/         ← reusable Test Case data/steps (see note below)
└── workspace/                             ← per-feature working area (not committed)
    └── <feature-name>/
        ├── input/                         ← env_<slug>.md, context_<slug>.md, test_basis_<slug>.md, assumptions_<slug>.md
        ├── docs/                          ← generated QA doc sections (Test Scenarios, Test Cases, Spec Review)
        └── qa_doc_<slug>.md               ← final packaged document
```

> `gen-test-scenarios`/`gen-test-cases` read `test-scenarios/principles/`, `test-scenarios/shared-references/`, `test-cases/principles/`, and `test-cases/shared-references/` if present, but `/config` on `dev/config` has no matching Context Sync category for any of them, so these four currently have no supported way to get populated.
