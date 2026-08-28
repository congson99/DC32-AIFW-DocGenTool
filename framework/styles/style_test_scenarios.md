# Style: Test Scenarios

Applies to `test_scenarios_<slug>.md` documents.

---

## Output Format

`Assumptions & Gaps` is its own top-level section in this file, never nested inside `Test Scenarios` — it is the single, unified table for the whole feature: rows carried forward from `/resolve-assumptions`, plus any new row surfaced later by `/gen-test-scenarios` or `/gen-test-cases` (the latter appends directly into this same table — see `gen-test-cases.md` — so `test_cases_<slug>.md` never carries its own copy).

```md
## 1. Assumptions & Gaps

| # | Item | Type | Notes |
|---|---|---|---|
| 1 | <item> | [Explicit] / [Assumed] / [Needs Clarification] | <notes> |

## 2. Test Scenarios

### Happy Path

**S1 — <Scenario title>**

Given <precondition>
When <action>
Then <observable outcome>
And <supporting check>

### Alternative Flows

### Validation Scenarios

### Business Rule Scenarios

### System Error Scenarios

### Edge Cases

### State-Based Scenarios

### Security Scenarios
```

Omit `## 1. Assumptions & Gaps` entirely if the table has zero rows (nothing was ever flagged, from `/resolve-assumptions` onward) — when omitted, `Test Scenarios` becomes `## 1. Test Scenarios` instead of `## 2.` (the top-level numbering always starts at `1` with whichever of the two sections is actually present). Omit any group heading entirely if it has no scenarios — do not print an empty group.

---

## Section Heading

- `Assumptions & Gaps`, when present, is always `## 1. Assumptions & Gaps` and always comes first. `Test Scenarios` is `## 2. Test Scenarios` when `Assumptions & Gaps` is present, or `## 1. Test Scenarios` when it's omitted — see Output Format above.
- Group headings inside `Test Scenarios` are fixed and always appear in this order when present: `### Happy Path`, `### Alternative Flows`, `### Validation Scenarios`, `### Business Rule Scenarios`, `### System Error Scenarios`, `### Edge Cases`, `### State-Based Scenarios`, `### Security Scenarios`.

---

## Numbering

- Number scenarios sequentially across all groups: `S1`, `S2`, `S3`…
- Do not restart numbering per group.
- Number `Assumptions & Gaps` rows independently, starting at `1`, and never renumber a row that was already assigned earlier in the pipeline — new rows (from `/gen-test-scenarios` or appended later by `/gen-test-cases`) just continue from the current highest `#`.

---

## Scenario Block Formatting

- Each scenario is a bold title line `**S<N> — <Title>**` followed by a Gherkin block: `Given` / `When` / `Then` / `And` lines.
- Keep the Gherkin keywords (`Given`, `When`, `Then`, `And`) in English regardless of the configured Document language — same treatment as fixed markers elsewhere in this framework.
- One blank line between the title and the Gherkin block, and one blank line between scenarios.
- Do not number individual Given/When/Then/And lines.
