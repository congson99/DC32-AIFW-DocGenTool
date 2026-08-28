# Style: Acceptance Criteria

Applies to `ac_<slug>.md` documents.

---

## Output Format

```md
## 3. Acceptance Criteria

### <Group 1>

**AC1:** <one testable statement>

**AC2:** <one testable statement>

### <Group 2>

**AC3:** <one testable statement>
```

---

## Groups

Use only groups relevant to the feature. The order below is canonical — always follow it:

```
### Access Control
### Search / Lookup
### Validation
### Default Values
### Processing
### Calculation
### Data Persistence
### Concurrency
### Data Consistency
### Notification
### Audit / History
### Response
```

---

## Numbering

- Number ACs sequentially across all groups: AC1, AC2, AC3…
- Do not restart numbering per group.
- Use bold label format: `**AC1:**`
