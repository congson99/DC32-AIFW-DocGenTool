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

### BA Doc Gen Flow Commands

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

### Other Commands

Used independently, as needed — project configuration and maintenance, not part of the BA doc gen flow.

| Command | Purpose |
|---|---|
| `/check <Feature Name>` | Show doc status and suggest next step |
| `/clear-project` | Delete synced context/reference files, reset project_config.md to its unconfigured state, and clear workspace/ |
| `/clear-workspace` | Delete all feature folders in workspace/ |
| `/config-project` | Interactively build project_config.md via Q&A (the only supported way to configure it) |
| `/connect-mcp` | Connect to MCP servers listed in project_config.md |
| `/sync-project` | Fetch Confluence pages into local project files |

## Structure

```
.claude/commands/               ← slash command definitions (see Commands above)

framework/                      ← reusable rules and styles, domain-agnostic
  framework_config.md           ← edit_framework setting (do not modify)
  rules/                        ← writing/content rules, one file per doc type
  styles/                       ← format rules, one file per doc type + style_general.md

project/                        ← project-level context
  project_config.md             ← project config (tracked — committed unconfigured; run /config-project to set it up locally per project)
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
