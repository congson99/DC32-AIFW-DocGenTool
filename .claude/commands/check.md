---
name: "Check Feature Status"
description: "Check which QA documents have been generated for a feature and suggest the next step. Usage: /check <Feature Name>"
---

You are a Senior QA Engineer reviewing documentation progress for a feature.

## Input

`$ARGUMENTS` is the **Feature name** exactly as typed by the user.

- If `$ARGUMENTS` is empty → stop and ask: "Which feature do you want to check? Run `/check <Feature Name>`." Do not list feature folders or guess — `workspace/` may contain multiple features, so a name is always required to disambiguate.

## Feature Name Normalization

1. Apply the same acronym normalization as `/start`'s Feature Name Normalization (`.claude/commands/start.md`) — preserve any acronym already written in full uppercase within `project/context/`, otherwise plain title case. Do not hardcode or restate the acronym list here.
2. Derive folder name: kebab-case (e.g. "Update User Profile" → `update-user-profile`)
3. Derive file slug: replace `-` with `_` (e.g. `update-user-profile` → `update_user_profile`)

## Steps

### 1. Check if the feature folder exists

- If `workspace/<folder-name>/` does not exist → stop and output:

```
Feature `<Feature Name>` not found.

→ Run /start <Feature Name> to initialize it.
```

### 2. Check the 4 macro steps of the flow

The flow now runs as 4 macro steps — the second, third, and fourth steps each execute their own internal sub-parts automatically and back-to-back, so there is no need to track those sub-parts individually. Check each macro step in order, using the file(s) it produces:

| # | Step | Produced by | Files checked |
|---|---|---|---|
| 1 | Start | `/start` | `input/env_<slug>.md`, `input/context_<slug>.md` |
| 2 | Investigate | `/investigate` | `input/investigation_<slug>.md` |
| 3 | Generate & Package | `/gen-doc` (resolve-assumptions → gen-test-scenarios → gen-test-cases → package → review, run automatically in sequence) | `qa_doc_<slug>.md`, plus the `**Review:**` line in `input/env_<slug>.md` |
| 4 | Publish | `/publish` | — (no local file marks this; see below) |

For each step, determine status:

- **Step 1 — Start**: ✓ Ready if both `env_<slug>.md` and `context_<slug>.md` exist and neither still contains an unfilled placeholder (pattern `<...>`). ⚠ "has unfilled placeholders" if either exists but still has one. ✗ Missing if either file doesn't exist.
- **Step 2 — Investigate**: ✓ Ready if `investigation_<slug>.md` exists. ⚠ "has unfilled sections" if it exists but still contains placeholder text (pattern `<...>`) in any section — this does not block progress; later steps will ask about it if the information turns out to be needed. ✗ Missing if it doesn't exist. Do not check this step if Step 1 is not ✓ Ready.
- **Step 3 — Generate & Package**: ✓ Ready if `qa_doc_<slug>.md` exists AND `env_<slug>.md` contains a `**Review:** ✓ Completed` line. ⚠ "Packaged but not yet reviewed — run /review" if `qa_doc_<slug>.md` exists but that line is missing. ✗ Missing if `qa_doc_<slug>.md` doesn't exist. Do not check this step if Step 2 is not ✓ Ready. Do not inspect the intermediate docs (`docs/assumptions_<slug>.md`, `test_scenarios_<slug>.md`, `test_cases_<slug>.md`) individually — `qa_doc_<slug>.md` existing is proof `/package` already required them.
- **Step 4 — Publish**: there is no local artifact that marks a feature as published (`/publish` doesn't write one, and its optional folder-clear step means a fully-published feature may simply no longer have a folder at all — which step 1 already handles by reporting "not found"). Report this step as "○ Ready to publish" once Step 3 is ✓ Ready, otherwise "✗ Not yet".

### 3. Determine the next step

Use this priority order — stop at the first condition that is true:

1. Step 1 missing → next: `/start <Feature Name>`
2. Step 1 has unfilled placeholders → next: "Fill in the placeholders in `env_<slug>.md` / `context_<slug>.md`"
3. Step 2 missing → next: `/investigate <Feature Name>`
4. Step 3 missing → next: `/gen-doc <Feature Name>`
5. Step 3 is ⚠ "Packaged but not yet reviewed" → next: `/review <Feature Name>`
6. Step 4 (all steps 1–3 ready) → next: `/publish <Feature Name>`

### 4. Output the status report

Print the report in this exact format:

```
## Feature Status — <Feature Name>

| Step | Status |
|---|---|
| 1. Start | ✓ Ready / ⚠ Has unfilled placeholders / ✗ Missing |
| 2. Investigate | ✓ Ready / ⚠ Has unfilled sections / ✗ Missing |
| 3. Generate & Package | ✓ Ready / ✗ Missing |
| 4. Publish | ○ Ready to publish / ✗ Not yet |

→ Next step: <command or action to take>
```

- Use `✓ Ready` when the step's file(s) exist with no detected issues.
- Use `⚠ <short issue description>` when the step's file(s) exist but have a problem.
- Use `✗ Missing` / `✗ Not yet` when the step hasn't happened yet.
- The "→ Next step" line must be actionable: either a slash command the user can copy-paste, or a clear instruction.
