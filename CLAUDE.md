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

Used as part of the regular per-feature BA document generation flow.

| Command | Purpose |
|---|---|
| `/start <Feature Name>` | Initialize feature folder, env file, and context file |
| `/investigate <Feature Name>` | Generate the Idea file from project context, asking the user for anything missing |
| `/gen-brief <Feature Name>` | Generate Brief from the Idea file |
| `/gen-dependencies <Feature Name>` | Generate Dependencies |
| `/gen-ac <Feature Name>` | Generate Acceptance Criteria |
| `/gen-business-rule <Feature Name>` | Generate Business Rules |
| `/gen-data-definition <Feature Name>` | Generate Data Definition |
| `/gen-navigation <Feature Name>` | Generate Navigation |
| `/gen-flow <Feature Name>` | Generate Flow |
| `/gen-ui-behavior <Feature Name>` | Generate UI Behavior |
| `/gen-messages <Feature Name>` | Generate Messages |
| `/gen-doc <Feature Name>` | Run gen-brief through gen-messages and package back-to-back |
| `/package <Feature Name>` | Package all artifacts into a single BA Doc |
| `/publish <Feature Name>` | Publish BA Doc to Confluence and update Jira status |
| `/check <Feature Name>` | Show doc status and suggest next step |
| `/clear-workspace` | Delete all feature folders in workspace/ |
| `/reset` | Delete all synced context/reference files, reset project_config.md to its unconfigured state, and clear all feature folders in workspace/ |
| `/sync` | Fetch the latest content from Confluence into project/context/ and project/reference/ based on project/project_config.md |
| `/connect-mcp` | Connect to the MCP servers (Atlassian, Figma) listed in project/project_config.md |
| `/connect-local-mcp` | Set up a project-scoped Atlassian MCP server (separate from the global one), for one or more Jira/Confluence instances |
| `/check-mcp` | Show every MCP connection currently available in this session and what it's connected to |

This branch does not carry `/config` — that lives on the `dev/config` branch. `/reset`, `/sync`, `/connect-mcp`, `/connect-local-mcp`, and `/check-mcp` exist on both this branch and `dev/QA`: their copies here work directly against project/project_config.md and project/status.md without needing to switch branches, since that data is already available here. See [Getting project_config.md](#getting-projectconfigmd) below for the one-time setup of project_config.md itself, which this branch still cannot configure on its own.

## Getting project_config.md

`project/project_config.md` must already be configured before running `/start` — this branch has no way to configure it itself, and `project/` is entirely gitignored here (same as on `dev/config`), so the file is never tracked by git on either branch.
- **Same clone**: check out `dev/config` and run `/config` there, then `git checkout dev/BA` again — the file (and `project/context/`, `project/reference/`) carry over automatically since none of it is tracked or touched by the branch switch.
- **Different clone/machine**: get the file from wherever your team shares the published config (the Confluence page `/config` publishes it to at the end) and save it as `project/project_config.md` here.

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
    navigation/                 ← shared navigation patterns
    ui-behavior/
      principles/                ← general UI behavior principles
      shared-references/         ← UI behavior groups reused across many screens
    messages/                   ← shared message templates and wording conventions
    flow/                      ← shared flow patterns and conventions (see note below)

workspace/                      ← per-feature working area (not committed)
  <feature-name>/
    input/                      ← env_<slug>.md, context_<slug>.md, idea_<slug>.md
    docs/                       ← generated BA doc sections (Brief through Messages)
    ba_doc_<slug>.md            ← final packaged document
```

> slug = kebab-case folder name with `-` replaced by `_` (e.g. `cancel-pr` → `cancel_pr`)

> `gen-flow` reads `project/reference/flow/` if present, but `/config` on `dev/config` has no matching Context Sync category yet, so this folder currently has no supported way to get populated.
