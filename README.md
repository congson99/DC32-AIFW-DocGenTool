# DC32 QA Documentation Claude Tool

v1.0

---

## Table of Contents

1. [Overview](#1-overview)
2. [QA Documentation Set](#2-qa-documentation-set)
3. [Quick Start](#3-quick-start)
4. [Setup Environment](#4-setup-environment)
5. [Available Commands](#5-available-commands)
6. [Folder Structure](#6-folder-structure)

---

## 1. Overview

**DC32 QA Documentation Claude Tool** is a tool built specifically for the **DC32 AI Framework**. It helps the QA generate a complete QA documentation set from existing project documents, refined through Q&A with the QA. Finally, it pushes the finished content to a Confluence page so the framework's next steps can proceed.

> The QA Documentation Set has a fixed structure, dedicated to the framework.

> Confluence is the primary source for reading and writing documents, via an MCP connection. Figma (optional) can also be connected to supply UI references for Test Cases.

---

## 2. QA Documentation Set

1. **Test Scenarios** — high-level test conditions derived from the feature's business flow, covering main, alternative, and exception paths to be validated.
2. **Test Cases** — detailed, step-by-step test procedures with input data, execution steps, and expected results, derived from the Test Scenarios.

---

## 3. Quick Start

**QA generating docs for a project that's already configured**
1. See [Setup Environment](#4-setup-environment) to set up your environment.
2. Run `/sync <confluence-page-url>` here, using the Confluence link this project's `project_config.md` was published to — it pulls the file down and fetches `project/context/`/`project/reference/` from Confluence in one go.
3. Run `/start <Feature Name>`, then follow the chat prompts to generate the QA documentation set.

> If your project doesn't have a `project_config.md` yet, go to https://github.com/congson99/DC32-AIFW-DocGenTool, find the branch for the Project Configuration Tool version you need, and clone it to create one for your project.

---

## 4. Setup Environment

1. **Install VS Code** — install [VS Code](https://code.visualstudio.com/), or any other IDE that supports the Claude Code extension (e.g. JetBrains IDEs).
2. **Clone this branch and open it in VS Code**
   - Go to https://github.com/congson99/DC32-AIFW-DocGenTool, find the branch for the **QA Documentation Tool** version you need, and clone it.
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

Run in this order to produce a complete QA Doc for one feature.

| Command | Purpose |
|---|---|
| `/start <Feature Name>` | Initialize feature folder, env file, and context file |
| `/investigate <Feature Name>` | Read the feature's Source BA Doc and distill it into an Investigation file, asking the user for anything missing |
| `/resolve-assumptions <Feature Name>` | Identify unclear points in the Investigation/Source BA Doc and get the user to confirm or resolve every one of them before any generation begins |
| `/gen-test-scenarios <Feature Name>` | Generate Test Scenarios from the Investigation |
| `/gen-test-cases <Feature Name>` | Generate Test Cases from the Test Scenarios |
| `/package <Feature Name>` | Package Test Scenarios and Test Cases into a single QA Doc |
| `/review <Feature Name>` | Review AC, Business Rules, Flow, and Test Scenarios for quality, completeness, and coverage — shown in chat, with every finding resolved before publishing |
| `/publish <Feature Name>` | Publish QA Doc to Confluence and update Jira status |

> `/gen-doc <Feature Name>` is not a step in this sequence — it's a shortcut that runs `/resolve-assumptions` → `/gen-test-scenarios` → `/gen-test-cases` → `/package` → `/review` back-to-back, pausing only where those steps themselves always pause (Assumptions & Gaps, Review). Use it instead of running those five commands one at a time.

### Not in the flow — project setup & maintenance

| Command | Purpose |
|---|---|
| `/check <Feature Name>` | Show doc status and suggest next step |
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
        ├── input/                         ← env_<slug>.md, context_<slug>.md, investigation_<slug>.md
        ├── docs/                          ← generated QA doc sections (Assumptions & Gaps, Test Scenarios, Test Cases, Spec Review)
        └── qa_doc_<slug>.md               ← final packaged document
```

> `/gen-test-scenarios`/`/gen-test-cases` read `test-scenarios/principles/`, `test-scenarios/shared-references/`, `test-cases/principles/`, and `test-cases/shared-references/` if present, but `/config` on `dev/config` has no matching Context Sync category for any of them, so these four currently have no supported way to get populated.
