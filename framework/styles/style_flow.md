# Style: Flow

Applies to `flow_<slug>.md` documents.

---

## Output Format

```md
## 7. Flow

### Entry

[Trigger event and preconditions]

### Main Flow

[Start]
[Step]
[End]

### Alternate Flows

#### [Alternate Flow Name]

[Start]
[Step]
[End]

### Secondary Flows

#### [Secondary Flow Name]

[Start]
[Step]
[End]
```

---

## Sections

| Section | Required | Purpose |
|---|---|---|
| `### Entry` | Yes | How the feature is triggered and what preconditions apply |
| `### Main Flow` | Yes | Successful end-to-end behavior after the trigger |
| `### Alternate Flows` | Optional | Paths where the Main Flow cannot continue |
| `### Secondary Flows` | Optional | Supporting sub-flows related to the feature |

- Omit `### Alternate Flows` and `### Secondary Flows` entirely if none are identified.
- Each alternate or secondary flow gets its own `#### [Name]` subheading.

---

## Section Heading

- Always use `## 7. Flow` as the top-level heading.
- Use `### Entry`, `### Main Flow`, `### Alternate Flows`, `### Secondary Flows` as fixed section headings.

---

## Entry Formatting

- Write Entry as plain steps — one per line, no `[Start]`/`[End]` markers.
- Describe the trigger event and any preconditions.
- Keep it short — Entry answers "How does this feature begin?"

Example (in English to illustrate structure only — write actual output in the feature's Document language, see `framework/styles/style_general.md`):
```
### Entry

User clicks Edit on a purchase order.
Purchase order is in Draft status.
```

Entry describes the upstream trigger and preconditions — not the feature page itself. The feature page appears as the first step of Main Flow, not in Entry.

---

## Flow Step Formatting

- Start each Main Flow, Alternate Flow, and Secondary Flow block with `[Start]` on its own line.
- End each block with `[End]` on its own line.
- Write each step on its own line.
- Keep steps concise and action-oriented.
- Write steps in present tense at the business level.
