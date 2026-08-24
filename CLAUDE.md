# BA Documentation Generation Framework

AI-assisted framework for Business Analysts to generate a complete BA documentation set from a single input.

## Framework Behavior

At the start of every task, read `framework/framework_config.md` and apply the following rules based on its settings:

**`edit_framework = no` (default)**
- Only perform document generation tasks.
- Do not modify, suggest changes to, or ask questions about any framework files: `.claude/`, `framework/`, or `CLAUDE.md`.
- When asked to edit framework files, respond only with: "You do not have permission to edit framework files." Do not explain how to enable editing.

**`edit_framework = yes`**
- Framework files may be modified or improved as needed.
- Suggestions and questions about framework design are allowed.

## Commands

### Main flow (per feature)

Run in this order to produce a complete BA Doc for one feature.

| Command | Purpose |
|---|---|
| `/start <Feature Name>` | Initialize feature folder, env file, and context file |
| `/investigate <Feature Name>` | Generate the Investigation file from project context, asking the user for anything missing |
| `/gen-brief <Feature Name>` | Generate Brief from the Investigation file |
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

This branch does not carry `/config` — that lives on the `dev/config` branch. `/reset`, `/sync`, `/connect-mcp`, `/connect-local-mcp`, and `/check-mcp` exist on both this branch and `dev/QA`: their copies here work directly against project/project_config.md and project/status.md without needing to switch branches, since that data is already available here. See [Getting project_config.md](#getting-projectconfigmd) below for the one-time setup of project_config.md itself, which this branch still cannot configure on its own.

## Getting project_config.md

`project/project_config.md` must already be configured before running `/start` — this branch has no way to configure it itself, and `project/` is entirely gitignored here (same as on `dev/config`), so the file is never tracked by git on either branch.
- **Same clone**: check out `dev/config` and run `/config` there, then `git checkout dev/BA` again — the file (and `project/context/`, `project/reference/`) carry over automatically since none of it is tracked or touched by the branch switch.
- **Different clone/machine**: run `/sync <confluence-page-url>`, using the Confluence page `/config` published it to at the end — it pulls the file down automatically before syncing, no manual copy needed.

## Structure

```
.claude/commands/               ← slash command definitions (see Commands above)

framework/                      ← reusable rules and styles, domain-agnostic
  framework_config.md           ← edit_framework setting (do not modify)
  rules/                        ← writing/content rules, one file per doc type
  styles/                       ← format rules, one file per doc type + style_general.md

project/                        ← project-level context
  project_config.md             ← project config (not committed — see "Getting project_config.md" above)
  status.md                     ← local bookkeeping: last /sync (not committed, not shared)
  context/                      ← domain overview, module map, user stories (not committed)
  reference/                    ← spec sheets, Confluence exports, detailed docs (not committed)
    business-rules/
      principles/                ← general principles for writing Business Rules
      shared-references/         ← rule groups reused across many features
    data-definition/
      shared-references/         ← field definitions (name, type, description) for entities reused across many features, e.g. Warehouse, Supplier
    navigation/                 ← shared navigation patterns
    ui-behavior/
      principles/                ← general UI behavior principles
      shared-references/         ← UI behavior groups reused across many screens
    messages/                   ← shared message templates and wording conventions
    flow/                      ← shared flow patterns and conventions
    sample-doc/                ← one or more complete example BA Docs, used by every gen-* command as a style/tone/detail-level reference for its own section

workspace/                      ← per-feature working area (not committed)
  <feature-name>/
    input/                      ← env_<slug>.md, context_<slug>.md, investigation_<slug>.md
    docs/                       ← generated BA doc sections (Brief through Messages)
    ba_doc_<slug>.md            ← final packaged document
```

> slug = kebab-case folder name with `-` replaced by `_` (e.g. `cancel-pr` → `cancel_pr`)
