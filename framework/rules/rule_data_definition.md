# Rule: Data Definition

## Main Principle

Data Definition describes business data objects, their fields, field-level validation rules, and related constraints.

Do not repeat business rules or acceptance criteria behaviors already covered elsewhere unless they are field-level validations that belong to the Data Definition layer.

---

## Writing Quality

- Use present tense.
- Use consistent field names from the source.
- Do not add inferred fields not present in the source.
- Do not include UI labels or layout behavior.
- Do not repeat the same validation across multiple fields; state it once under the relevant field.

---

## Scope Boundary

Data Definition describes data objects and their field-level behavior.

Do not use Data Definition for:

- Business-level constraints that span multiple objects or statuses (→ Business Rules)
- Workflow transitions or process steps (→ Acceptance Criteria)
- Permission enforcement logic (→ Acceptance Criteria)
- Search behavior (→ Acceptance Criteria)
- Response behavior or messages (→ Acceptance Criteria)
- Processing, audit, notification, or persistence behavior (→ Acceptance Criteria)
- UI behavior or screen layout

---

## Object Structure

For each data object, define:

1. **Field Definition table** — one row per field, using the standard columns.
2. **Field Validation Rules** — one block per field that has rules; skip fields with no rules.

If a child object exists in the source, define it as a separate object with its own Field Definition table and Field Validation Rules.

---

## Object Scope

Include only objects and fields created, updated, viewed, or referenced by the feature.

Do not include unrelated fields from the complete object model.

---

## Field Definition Rules

Use exactly these columns in order:

| **Column**  | **Rule**                                                                          |
| ----------- | --------------------------------------------------------------------------------- |
| Field       | Business field name from the source                                               |
| Type        | Data type: string, number, date, datetime, enum, reference, file, user            |
| Required    | Yes / No / blank — blank when the field is not user-provided (system-generated, system-managed, or auto-assigned) |
| Editable    | Yes / No                                                                          |
| Default     | Default value, system-generated, current user, current timestamp, or blank        |
| Values      | Allowed values, reference target, numeric rule, or blank                          |
| Format      | Date/number/display format if source provides it; otherwise blank                 |
| Sample      | One representative example value for this field; blank if not applicable          |
| Description | Short business description                                                        |

---

## Required Column Rules

- `Required` applies only to user-provided fields.
- User-input field, must be provided → `Required = Yes`.
- User-input field, optional → `Required = No`.
- System-generated, system-managed, or auto-assigned fields → leave `Required` blank (not applicable).

---

## Editable Column Rules

- `Editable` is mandatory for every field.
- User-input fields → `Editable = Yes`.
- System-managed fields → `Editable = No`.
- System-generated fields, audit fields, status fields, and server-assigned values are `Editable = No`.
- If editability is unclear from the source, infer only when the source clearly indicates user input or system-managed behavior.

---

## Field Validation Rules

- Keep each rule to one concise bullet.
- Do not repeat "The system validates" for every bullet.
- Optional field rules apply only when a value is provided.
- System-managed fields must explicitly state their auto-assignment behavior.
- Client-provided values for system-managed fields must be ignored when the source says so.

---

## Validation Scope

- Include only field-level validations.
- Do not repeat object-level business rules.
- Do not include workflow behavior, status transitions, calculations, or cross-entity policies.

---

## Sample Rules

- Use one representative example value.
- Keep samples business-friendly.
- Leave blank when no meaningful example exists.
- Do not use placeholders such as `<value>`.

---

## Description Rules

- Keep descriptions short.
- Describe the business meaning of the field.
- Do not repeat validations, default values, or formats.

---

## Field Attribute Test

Data Definition should describe field attributes and field-level validations.

Business policies, workflow behavior, processing, responses, and UI behavior belong to their respective sections.
