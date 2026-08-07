# Style: Test Cases

Applies to `test_cases_<slug>.md` documents.

---

## Output Format

```md
## 2. Test Cases

### Assumptions & Gaps

| # | Item | Type | Notes |
|---|---|---|---|
| 1 | <item> | [Explicit] / [Assumed] / [Needs Clarification] | <notes> |

### Classification & Traceability

| TC ID | Scenario | Mapped To | Priority | Test Focus | Automatable |
|---|---|---|---|---|---|
| TC-001 | S1 | <AC/BR id or Test Basis reference> | P0 | Functional | Yes |

### Detailed Test Cases

### TC-001: <Clear, business-readable title>

- **Scenario:** S1
- **Automatable:** Yes | No | Partial
- **Test Focus:** Functional | Validation | UI | UX | Permission | Business Rule | State Transition | API | Error Handling | Security

**Preconditions:**
- User role: <role + permission scope>
- Data state: <what must exist before this test>

**Steps:**
1. <action>
2. <action>

**Test Data:**

| Field | Value | Type |
|---|---|---|
| <field> | <value> | Valid / Invalid / Boundary |

**Expected Result:**

**Functional:**
- <what the system does — clear, testable, deterministic>

**UI (if applicable):**
- <what is displayed>

### Coverage Summary

| Category | Total in Spec | Covered by Test Cases | Gap |
|---|---|---|---|
| Test Scenarios | X | X | 0 |
| Acceptance Criteria | X | X | 0 |
| Business Rules | X | X | 0 |
```

Omit the `Assumptions & Gaps` table entirely if nothing new was flagged at the Test Case stage. Omit the `Preconditions` bullet, `Test Data` table, or `UI` block for a given Test Case when not applicable — do not write "N/A".

---

## Section Heading

- Always use `## 2. Test Cases` as the top-level heading.
- Fixed order: `### Assumptions & Gaps` (if any) → `### Classification & Traceability` → `### Detailed Test Cases` → `### Coverage Summary`.

---

## Numbering

- Number Test Cases sequentially: `TC-001`, `TC-002`, … (zero-padded to 3 digits).
- `Scenario` must reference an existing `S<N>` ID exactly as used in `test_scenarios_<slug>.md`.

---

## Table Formatting

- `Classification & Traceability` lists every Test Case in the same order they appear in `Detailed Test Cases`.
- `Test Data` rows use concrete sample values, never placeholders like `<value>`.
- `Coverage Summary` rows cover, at minimum, Test Scenarios, Acceptance Criteria, and Business Rules — add a row for any other Test Basis category the feature uses (e.g. Permissions). List any uncovered item with its reason directly under the table.
