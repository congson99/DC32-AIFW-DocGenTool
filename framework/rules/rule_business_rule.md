# Rule: Business Rules

## Main Principle

Business Rules define business-level constraints and behaviors.

They describe rules that affect multiple fields, objects, statuses, or business processes.

Do not repeat field-level validations or behaviors already covered by Acceptance Criteria unless they represent a business policy or business constraint.

---

## Writing Quality

- Keep each rule short and focused on one business behavior.
- Use present tense.
- Use consistent terminology from Data Definition.
- Do not add inferred rules not present in the source.
- Do not include UI behavior.
- Do not restate field validations, search behavior, response behavior, or Acceptance Criteria.

---

## Scope Boundary

Business Rules describe business policies, constraints, and business-visible behavior.

Do not use Business Rules for:

- Required field validations
- Minimum item count or structural validations
- Search behavior
- Success or error responses
- UI behavior
- Messages
- Processing, audit, or notification behavior already covered by Acceptance Criteria
- Data persistence behavior already covered by Acceptance Criteria
- Default value behavior already covered by Acceptance Criteria unless it represents a business policy
- Entity existence checks that do not represent a business policy

Entity existence checks belong to Validation Acceptance Criteria unless they represent a cross-entity business policy.

---

## Implementation Detail Boundary

Business Rules may include business-visible formats, sequences, and numbering policies when no separate Design Document exists.

Avoid describing implementation mechanisms such as:

- Database tables
- Database sequences
- API endpoints
- Locking strategies
- Algorithms
- Internal services

---

## Include When Present

- Permission enforcement rules
- Numbering or auto-generation rules
- Uniqueness rules
- Status assignment rules
- State transition rules
- Calculation rules
- Cross-field rules
- Cross-entity rules
- External dependency rules
- Concurrency rules
- Referential integrity / deletion constraint rules — whether a record can be deleted while other active records still reference it (e.g. a master-data entity referenced by transactional records). When the source doesn't state this explicitly for an entity that other modules clearly depend on (per the project's module map), do not assume it's unrestricted — ask, or record it under Assumptions & Gaps.

---

## Granularity Rules

- Keep one business behavior per rule.
- Split numbering policies into separate rules when format, uniqueness, sequence, or reset policies are independently meaningful.
- Group fields only when they always share the same policy.

---

## Business Policy Test

Business Rules should describe business policies and business constraints.

Validation, search, processing, persistence, response, audit, notification, and UI behavior belong to Acceptance Criteria.