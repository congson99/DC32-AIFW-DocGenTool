# Project Config Framework

AI-assisted framework for setting up and maintaining the shared project configuration (`project/project_config.md`) and its synced Confluence context, used by the BA/QA documentation generation tools.

## Framework Behavior

At the start of every task, read `framework/framework_config.md` and apply the following rules based on its settings:

**`edit_framework = no` (default)**
- Only perform project configuration/sync tasks.
- Do not modify, suggest changes to, or ask questions about any framework files: `.claude/`, `framework/`, `CLAUDE.md`, `README.md`, or `.gitignore`.
- When asked to edit framework files, respond only with: "You do not have permission to edit framework files." Do not explain how to enable editing.

**`edit_framework = yes`**
- Framework files may be modified or improved as needed.
- Suggestions and questions about framework design are allowed.

## Commands

| Command | Purpose |
|---|---|
| `/config` | Interactively build project_config.md via Q&A (the only supported way to configure it) |
| `/update-config` | Update one or more specific parts of an already-configured project_config.md, one at a time |
| `/connect-mcp` | Connect to MCP servers listed in project_config.md |
| `/connect-local-mcp` | Set up a project-scoped Atlassian MCP server, separate from the global one, for one or more Jira/Confluence instances |
| `/check-mcp` | Show every MCP connection currently available in this session and what it's connected to |
| `/sync` | Fetch Confluence pages into local project files |
| `/reset` | Delete synced context/reference files and reset project_config.md to its unconfigured state |

## Handoff to the documentation tools

This branch only produces the configuration — it does not generate BA or QA documents itself. `/config`, `/update-config`, and `/reset` live only here — setting up a project is a one-time, project-level task, not something tied to any particular feature. `dev/BA` and `dev/QA` each carry their own copies of `/connect-mcp`, `/connect-local-mcp`, `/check-mcp`, and `/sync`, so reconnecting an MCP server, setting up a second Atlassian instance, checking connections, or refreshing Confluence content doesn't require switching branches once `project/project_config.md` has been configured and shared. Once `project/project_config.md` is configured and `/sync` has been run:

1. Share `project/project_config.md` with the team — save/send the file directly, or publish its content to a Confluence page (`/config` offers to do this automatically at the end of setup).
2. `project/project_config.md` is gitignored, so it is never committed and a branch switch never resets or carries it. In this same clone, switching to `dev/BA` or `dev/QA` leaves the file exactly as configured — no per-project branch needed. Other team members, in their own clone, check out the doc-gen branch (`git checkout dev/BA` or `git checkout dev/QA`) and manually place the shared config at `project/project_config.md` there, since git won't distribute it for them.

## Structure

```
.claude/commands/               ← slash command definitions (see Commands above)
.claude/settings.local.json     ← auto-gitignored by Claude Code; holds project-scoped Atlassian credentials (env key) from /connect-local-mcp — persists across /reset and branch switches, since it's a durable local connection, not per-project state

framework/                      ← reusable rules and styles, domain-agnostic
  framework_config.md           ← edit_framework setting (do not modify)

project/                        ← project-level context
  project_config.md             ← project config (gitignored — never committed; run /config to set it up locally per project)
  status.md                     ← local bookkeeping: last /sync, /connect-mcp (not committed, not shared)
  context/                      ← domain overview, module map, user stories (not committed)
  reference/                    ← spec sheets, Confluence exports, detailed docs (not committed)
    business-rules/
      principles/               ← general principles for writing Business Rules
      shared-references/        ← rule groups reused across many features
    navigation/                 ← shared navigation patterns
    ui-behavior/
      principles/               ← general UI behavior principles
      shared-references/        ← UI behavior groups reused across many screens
    messages/                   ← shared message templates and wording conventions
    test-scenarios/
      principles/               ← general principles for designing Test Scenarios
```
