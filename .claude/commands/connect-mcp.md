---
name: "Connect MCP"
description: "Connect to MCP servers listed in project/project_config.md. Usage: /connect-mcp"
---

You are connecting to the MCP servers configured for this project.

## Steps

1. Check whether `project/project_config.md` exists:
   - If not → stop and inform the user: "project/project_config.md not found. See README.md for setup."

2. Read `project/project_config.md` and locate the `### MCP Config` subsection under `## 1. Project Setup`. Parse all entries within that subsection. Each entry has this format:
   ```
   - <server-name>: <url>
   ```
   Stop parsing at the next `### ` heading. There can be **more than one Atlassian entry** — a project connected to multiple Jira/Confluence sites (via `/connect-local-mcp`) has one `- Atlassian (<slug>): <url>` line per site, where `<slug>` is always derived from that site's hostname (never a freely-chosen nickname); treat each as its own entry to resolve independently in step 4.

3. Validate entries:
   - Skip any entry where the URL is still a placeholder (e.g. `<confluence-mcp-url>`).
   - If all entries are placeholders → stop and inform:
     ```
     No MCP URLs configured. Open project/project_config.md and fill in the URLs under "### MCP Config" (under "## 1. Project Setup").
     ```

4. **Atlassian entries** — resolve **each Atlassian line independently** (there may be several — see step 2). For each one, check it against **both** possible kinds of connector, since they live under different tool namespaces and can safely stay connected at the same time (no disconnecting needed, ever): the single **global connector** (`mcp__claude_ai_Atlassian__*`, shared across all Atlassian entries) and a **project-scoped connector** specific to this line, if one has been set up via `/connect-local-mcp`. Whichever one's site matches wins.

   For the entry being resolved:
   - Extract its label (slug) from the server-name: `Atlassian (<slug>)`.
   - Extract the hostname from its `<url>`.

   Check the project-scoped candidate **first** — if it resolves, there's no need to call the global connector at all for this entry:
   - Read `.claude/settings.local.json`'s `env.JIRA_BASE_URL_<ENV-LABEL>` (slug uppercased/underscored).
     - **Absent** → no project-scoped candidate exists for this entry. Check the global candidate below.
     - **Present but its hostname doesn't match this entry's `<url>`** → this labeled connection is stale, most likely because `project_config.md`'s URL for this same `Atlassian (<slug>)` line was changed (e.g. via `/update-config`) without re-running `/connect-local-mcp` to match — the slug and the actual configured site have drifted apart. Don't treat this as "not connected"; note explicitly that a previous connection for this label pointed elsewhere, so whatever happens next (see "Neither matches" below) can tell the user that rather than implying nothing was ever set up here. Then check the global candidate below.
     - **Present and its hostname matches this entry** → don't stop at the text match, confirm the connector is actually live: `ToolSearch` for `mcp__atlassian-<slug>__jira_test_account` and call it.
       - **Tool not found at all** → this server key was never approved in this session; treat as no project-scoped candidate (falls through to the "neither matches" handling below, which routes into `/connect-local-mcp` — its own step 1/step 7 recognizes the site is already configured and just activates it, no re-prompting).
       - **Tool found and succeeds** → ✓ live match — this also tells you the `.mcp.json` server key (`atlassian-<slug>`) and tool prefix to use going forward. Resolved — record it (step 8) and move on to the next entry without checking the global candidate at all.
       - **Tool found but fails** (e.g. "No active account configured" — happens when the subprocess was already running before these credentials were saved, such as right after `/reset` then re-adding a site) → self-heal automatically, no user interaction needed: call `jira_add_account` with `id` (the slug), `name`, `url`, `email` (`env.JIRA_USER_EMAIL_<ENV-LABEL>`), and `api_key` (`env.JIRA_API_TOKEN_<ENV-LABEL>`), then retry `jira_test_account`. If it now succeeds → ✓ live match, resolved, move on. If it still fails, report the concrete error — a stale/expired token needs the user to run `/connect-local-mcp` again with a fresh one, not another reload.
   - **Global candidate** — only reached if the project-scoped check above didn't already resolve this entry. Call the global Atlassian MCP's accessible-resources tool once per `/connect-mcp` run (reuse the result across all Atlassian lines) to list every site the currently active connection can reach, and compare this entry's hostname against the `url` field of each returned resource.

   Resolve (only needed when the project-scoped candidate above didn't already resolve the entry on its own):
   - **Global candidate's hostname matches** → ✓ connected via the global connector. Record it (step 8) and move on to the next entry.
   - **Neither matches** → don't lead with a wall of technical state (which one is/isn't configured, what's reachable, etc.) — ask the simple preference question first, in plain terms (never say "project-scoped connector" or "global connector", the user doesn't need that vocabulary), then only check the details relevant to whichever they pick. This is a genuine fixed-choice question (exactly two mutually exclusive options, no free text needed), so ask it with an AskUserQuestion-style select box instead of a plain chat message:
     ```
     Couldn't connect to site "<slug>" (<expected-host>).
     Option 1: Connect through your shared Atlassian account (via claude.ai)
     Option 2: Set up a dedicated connection just for this project
     ```
     - **Dedicated connection for this project** → run `/connect-local-mcp` (follow `.claude/commands/connect-local-mcp.md` in full) for this specific site/label. That command already does its own check for whether one exists and asks add-new-vs-overwrite on its own — don't duplicate or pre-empt that check here.
     - **Shared Atlassian account** → now check whether the global connector currently responds at all:
       - **Not connected at all** → walk them through authorizing it, one step at a time (not as a full list), waiting for confirmation before the next step:
         1. "Open claude.ai (web) → Settings → Connectors (or Integrations)."
         2. "Find 'Atlassian' in the list."
         3. "Click Connect / Authorize, sign in, and grant access."
         4. "Let me know when done so I can re-check the connection."
       - **Connected, but to the wrong site** → tell them what's currently reachable, then walk them through reauthorizing to the right account, one step at a time, waiting for confirmation before the next step:
         1. "Open claude.ai (web) → Settings → Connectors (or Integrations)."
         2. "Find 'Atlassian' in the list — it's already there, just needs switching to the account that can reach <expected-host>."
         3. "Click Reauthorize, sign in with the right account, and grant access."
         4. "Let me know when done so I can re-check the connection."
   - In every case, do not tell the user to "paste the link into the chat" or "follow the prompts" — that mechanism does not work in this environment.

