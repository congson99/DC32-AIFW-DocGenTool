# Rule: Acceptance Criteria

## Main Principle

Acceptance Criteria describe expected system behavior at a business level. Each AC must be short, clear, testable, business-focused, and grouped by behavior type.

---

## Writing Quality

- Write ACs from the system's perspective.
- Use present tense.
- Use "The system" when describing system behavior.
- Each AC should describe a single observable behavior.
- Avoid vague terms such as "correctly" or "properly".
- Avoid generic outcomes without observable results.
- Avoid implementation details.
- Do not reference UI/UX elements (page names, screens, tabs, dialogs, buttons, layout/visual placement) — describe system/user behavior only. UI presentation belongs to Navigation, Flow, or UI Behavior.
- Do not mix validation, processing, persistence, and response in one AC.
- Keep AC wording consistent with Business Rules and Messages.
- Keep ACs within the same group at a similar level of detail.
- Do not invent validations, permissions, statuses, calculations, notifications, integrations, or background processes unless supported by the source.

---

## Clarification Required

Before generating any AC, verify the information below. If any item is missing or ambiguous, stop and ask the user — do not assume.

### Ask only if the group is relevant to the feature

| Information needed | Used in group | What to ask if missing |
|---|---|---|
| Search field(s) | Search / Lookup | "What field(s) can the user search by when looking up `<entity>`?" |
| Required fields for validation | Validation | "Which fields are required before saving?" |
| Default values on creation | Default Values | "What default values does the system set on creation?" |

### Always ask — even if source is silent

These groups are commonly omitted from feature descriptions. Always ask if the source does not explicitly address them.

| Information needed | Used in group | What to ask |
|---|---|---|
| Notifications triggered | Notification | "Does this action trigger any notifications (email, in-app, etc.)?" |
| Audit / history logging | Audit / History | "Should this action be recorded in an activity log or history?" |

If the user answers **yes** to either, follow up immediately:
- For Notification: "Please provide the link to the US or feature that defines the notification structure (recipients, triggers, content)."
- For Audit / History: "Please provide the link to the US or feature that defines the activity log structure."

These links will be referenced in the AC. Do not define notification or log structure within the AC of this feature.

Only proceed to generate once all needed information is confirmed.

---

## Group-Specific Rules

> The example sentences below are written in English to illustrate structure and framing only (see `framework/styles/style_general.md`). Apply the same structure in the feature's Document language — do not reuse the English wording verbatim.

- Access Control ACs must use rejection-based framing: "The system rejects the request when the user does not have `<PERMISSION>` permission." Do not use positive framing ("allows only users with…").
- Access Control ACs must name the specific permission constant required, in SCREAMING_SNAKE_CASE format: `<VERB>_<FULL_NOUN>`. Derive from the feature name — expand abbreviations using the project context (e.g., "Create PO" → `CREATE_PURCHASE_ORDER`, "Update PR" → `UPDATE_PURCHASE_REQUEST`). Do not use the abbreviation as-is.
- Search ACs must explicitly state the field(s) the search is performed on. Do not write a search AC without naming the searchable value.
  - Correct: "The system allows products to be searched by name when adding items."
  - Incorrect: "The system allows products to be searched when adding items."
  - If multiple fields are searchable, list them: "…searched by name or code…"
  - Include matching rule and minimum keyword length if present in the source.
- Validation ACs must end with an explicit rejection AC: "The system rejects the request when validation fails." This AC is required whenever there are one or more validation ACs.
- Concurrency ACs: Include only when the source explicitly describes a conflict scenario — such as simultaneous edits to the same record, duplicate submission prevention, or resource contention handling. Do not add a Concurrency AC solely to restate a uniqueness rule (e.g., "PO Number must be unique") — that belongs in Processing. Do not add concurrency ACs solely because multiple users may use the system simultaneously.
  - When included, use the framing: "The system prevents `<conflict>` when `<concurrent scenario>`."
  - Correct: "The system prevents duplicate submission when the same form is submitted multiple times at the same time."
  - Incorrect: "The system ensures each Purchase Order receives a unique Purchase Order Number even when multiple Purchase Orders are created at the same time." — this restates the uniqueness rule, not a conflict scenario.
- Notification ACs must reference the US or feature that defines the notification structure — do not redefine recipients, content, or triggers here. Use the framing: "The system sends notifications when `<event>` — see [US/Feature Name](`<link>`) for notification details."
  - Correct: "The system sends notifications when the Purchase Order is created — see [Notification - Purchase Order](https://...) for notification details."
  - Incorrect: "The system sends an email notification to the requester when the Purchase Order is approved." — defines structure instead of referencing it.
- Audit / History ACs must reference the US or feature that defines the activity log structure — do not redefine what is captured here. Use the framing: "The system records `<action>` in the activity log when `<event>` — see [US/Feature Name](`<link>`) for log structure."
  - Correct: "The system records the creation event in the Purchase Order activity log when the Purchase Order is created — see [Audit Log - Purchase Order](https://...) for log structure."
  - Incorrect: "The system records Supplier, PO Number, Created By, and timestamp in the activity log." — defines log fields instead of referencing them.

---

## Granularity Rules

- Required field validations of the same type (simple "must be provided/selected" checks on the same level) may be combined into one AC listing all fields. Do not combine validations that have structurally different conditions.
  - Correct: "The system requires Supplier and Expected Delivery Date to be provided before saving."
  - Incorrect to combine: "The system requires Supplier and at least one item before saving." — these are structurally different conditions.
  - Do not apply this grouping to Default Values, Processing, or other groups — those remain one AC per behavior.
- Each distinct field default or status value must be its own AC. Do not combine multiple fields into one AC.
  - Correct: "The system sets Status to `Draft` upon creation." / "The system sets Quantity to `0` upon creation."
  - Incorrect: "The system sets Status to `Draft` and Quantity to `0` upon creation."
- System-generated processing fields (e.g. Created By, Created At, Last Updated At) follow the same one-behavior-per-AC rule, with one exception: fields that are always set to the same value at the same time may be grouped into a single AC.
  - Correct (separate — different values): "The system sets Created By to the current user upon creation." and "The system sets Created At to the current timestamp upon creation." — these have different values so stay separate.
  - Correct (grouped — same value, always together): "The system sets Created At and Last Updated At to the current timestamp upon creation." — both are always the same timestamp at creation, so grouping is valid.
  - Incorrect (mixed grouping): "The system sets Created By, Created At, and Last Updated At upon creation." — Created By has a different value (current user) than the timestamps, so it must not be grouped with them.
- Avoid specifying format, sequence, or generation algorithm in Processing ACs — these are implementation details.
  - Correct: "The system generates a unique Order Number upon creation."
  - Incorrect: "The system generates a unique Order Number in ORD-XXXXXX format, incrementing sequentially from ORD-0000001."
- Data Persistence ACs must be split by data level: one AC for the main record (header information), one AC for items/lines if the feature includes them. Do not combine both into a single AC.
  - Correct: "The system saves Purchase Order information when the Purchase Order is created."
  - Incorrect: "The system saves Supplier, Expected Delivery Date, Notes, and all items when the Purchase Order is created."
