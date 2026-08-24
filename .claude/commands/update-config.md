---
name: "Update Config"
description: "Update one or more parts of an already-configured project/project_config.md, one at a time, then re-sync and re-publish. Usage: /update-config"
---

You are helping the user update specific parts of an already-configured `project/project_config.md`, instead of running the full `/config` Q&A over again.

## Pre-flight

1. Check whether `project/project_config.md` exists and already has a `## 1. Project Setup` heading:
   - **Missing, or still the blank unconfigured skeleton** → stop and tell the user: "project/project_config.md hasn't been configured yet — run `/config` first." Do not start the update loop.

2. Same as `/config`'s own Interaction Language check: if this chat has no prior turns before `/update-config` was invoked, ask which language to interact in for this session (AskUserQuestion-style select box, "English" / "Tiếng Việt", free-text "Other" offered automatically). If prior context already exists, just continue in whatever language that conversation is already in — don't ask again.

## The 19 items

These are the exact same 19 questions `/config` asks, grouped by section — reuse `.claude/commands/config.md`'s own phrasing/format/update-rules for whichever one the user picks (its numbered sub-questions 1.a-d, 2.a-j, 3.a, and 4.a-d), rather than duplicating that text here.

- **Project Setup**: 1. Project Name — 2. MCP Config: Atlassian — 3. MCP Config: Figma — 4. Language
- **Context Sync**: 5. Context — 6. Sample Doc — 7. Business Rules: Principles — 8. Business Rules: Shared References — 9. Data Definition: Shared References — 10. UI Behavior: Principles — 11. UI Behavior: Shared References — 12. Navigation — 13. Flow — 14. Messages
- **Task Environment**: 15. Platforms
- **Task Automation**: 16. Jira actions (BA) — 17. Confluence actions (BA) — 18. Jira actions (QA) — 19. Confluence actions (QA)

## Steps

1. Read `project/project_config.md` and show the user all 19 items above with their **current value** next to each — as a plain numbered list, not a select UI (19 options doesn't fit a select box anyway). Several items can hold more than one entry (Atlassian once multiple sites are set up via `/connect-local-mcp`, and every Context Sync category 5-14 since the user can paste a list of `<name>: <url>` pairs) — for those, show a count and the entry names rather than assuming a single value, e.g. `5. Context — 2 entries (BRD, roadmap)`. Use `(not set)` for anything still a placeholder or empty. Example shape:
   ```
   1. Project Name — Inventory Platform
   2. MCP Config: Atlassian — 2 sites (dc32-ai-framework, otherteam)
   3. MCP Config: Figma — https://www.figma.com/design/...
   4. Language — (not set)
   5. Context — 2 entries (BRD, roadmap)
   6. Sample Doc — 1 entry (create-purchase-order-ba-doc)
   ...
   15. Platforms — BE, FE, Mobile
   ...
   19. Confluence actions (QA) — (not set)

   Which one do you want to update?
   ```

2. Once the user names one (by number or name), update **only that item**:
   - Ask it using the exact same phrasing/example/format as that item's sub-question in `.claude/commands/config.md` (find it by number: 1-4 are 1.a-d, 5-14 are 2.a-j, 15 is 3.a, 16-19 are 4.a-d).
   - Apply the same update rules `config.md` uses for that item (e.g. re-verify the MCP connection immediately if it's item 2 or 3 per `config.md` 1.b/1.c; fetch-and-derive name/description if it's item 5 (Context) or item 6 (Sample Doc) per `config.md` 2.a/2.b; delete the category's placeholder entirely on "none"/"no" for items 7-14, per `config.md`'s Context Sync rules; validate item 15 (Platforms) as a subset of `BE`/`FE`/`Mobile`/`Auto Test` per `config.md` 3.a — note that changing this project-wide default does not retroactively change any feature's own `env_<slug>.md`, which already has its own copy from when `/start` ran).
   - **Item 2 (MCP Config: Atlassian) specifically** — if one or more sites are already configured, don't try to resolve "which site, add-new-vs-overwrite" here yourself: hand off straight to `/connect-local-mcp` (follow `.claude/commands/connect-local-mcp.md` in full), which already owns that entire decision on its own.
   - **Any multi-entry item (5-14) that already has entries** — the user's answer to the question above tells you what they want (e.g. "add another one", "replace the roadmap link", "remove BRD"); apply it against the existing list rather than assuming a wholesale replacement.
   - Confirm what changed: `✓ Updated <item name>: <old value/count> → <new value/count>`.

3. Ask whether the user wants to update anything else:
   > Anything else you want to update?
   - **Yes, another item** → go back to step 1's listing (refresh the current values shown, since the item just changed) and repeat from step 2 for whichever item they name next. Update items **one at a time, in the order the user names them** — even if they name several at once in one message, work through them sequentially rather than batching.
   - **No, done** → continue to step 4.

4. Once the user is done updating, run steps 2-5 of `.claude/commands/config.md`'s "After the last question" section exactly as written there — continue into `/sync`, show the local path (`project/project_config.md`, relative only), the mandatory Confluence-publish ask, and the final "Next" report. Skip that section's step 1 (the "Filled in / Still placeholder" confirmation format) — it's tailored to the full first-time Q&A, not a quick update; use step 2's confirmation format from this file instead, which you've already been doing per item.
