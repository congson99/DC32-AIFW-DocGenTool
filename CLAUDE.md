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

Used as part of the regular per-feature QA document generation flow.

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
| `/sync` | Fetch the latest content from Confluence into project/context/ and project/reference/ based on project/project_config.md |

This branch does not carry `/config`, `/connect-mcp`, or `/reset` — those live on the `dev/project-config` branch. `/sync` exists on both branches: this branch's `/sync` refreshes project/context/ and project/reference/ directly from Confluence without needing to switch branches, since project_config.md's Context Sync mappings are already available here. See [Getting project_config.md](#getting-projectconfigmd) below for the one-time setup of project_config.md itself, which this branch still cannot configure on its own.

## Getting project_config.md

`project/project_config.md` must already be configured before running `/start` — this branch has no way to configure it itself. In the same clone:
1. Check out `dev/project-config` and run `/config` there (or have your team lead do this once and push it to a `project/<name>` branch).
2. Check out this branch again (`git checkout dev/QA`) — `project/context/` and `project/reference/` are gitignored, so they carry over automatically from the sync above.
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
  status.md                     ← local bookkeeping: last /sync (not committed, not shared)
  context/                      ← domain overview, module map, user stories (not committed)
  reference/                    ← spec sheets, Confluence exports, detailed docs (not committed)
    business-rules/
      principles/                ← general principles for writing Business Rules
      shared-references/         ← rule groups reused across many features
    ui-behavior/
      principles/                ← general UI behavior principles
      shared-references/         ← UI behavior groups reused across many screens
    navigation/                 ← shared navigation patterns
    messages/                   ← shared message templates and wording conventions
    test-scenarios/
      principles/                ← general principles for designing Test Scenarios
      shared-references/         ← reusable Test Scenario groups (see note below)
    test-cases/
      principles/                ← general principles for writing Test Cases
      shared-references/         ← reusable Test Case data/steps (see note below)

workspace/                      ← per-feature working area (not committed)
  <feature-name>/
    input/                      ← env_<slug>.md, context_<slug>.md, test_basis_<slug>.md, assumptions_<slug>.md
    docs/                       ← generated QA doc sections (Test Scenarios, Test Cases, Spec Review)
    qa_doc_<slug>.md            ← final packaged document
```

> slug = kebab-case folder name with `-` replaced by `_` (e.g. `cancel-pr` → `cancel_pr`)

> `gen-test-scenarios`/`gen-test-cases` read `test-scenarios/shared-references/`, `test-cases/principles/`, and `test-cases/shared-references/` if present, but `/config` on `dev/project-config` has no matching Context Sync category yet, so these three currently have no supported way to get populated.
