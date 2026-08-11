# Style: Spec Review

Applies to `spec_review_<slug>.md` documents.

---

## Output Format — Strict Order

```md
## Spec Review — <Feature Name>

### Section 1: Assumptions & Gaps

| # | Item | Type | Notes |
|---|---|---|---|
| 1 | <item> | [Explicit] / [Assumed] / [Needs Clarification] | <notes> |

### Section 2: AC Quality Review

#### AC-<N>: <AC title or summary>

| Criterion | Status | Notes |
|---|---|---|
| Testable | ✅ / ⚠️ / ❌ | <notes> |
| Atomic | ✅ / ⚠️ / ❌ | <notes> |
| Unambiguous | ✅ / ⚠️ / ❌ | <notes> |
| Bounded | ✅ / ⚠️ / ❌ | <notes> |
| Actor-aware | ✅ / ⚠️ / ❌ | <notes> |
| Result-clear | ✅ / ⚠️ / ❌ | <notes> |
| In-scope | ✅ / ⚠️ / ❌ | <notes> |

**Overall:** ✅ Good | ⚠️ Needs Improvement | ❌ Rewrite Required

**Issues:**
- <specific issue with suggestion>

**Suggested fix (if needed):**
> <rewritten AC or targeted fix — only if ⚠️ or ❌>

### Section 3: AC Completeness Review

| Question | Status | Notes |
|---|---|---|
| Do ACs cover the Happy Path end-to-end? | ✅ / ⚠️ / ❌ | <notes> |
| Do ACs cover all Alternative Flows stated or implied by the source? | ✅ / ⚠️ / ❌ | <notes> |
| Do ACs cover Negative / Error scenarios? | ✅ / ⚠️ / ❌ | <notes> |
| Do ACs cover all Business Rules listed? | ✅ / ⚠️ / ❌ | <notes> |
| Do ACs cover all steps/branches in the Flow? | ✅ / ⚠️ / ❌ | <notes> |
| Are there duplicate or overlapping ACs? | ✅ None / ⚠️ Some | <notes> |
| Are there ACs that belong to a different feature? | ✅ None / ⚠️ Found | <notes> |

**Missing AC candidates (if any):**

| # | Missing Behavior | Reason / Source |
|---|---|---|
| 1 | <what is not covered> | <which BR / Flow step / implied behavior> |

### Section 4: BDD Quality Review

#### BDD-<N>: <Scenario title>

**Maps to AC:** AC-<N>

| Criterion | Status | Notes |
|---|---|---|
| Maps to one AC | ✅ / ⚠️ / ❌ | <notes> |
| Given meaningful | ✅ / ⚠️ / ❌ | <notes> |
| When is one action | ✅ / ⚠️ / ❌ | <notes> |
| Then is observable | ✅ / ⚠️ / ❌ | <notes> |
| No UI leakage | ✅ / ⚠️ / ❌ | <notes> |
| Title is clear | ✅ / ⚠️ / ❌ | <notes> |

**Overall:** ✅ Good | ⚠️ Needs Improvement | ❌ Rewrite Required

**Issues:**
- <specific issue>

**Suggested fix (if needed):**
> <rewritten scenario or targeted fix>

### Section 5: BDD Coverage Matrix

| AC ID | AC Summary | Scenario(s) | Happy Path | Negative / Alt Flow | Coverage Status |
|---|---|---|---|---|---|
| AC-1 | <summary> | S1, S2 | ✅ | ✅ | ✅ Full |
| AC-2 | <summary> | S3 | ✅ | ⚠️ Missing | ⚠️ Partial |
| AC-3 | <summary> | — | ❌ | ❌ | ❌ Not Covered |

**Coverage Status Legend:**
- ✅ Full — AC is covered by at least one happy path + relevant negative/alt scenario.
- ⚠️ Partial — AC has some coverage but is missing scenarios.
- ❌ Not Covered — no scenario maps to this AC.

**Missing scenario candidates (if any):**

| # | AC ID | Missing Scenario | Type |
|---|---|---|---|
| 1 | AC-<N> | <describe the scenario needed> | Negative / Alt Flow / Edge Case |

### Section 6: Overall Summary

| Area | Status | Key Issues |
|---|---|---|
| AC Quality | ✅ / ⚠️ / ❌ | <summary> |
| AC Completeness | ✅ / ⚠️ / ❌ | <summary> |
| BDD Quality | ✅ / ⚠️ / ❌ | <summary> |
| BDD Coverage | ✅ / ⚠️ / ❌ | <summary> |
| Business Rules Coverage | ✅ / ⚠️ / ❌ | <summary> |
| Flow Coverage | ✅ / ⚠️ / ❌ | <summary> |

**Priority Actions (what to fix first):**
1. <most critical issue>
2. <second priority>
```

Example sentences and anti-pattern quotes in this file (and in `framework/rules/rule_spec_review.md`) are written in English to illustrate structure/pattern only — see `framework/styles/style_general.md`. Write actual review notes in the feature's Document language; keep section headings, table headers, status legend symbols (✅/⚠️/❌), and ID prefixes (`AC`, `BDD`, `S`) in English.

---

## Section Heading

- Top-level heading is `## Spec Review — <Feature Name>`.
- Fixed order: Section 1 → 2 → 3 → 4 → 5 → 6, always present in this order.
- Omit `### Section 1: Assumptions & Gaps` only if nothing was flagged during review — every other section is always included, even if a table ends up with zero rows (state that explicitly, e.g. "No AC quality issues found.").

---

## Numbering

- AC IDs (`AC-1`, `AC-2`, …) must match the IDs already used in the source (Test Basis / original BA Doc) when available — do not renumber them.
- Scenario IDs must match the `S<N>` IDs already used in `test_scenarios_<slug>.md` — do not renumber them.
- Number `Assumptions & Gaps` and "Missing candidate" rows independently, starting at `1`.

---

## Table Formatting

- Use the exact status symbols `✅` / `⚠️` / `❌` — do not substitute text like "Pass"/"Fail".
- Keep the AC Quality Review and BDD Quality Review criterion tables in the exact row order shown above.
- One `#### AC-<N>` block per AC in Section 2; one `#### BDD-<N>` block per scenario in Section 4.
