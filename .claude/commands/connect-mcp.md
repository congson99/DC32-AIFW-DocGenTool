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
   Stop parsing at the next `### ` heading.

3. Validate entries:
   - Skip any entry where the URL is still a placeholder (e.g. `<confluence-mcp-url>`).
   - If all entries are placeholders → stop and inform:
     ```
     No MCP URLs configured. Open project/project_config.md and fill in the URLs under "### MCP Config" (under "## 1. Project Setup").
     ```

4. For each valid entry, check whether the connection actually works (e.g. by trying to look up a matching MCP tool for that server — Atlassian tools for an `Atlassian` entry, Figma tools for a `Figma` entry, and so on for any other server name):
   - **If it works** → the entry is connected, nothing more to do.
   - **If it fails (any entry)** → this session cannot run an OAuth flow itself, so tell the user to authorize manually:
     ```
     <Server name> MCP is not connected. To authorize it:
     1. Open claude.ai (web) → Settings → Connectors (or Integrations).
     2. Find "<Server name>" in the list.
     3. Click Connect / Authorize.
     4. Log in and grant access.
     5. Come back here and let me know when it's done, so I can retry the connection.
     ```
     Do not tell the user to "paste the link into the chat" or "follow the prompts" — that mechanism does not work in this environment.

5. After the user confirms they've authorized, re-check the entries that failed. Repeat step 4 if any are still failing.

6. Update `project/status.md` with the MCP connect timestamp, tracked per server (not one shared timestamp). This file is local bookkeeping only (gitignored, never shared or published) — separate from `project/project_config.md`, which is the one tracked/shared file:
   - Get the current date and time at the moment each entry's connection completes.
   - Check if `project/status.md` already exists:
     - **If it exists and already has a `Latest MCP connect:` line** → under that line, update or add a `- <server-name>: YYYY/MM/DD HH:MM:SS` line for each server that was just (re)connected, leaving other servers' lines and any `Latest sync:` / `Latest artifact:` lines untouched.
     - **If it exists but has no `Latest MCP connect:` line yet** → add a `Latest MCP connect:` block as a new line in the file, with one line per connected server.
     - **If `project/status.md` does not exist at all** → create it with this content:
       ```
       # Status

       > Local bookkeeping only — not shared with the team, not published. Tracks the last /connect-mcp, /sync, and /config artifact publish for this project.

       Latest MCP connect:
       - <server-name>: YYYY/MM/DD HH:MM:SS
       ```
   - Use the format `YYYY/MM/DD HH:MM:SS` for each timestamp.

7. Report results:
   ```
   MCP Connection Summary:

   ✓ <server-name> — connected
   ✗ <server-name> — failed: <reason>

   Skipped (no URL): <count> entries
   ```
