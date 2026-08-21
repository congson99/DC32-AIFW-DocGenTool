# Rule: Review

## Main Principle

Review the fully generated BA Doc for a feature — Acceptance Criteria (AC), Business Rules (R), Data Definition, Navigation, Flow, UI Behavior, and Messages — to assess:

1. Whether every unclear point in the source (Idea file, project context, and the generated sections themselves) has been surfaced and resolved with the user.
2. Whether each AC is well-written.
3. Whether each Business Rule is well-written.
4. Whether the ACs and Business Rules are complete relative to the feature intent (Brief, Dependencies, Flow, Data Definition).
5. Whether the nine sections are internally consistent with each other — the same field, message, page, or permission referenced in one section must actually exist, and mean the same thing, in the section that owns it.
6. Whether the nine sections are still faithful to the feature's own source (the Idea file and the context files loaded through `context_<slug>.md`) and to the project's shared context/reference material (`project/context/`, `project/reference/`) — nothing silently dropped from the source, nothing invented that contradicts it, and nothing that ignores project-wide ground truth or conventions without a stated reason.

This is a review pass over already-generated artifacts (Brief through Messages, and the packaged `ba_doc_<slug>.md`) — it does not regenerate them wholesale. It runs after `/package` and before `/publish`, as the final quality gate on the whole document set. Unlike a normal generation step, every finding from all five checks above must be resolved with the user before the review finishes — not just recorded for later. The review itself is shown in chat, not written to a file.

---

## What To Do

- Base all judgments strictly on the Idea file, the nine generated sections, and the project context/reference material they were built from.
- Evaluate each AC and each Business Rule individually and holistically.
- Flag missing coverage, ambiguity, contradictions, and cross-document inconsistencies.
- Group related findings where possible — do not repeat the same issue multiple times.
- For every finding (not only unclear points), propose a specific fix and get the user's explicit decision before applying it or moving on.
- If the doc set is large, review in batches and ask before continuing.

---

## What NOT To Do

