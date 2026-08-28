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

#### AC<N>: <AC title or summary>

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
> <the fix actually applied to `ac_<slug>.md`, or the user's explicit reason for leaving it as-is>

### Section 3: Business Rules Quality Review

#### R<N>: <Rule summary>

| Criterion | Status | Notes |
|---|---|---|
| Single-behavior | ✅ / ⚠️ / ❌ | <notes> |
| Unambiguous | ✅ / ⚠️ / ❌ | <notes> |
| Bounded | ✅ / ⚠️ / ❌ | <notes> |
| In-scope for Business Rules | ✅ / ⚠️ / ❌ | <notes> |
| Consistent terminology | ✅ / ⚠️ / ❌ | <notes> |
| Non-duplicative | ✅ / ⚠️ / ❌ | <notes> |
| Sourced | ✅ / ⚠️ / ❌ | <notes> |

**Overall:** ✅ Good | ⚠️ Needs Improvement (resolved) | ❌ Rewrite Required (resolved)

**Issue (if any):**
- <what was wrong>

**Resolution (if an issue was found):**
> <the fix actually applied to `business_rule_<slug>.md`, or the user's explicit reason for leaving it as-is>

### Section 4: Completeness, Cross-Document & Source Consistency Review

| Question | Status | Notes |
|---|---|---|
| Do ACs cover the Happy Path end-to-end (per Flow's Main Flow)? | ✅ / ⚠️ / ❌ | <notes> |
| Do ACs cover all Alternate/Secondary Flows? | ✅ / ⚠️ / ❌ | <notes> |
| Do ACs cover all validation rules implied by Data Definition (Required, Values, Format)? | ✅ / ⚠️ / ❌ | <notes> |
| Do ACs and Business Rules together cover every permission the feature needs? | ✅ / ⚠️ / ❌ | <notes> |
| Are there duplicate or overlapping ACs/Business Rules? | ✅ None / ⚠️ Some | <notes> |
| Are there ACs or Business Rules that belong to a different feature? | ✅ None / ⚠️ Found | <notes> |
| Does every rejection/validation/success outcome in AC have a matching Messages row? | ✅ / ⚠️ / ❌ | <notes> |

**Missing AC / Business Rule candidates (if any):**

| # | Missing Behavior | Reason / Source | Resolution |
|---|---|---|---|
| 1 | <what is not covered> | <which Flow step / Data Definition field / implied behavior> | <AC/Rule added, or the user's explicit reason it isn't needed> |

**Consistency issues found (if any):**

| # | Section A | Section B | Mismatch | Resolution |
|---|---|---|---|---|
| 1 | AC5 | Business Rule R3 | <e.g. AC5 references permission `APPROVE_PURCHASE_ORDER`; R3 uses `PO_APPROVE` for the same check> | <which side was changed, or the user's explicit reason to leave the mismatch> |

**Source & project consistency issues found (if any):**

| # | Source | Doc Section | Mismatch | Resolution |
|---|---|---|---|---|
| 1 | Investigation file / `project/reference/<path>` | <e.g. Data Definition — Manager field> | <what the source/project material says vs. what the doc currently says> | <doc corrected to match the source, or the user's specific, feature-level reason to keep the deviation> |

### Section 5: Overall Summary

| Area | Status | Key Findings |
|---|---|---|
| AC Quality | ✅ | <summary — all findings already resolved by this point> |
| Business Rules Quality | ✅ | <summary> |
| AC & Business Rules Completeness | ✅ | <summary> |
| Cross-Document Consistency | ✅ | <summary> |
| Source & Project Consistency | ✅ | <summary> |

**Left as-is (with reason):**
- <any finding the user explicitly chose not to fix, and why — e.g. depends on a feature that doesn't exist yet in this project, or a framework-level concern out of scope for this feature>
- _None — every finding was fixed in the docs during this review._ (use this line if nothing was left as-is)
```

Example sentences and anti-pattern quotes in this file (and in `framework/rules/rule_review.md`) are written in English to illustrate structure only — see `framework/styles/style_general.md`. Write actual review notes in the feature's Document language; keep section headings, table headers, status legend symbols (✅/⚠️/❌), and ID prefixes (`AC`, `R`) in English.

---

## Section Heading

- Top-level heading is `## Review — <Feature Name>`.
- Fixed order: Section 1 → 2 → 3 → 4 → 5, always present in this order.
- Omit `### Section 1: Assumptions & Gaps` only if nothing was flagged during review — every other section is always included, even if a table ends up with zero rows (state that explicitly, e.g. "No AC quality issues found.").
- Because every finding is resolved before this is shown, Section 5's Area statuses should read ✅ in the normal case — a status is only ⚠️/❌ here if the user explicitly chose to leave that area's issue unresolved (then it must also appear in "Left as-is (with reason)").

---

## Numbering

- AC IDs (`AC1`, `AC2`, …) must match the IDs already used in `ac_<slug>.md` — do not renumber them, including any newly added during this review.
- Business Rule IDs (`R1`, `R2`, …) must match the IDs already used in `business_rule_<slug>.md` — do not renumber them, including any newly added during this review.
- Number `Assumptions & Gaps`, "Missing candidate", "Consistency issues", and "Source & project consistency issues" rows independently, starting at `1`.

---

## Table Formatting

- Use the exact status symbols `✅` / `⚠️` / `❌` — do not substitute text like "Pass"/"Fail".
- Keep the AC Quality Review and Business Rules Quality Review criterion tables in the exact row order shown above.
- One `#### AC<N>` block per AC in Section 2; one `#### R<N>` block per rule in Section 3.
