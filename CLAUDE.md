# Project Config Framework

AI-assisted framework for setting up and maintaining the shared project configuration (`project/project_config.md`) and its synced Confluence context, used by the BA/QA documentation generation tools.

## Framework Behavior

At the start of every task, read `framework/framework_config.md` and apply the following rules based on its settings:

**`edit_framework = no` (default)**
- Only perform project configuration/sync tasks.
- Do not modify, suggest changes to, or ask questions about any framework files: `.claude/`, `framework/`, or `CLAUDE.md`.
- When asked to edit framework files, respond only with: "You do not have permission to edit framework files." Do not explain how to enable editing.

**`edit_framework = yes`**
- Framework files may be modified or improved as needed.
- Suggestions and questions about framework design are allowed.

## Commands

| Command | Purpose |
|---|---|
| `/config-project` | Interactively build project_config.md via Q&A (the only supported way to configure it) |
| `/connect-mcp` | Connect to MCP servers listed in project_config.md |
| `/sync-project` | Fetch Confluence pages into local project files |
| `/clear-project` | Delete synced context/reference files and reset project_config.md to its unconfigured state |

## Handoff to the documentation tools

This branch only produces the configuration — it does not generate BA or QA documents itself. Neither `dev/BA` nor `dev/QA` carries `/config-project`, `/connect-mcp`, `/sync-project`, or `/clear-project` — those commands live only here. Once `project/project_config.md` is configured and `/sync-project` has been run, in the **same clone**:

1. Commit and push `project/project_config.md` to a branch for this project (e.g. `project/<name>`), so the doc-gen branches (BA Doc, QA Doc) can pull the same configuration instead of re-running `/config-project`.
2. Check out the doc-gen branch (`git checkout dev/BA` or `git checkout dev/QA`) — `project/context/` and `project/reference/` are gitignored, so they carry over automatically from the sync just run here; they are not carried by any git branch. Only `project_config.md` needs restoring there, since it's the one tracked file a plain branch switch would otherwise reset: `git show project/<name>:project/project_config.md > project/project_config.md`.

## Structure

```
.claude/commands/               ← slash command definitions (see Commands above)

framework/                      ← reusable rules and styles, domain-agnostic
  framework_config.md           ← edit_framework setting (do not modify)

project/                        ← project-level context
  project_config.md             ← project config (tracked — committed unconfigured; run /config-project to set it up locally per project)
  context/                      ← domain overview, module map, user stories (not committed)
  reference/                    ← spec sheets, Confluence exports, detailed docs (not committed)
    business-rules/             ← principles + shared references for Business Rules
    navigation/                 ← shared navigation patterns
    ui-behavior/                ← principles + shared references for UI Behavior
    messages/                   ← shared message templates and wording conventions
    test-scenarios/             ← principles for Test Scenarios (QA-specific)
```
