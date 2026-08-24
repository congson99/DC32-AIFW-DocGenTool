# Rule: Test Cases

## Main Principle

Generate a complete, detailed Test Case package strictly from the Investigation, the Test Scenarios, and the original Source BA Doc. Every Test Case must trace back to exactly one Test Scenario.

---

## What to Do

- Base everything strictly on the provided source — Investigation, Test Scenarios, Source BA Doc, and any UI references.
- One clear validation objective per Test Case.
- Cover Happy Path, Alternative Flows, Negative Scenarios, and Edge Cases (mirroring whatever Test Scenario groups exist).
- Group similar boundary and invalid data into Test Data variations within one Test Case, instead of creating separate Test Cases for each value.
- If verifying UI is large or independent enough to stand alone, create a dedicated UI-focused Test Case rather than folding it into a functional one.
- If a dedicated UI-focused Test Case already exists for an element, do not repeat that same UI expectation inside other functional Test Cases.

---

## What NOT to Do

- Do not invent business rules that are not explicitly stated or strongly implied by the source.
- Do not duplicate Test Cases.
- Do not generate out-of-scope Test Cases, except guardrail tests when the UI or API may expose unsupported behavior.
- Do not treat assumptions as confirmed facts — anything tagged `[Assumed]` or `[Needs Clarification]` in Assumptions & Gaps stays flagged until resolved.
- Do not infer new business behavior from UI screenshots — screenshots are supporting evidence only.

---

## Unclear Points

Same definition and tagging as Test Scenarios (`[Explicit]` / `[Assumed]` / `[Needs Clarification]`) — a point is unclear when it's missing detail needed for deterministic testing, conflicts across sources, is ambiguous, is an unconfirmed implicit rule, isn't fully testable without clarification, or when a Test Scenario conflicts with the source. For every `[Needs Clarification]` item, ask the user before writing the Test Case(s) that depend on it.

---

## Automation Guideline

- **Yes** — stable and deterministic.
- **Partial** — requires complex setup or an external dependency.
- **No** — subjective UX or usability validation.

---

## Scope Guideline

