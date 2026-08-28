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

### Section 2: BDD Quality Review

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

### Section 3: Test Case Quality Review

#### TC-<N>: <Test Case title>

**Scenario:** S<N>

| Criterion | Status | Notes |
|---|---|---|
| Maps to one scenario | ✅ / ⚠️ / ❌ | <notes> |
| Steps are concrete | ✅ / ⚠️ / ❌ | <notes> |
| Test Data is concrete | ✅ / ⚠️ / ❌ | <notes> |
| Preconditions are concrete | ✅ / ⚠️ / ❌ | <notes> |
| Expected Result is deterministic | ✅ / ⚠️ / ❌ | <notes> |
| Scope/Priority/Automatable correctly assigned | ✅ / ⚠️ / ❌ | <notes> |
| No duplicate intent | ✅ / ⚠️ / ❌ | <notes> |

**Overall:** ✅ Good | ⚠️ Needs Improvement (resolved) | ❌ Rewrite Required (resolved)

**Issue (if any):**
- <what was wrong>

**Resolution (if an issue was found):**
> <the fix actually applied to `test_cases_<slug>.md`, or the user's explicit reason for leaving it as-is>

### Section 4: BDD Coverage Matrix

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

### Section 5: Cross-Document & Source Consistency Review

**Cross-document consistency issues found (if any):**

| # | Section A | Section B | Mismatch | Resolution |
|---|---|---|---|---|
| 1 | Test Scenario S3 | Test Case TC-5 | <e.g. S3 expects "Failed to save." but TC-5 asserts "Save failed."> | <which side was changed, or the user's explicit reason to leave the mismatch> |

**Source & project consistency issues found (if any):**

| # | Source | Spec Section | Mismatch | Resolution |
|---|---|---|---|---|
| 1 | Source BA Doc / `project/reference/<path>` | Investigation / Test Scenarios / Test Cases | <what the source/project material says vs. what the spec currently says> | <spec corrected to match the source, or the user's specific, feature-level reason to keep the deviation> |

### Section 6: Overall Summary

| Area | Status | Key Findings |
|---|---|---|
| BDD Quality | ✅ | <summary — all findings already resolved by this point> |
| Test Case Quality | ✅ | <summary> |
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
- Fixed order: Section 1 → 2 → 3 → 4 → 5 → 6, always present in this order.
- Omit `### Section 1: Assumptions & Gaps` only if nothing was flagged during review — every other section is always included, even if a table ends up with zero rows (state that explicitly, e.g. "No BDD quality issues found.").
- Because every finding is resolved before this is shown, Section 6's Area statuses should read ✅ in the normal case — a status is only ⚠️/❌ here if the user explicitly chose to leave that area's issue unresolved (then it must also appear in "Left as-is (with reason)").

---

## Numbering

- AC IDs (`AC-1`, `AC-2`, …) in the BDD Coverage Matrix must match the IDs already used in the Investigation (resolved earlier by `/resolve-assumptions`) — do not renumber them.
- Scenario IDs must match the `S<N>` IDs already used in `test_scenarios_<slug>.md` — do not renumber them, including any newly added during this review.
- Test Case IDs must match the `TC-<N>` IDs already used in `test_cases_<slug>.md` — do not renumber them.
- Number `Assumptions & Gaps`, "Missing scenario candidate", and "Consistency issues" rows independently, starting at `1`.

---

## Table Formatting

- Use the exact status symbols `✅` / `⚠️` / `❌` — do not substitute text like "Pass"/"Fail".
- Keep the BDD Quality Review and Test Case Quality Review criterion tables in the exact row order shown above.
- One `#### BDD-<N>` block per scenario in Section 2.
- One `#### TC-<N>` block per Test Case in Section 3.
