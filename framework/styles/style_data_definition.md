# Style: Data Definition

Applies to `data_definition_<slug>.md` documents.

---

## Output Format

```md
## 5. Data Definition

### [Object Name]

| **Field** | **Type** | **Required** | **Editable** | **Default** | **Values** | **Format** | **Sample** | **Description** |
|---|---|---|---|---|---|---|---|---|
| [field] | [type] | Yes/No | Yes/No | [default or blank] | [values or blank] | [format or blank] | [sample or blank] | [description] |

**[Field Name]**

* [Rule]

**[Field Name]**

* [Rule]
```

---

## Section Heading

- Always use `## 5. Data Definition` as the top-level heading.
- Each data object gets a `### [Object Name]` subheading.
- Child objects are defined as separate `### [Child Object Name]` sections following their parent.

---

## Table Formatting

- Use `|---|` column separators (no spaces needed for alignment).
- Blank cells use an empty cell — do not write "N/A" or "-".
- `Required` is blank (not `No`) for system-generated, system-managed, or auto-assigned fields — it is not applicable for those fields.
- Enum values are listed comma-separated in the Values column: `Active, Inactive, Pending`.
- Reference values use the format: `ref: [Object Name]`.
- If a column has no value in any row of a given table, remove that column from that table. Each object table is evaluated independently — a column kept in one table may be omitted in another.

---

## Field Validation Rules Formatting

- Start each field block with a bold heading: `**[Field Name]**`
- Use a bullet list under each heading.
- Only include fields that have at least one rule.
- Omit the Field Validation Rules block entirely if no fields have rules.

---

## Ordering

- Define parent objects before child objects.
- Within a table, follow the field order from the source; if not specified, put required fields first, then optional fields.
