# Rule: Messages

## Main Principle

Messages define validation, permission, success, confirmation, and system error messages shown or returned by the system.

---

## Scope

Include messages for the following cases when supported by the source:

- Permission errors
- Validation errors
- Confirmation dialogs
- Success messages
- Business errors
- System errors

Do not include:
- Validation rules or constraints (→ Acceptance Criteria)
- Business policies (→ Business Rules)
- UI layout or display logic (→ UI Behavior)
- API error payloads
- HTTP status codes
- Logging messages
- Audit messages
- Internal exception text
- Technical error messages
- Loading states
- Empty states
- Read-only indicators
- Hidden or disabled controls

---

## Column Rules

**Case** — describe the condition that triggers the message. Be specific enough to distinguish from similar cases.

**Message Type** — use one of: `Validation Error`, `Error`, `Success`, `Confirmation`.

**Source** — use one of: `BE`, `FE`, `BE / FE`.

**UI Display** — describe where and how the message appears. Examples:
- `Inline validation under [Field] field`
- `Inline validation in [Dialog Name]`
- `[List name] validation`
- `Error toast`
- `Success toast`
- `No Permission page`
- `Confirmation dialog`

If the UI state itself is not a message (e.g. a redirect to an error page), leave **Message** blank.

**Message** — use the exact wording from the source. If no wording is provided, write a clear, concise message consistent with the feature context.

---

## Ordering

Order rows in the following sequence:
1. Permission errors
2. Validation errors — in the same order as fields appear in the UI (top to bottom, left to right)
3. Confirmation dialogs
4. Business errors
5. System errors
6. Success messages

---

## Quality Rules

- Do not split BE response messages and UI display messages into separate rows unless explicitly requested.
- Do not add duplicate rows for the same case.
- Validation messages must always specify where they display in **UI Display**.
- Use source messages exactly when provided — do not paraphrase.
- If multiple fields share the same validation rule, write one row per field.
