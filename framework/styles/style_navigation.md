# Style: Navigation

Applies to `navigation_<slug>.md` documents.

---

## Output Format

```md
## 6. Navigation

### [Entry Page]

Click "[Action]" button → Navigate to [Target Page]

### [Main Page]

Click "[Action]" button → [Result]

### [Dialog / Sub Page]

Click "[Action]" button → [Result]
```

---

## Section Heading

- Always use `## 6. Navigation` as the top-level heading.
- Each page or dialog gets a `### [Page Name]` subheading.
- Use the exact page/dialog name from the source.

---

## Navigation Entry Formatting

- Each navigation action is one line: `Click "[Label]" button → [Result]`
- Use double quotes around button/link labels.
- Use `→` (arrow) to separate the trigger from the result.
- Describe the result concisely:
  - Navigate to a page: `Navigate to [Target Page]`
  - Open a dialog: `Open [Dialog Name] dialog`
  - Close a dialog: `Close dialog`
  - Return to a page: `Return to [Page Name]`
- One action per line.
- Do not add inline conditions or explanations — those belong in AC.

---

## Ordering

- List sections in order: Entry Page → Main Page → Dialog/Sub Page.
- Within each section, list actions in logical user flow order.
