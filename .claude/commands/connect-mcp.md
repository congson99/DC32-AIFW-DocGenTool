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

4. **Atlassian entries** — a tool call succeeding is not enough, since more than one MCP server can expose tools under the same integration name (a project-scoped connector from `/connect-repo-mcp` and the global connector), and only one of them may be the site this project actually points at. Check the **project-scoped MCP first**; only fall back to the **global connector** if the project-scoped one doesn't already give a match:

   a. **Project-scoped check** (`.mcp.json`'s `atlassian` entry, `@bodywave/jira-mcp` package, tools under `mcp__atlassian__*`):
      - If no `mcp__atlassian__*` tool responds at all (not set up for this repo, or not currently enabled) → skip straight to sub-step b, nothing to clean up.
      - If a tool responds → read the `JIRA_URL` value from `project/.mcp.env` and compare its hostname against the expected hostname from this entry's `<url>`:
        - Matches → ✓ connected via the project-scoped MCP. Nothing more to do — move on to the next entry.
        - Doesn't match → this project-scoped entry points at the wrong site and is stale. Remove the `atlassian` entry from `.mcp.json` and delete `project/.mcp.env`, then continue to sub-step b.

   b. **Global connector check** (`mcp__claude_ai_Atlassian__*`): extract the hostname from `<url>`. Call the global Atlassian MCP's accessible-resources tool to list every site the currently active connection can reach, and compare that hostname against the `url` field of each returned resource:
      - Hostname matches one of the accessible resources → ✓ connected via the global connector. Use it. Nothing more to do — move on to the next entry.
      - **No Atlassian MCP tool responds at all (not connected)** → tell the user and guide them to authorize the global connector manually. Walk them through it one step at a time (not as a full list) and wait for confirmation before giving the next step:
        1. "Mở claude.ai (web) → Settings → Connectors (or Integrations)."
        2. "Tìm 'Atlassian' trong danh sách."
        3. "Bấm Connect / Authorize, đăng nhập và cấp quyền."
        4. "Xong báo mình để mình kiểm tra lại kết nối."
      - **The tool responds, but the hostname isn't among the accessible resources (connected to the wrong site)** → tell the user what's currently reachable, then give them 2 options:
        ```
        Kết nối Atlassian toàn cục (global) hiện đang trỏ tới <site-1>, <site-2>, ..., không phải <expected-host> mà project này cần.
        Bạn muốn: (a) kết nối lại global connector cho đúng site này, hay (b) tạo 1 kết nối Atlassian riêng chỉ cho repo này (không đụng tới global connector)?
        ```
        - **(a) Kết nối lại global** → tell the user. Walk them through it one step at a time (not as a full list) and wait for confirmation before giving the next step:
          1. "Chạy `/mcp` và disconnect entry 'atlassian' không trỏ tới `<expected-host>`."
          2. "Reauthorize lại global Atlassian connector cho đúng account qua claude.ai (web) → Settings → Connectors."
          3. "Xong báo mình để mình kiểm tra lại kết nối."
        - **(b) Kết nối riêng cho repo này** → do not run `/connect-repo-mcp` automatically from here. Tell the user to run it themselves whenever they're ready:
          ```
          Chạy /connect-repo-mcp để thiết lập kết nối riêng cho repo này. URL site đã biết sẵn (<expected-host>) nên lệnh đó sẽ chỉ hỏi bạn email và API token thôi.
          ```
          Leave this entry unresolved for now — stop here rather than continuing to step 7 for this entry. Once the user confirms `/connect-repo-mcp` finished and its manual terminal steps are done, they can re-run `/connect-mcp` (or ask you to re-check this entry) to verify.
      - In every case, do not tell the user to "paste the link into the chat" or "follow the prompts" — that mechanism does not work in this environment.

5. **Figma entries** — check by calling a Figma MCP tool (e.g. an identity/whoami-style call). Figma's `project_config.md` entry is a single account's file link, not a separate multi-tenant site the way Atlassian is, so there's no per-URL identity to cross-check — a successful call is the connection check.
   - **If it succeeds** → ✓, nothing more to do.
   - **If not connected** → tell the user to authorize manually. Walk them through it one step at a time (not as a full list) and wait for confirmation before giving the next step:
     1. "Mở claude.ai (web) → Settings → Connectors (or Integrations)."
     2. "Tìm 'Figma' trong danh sách."
     3. "Bấm Connect / Authorize, đăng nhập và cấp quyền."
     4. "Xong báo mình để mình kiểm tra lại kết nối."
   - Do not tell the user to "paste the link into the chat" or "follow the prompts" — that mechanism does not work in this environment.

6. **Any other server name** — best-effort: try to find a matching MCP tool for that server name. There's no fixed naming convention for arbitrary integrations, so this may not reliably detect a connection; treat a failed lookup the same as "not connected."
   - **If it succeeds** → ✓, nothing more to do.
   - **If not connected** → tell the user to authorize manually. Walk them through it one step at a time (not as a full list) and wait for confirmation before giving the next step:
     1. "Mở claude.ai (web) → Settings → Connectors (or Integrations)."
     2. "Tìm '<Server name>' trong danh sách."
     3. "Bấm Connect / Authorize, đăng nhập và cấp quyền."
     4. "Xong báo mình để mình kiểm tra lại kết nối."
   - Do not tell the user to "paste the link into the chat" or "follow the prompts" — that mechanism does not work in this environment.

7. After the user confirms they've authorized (or fixed the site mismatch), re-check the entries that failed. Repeat step 4, 5, or 6 (whichever type of entry it is) if any are still failing.

8. Update `project/status.md` with the MCP connect timestamp, tracked per server (not one shared timestamp). This file is local bookkeeping only (gitignored, never shared or published) — separate from `project/project_config.md`, which is the one tracked/shared file:
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

9. Report results:
   ```
   MCP Connection Summary:

   ✓ <server-name> — connected
   ⚠ <server-name> — connected, but to the wrong site (expected <expected-host>, reachable: <site-1>, <site-2>, ...)
   ✗ <server-name> — failed: <reason>

   Skipped (no URL): <count> entries
   ```