Determine each Test Case's **Scope** — which platform(s) it applies to, drawn from `BE`, `FE`, `Mobile` — using a two-step check. First, resolve the feature's **client platforms**: read the `**Platforms:**` line from `env_<slug>.md` (a comma-separated subset of `BE`, `FE`, `Mobile`, `Auto Test`, cached there by `/investigate` from the Source BA Doc's `## 1. Brief` section — BA's per-feature confirmed value) and take only whichever of `FE`/`Mobile` appear there — this is the client-platform set for the two-step check below. If `env_<slug>.md` has no such line, fall back to the `**Platforms:**` line under `### 3.1 BA` in `project/project_config.md` (the project-wide default). If neither is available, default the client-platform set to `FE` only (never invent `Mobile` for a feature/project that hasn't configured it).

1. **Reachability** — Can the Steps be carried out entirely through the UI (a real user action in the app), using only a BA-defined entry point (see Entry Point Rules)? If no valid UI path exists for the trigger — the action can only be exercised by sending a request directly (e.g. via API) — the Test Case's Scope is `BE` only. Stop here.
2. **Verification** — If reachable through the UI, the Test Case's Scope always includes every platform in the client-platform set resolved above (the source material doesn't distinguish FE-specific from Mobile-specific behavior when both are configured, so a UI-reachable step is assumed to apply to every configured client platform — but never to a platform the project hasn't configured). Then check: does confirming Pass/Fail also require checking something not observable in the UI (a backend/data state, a calculation, a persistence check, an absence-of-change check like "no data is persisted")?
   - No — everything needed to confirm the result is visible in the UI itself → Scope is the client-platform set alone (e.g. `FE`, or `FE, Mobile` if Mobile is configured)
   - Yes — the UI-driven flow also needs a backend-only check beyond what the UI shows → Scope is `BE` plus the client-platform set (e.g. `BE, FE`, or `BE, FE, Mobile` if Mobile is configured)

Write Scope as a comma-separated list of whichever platforms apply, restricted to `BE` plus the project's actual client-platform set — never empty, and never naming a client platform the project hasn't configured.

Do not infer Scope from whether the Expected Result happens to carry a `Functional` and/or `UI` block — a Test Case can legitimately have Steps that run entirely through the UI while its Expected Result omits the `UI` block (per Duplicate Prevention: a UI expectation already covered by a dedicated UI Test Case is not repeated elsewhere). Scope reflects how the Test Case is *executed* (its Steps), not which Expected Result block was written for it.

---

## Priority Guideline

- **P0** — blocker, security issue, data corruption, system unavailable.
- **P1** — core business functionality.
- **P2** — important secondary behavior.
- **P3** — cosmetic or low-impact behavior.

---

## Duplicate Prevention

- Extract all business rules, acceptance criteria, and requirements from the source.
- Group them by unique behavior and outcome.
- Generate only one Test Case per unique observable behavior.
- Put supporting validations into the same Test Case when appropriate, rather than splitting them out.
- Add a case for an edge/boundary value only when its trigger or expected outcome is meaningfully different from an existing case.
- Do not create multiple Test Cases validating the same rule through equivalent paths — merge equivalent boundary/invalid data into Test Data variations instead.
- Do not create multiple Test Cases when the objective, trigger, and expected outcome are already covered by an existing one.
- Review for duplication before finalizing the output.

---

## UI Coverage Rules

Applies when UI screenshots, mockups, or UI references are available. Cover only visible UI elements or behavior the source (Investigation / BA Doc) actually supports:

- Page title, table columns, search input, filter controls, sort indicators, pagination controls, status badges, buttons, links, dialogs, empty states, loading states, error states, validation message locations.

Rules:
- UI references are supporting evidence only — never use them to infer a new business rule not stated in the source.
- If the source defines a validation as inline or field-level, verify the exact display location when the source defines it.
- If a message is API-only, do not expect it to be displayed in the UI, and do not display API-only messages as UI messages.

---

## Common System Page Rules

If the project has configured shared UI references (`### Test Cases — UI References` in `project_config.md`, read live via Figma MCP — commonly Error Page, No Permission Page, 404 Page), reuse them whenever the corresponding state is explicitly defined in the source, instead of redefining that page's behavior inline. Use these pages only for UI flows — keep API-only validations API-focused. If no UI Reference is configured or Figma isn't connected, do not invent the page's appearance — describe only what the Investigation/Source BA Doc states.

---

## Entry Point Rules

- Use only BA-defined entry points to reach a page under test.
- A Test Case that accesses a page via direct URL must use direct URL access only — do not mix in other navigation paths.
- If navigation itself is a distinct business scenario, generate a dedicated navigation Test Case for it rather than folding navigation checks into unrelated cases.
- Do not write generic steps like "Open the page" or "Navigate to the page" unless the source explicitly defines that as the entry point.
- Entry-point steps needed purely to set up an independent Test Case are test setup, not duplicate navigation coverage — they do not conflict with a dedicated navigation Test Case, which validates the navigation behavior itself and is never a substitute for the required setup steps in other cases.
- If no valid BA-defined entry point exists for a required page state, record it in Assumptions & Gaps and ask the user rather than inventing one.

---

## Test Case Fields

- **Preconditions** — only case-specific preconditions (record status, prior data setup); do not restate generic environment setup (e.g. "user is logged in") unless the case specifically depends on it.
- **Steps** — numbered, imperative, concrete ("Enter '0' in the Quantity field", not "Enter an invalid quantity").
- **Test Data** — concrete sample values, never placeholders; reuse sample values from the Investigation's Data Definition when available.
- **Expected Result** — split into **Functional** (system behavior, feedback, state change) and **UI** (what is displayed), omitting UI when not applicable. Wording must match the exact message text from the Investigation's Messages section when the case is about a specific message.

---

## Quality Checklist

- Every Test Case references a real Test Scenario ID
- One clear validation objective per Test Case
- Steps are numbered and concrete, not vague
- Test Data uses real sample values, not placeholders
- Expected Result is observable, deterministic, and matches source wording where applicable
- UI and API behavior are kept separate
- No duplicated Test Cases for the same data variation of the same scenario
- No unsupported assumptions treated as fact
- Classification & Traceability and Coverage Summary are complete
