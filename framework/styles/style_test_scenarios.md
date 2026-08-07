# Style: Test Scenarios

Applies to `test_scenarios_<slug>.md` documents.

---

## Output Format

```md
## 1. Test Scenarios

### Assumptions & Gaps

| # | Item | Type | Notes |
|---|---|---|---|
| 1 | <item> | [Explicit] / [Assumed] / [Needs Clarification] | <notes> |

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

Omit the `Assumptions & Gaps` table entirely if nothing was flagged during review. Omit any group heading entirely if it has no scenarios — do not print an empty group.

---

## Section Heading

- Always use `## 1. Test Scenarios` as the top-level heading.
- Group headings are fixed and always appear in this order when present: `### Assumptions & Gaps`, `### Happy Path`, `### Alternative Flows`, `### Validation Scenarios`, `### Business Rule Scenarios`, `### System Error Scenarios`, `### Edge Cases`, `### State-Based Scenarios`, `### Security Scenarios`.

---

## Numbering

- Number scenarios sequentially across all groups: `S1`, `S2`, `S3`…
- Do not restart numbering per group.
- Number `Assumptions & Gaps` rows independently, starting at `1`.

---

## Scenario Block Formatting

- Each scenario is a bold title line `**S<N> — <Title>**` followed by a Gherkin block: `Given` / `When` / `Then` / `And` lines.
- Keep the Gherkin keywords (`Given`, `When`, `Then`, `And`) in English regardless of the configured Document language — same treatment as fixed markers elsewhere in this framework.
- One blank line between the title and the Gherkin block, and one blank line between scenarios.
- Do not number individual Given/When/Then/And lines.