- Do not invent business rules, fields, messages, or navigation not stated or strongly implied by the source.
- Do not rewrite AC, Business Rules, or any other section without the user's explicit decision on that specific finding first — propose the fix, then apply only what they confirm (or their alternative).
- Do not treat your own assumptions as confirmed facts.
- Do not raise issues that are clearly out of scope for this feature (check the Brief's "Out of scope" list first).
- Do not let a finding go unresolved with a bare "skip" — every finding needs either an applied fix or an explicit, recorded reason it was left as-is.

---

## Unclear Points

A point is unclear if it meets any of:

1. Missing detail needed to write a deterministic AC, Business Rule, or field definition (e.g. a max length or a permission constant not defined).
2. Conflicting descriptions across sections (e.g. Business Rules and Data Definition disagree on a field's default value).
3. Ambiguous wording allowing multiple interpretations.
4. An implicit business rule that is not explicitly confirmed anywhere in the doc set.
5. A cross-document reference (field, message, page, permission) used in one section but not defined in the section that should own it.

Every unclear point goes into the `Assumptions & Gaps` table with a tag:
- `[Explicit]` — clearly stated in the source, recorded here only because it's a load-bearing assumption worth surfacing.
- `[Assumed]` — inferred but not confirmed by the source.
- `[Needs Clarification]` — cannot be finalized without an answer.

For every `[Needs Clarification]` item, ask the user directly — one focused question at a time, in plain language, following the same question style as `/investigate` — and resolve it before finalizing any finding that depends on it. Do not invent an answer and do not silently proceed. `[Explicit]` and `[Assumed]` items can be recorded and the review can continue.

---

## What Makes a Good AC

Same seven criteria `framework/rules/rule_ac.md` already writes by — restated here as a review checklist:

| Criterion | Description |
|---|---|
| Testable | Can be verified objectively — has a clear pass/fail condition. |
| Atomic | Covers exactly one behavior or rule — not bundled with others. |
| Unambiguous | No vague terms (e.g. equivalents of "fast", "easy", "appropriate", "should work"). |
| Bounded | States specific conditions, limits, or constraints — not open-ended. |
| Actor-aware | Clear who does what (user, system, admin, etc.). |
| Result-clear | States what the system does in response — not just what the user does. |
| In-scope | Belongs to this feature — not a different feature or epic. |

**Common AC anti-patterns** (illustrated in English for pattern recognition only — judge the actual AC in the Document language it's written in):
- "The system should be user-friendly" — not testable.
- "Users can create and edit and delete X" — not atomic.
- "The form validates correctly" — vague, no specifics.
- "It works on mobile" — needs an explicit constraint (which breakpoints? which behaviors?).

---

## What Makes a Good Business Rule

Derived from `framework/rules/rule_business_rule.md`'s scope boundary and writing quality — restated here as a review checklist:

| Criterion | Description |
|---|---|
| Single-behavior | Covers exactly one business policy or constraint — not bundled with others. |
| Unambiguous | Clear condition and outcome — no vague terms. |
| Bounded | States specific conditions, limits, or constraints — not open-ended. |
| In-scope for Business Rules | Describes a business policy/constraint (permission enforcement, numbering, uniqueness, status/state transition, calculation, cross-field/cross-entity, concurrency) — not a field validation, search behavior, response, persistence, or UI behavior already owned by AC. |
| Consistent terminology | Uses the same field/object names as Data Definition. |
| Non-duplicative | Doesn't restate an AC's own wording (the same rejection/response sentence copy-pasted) — but a Business Rule stating the *policy* (e.g. a uniqueness or numbering constraint) alongside an AC stating the *testable enforcement/response* for that same policy is the expected pair, not duplication. Only flag it as duplicate when both sides say the same thing from the same angle. |
| Sourced | Traceable to the Idea file / project context — not invented. |

**Common Business Rule anti-patterns:**
- "Product Name is required." — this is a field validation; belongs to AC, not Business Rules.
- "The system rejects the request when another Warehouse already has the same Name." — this is enforcement/response wording; belongs to AC, not Business Rules. (Contrast with "Warehouse Name must be unique across the whole system" — that's the correct Business Rule phrasing: the policy itself, not the system's response to violating it.)
- "Only admins can approve." — needs the actual permission constant, consistent with the one used in the corresponding Access Control AC.

**Not an anti-pattern — the expected policy/enforcement pair:** a Business Rule stating "Warehouse Name must be unique across the whole system" together with an AC stating "The system rejects the request when another Warehouse already has the same Name" is two different things (policy vs. testable response), not the same thing said twice. Do not flag this pairing as duplication or suggest removing either side — flag it only if one side is *missing* (see Section 4's completeness check).

---

## Source Mapping

- **AC** — from `ac_<slug>.md`.
- **Business Rules** — from `business_rule_<slug>.md`.
- **Data Definition** — from `data_definition_<slug>.md`: field names, Required/Default/Values columns, and per-field validation rules.
- **Navigation** — from `navigation_<slug>.md`: page/dialog names and the actions that move between them.
- **Flow** — from `flow_<slug>.md`: Entry, Main Flow, Alternate Flows, Secondary Flows.
- **UI Behavior** — from `ui_behavior_<slug>.md`.
- **Messages** — from `messages_<slug>.md`: one row per message case.
- **Brief** — from `brief_<slug>.md`: the "In scope" / "Out of scope" boundary, used to catch out-of-scope findings before they're raised.
- **Dependencies** — from `dependencies_<slug>.md`: used only to check that a finding isn't actually the responsibility of a dependency, not re-reviewed itself.
- **Idea file** — from `idea_<slug>.md`: the feature's own original source of truth for scope, entities/fields, flow, and business rules — used to check the final doc set didn't drift from, drop, or contradict it during generation.
- **Project Context/Reference** — from every file `context_<slug>.md` lists (mirrors `project/context/`) and every `project/reference/` subfolder relevant to this doc set (`business-rules/principles/`, `business-rules/shared-references/`, `data-definition/shared-references/`, `ui-behavior/principles/`, `ui-behavior/shared-references/`, `navigation/`, `flow/`, `messages/`) — the project-wide ground truth and conventions, used to check the final doc set doesn't ignore or contradict them without a stated reason.

---

## Cross-Document Consistency Checks

Check that references made in one section actually exist, and agree, in the section that owns them:

- Every field an AC or Business Rule names (for validation, default value, or calculation) exists in Data Definition, with a matching Required/Default/Values value.
- Every permission constant an AC or Business Rule names is used consistently everywhere else it appears.
- Every page or dialog a Flow step references exists as a `### [Page Name]` section in Navigation.
- Every rejection/validation/success outcome an AC implies has a corresponding row in Messages (case, message text).
- Every UI Behavior entry that references a specific field or page matches how that field/page is defined in Data Definition/Navigation.
- Terminology (field names, object names, status values) is spelled and cased the same way across every section.
- None of Brief, Dependencies, AC, Business Rules, or Data Definition — the five "business" sections that come before Navigation/Flow/UI Behavior in the pipeline — contain a UI/UX element (a page/screen/tab/dialog name, a button or control label, or a layout/visual-placement description). Flag any found; the content belongs in Navigation, Flow, or UI Behavior instead.

Record each mismatch found as a Consistency Issue (see `framework/styles/style_review.md`), citing both sides of the mismatch (e.g. "AC5 references permission `APPROVE_PURCHASE_ORDER`; Business Rule R3 uses `PO_APPROVE` for the same check").

---

## Source & Project Consistency Checks

This is a different comparison than the one above: not the nine sections against each other, but the finished doc set against where it came from. Check:

- Every entity, field, business rule, permission, and flow step the Idea file states is reflected somewhere in the nine sections — flag anything silently dropped.
- Nothing in the nine sections contradicts the Idea file (e.g. a default value, flow step order, or permission constant that doesn't match what the Idea file says).
- Every object/field that matches an entity defined in `project/reference/data-definition/shared-references/` uses that entity's field definitions as ground truth (type, required-ness, allowed values) — flag any doc field that was re-derived differently instead.
- Every rule, UI behavior, navigation pattern, flow step, or message that should follow a convention in `project/reference/business-rules/`, `ui-behavior/`, `navigation/`, `flow/`, or `messages/` actually aligns with it — flag any place the doc deviates without the source stating a specific reason to.
- Any fact in `project/context/` (module map, user stories, other known features) that a generated section contradicts (e.g. an entity relationship, a naming convention, a permission-constant pattern used elsewhere in the project).

Record each mismatch found as a Source & Project Consistency Issue (see `framework/styles/style_review.md`), citing the source side (Idea file / the specific `project/context/` or `project/reference/` file) and the doc side, e.g. "Idea file's Entities & Fields lists `Manager` with no type given; `project/reference/data-definition/shared-references/entity-glossary.md` defines `Manager: reference: User`; Data Definition currently has it as `string`." When resolving, the doc should normally be corrected to match the source/project ground truth — deviate only when the user gives a specific, feature-level reason to.
