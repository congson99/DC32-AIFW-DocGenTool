# DC32 QA Documentation Claude Tool

v1.0

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
2. Get `project/project_config.md` for this project — either check out `dev/project-config` in the same clone and run `/config-project` + `/sync-project` there yourself, or ask your team lead for the branch it was pushed to (e.g. `project/<name>`) and restore it: `git show project/<name>:project/project_config.md > project/project_config.md`.
3. Run `/start <Feature Name>`, then follow the chat prompts to generate the QA documentation set.

> This branch does not include `/config-project`, `/connect-mcp`, `/sync-project`, or `/clear-project` — those commands live on the `dev/project-config` branch, since setting up a project is a one-time, project-level task independent of generating docs for any particular feature.

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

This branch has no sync/config commands of its own. In the same clone:

1. `git checkout dev/project-config`
2. Run `/config-project` (if not already done for this project) then `/sync-project` — this populates `project/project_config.md`, `project/context/`, and `project/reference/`.
3. `git checkout dev/QA` (back to this branch) — `project/context/` and `project/reference/` are gitignored, so they carry over automatically.
4. Restore `project_config.md` here, since it's the one tracked file a plain branch switch would otherwise reset to this branch's own blank copy: `git show dev/project-config:project/project_config.md > project/project_config.md`.

> If someone else already configured and pushed `project_config.md` to a `project/<name>` branch, skip straight to step 4 using that branch name instead.

> Re-run from step 1 any time the source data changes to pull the latest content locally.

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
| `/review-spec <Feature Name>` | Review AC, Business Rules, Flow, and Test Scenarios for quality, completeness, and coverage |
| `/gen-doc <Feature Name>` | Run resolve-assumptions, gen-test-scenarios, gen-test-cases, package, and review-spec back-to-back |
| `/publish <Feature Name>` | Publish QA Doc to Confluence and update Jira status |
| `/check <Feature Name>` | Show doc status and suggest next step |
| `/clear-workspace` | Delete all feature folders in workspace/ |

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
│       ├── ui-behavior/                   ← principles + shared references for UI Behavior
│       ├── navigation/                    ← shared navigation patterns
│       ├── messages/                      ← shared message templates and wording conventions
│       ├── test-scenarios/                ← principles + shared references for Test Scenarios
│       └── test-cases/                    ← principles + shared references for Test Cases
└── workspace/                             ← per-feature working area (not committed)
    └── <feature-name>/
        ├── input/                         ← env_<slug>.md, context_<slug>.md, test_basis_<slug>.md, assumptions_<slug>.md
        ├── docs/                          ← generated QA doc sections (Test Scenarios, Test Cases, Spec Review)
        └── qa_doc_<slug>.md               ← final packaged document
```
