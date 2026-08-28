# Rule: Flow

## Main Principle

Flow describes the end-to-end business behavior from trigger to completion. It should read like a business use case that can be used by BA, QA, and Developers.

---

## Section Definitions

**Entry** — Describes the trigger event and preconditions required before the feature begins.

**Main Flow** — Describes the successful end-to-end path after the feature is triggered. Includes user actions, system actions, and key processing steps at a business level.

**Alternate Flow** — Describes valid variations of the Main Flow or paths where the Main Flow cannot continue (e.g. permission denied, invalid status, validation failure). Each alternate flow must begin with a user action step that triggers the check or failure — the system cannot reject a request that was never made.

**Secondary Flow** — Describes supporting sub-flows related to the feature but not part of the primary path (e.g. search, add item, remove item).

---

## Required Subsections

- `### Entry` — always required
- `### Main Flow` — always required
- `### Alternate Flows` — optional, include when supported by the source, Acceptance Criteria, or Business Rules
- `### Secondary Flows` — optional, include when described by the source or when supporting interactions are clearly identifiable from the feature behavior

---

## Entry vs Main Flow

Entry contains:

- Trigger events
- Preconditions

Main Flow contains:

- User actions after the trigger
- System actions after the trigger
- Data loading
- Data modification
- Submission
- Validation
- Processing
- Persistence
- Responses

Example (written in English to illustrate structure only — see `framework/styles/style_general.md`; apply the same structure in the feature's Document language):

**Entry**

User clicks Edit on a purchase order.
Purchase order is in Draft status.

**Main Flow**

[Start]
User opens Update Purchase Order page.
System loads purchase order information.
User modifies purchase order information.
User submits the update request.
System validates the purchase order data.
System updates the purchase order.
System returns a success response.
[End]

Entry describes the upstream trigger (the action that leads to the feature) and preconditions. Main Flow starts from when the user is on the feature page. Do not repeat the trigger from Entry as the first step of Main Flow — these must be distinct. The first step of Main Flow must always be the user action that opens the feature page (e.g. "User opens Update Purchase Order page.").

This separation must be applied consistently across all generated flows.

---

## Scope Boundary

Flow describes end-to-end business behavior.

Do not use Flow for:

- UI layout or component structure
- Page navigation (→ Navigation)
- Field definitions (→ Data Definition)
- Business policies (→ Business Rules)
- Acceptance Criteria at the same level of detail
- Message catalogs
- API endpoints
- Database operations
- Internal services or algorithms

---

## Writing Quality

- Write at the business level — not the technical level.
- Main Flow includes user-system interactions that occur after the feature is triggered, including opening the feature, loading data, modifying information, submitting requests, and completing the business process.
- Main Flow describes the successful path from trigger to completion.
- Do not repeat field-level validations already covered by Acceptance Criteria.
- Do not repeat rules already covered by Business Rules.
- Do not repeat field definitions already covered by Data Definition.
- Summarize validation as a single step (e.g. "Validate purchase order data") unless the source explicitly expands it.
- Alternate Flows are separate from Main Flow — do not embed exception branches inside Main Flow.
- Every Alternate Flow must start with a user action step (e.g. "User requests to update a purchase order.", "User submits the update request.") before the system check or rejection step. Do not start an Alternate Flow with a system step.
- Secondary Flows are not failure paths.
- Use `[Start]` and `[End]` markers for Main Flow, Alternate Flows, and Secondary Flows.
- Do not add hidden technical operations.
- Do not collapse detailed source flow into an overly short summary.

---

## Secondary Flow Identification

Supporting interactions that can occur independently within the feature should be modeled as Secondary Flows rather than embedded in the Main Flow.

Do not embed these interactions inside the Main Flow unless they are required for the successful completion of the Main Flow.

When modeled as Secondary Flows, do not repeat the same interaction in the Main Flow.

Examples:

- Search
- Add item
- Edit item
- Remove item
- Upload attachment

---

## AC Boundary

Do not expand individual Acceptance Criteria into separate flow steps.

Examples below are in English to illustrate structure only — write actual output in the feature's Document language.

Prefer:

- Validate purchase order data.

Instead of:

- Validate Supplier.
- Validate Ordered Quantity.
- Validate Product.
- Validate Notes length.

---

## Granularity Rules

- Keep one behavior per step.
- Preserve the order from the source.
- Do not merge alternate paths into the main path.
- Do not combine multiple system behaviors into one line.

---

## Flow Fidelity Test

Preserve the sequence described by the source.

Do not invent:

- Intermediate steps
- Technical operations
- Alternate paths not supported by the source, Acceptance Criteria, or Business Rules
- Error handling not explicitly described

---

## Flow Test

Flow describes what the system does from trigger to completion.

Include when applicable:

- Trigger events and preconditions (Entry)
- User and system interactions at the business level
- Validation (summarized unless source expands it)
- Processing
- Persistence
- Responses
- Alternate paths supported by the source, Acceptance Criteria, or Business Rules

Exclude:

- Navigation
- UI layout
- Field-level validation details (already in AC)
- Business rule details (already in Business Rules)
- Data definition details (already in Data Definition)
- Technical implementation details
