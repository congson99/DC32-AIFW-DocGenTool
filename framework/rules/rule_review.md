# Rule: Review

## Main Principle

Review the fully generated QA spec for a feature — the BDD-style Test Scenarios and Test Cases — to assess:

1. Whether every unclear point in the source (Investigation, Source BA Doc, Test Scenarios, Test Cases) that surfaces only now (i.e. not already resolved by `/resolve-assumptions`) has been surfaced and resolved with the user.
2. Whether each Test Scenario (BDD) is well-written.
3. Whether each Test Case is well-written — concrete steps, deterministic expected results, and correct Scope/Priority/Automatable assignment per `framework/rules/rule_test_cases.md`.
4. Whether the Test Scenarios fully cover all ACs — the AC list itself comes from the Investigation as already-resolved ground truth (its quality and completeness were evaluated and resolved earlier, in `/resolve-assumptions` — see `framework/rules/rule_resolve_assumptions.md`); this review does not re-evaluate AC quality or re-run AC completeness checks, only whether Test Scenarios map to every AC.
5. Whether the spec is faithful to its own source — the Source BA Doc, the Investigation, and the project's shared context/reference material (`project/context/`, `project/reference/test-scenarios/`, `project/reference/test-cases/`).

This is a review pass over already-generated artifacts (Investigation, Test Scenarios, Test Cases, and the packaged `qa_doc_<slug>.md`) — it does not regenerate them wholesale. It runs after `/package`, as the final quality gate before publishing. Every finding from all four checks above must be resolved with the user before the review finishes — not just recorded for later. The review itself is shown in chat, not written to a file.

---

## What To Do

- Base all judgments strictly on the Investigation, the Source BA Doc, the generated Test Scenarios/Test Cases, and the project context/reference material they were built from.
- Evaluate each Test Scenario individually and holistically.
- Flag missing coverage, ambiguity, contradictions, and quality issues.
- Group related findings where possible — do not repeat the same issue multiple times.
- For every finding (not only unclear points), propose a specific fix and get the user's explicit decision before applying it or moving on.
- If the spec is large, review in batches and ask before continuing.

---

## What NOT To Do

- Do not invent business rules, scenarios, or test data not stated or strongly implied by the source.
- Do not rewrite Test Scenarios or Test Cases without the user's explicit decision on that specific finding first — propose the fix, then apply only what they confirm (or their alternative).
- Do not treat your own assumptions as confirmed facts.
- Do not raise issues that are clearly out of scope for this feature.
- Do not let a finding go unresolved with a bare "skip" — every finding needs either an applied fix or an explicit, recorded reason it was left as-is.
- Do not re-litigate `assumptions_<slug>.md`'s already-resolved rows, or the Investigation's AC quality/completeness already resolved, from `/resolve-assumptions` — carry them forward as-is; only a genuinely new unclear point surfacing during this review gets added to the working list.

---

## Unclear Points

A point is unclear if it meets any of:

1. Missing detail needed for deterministic testing (e.g. a max length not defined).
2. Conflicting descriptions across the Investigation, Source BA Doc, Test Scenarios, or Test Cases.
3. Ambiguous wording allowing multiple interpretations.
4. An implicit business rule that is not explicitly confirmed anywhere in the spec.
5. Behavior described but not fully testable without clarification.

Every unclear point goes into the combined findings list with a tag:
- `[Explicit]` — clearly stated in the source, recorded here only because it's a load-bearing assumption worth surfacing.
- `[Assumed]` — inferred but not confirmed by the source.
- `[Needs Clarification]` — cannot be finalized without an answer.

For every `[Needs Clarification]` item, ask the user directly — one focused question at a time, in plain language — and resolve it before finalizing any finding that depends on it. Do not invent an answer and do not silently proceed. `[Explicit]` and `[Assumed]` items still need an explicit confirmation from the user, not just a record.

---

## What Makes a Good Test Scenario (BDD)

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

## What Makes a Good Test Case

