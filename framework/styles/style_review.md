# Style: Review

Applies to the chat message `/review` shows once every finding has been resolved. This review produces no file — the format below governs the chat output only.

---

## Output Format — Strict Order

```md
## Review — <Feature Name>

### Section 1: Assumptions & Gaps

| # | Item | Type | Notes |
|---|---|---|---|
| 1 | <item> | [Explicit] / [Assumed] | <notes, reflecting the user's confirmation or resolution> |

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

**Overall:** ✅ Good | ⚠️ Needs Improvement (resolved) | ❌ Rewrite Required (resolved)

**Issue (if any):**
- <what was wrong>

**Resolution (if an issue was found):**
> <the fix actually applied to `investigation_<slug>.md`, or the user's explicit reason for leaving it as-is>

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

| # | Missing Behavior | Reason / Source | Resolution |
|---|---|---|---|
| 1 | <what is not covered> | <which BR / Flow step / implied behavior> | <AC added to the Investigation, or the user's explicit reason it isn't needed> |

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

**Overall:** ✅ Good | ⚠️ Needs Improvement (resolved) | ❌ Rewrite Required (resolved)

**Issue (if any):**
- <what was wrong>

**Resolution (if an issue was found):**
> <the fix actually applied to `test_scenarios_<slug>.md`, or the user's explicit reason for leaving it as-is>

### Section 5: BDD Coverage Matrix

| AC ID | AC Summary | Scenario(s) | Happy Path | Negative / Alt Flow | Coverage Status |
|---|---|---|---|---|---|
| AC-1 | <summary> | S1, S2 | ✅ | ✅ | ✅ Full |
| AC-2 | <summary> | S3 | ✅ | ⚠️ Missing | ⚠️ Partial (resolved) |
| AC-3 | <summary> | — | ❌ | ❌ | ❌ Not Covered (resolved) |

**Coverage Status Legend:**
- ✅ Full — AC is covered by at least one happy path + relevant negative/alt scenario.
- ⚠️ Partial — AC has some coverage but is missing scenarios.
- ❌ Not Covered — no scenario maps to this AC.

**Missing scenario candidates (if any):**

| # | AC ID | Missing Scenario | Type | Resolution |
|---|---|---|---|---|
| 1 | AC-<N> | <describe the scenario needed> | Negative / Alt Flow / Edge Case | <scenario added to `test_scenarios_<slug>.md`, or the user's explicit reason it isn't needed> |

### Section 6: Cross-Document & Source Consistency Review

**Cross-document consistency issues found (if any):**

| # | Section A | Section B | Mismatch | Resolution |
|---|---|---|---|---|
| 1 | Test Scenario S3 | Test Case TC-5 | <e.g. S3 expects "Failed to save." but TC-5 asserts "Save failed."> | <which side was changed, or the user's explicit reason to leave the mismatch> |

**Source & project consistency issues found (if any):**

| # | Source | Spec Section | Mismatch | Resolution |
|---|---|---|---|---|
| 1 | Source BA Doc / `project/reference/<path>` | Investigation / Test Scenarios / Test Cases | <what the source/project material says vs. what the spec currently says> | <spec corrected to match the source, or the user's specific, feature-level reason to keep the deviation> |

### Section 7: Overall Summary

| Area | Status | Key Findings |
|---|---|---|
| AC Quality | ✅ | <summary — all findings already resolved by this point> |
| AC Completeness | ✅ | <summary> |
| BDD Quality | ✅ | <summary> |
| BDD Coverage | ✅ | <summary> |
| Cross-Document Consistency | ✅ | <summary> |
| Source & Project Consistency | ✅ | <summary> |

**Left as-is (with reason):**
- <any finding the user explicitly chose not to fix, and why>
- _None — every finding was fixed during this review._ (use this line if nothing was left as-is)
```

Example sentences and anti-pattern quotes in this file (and in `framework/rules/rule_review.md`) are written in English to illustrate structure only — see `framework/styles/style_general.md`. Write actual review notes in the feature's Document language; keep section headings, table headers, status legend symbols (✅/⚠️/❌), and ID prefixes (`AC`, `BDD`, `S`, `TC`) in English.

---

## Section Heading

- Top-level heading is `## Review — <Feature Name>`.
- Fixed order: Section 1 → 2 → 3 → 4 → 5 → 6 → 7, always present in this order.
- Omit `### Section 1: Assumptions & Gaps` only if nothing was flagged during review — every other section is always included, even if a table ends up with zero rows (state that explicitly, e.g. "No AC quality issues found.").
- Because every finding is resolved before this is shown, Section 7's Area statuses should read ✅ in the normal case — a status is only ⚠️/❌ here if the user explicitly chose to leave that area's issue unresolved (then it must also appear in "Left as-is (with reason)").

---

## Numbering

- AC IDs (`AC-1`, `AC-2`, …) must match the IDs already used in the source (Investigation / original BA Doc) when available — do not renumber them, including any newly added during this review.
- Scenario IDs must match the `S<N>` IDs already used in `test_scenarios_<slug>.md` — do not renumber them, including any newly added during this review.
- Number `Assumptions & Gaps`, "Missing candidate", and "Consistency issues" rows independently, starting at `1`.

---

## Table Formatting

- Use the exact status symbols `✅` / `⚠️` / `❌` — do not substitute text like "Pass"/"Fail".
- Keep the AC Quality Review and BDD Quality Review criterion tables in the exact row order shown above.
- One `#### AC-<N>` block per AC in Section 2; one `#### BDD-<N>` block per scenario in Section 4.
