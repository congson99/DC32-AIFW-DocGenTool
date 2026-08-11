# Rule: Spec Review

## Main Principle

Review the full specification of a feature — Acceptance Criteria (AC), Business Rules (BR), Flow, and BDD-style Test Scenarios — to assess:
1. Whether each AC is well-written.
2. Whether each Test Scenario (BDD) is well-written.
3. Whether the ACs are complete and correct relative to the feature intent.
4. Whether the Test Scenarios fully cover all ACs.

This is a review pass over already-generated artifacts (Test Basis, Test Scenarios) — it does not regenerate them.

---

## What To Do

- Base all judgments strictly on the provided Test Basis (Feature Overview, Business Rules & Validations, Flow, Permissions) and the generated Test Scenarios (`test_scenarios_<slug>.md`).
- Evaluate each AC and each Test Scenario individually and holistically.
- Flag missing coverage, ambiguity, contradictions, and quality issues.
- Group related findings where possible — do not repeat the same issue multiple times.
- If the spec is large, review in batches and ask before continuing.

---

## What NOT To Do

- Do not invent business rules not stated or strongly implied by the source.
- Do not rewrite AC or Test Scenarios unless asked — only flag issues and suggest fixes.
- Do not treat your own assumptions as confirmed facts.
- Do not raise issues that are clearly out of scope for this feature.

---

## When Something Is Unclear

List it explicitly under Assumptions & Gaps. Tag each as:
- `[Explicit]` — clearly stated in the source, recorded here only because it's a load-bearing assumption worth surfacing.
- `[Assumed]` — inferred but not confirmed by the source.
- `[Needs Clarification]` — cannot proceed without an answer; ask the user directly and resolve before finalizing findings that depend on it.

---

## What Makes a Good AC

An AC is well-written when it meets **all** of the following criteria:

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

## What Makes a Good Test Scenario (BDD)

A Test Scenario is well-written when it meets **all** of the following criteria:

| Criterion | Description |
|---|---|
| Maps to one AC | Each scenario targets a single AC or a single behavior — no bundling. |
| Given is meaningful | Sets up a real precondition — not a trivial/empty setup. |
| When is one action | One trigger only — not several actions chained together. |
| Then is observable | Describes system output, not internal state — verifiable from UI/API. |
| No UI leakage | Avoids hardcoded labels/selectors unless testing UI specifically. |
| Title is clear | Title summarizes the behavior being tested, not the steps. |
| Covers the negative | Happy path + at least one alternative or failure path per AC, when applicable. |

**Common Test Scenario anti-patterns** (illustrated in English for pattern recognition only):
- `Given I open the browser` — meaningless precondition.
- `When I fill in all fields and click Submit` — bundled action.
- `Then the system works` — not observable.
- Scenario title = "Test create product" — describes the action, not the behavior.
- Multiple `Then`/`And` lines that each belong to a different AC — should be split.

---

## Source Mapping

- **AC** — from the Test Basis's `Business Rules & Validations` section (validation-style items) and `Permissions` section, cross-referenced against the original AC IDs when the Source BA Doc carries them.
- **BR** — from the Test Basis's `Business Rules & Validations` section (policy-style items).
- **Flow** — from the Test Basis's `Flow` section (Main Flow / Alternate Flows).
- **BDD / Test Scenarios** — from `test_scenarios_<slug>.md`.