| Criterion | Description |
|---|---|
| Maps to one scenario | References exactly one existing `S<N>` ID, with one clear validation objective. |
| Steps are concrete | Numbered, imperative, concrete actions — not vague ("navigate to X" only via a BA-defined entry point). |
| Test Data is concrete | Real sample values, reusing the Investigation's Data Definition where available — never placeholders. |
| Expected Result is deterministic | Observable, testable pass/fail; message wording matches the Source BA Doc/Investigation exactly when the case is about a specific message. |
| Scope/Priority/Automatable correctly assigned | Scope follows the Scope Guideline's two-step check; Priority and Automatable follow their guidelines — all in `framework/rules/rule_test_cases.md`. |
| No duplicate intent | Doesn't re-test a behavior or data variation already covered by another Test Case. |

**Common Test Case anti-patterns** (illustrated in English for pattern recognition only):
- Steps: "Enter an invalid quantity" — not concrete; should state the exact value used.
- Test Data: `<value>` left as a placeholder instead of a real sample.
- Expected Result: "Shows an error" — not deterministic; should state the exact message.
- Scope marked `BE, FE` for a case whose trigger has no valid UI path (should be `BE` only per the Scope Guideline).
- A second Test Case that only changes one data value from an existing case with the same trigger and outcome — should be a Test Data row instead.

---

## Source Mapping

- **AC** — from the Investigation's `Business Rules & Validations` section (validation-style items) and `Permissions` section, cross-referenced against the original AC IDs when the Source BA Doc carries them. Taken as already-resolved ground truth (`/resolve-assumptions` already evaluated its quality and completeness) — used here only to build the BDD Coverage Matrix, not re-evaluated.
- **BR** — from the Investigation's `Business Rules & Validations` section (policy-style items).
- **Flow** — from the Investigation's `Flow` section (Main Flow / Alternate Flows).
- **BDD / Test Scenarios** — from `test_scenarios_<slug>.md`.
- **Test Cases** — from `test_cases_<slug>.md`.
- **Source BA Doc** — the original document `investigation_<slug>.md` was distilled from (re-fetched via the `**Source BA Doc:**` line in `env_<slug>.md`) — the ground-truth check for whether the Investigation drifted from it.
- **Project Context/Reference** — from every file `context_<slug>.md` lists (mirrors `project/context/`), plus `project/reference/test-scenarios/principles/`, `project/reference/test-scenarios/shared-references/`, `project/reference/test-cases/principles/`, and `project/reference/test-cases/shared-references/` — the project-wide ground truth and conventions.

---

## Cross-Document Consistency Checks

Check that references made in one artifact actually exist, and agree, in the artifact that owns them:

- Every AC/BR the Test Scenarios reference actually exists in the Investigation, with matching wording/intent.
- Every Test Scenario ID (`S1`, `S2`, …) a Test Case maps to actually exists in `test_scenarios_<slug>.md`.
- Terminology (field names, object names, status values, message wording) is spelled and cased the same way across the Investigation, Test Scenarios, and Test Cases.
- Every message wording used in a Test Case matches what the Source BA Doc/Investigation actually states — not a paraphrase.

Record each mismatch found as a Consistency Issue (see `framework/styles/style_review.md`), citing both sides of the mismatch.

---

## Source & Project Consistency Checks

This is a different comparison than the one above: not the generated artifacts against each other, but the finished spec against where it came from. Check:

- Every business rule, validation, flow step, and permission the Source BA Doc states is reflected somewhere in the Investigation and, from there, in Test Scenarios/Test Cases coverage — flag anything silently dropped during distillation.
- Nothing in the Investigation, Test Scenarios, or Test Cases contradicts the Source BA Doc (e.g. a message wording, default value, or permission constant that doesn't match).
- Every scenario/case that should reuse a convention in `project/reference/test-scenarios/principles/`, `test-scenarios/shared-references/`, `test-cases/principles/`, or `test-cases/shared-references/` actually does — flag any place the spec re-derives something from scratch instead of reusing the shared definition, or deviates from a principle without the source stating a specific reason to.
- Any fact in `project/context/` (module map, user stories, other known features) that the Investigation or generated scenarios/cases contradict.

Record each mismatch found as a Source & Project Consistency Issue (see `framework/styles/style_review.md`), citing the source side (Source BA Doc / the specific `project/context/` or `project/reference/` file) and the spec side. When resolving, the spec should normally be corrected to match the source/project ground truth — deviate only when the user gives a specific, feature-level reason to.
