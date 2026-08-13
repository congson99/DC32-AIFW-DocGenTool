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
| `/sync` | Fetch the latest content from Confluence into project/context/ and project/reference/ based on project/project_config.md |

This branch does not carry `/config-project`, `/connect-mcp`, or `/clear-project` — those live on the `dev/project-config` branch. `/sync` exists on both branches: this branch's `/sync` refreshes project/context/ and project/reference/ directly from Confluence without needing to switch branches, since project_config.md's Context Sync mappings are already available here. See [Getting project_config.md](#getting-projectconfigmd) below for the one-time setup of project_config.md itself, which this branch still cannot configure on its own.

## Getting project_config.md

`project/project_config.md` must already be configured before running `/start` — this branch has no way to configure it itself. In the same clone:
1. Check out `dev/project-config` and run `/config-project` + `/sync-project` there (or have your team lead do this once and push it to a `project/<name>` branch).
2. Check out this branch again (`git checkout dev/BA`) — `project/context/` and `project/reference/` are gitignored, so they carry over automatically from the sync above.
3. Restore the configured `project_config.md` here, since it's the one tracked file that a plain branch switch would otherwise reset: `git show project/<name>:project/project_config.md > project/project_config.md` (or `git show dev/project-config:project/project_config.md > project/project_config.md` if it wasn't pushed to its own project branch).

## Structure

```
.claude/commands/               ← slash command definitions (see Commands above)

framework/                      ← reusable rules and styles, domain-agnostic
  framework_config.md           ← edit_framework setting (do not modify)
  rules/                        ← writing/content rules, one file per doc type
  styles/                       ← format rules, one file per doc type + style_general.md

project/                        ← project-level context
  project_config.md             ← project config (tracked — see "Getting project_config.md" above)
  context/                      ← domain overview, module map, user stories (not committed)
  reference/                    ← spec sheets, Confluence exports, detailed docs (not committed)
    business-rules/             ← principles + shared references for Business Rules
    navigation/                 ← shared navigation patterns
    ui-behavior/                ← principles + shared references for UI Behavior
    messages/                   ← shared message templates and wording conventions

workspace/                      ← per-feature working area (not committed)
  <feature-name>/
    input/                      ← env_<slug>.md, context_<slug>.md, idea_<slug>.md
    docs/                       ← generated BA doc sections (Brief through Messages)
    ba_doc_<slug>.md            ← final packaged document
```

> slug = kebab-case folder name with `-` replaced by `_` (e.g. `cancel-pr` → `cancel_pr`)
