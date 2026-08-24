# Brief Writing Rules

Writing quality standards for Feature Brief content.

---

## Business-Only Scope

Brief describes business intent and outcomes only. Do not reference UI/UX elements anywhere in the document — page names, screens, tabs, dialogs, buttons, or layout/visual placement. Those belong to Navigation, Flow, or UI Behavior. This applies to every section below, not just Goal.

---

## Feature Name

- Use the feature name exactly as provided
- Do not rename, rephrase, expand, or abbreviate
- Preserve capitalization from user input

---

## Goal

- Exactly one sentence
- Active voice, present tense
- Pattern: “Allow [actor] to [action] so [outcome].”
- Describe the business purpose only
- Do not include detailed scope, validations, workflows, permissions, or UI behavior

---

## Platforms

- Copy the value verbatim from `env_<slug>.md`'s `**Platforms:**` line — do not rephrase, reorder, or infer a different set
- This is the authoritative per-feature platform scope; it may differ from the project's default (see `project/project_config.md`'s `### 3.1 BA` template)

---

## In Scope

- Include only capabilities directly delivered by this feature
- Each item represents a distinct user-facing capability
- Start each item with a verb (Create, Update, View, Define, Assign, Approve...)
- Keep items concise and outcome-focused
- Derive from the user's description; do not invent new functionality
- Keep all items at a similar level of abstraction
- Do not include technical implementation details
- Do not list form fields, validations, UI interactions, or sub-steps of another capability
- Do not enumerate specific field names in parentheses (e.g. write "Update basic information", not "Update basic information (Name, Date, Notes)")

Example (in English to illustrate structure only — write actual output in the feature's Document language, see `framework/styles/style_general.md`):

If the feature is "Create Account":

Good:
- Create an Account
- Assign roles
- Activate the Account

Avoid:
- Enter user name
- Enter email address
- Select a role
- Click Save

---

## Out of Scope

- Include only closely related capabilities that are intentionally excluded
- Include any exclusions explicitly mentioned by the user
- Include adjacent operations only when they relate to the same object, workflow, or user task
- Prefer quality over quantity
- If no meaningful exclusions exist, keep the section short rather than inventing exclusions

Examples (in English to illustrate structure only — write actual output in the feature's Document language):

If the feature is "View User Profile", out of scope may include:
- Edit User Profile
- Delete User Profile
- Change User Password

Do NOT include unrelated areas of the system unless explicitly mentioned by the user

Examples of exclusions that should NOT be added:
- User Management
- Reporting
- Inventory Management
- Notification Configuration

---

## Quality Checklist

- Feature name is unchanged from user input
- Goal is exactly one sentence
- Platforms value is copied verbatim from `env_<slug>.md`, not invented or altered
- In Scope items are actions or capabilities
- In Scope and Out of Scope are written at a consistent level of detail
- Out of Scope items are genuinely adjacent to the feature
- No duplicate items between In Scope and Out of Scope
- Out of Scope is concise and focused on boundary clarification rather than exhaustive system listing
- No technical details, validations, API behavior, database rules, or implementation notes