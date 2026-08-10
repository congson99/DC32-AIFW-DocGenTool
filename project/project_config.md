# Project Config

> See README.md § "Configure the Project" for detailed guidance on filling in each section below. Placeholders look like `<this>` — replace them with real values.

---

## 0. Status
Latest MCP connect: 2026/08/07 00:00:00
Latest sync: 2026/08/07 00:00:00
---

## 1. Project Setup

### Project Name

- Warehouse Management System

### MCP Config

- Atlassian: https://confluence.example.com/wiki/spaces/WMS

### Language

- Document language: Vietnamese

---

## 2. Context Sync

### Context

- project/context/wms-brd-summary.md
  url: https://confluence.example.com/wiki/spaces/WMS/pages/100001/BRD+Summary
  desc: Tóm tắt yêu cầu nghiệp vụ tổng thể của hệ thống quản lý kho (WMS).

- project/context/wms-module-map.md
  url: https://confluence.example.com/wiki/spaces/WMS/pages/100002/Module+Map
  desc: Bản đồ các module nghiệp vụ chính của WMS (Receiving, Putaway, Picking, Inventory, Shipping).

### Business Rules — Principles

- project/reference/business-rules/principles/br-writing-principles.md
  url: https://confluence.example.com/wiki/spaces/WMS/pages/100010/BR+Writing+Principles

### Business Rules — Shared References

- project/reference/business-rules/shared-references/br-shared-references.md
  url: https://confluence.example.com/wiki/spaces/WMS/pages/100011/BR+Shared+References

### UI Behavior — Principles

- project/reference/ui-behavior/principles/ui-behavior-principles.md
  url: https://confluence.example.com/wiki/spaces/WMS/pages/100020/UI+Behavior+Principles

### UI Behavior — Shared References

- project/reference/ui-behavior/shared-references/ui-shared-references.md
  url: https://confluence.example.com/wiki/spaces/WMS/pages/100021/UI+Shared+References

### Navigation

- project/reference/navigation/navigation-conventions.md
  url: https://confluence.example.com/wiki/spaces/WMS/pages/100030/Navigation+Conventions

### Messages

- project/reference/messages/message-wording-conventions.md
  url: https://confluence.example.com/wiki/spaces/WMS/pages/100040/Message+Wording+Conventions

---

## 3. Task Environment

```
**BA Task Jira ticket:** <jira-ticket-url>

**Confluence output pages:**
- BA Doc: <confluence-page-url>
- AI Doc folder: <confluence-page-url>
```

---

## 4. Task Automation

### Jira

- Update ticket status to: Done
  jira-project: WMS

- Add Confluence page link as comment on ticket
  jira-project: WMS

### Confluence

- Publish BA Doc as a new page under the "AI Generated BA Docs" folder (see Confluence output pages above)
