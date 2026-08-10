# Dependencies Writing Rules

Writing quality standards for Feature Dependencies content.

---

## Scope

- List prerequisite features, modules, external systems, or configurations that must already exist, be completed, or be in place before this feature can function.
- Do not list incidental technical implementation details (e.g. specific database tables, internal service calls, infrastructure) unless they represent a genuine external system or configuration precondition.
- List only the forward direction — prerequisites this feature depends on. Do not list features, modules, or systems that depend on this one.

---

## Identifying Dependencies

- Derive dependencies from the idea file's Overview, Process Flow, and Entities & Fields sections, and from the loaded context files (domain overview, module map, user stories).
- A dependency exists when this feature cannot function, or cannot be entered, without a prerequisite feature, module, external system, or configuration already being in place (e.g. a "View X" feature depends on the "Create X" feature since X must exist first; a payment feature depends on a payment gateway being configured).
- Do not infer a dependency from a shared entity alone — the dependency must be a genuine precondition, not just a related feature.
- If the idea file and context do not clearly indicate whether a prerequisite exists, ask the user directly rather than assuming either way — do not skip this check silently, and do not invent a dependency that isn't supported by the source.

---

## Writing Quality

- One row per dependency.
- Name the prerequisite exactly as it is known in the project (same name used elsewhere in context files, prior features, or system/configuration references), not a paraphrase.
- State the reason in one sentence, business-level, using the pattern: "`<Prerequisite>` must already exist/be completed/be configured before `<this feature's action>` can happen."
- If this feature has no dependencies, state that explicitly rather than leaving the section blank or omitting it.

---

## Quality Checklist

- Every dependency is a genuine precondition, not just a related or similar feature
- Each row names one prerequisite and one reason
- No incidental technical implementation details included — only genuine external system or configuration preconditions
- No reverse dependencies (features, modules, or systems depending on this one) included
- "No dependencies" is stated explicitly when applicable, not left blank
