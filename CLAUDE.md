# QA Documentation Generation Framework

AI-assisted framework for QA Engineers to generate a complete QA documentation set from a single input.

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
    test-scenarios/             ← principles + shared references for Test Scenarios
    test-cases/                 ← principles + shared references for Test Cases

workspace/                      ← per-feature working area (not committed)
  <feature-name>/
    input/                      ← env_<slug>.md, context_<slug>.md, test_basis_<slug>.md
    docs/                       ← generated QA doc sections (Test Scenarios, Test Cases)
    qa_doc_<slug>.md            ← final packaged document
```

> slug = kebab-case folder name with `-` replaced by `_` (e.g. `cancel-pr` → `cancel_pr`)
