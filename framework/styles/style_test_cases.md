# Style: Test Cases

Applies to `test_cases_<slug>.md` documents.

---

## Output Format

`test_cases_<slug>.md` never carries its own `Assumptions & Gaps` table — that table is unified and lives only in `test_scenarios_<slug>.md`'s `## 1. Assumptions & Gaps` (see `style_test_scenarios.md`). Any new unclear point found while writing Test Cases gets appended as a new row directly into that same table (editing `test_scenarios_<slug>.md`), not written here.

```md
## 2. Test Cases

### Classification & Traceability

| TC ID | Scenario | Mapped To | Priority | Test Focus | Automatable | Scope |
|---|---|---|---|---|---|---|
| TC-001 | S1 | <AC/BR id or Investigation reference> | P0 | Functional | Yes | BE, FE, Mobile |

### Detailed Test Cases

### TC-001: <Clear, business-readable title>

- **Scenario:** S1
- **Automatable:** Yes | No | Partial
- **Test Focus:** Functional | Validation | UI | UX | Permission | Business Rule | State Transition | API | Error Handling | Security
- **Scope:** <comma-separated subset of BE, FE, Mobile>

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

Omit the `Preconditions` bullet, `Test Data` table, or `UI` block for a given Test Case when not applicable — do not write "N/A".

---

## Section Heading

- `test_cases_<slug>.md` itself always uses `## 2. Test Cases` as its own top-level heading (this file is written independently of whether `test_scenarios_<slug>.md` ended up with 1 or 2 top-level sections). `/package` renumbers this heading in the combined `qa_doc_<slug>.md` to continue sequentially from `test_scenarios_<slug>.md`'s last top-level number — see `package.md`.
- Fixed order within this file: `### Classification & Traceability` → `### Detailed Test Cases` → `### Coverage Summary`.

---

## Numbering

- Number Test Cases sequentially: `TC-001`, `TC-002`, … (zero-padded to 3 digits).
- `Scenario` must reference an existing `S<N>` ID exactly as used in `test_scenarios_<slug>.md`.

---

## Table Formatting

- `Classification & Traceability` lists every Test Case in the same order they appear in `Detailed Test Cases`.
- `Scope` must be a comma-separated subset of `BE`, `FE`, `Mobile` (never empty) — see `framework/rules/rule_test_cases.md`'s Scope Guideline. Keep the value identical between the `Classification & Traceability` row and the `Detailed Test Cases` bullet for the same Test Case.
- `Test Data` rows use concrete sample values, never placeholders like `<value>`.
- `Coverage Summary` rows cover, at minimum, Test Scenarios, Acceptance Criteria, and Business Rules — add a row for any other Investigation category the feature uses (e.g. Permissions). List any uncovered item with its reason directly under the table.
