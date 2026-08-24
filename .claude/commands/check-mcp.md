---
name: "Check MCP"
description: "Show every MCP connection currently connected in this session and what it's actually connected to. Usage: /check-mcp"
---

You are producing a read-only status report of **every** MCP server visible in the current session, connected or not, **except** connectors that merely require authentication (those are excluded from the report entirely, not listed with a status) — this does not connect, disconnect, or approve anything, and does not require `project/project_config.md` to exist. Every other server found gets a line with an explicit status; none of those are silently omitted.

## Statuses

- `✓ connected` — live and verified working right now.
- `✗ no active account` — approved/credentialed but the live check failed (e.g. "No active account configured").
- `✗ not connected` — approved/credentialed but the tool group isn't present at all (subprocess not running).
- `⏳ connecting` — session reports it's still establishing (tools not available yet, but not flagged as needing auth).
- `✗ missing credentials` — approved but `.claude/settings.local.json`'s `env` doesn't have the entries this server needs.
- `✗ not approved` — present in `.mcp.json` but not in `enabledMcpjsonServers`.

Connectors the session flags as "requires authentication" are never included — skip them the same way "not connected" servers used to be skipped.

## Steps

1. **Project-scoped connectors** — read `.mcp.json`'s `mcpServers` keys (e.g. `atlassian-<slug>`, or any other project-scoped server that's been added). Before checking each one individually, do a single `ToolSearch` with a shared prefix (e.g. `mcp__atlassian-`) to discover which of these servers' tool groups are present at all in one call, instead of one `ToolSearch` per key. Then, for each key, check `.claude/settings.local.json`'s `enabledMcpjsonServers` list:
   - **Not in that list** → `✗ not approved`.
   - **Approved but its credentials are missing from `.claude/settings.local.json`'s `env`** → `✗ missing credentials`.
   - **Approved and credentials present** → look up its site from `.claude/settings.local.json`'s `env` key (`JIRA_BASE_URL_<ENV-LABEL>` for `atlassian-<slug>`) — this is already known, no tool call needed for the URL itself. But "approved" only means it was authorized at some point, not that the running subprocess actually has a working account right now (e.g. right after `/reset` re-added credentials without a fresh session reload) — so confirm liveness using the batched `ToolSearch` result above: is `mcp__atlassian-<slug>__jira_test_account` present?
     - **Not present at all** → `✗ not connected`.
     - **Present** → call it.
       - **Succeeds** → `✓ connected`, with its site.
       - **Fails** (e.g. "No active account configured") → `✗ no active account` — this is a read-only status check, so don't self-heal it here the way `/connect-mcp`/`/connect-local-mcp` do; just report what's actually true right now.

2. **Global connectors** — gather every `claude.ai <ConnectorName>` the session surfaces across these states, so none are missed (except auth-required ones, which are dropped entirely):
   - Tool groups already present: use ToolSearch (query like `mcp__claude_ai_`) to find which `mcp__claude_ai_<ConnectorName>__*` groups are available now → candidates for `✓ connected`.
   - Connectors the session flagged as "still connecting" → `⏳ connecting`.
   - Connectors the session flagged as "requires authentication" → excluded, don't include them in the report at all.
   For each `✓ connected` candidate, get its destination with a best-effort identity-style call:
   - **Atlassian** → call its accessible-resources tool; report every reachable site's hostname.
   - **Figma** → call a whoami/identity-style tool; report the account/team if returned.
   - **Any other connector** (ClickUp, Linear, Notion, etc.) → try an identity/whoami-style tool if one exists in that group; if none exists or it fails, just report `✓ connected` without a destination (there's no reliable generic way to introspect an arbitrary connector's account).

3. **Any other MCP server** visible in the session that doesn't match a known pattern above: list it by name with whichever status applies, and a destination only if an obvious identity tool exists for it.

4. Report every server found, in one list, grouped by scope (project-scoped first, then global), each line carrying its status:
   ```
   MCP Connections:

   Project-scoped (.mcp.json):
   ✓ atlassian-dc32-ai-framework — https://dc32-ai-framework.atlassian.net
   ✗ atlassian-otherteam — no active account

   Global (claude.ai connectors):
   ✓ Figma — user@example.com (team: Acme)
   ⏳ ClickUp — connecting
   ```
   If a connector is in use by an entry in `project/project_config.md`'s `### MCP Config`, note it inline (e.g. `— in use by "Atlassian (otherteam)" in project_config.md`). Skip this cross-reference entirely if `project/project_config.md` doesn't exist or isn't configured yet.
   If no MCP servers are visible in the session at all, report: "No MCP servers found in this session."
