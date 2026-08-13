---
name: "Connect MCP"
description: "Connect to MCP servers listed in project/project_config.md. Usage: /connect-mcp"
---

You are connecting to the MCP servers configured for this project.

## Steps

1. Check whether `project/project_config.md` exists:
   - If not → stop and inform the user: "project/project_config.md not found. Get it from the dev/config branch first — see README.md § Setup Environment."

2. Read `project/project_config.md` and locate the `### MCP Config` subsection under `## 1. Project Setup`. Parse all entries within that subsection. Each entry has this format:
   ```
   - <server-name>: <url>
   ```
   Stop parsing at the next `### ` heading.

3. Validate entries:
   - Skip any entry where the URL is still a placeholder (e.g. `<confluence-mcp-url>`).
   - If all entries are placeholders → stop and inform:
     ```
     No MCP URLs configured. This branch doesn't edit project_config.md — go to the dev/config branch (in this same clone) and fill in the URLs under "### MCP Config" (under "## 1. Project Setup") there, then come back here and run /connect-mcp again.
     ```

4. For each valid entry, check not just whether a matching MCP tool works, but whether it's actually connected to the same site listed in `<url>` — a tool call succeeding is not enough, since more than one MCP server can expose tools under the same integration name (e.g. a global Atlassian connector and a project-scoped one from `/connect-multiple-atlassian-mcp`), and only one of them may be the site this project actually points at:
   - **Atlassian entries**: extract the hostname from `<url>` (the part between `https://` and the next `/`). Call the Atlassian MCP's accessible-resources tool to list every site the currently active connection can reach, and compare that hostname against the `url` field of each returned resource:
     - Hostname matches one of the accessible resources → connected to the right site → ✓.
     - No Atlassian MCP tool responds at all → not connected → go to the "not connected" branch below.
     - The tool responds, but the hostname isn't among the accessible resources → an Atlassian MCP *is* connected, just to the wrong site → go to the "wrong site" branch below.
   - **Figma entries**: check by calling a Figma MCP tool (e.g. an identity/whoami-style call). Figma's `project_config.md` entry is a single account's file link, not a separate multi-tenant site the way Atlassian is, so there's no per-URL identity to cross-check — a successful call is the connection check.
   - **Any other server name**: best-effort — try to find a matching MCP tool for that server name. There's no fixed naming convention for arbitrary integrations, so this may not reliably detect a connection; treat a failed lookup the same as "not connected."

   - **If connected to the right site (or Figma/other entries that pass)** → nothing more to do.
   - **If not connected at all**:
     - **Atlassian entry** → first ask the user: "Project này cần connect tới một site Atlassian duy nhất, hay bạn cần làm việc với nhiều site Atlassian khác nhau (ví dụ nhiều client/tổ chức)?"
       - **Một site** → tell the user to authorize the global connector manually:
         ```
         Atlassian MCP is not connected. To authorize it:
         1. Open claude.ai (web) → Settings → Connectors (or Integrations).
         2. Find "Atlassian" in the list.
         3. Click Connect / Authorize.
         4. Log in and grant access.
         5. Come back here and let me know when it's done, so I can retry the connection.
         ```
       - **Nhiều site** → this branch doesn't carry `/connect-multiple-atlassian-mcp` — tell the user to go to the `dev/config` branch (in this same clone), run it there using this entry's `<url>` as the site (skip re-asking for it, only provide email/token when prompted), complete its remaining manual terminal steps, then come back to this branch and continue at step 5 below.
     - **Figma or any other server name** → tell the user to authorize manually:
       ```
       <Server name> MCP is not connected. To authorize it:
       1. Open claude.ai (web) → Settings → Connectors (or Integrations).
       2. Find "<Server name>" in the list.
       3. Click Connect / Authorize.
       4. Log in and grant access.
       5. Come back here and let me know when it's done, so I can retry the connection.
       ```
     - In every case, do not tell the user to "paste the link into the chat" or "follow the prompts" — that mechanism does not work in this environment.
   - **If connected to the wrong site** (Atlassian only) → tell the user:
     ```
     An Atlassian MCP is connected, but not to <expected-host> — the currently active connection only reaches: <site-1>, <site-2>, ...
     This usually means a project-scoped Atlassian MCP (from /connect-multiple-atlassian-mcp on dev/config) and the global one are both active and colliding. To fix it:
     1. Run /mcp and disconnect whichever "atlassian" entry does not point at <expected-host>.
     2. If neither does, reauthorize the global Atlassian connector for the right account via claude.ai (web) → Settings → Connectors.
     3. Come back here and let me know when it's done, so I can retry the connection.
     ```

5. After the user confirms they've authorized (or fixed the site mismatch), re-check the entries that failed. Repeat step 4 if any are still failing.

6. Update `project/status.md` with the MCP connect timestamp, tracked per server (not one shared timestamp). This file is local bookkeeping only (gitignored, never shared or published) — separate from `project/project_config.md`, which is the one tracked file on this branch:
   - Get the current date and time at the moment each entry's connection completes.
   - Check if `project/status.md` already exists:
     - **If it exists and already has a `Latest MCP connect:` line** → under that line, update or add a `- <server-name>: YYYY/MM/DD HH:MM:SS` line for each server that was just (re)connected, leaving other servers' lines and any `Latest sync:` line untouched.
     - **If it exists but has no `Latest MCP connect:` line yet** → add a `Latest MCP connect:` block as a new line in the file, with one line per connected server.
     - **If `project/status.md` does not exist at all** → create it with this content:
       ```
       # Status

       > Local bookkeeping only — not shared with the team, not published. Tracks the last /connect-mcp and /sync for this project.

       Latest MCP connect:
       - <server-name>: YYYY/MM/DD HH:MM:SS
       ```
   - Use the format `YYYY/MM/DD HH:MM:SS` for each timestamp.

7. Report results:
   ```
   MCP Connection Summary:

   ✓ <server-name> — connected
   ⚠ <server-name> — connected, but to the wrong site (expected <expected-host>, reachable: <site-1>, <site-2>, ...)
   ✗ <server-name> — failed: <reason>

   Skipped (no URL): <count> entries
   ```
