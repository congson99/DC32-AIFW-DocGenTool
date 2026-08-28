# Rule: Navigation

## Main Principle

Navigation describes how users enter, leave, and move between pages/dialogs/screens.

---

## Writing Quality

- Keep navigation actions short.
- Separate entry page, main page, and dialog/sub-page if present.
- Do not add validation or processing logic here.
- Do not include implementation selectors.

---

## Section Labeling

Every `### [Page Name]` heading must include a role label in parentheses:

- `### [Page Name] (Entry Page)` — pages the user passes through to reach the feature
- `### [Page Name] (Main Page)` — the primary page of the feature being documented
- `### [Dialog Name] (Dialog)` — dialogs or sub-pages opened from the main page

Rules:
- Exactly one section must be labeled `(Main Page)`.
- All pages navigated before reaching the main page are `(Entry Page)`.
- All dialogs and sub-pages opened from any page are `(Dialog)`.
- Do not omit the label even when there is only one entry page or one dialog.

---

## Scope Boundary

Navigation describes page-level movement triggered by user actions.

Do not use Navigation for:

- Validation behavior (→ Acceptance Criteria)
- Workflow steps (→ Acceptance Criteria)
- Processing steps or system actions (→ Acceptance Criteria)
- Permission checks (→ Acceptance Criteria or Business Rules)
- Data saving or submission behavior (→ Acceptance Criteria)
- Messages and toast notifications
- UI layout or component structure

---

## Navigation Entry Rules

- Include only user-triggered navigation actions.
- Ignore actions that do not change page, dialog, or view.
- Include dialogs only when they represent a navigation destination or confirmation step.
- Ignore validation popups and toast messages.
- One action per line.
- Do not describe system-initiated redirects unless explicitly stated in the source.
- Confirmation dialogs on unsaved changes are a separate sub-page section, not inline conditions.

---

## Granularity Rules

- Do not combine multiple destinations into one action.
- Describe navigation only, not the business operation performed before navigation.

---

## Source Fidelity

- Use the exact button label and page name from the source.
- Do not infer or add page names, actions, or navigation paths not described in the source.
- If any button label, page name, or navigation action is missing from the source, ask the user to clarify before writing the file. Do not use placeholders such as `[?]`, `TBD`, or `...`.

---

## Navigation Action Test

Determine whether an action changes the user's location or view.

Include:

- Page-to-page navigation
- Dialog opening and closing
- Sub-page navigation
- Explicit redirects described in the source