5. **Figma entries** — check by calling a Figma MCP tool (e.g. an identity/whoami-style call). Figma's `project_config.md` entry is a single account's file link, not a separate multi-tenant site the way Atlassian is, so there's no per-URL identity to cross-check — a successful call is the connection check.
   - **If it succeeds** → ✓, nothing more to do.
   - **If not connected** → tell the user to authorize manually. Walk them through it one step at a time (not as a full list) and wait for confirmation before giving the next step:
     1. "Open claude.ai (web) → Settings → Connectors (or Integrations)."
     2. "Find 'Figma' in the list."
     3. "Click Connect / Authorize, sign in, and grant access."
     4. "Let me know when done so I can re-check the connection."
   - Do not tell the user to "paste the link into the chat" or "follow the prompts" — that mechanism does not work in this environment.

6. **Any other server name** — best-effort: try to find a matching MCP tool for that server name. There's no fixed naming convention for arbitrary integrations, so this may not reliably detect a connection; treat a failed lookup the same as "not connected."
   - **If it succeeds** → ✓, nothing more to do.
   - **If not connected** → tell the user to authorize manually. Walk them through it one step at a time (not as a full list) and wait for confirmation before giving the next step:
     1. "Open claude.ai (web) → Settings → Connectors (or Integrations)."
     2. "Find '<Server name>' in the list."
     3. "Click Connect / Authorize, sign in, and grant access."
     4. "Let me know when done so I can re-check the connection."
   - Do not tell the user to "paste the link into the chat" or "follow the prompts" — that mechanism does not work in this environment.

7. After the user confirms they've authorized (or fixed the site mismatch), re-check the entries that failed — except an Atlassian entry that was just routed through `/connect-local-mcp` (the "Dedicated connection" option above): that command already ran its own `jira_test_account` check and reported success/failure directly, so trust that result instead of calling `jira_test_account` a second time here. For every other still-failing entry, repeat step 4, 5, or 6 (whichever type it is).

8. Update `project/status.md` with the MCP connect timestamp, tracked per server (not one shared timestamp) — and per Atlassian **site**, since there can be more than one. This file is local bookkeeping only (gitignored, never shared or published) — separate from `project/project_config.md`, which is the one tracked/shared file:
   - Get the current date and time at the moment each entry's connection completes.
   - For each Atlassian entry specifically, use its full label as the server-name (`Atlassian (<slug>)`, matching `project_config.md`) and append its resolved hostname and which connector was actually used: `[<hostname>] (via project-scoped connector: <server-key>)` or `[<hostname>] (via global connector)` — this is what lets `/sync` and other Jira/Confluence steps know, for a given Confluence/Jira URL, which tool prefix (`mcp__atlassian-<slug>__*`, or `mcp__claude_ai_Atlassian__*`) to call without re-resolving every time.
   - Check if `project/status.md` already exists:
     - **If it exists and already has a `Latest MCP connect:` line** → under that line, update or add a `- <server-name>: YYYY/MM/DD HH:MM:SS` line for each server that was just (re)connected (Atlassian lines get the `[<hostname>] (via ...)` suffix from above), leaving other servers' lines and any `Latest sync:` line untouched.
     - **If it exists but has no `Latest MCP connect:` line yet** → add a `Latest MCP connect:` block as a new line in the file, with one line per connected server.
     - **If `project/status.md` does not exist at all** → create it with this content:
       ```
       # Status

       > Local bookkeeping only — not shared with the team, not published. Tracks the last /connect-mcp and /sync for this project.

       Latest MCP connect:
       - <server-name>: YYYY/MM/DD HH:MM:SS
       ```
       Example with two Atlassian sites:
       ```
       Latest MCP connect:
       - Atlassian (dc32claude): 2026/08/18 10:30:00 [dc32claude.atlassian.net] (via project-scoped connector: atlassian-dc32claude)
       - Atlassian (otherteam): 2026/08/18 10:31:00 [otherteam.atlassian.net] (via global connector)
       - Figma: 2026/08/18 10:31:20
       ```
   - Use the format `YYYY/MM/DD HH:MM:SS` for each timestamp.

9. Report results:
   ```
   MCP Connection Summary:

   ✓ <server-name> — connected [<hostname>] (via project-scoped connector | via global connector, when the entry is Atlassian)
   ⚠ <server-name> — connected, but to the wrong site (expected <expected-host>, reachable: <site-1>, <site-2>, ...)
   ✗ <server-name> — failed: <reason>

   Skipped (no URL): <count> entries
   ```
