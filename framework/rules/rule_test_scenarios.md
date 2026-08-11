# Rule: Test Scenarios

## Main Principle

Generate concise, business-focused Test Scenarios in Gherkin format from the Test Basis (and the original Source BA Doc). Scenarios must be testable, readable, and cover positive, negative, validation, business rule, security, error, and edge cases — focused on observable system behavior, never implementation.

- Extract every business rule and Acceptance Criterion from the source.
- Group them by unique behavior/outcome.
- Generate only one scenario per unique observable behavior.
- Put supporting ACs as extra `And` checks inside that same scenario — do not split them into separate scenarios.
- Add an edge case only when its trigger or outcome is meaningfully different from an existing scenario.
- **Duplication review is a blocking step.** Do not finalize the scenario list until the duplicate-intent review (see below) is complete. If duplicates are found, merge or remove them before writing the file.

---

## Unclear Points

A point in the source is unclear if it meets any of:

1. Missing detail required for deterministic testing (e.g. a max length not defined).
2. Conflicting descriptions across requirements, flows, or rules.
3. Ambiguous wording allowing multiple interpretations.
4. An implicit business rule that is not explicitly confirmed.
5. Behavior described but not fully testable without clarification.

Every unclear point goes into the `Assumptions & Gaps` table with a tag:
- `[Explicit]` — clearly stated in the source, recorded here only because it's a load-bearing assumption worth surfacing.
- `[Assumed]` — inferred but not confirmed by the source.
- `[Needs Clarification]` — cannot proceed without an answer.

For every `[Needs Clarification]` item, ask the user directly and resolve it before generating scenarios that depend on it — do not invent an answer and do not silently proceed. `[Explicit]` and `[Assumed]` items can be recorded and generation can proceed.

---

## Scenario Format

- Title: `S<N> — <short business-readable title>`.
- Body: `Given` / `When` / `Then` / `And` lines, active voice, present tense, concise.
- One objective per scenario.
  - Good: "Reject duplicate `<Field>`"
  - Avoid: "Reject duplicate `<Field>` and invalid `<Other Field>`" (two objectives merged)

---

## Keep Wording Consistent

Prefer these fixed phrases when the outcome matches:
- "The system rejects the request"
- "The system returns validation error"
- "The system returns business error"
- "The system returns success message"
- "No data is persisted"

Avoid long explanations, technical/backend wording, or API implementation details.

---

## Groups & Coverage

Generate scenarios in this fixed order, one group at a time, and omit any group entirely when nothing applies:

1. **Happy Path** — successful creation/update/delete, successful retrieval, successful persistence.
2. **Alternative Flows** — optional fields omitted, trim behavior, maximum valid values, other valid input variations.
3. **Validation Scenarios** — missing required fields, empty after trimming, invalid formats, unsupported characters, exceeding max length, invalid enum values. One validation objective per scenario; always verify persistence behavior (e.g. "no data is persisted") alongside the rejection.
4. **Business Rule Scenarios** — duplicate validation, case-insensitive uniqueness, conditional business rules, cross-entity/dependency validation. Compare against Validation Scenarios first — do not regenerate a scenario here if it's already covered there.
5. **System Error Scenarios** — processing failure, persistence failure, rollback behavior, external dependency failure. Always validate both the error response and that no partial data was persisted.
6. **Edge Cases** — concurrent requests, duplicate submissions, large valid input, special characters, empty-after-trim boundary cases.
7. **State-Based Scenarios** — default states, system-managed fields, state transitions, ignored client-provided system fields. Only generate when the behavior is not already covered elsewhere — do not generate a scenario here solely because a separate AC, Business Rule, or state exists; it must introduce a genuinely new observable outcome.
8. **Security Scenarios** — missing permission, unauthorized access, hidden actions, direct URL access restriction, interrupted permission mid-flow.

---

## Avoid Duplicate Intent

Do not generate multiple scenarios that test the same behavior with only different data values — group those into one scenario instead (data variation belongs to Test Cases, not separate Test Scenarios).

Before finalizing, for every scenario:
1. Identify its primary observable outcome.
2. Compare it against every other scenario already generated.
3. Remove it if that outcome is already verified elsewhere — even if the two scenarios originate from different ACs, Business Rules, or states. A scenario earns its place only by introducing a new observable outcome, never merely because a separate AC/Rule/state exists for it.

---

## Avoid Technical Details

Do not mention database logic, backend processing, API payload structure, or internal implementation, unless the source explicitly requires it for the scenario to be testable.

---

## Quality Checklist

- Every unclear point is captured in Assumptions & Gaps with the correct tag, and every `[Needs Clarification]` item was resolved with the user before use
- Coverage is complete across all applicable groups, in the fixed group order
- No duplicated testing intent — final duplicate review completed
- One observable behavior per scenario
- Titles are short and business-readable
- Wording matches the fixed phrases where applicable
- No technical/implementation details
