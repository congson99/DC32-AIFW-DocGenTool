# Rule: Resolve Assumptions

## Main Principle

Before any Test Scenario or Test Case generation begins, review the Investigation on its own terms — every unclear point, and the quality/completeness of its Acceptance Criteria — and get the user to confirm or resolve each one. This way `/gen-test-scenarios`, `/gen-test-cases`, and `/review` can all build on an already-agreed, already-solid Investigation instead of each re-deriving (and re-asking about) it, and instead of `/review` discovering AC-level problems only after Test Scenarios/Test Cases were already generated from a flawed AC.

This assesses:
1. Whether every unclear point in the Investigation and the Source BA Doc has been surfaced and resolved with the user.
2. Whether each AC is well-written.
3. Whether the ACs are complete and correct relative to the feature intent — including full coverage of every Business Rule listed in the Investigation (Business Rules are not scored as their own quality dimension the way ACs are).

`/review`, which runs later once Test Scenarios/Test Cases exist, does not re-evaluate AC quality/completeness — it takes the Investigation's AC list as already-resolved ground truth and builds the BDD Coverage Matrix from it.

---

## Unclear Points

A point in the source is unclear if it meets any of:

1. Missing detail required for deterministic testing (e.g. a max length not defined).
2. Conflicting descriptions across requirements, flows, or rules.
3. Ambiguous wording allowing multiple interpretations.
4. An implicit business rule that is not explicitly confirmed.
5. Behavior described but not fully testable without clarification.

Every unclear point goes into the combined findings list with a tag:
- `[Explicit]` — clearly stated in the source, recorded here only because it's a load-bearing assumption worth surfacing.
- `[Assumed]` — inferred but not confirmed by the source.
- `[Needs Clarification]` — cannot proceed without an answer.

No row may remain `[Needs Clarification]` once the resolved list is written — every item must be resolved to `[Explicit]` or `[Assumed]` first.

---

## What Makes a Good AC

Evaluate each AC/BR item from the Investigation's `Business Rules & Validations` and `Permissions` sections against these 7 criteria. Reuse the original ID (e.g. `AC1`) when the Investigation carries one from the Source BA Doc; otherwise assign a new sequential `AC-<N>`. Only an item that fails at least one criterion is a finding — a fully-passing AC does not need to be asked about.

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

## AC Completeness Checks

Cross-reference the Investigation's Flow and Business Rules against the AC list above:

1. Do the ACs cover the Happy Path end-to-end?
2. Do the ACs cover all Alternative Flows stated or implied by the source?
3. Do the ACs cover Negative / Error scenarios?
4. Do the ACs cover all Business Rules listed?
5. Do the ACs cover all steps/branches in the Flow?
6. Are there duplicate or overlapping ACs?
7. Are there ACs that belong to a different feature?

Any question that surfaces a gap becomes a missing-AC-candidate finding — describe what behavior isn't covered and which Business Rule/Flow step/implied behavior it comes from. A question that's already satisfied is not a finding.

---

## What To Do

- Base every identified point on the Investigation and the full Source BA Doc together — the Investigation is a distillation, so re-reading the complete original BA Doc is required to catch what a summary can drop.
- Evaluate each AC individually and holistically against the 7 criteria above.
- Ask about every finding — unclear points, AC quality issues, and AC completeness gaps alike — not only the `[Needs Clarification]` ones; an `[Explicit]`/`[Assumed]` item still needs the user's explicit confirmation before it's recorded as agreed.
- Merge all findings (unclear points, AC quality issues, AC completeness gaps) into one combined, ordered list, and ask about each one at a time, in that order — never batch multiple items into one message.
- Write each question in plain, concrete language a QA/BA can answer without decoding jargon — describe the real situation or what's wrong, then ask a direct question or propose a specific fix, rather than dumping the raw item text/tag/criterion name.
- Apply a confirmed AC fix or a confirmed missing-AC addition directly to `investigation_<slug>.md`.

## What NOT To Do

- Do not accept a bare "skip" for a `[Needs Clarification]` item — it cannot be finalized without an answer.
- Do not treat your own assumption as confirmed fact — every `[Assumed]`/`[Explicit]` item and every AC quality/completeness finding needs the user's explicit "confirm" (or their correction) before it's locked in.
- Do not batch multiple findings into a single question.
- Do not invent business rules or ACs not stated or strongly implied by the Investigation/Source BA Doc.
- Do not raise an AC quality/completeness issue that is clearly out of scope for this feature.
