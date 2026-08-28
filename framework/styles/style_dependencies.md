# Style: Dependencies

Applies to `dependencies_<slug>.md` documents.

---

## Output Format

```md
## 2. Dependencies

| Depends On | Reason |
|---|---|
| [Feature/Module/System/Configuration Name] | [Why this prerequisite must exist, be completed, or be configured first] |
```

If there are no dependencies:

```md
## 2. Dependencies

This feature has no dependencies on other features, modules, external systems, or configurations.
```

---

## Section Heading

- Always use `## 2. Dependencies` as the top-level heading.

---

## Table Formatting

- Use a single table, one row per dependency.
- Do not repeat the header row.
- Use the "no dependencies" sentence instead of the table when none exist — do not leave an empty table.
