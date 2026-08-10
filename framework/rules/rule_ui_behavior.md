# Rule: UI Behavior

## Main Principle

UI Behavior describes how the UI responds to user interactions, permissions, and system state. It covers visibility, editability, and display rules specific to the feature.

---

## Scope Boundary

UI Behavior describes feature-specific UI rules and references applicable shared UI standards.

Do not use UI Behavior for:

- System processing or business logic (→ Acceptance Criteria)
- Data field definitions (→ Data Definition)
- Business policies (→ Business Rules)
- Navigation paths (→ Navigation)
- End-to-end flow steps (→ Flow)
- Message wording or content

---

## Feature-Specific Entries

Include UI behavior that is specific to this feature:

- Visibility rules (e.g. a button visible only when user has a specific permission)
- Read-only or editable states of fields
- Conditional display based on record status or user role
- Disabled states and when they apply

Do not include:

- Generic UI standards already covered by shared reference files
- Validation logic (→ Acceptance Criteria)
- Business rules (→ Business Rules)

---

## Shared UI Behavior References

After generating feature-specific entries, identify which shared UI behavior groups are relevant to the feature.

A group is relevant when the feature contains UI elements governed by that group.

Examples:

- Feature contains a data table → Table group is relevant
- Feature contains an editable form → Edit Form group is relevant
- Feature contains a page header → Page Header group is relevant
- Feature contains a sidebar → Sidebar group is relevant
- Feature displays text content → Text Display group is relevant

Rules:

- Do not copy the contents of reference files into the feature document.
- Append one reference line per relevant group: `**UIN:** [Group Name]: follow General UI Behavior Rules.`
- Only reference groups that are clearly used by the feature.
- Do not infer groups that are not evidenced by the feature source.
- Do not generate references for unrelated groups.

---

## Numbering Rules

- Number all entries sequentially: UI1, UI2, UI3, …
- Feature-specific entries are numbered first.
- Shared references continue the same sequence after feature-specific entries.

---

## Ordering

1. Feature-specific UI behavior entries
2. Shared UI behavior references
