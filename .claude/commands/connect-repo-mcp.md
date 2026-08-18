---
name: "Connect Atlassian MCP (Project-Scoped)"
description: "Set up a project-scoped Atlassian MCP server (separate from the global one), for connecting to a different Jira/Confluence instance per project. Usage: /connect-repo-mcp"
---

You are setting up a project-scoped Atlassian MCP connection for this repo, separate from any global/user-level Atlassian MCP connector, so this project can talk to a different Jira/Confluence site than the account connected globally.

## What this command automates vs. what you must do by hand

Claude has no tool to enable/disable MCP connectors or to restart its own CLI process, so those two actions cannot be scripted from inside this session. Everything else below — creating the config file, collecting credentials, storing them safely, pinning the MCP package version — is handled automatically by this command.

## Steps

1. Check whether `.mcp.json` already exists and already has a `mcpServers.atlassian` entry:
   - If yes → ask the user to confirm before overwriting: "A project-scoped `atlassian` MCP entry already exists in .mcp.json. Overwrite it? (yes/no)" If declined, stop here.

2. Ask the user for the values needed to connect, in one friendly, direct message rather than a bare list. If the site URL is already known (e.g. passed in from `/connect-mcp`), only ask for the email and API token:
   ```
   Mình sẽ giúp bạn thiết lập kết nối Atlassian riêng cho project này, Email tài khoản Atlassian và API token của bạn là gì? (Nếu chưa có API token, tạo tại: https://id.atlassian.com/manage-profile/security/api-tokens)
   ```
   Otherwise (site URL not yet known), also ask for it in the same message: Jira/Confluence site URL (e.g. `https://mycompany.atlassian.net`), Atlassian account email, and Atlassian API token (same link as above if they don't have one).

3. Look up the current published version of the MCP package: run `npm view @bodywave/jira-mcp version`. This is a third-party package executed via `npx` with real Jira credentials in its environment, so pin it to this exact version rather than leaving it on `latest` — otherwise the code that actually runs could change silently between sessions without the user noticing.

4. Create or update `.mcp.json` in the project root (this file's location is fixed — Claude Code only auto-loads project-scoped MCP servers from `.mcp.json` at the root of the directory `claude` is launched from):
   ```json
   {
     "mcpServers": {
       "atlassian": {
         "command": "npx",
         "args": ["-y", "@bodywave/jira-mcp@<version from step 3>"],
         "env": {
           "JIRA_URL": "${JIRA_URL}",
           "JIRA_EMAIL": "${JIRA_EMAIL}",
           "JIRA_API_KEY": "${JIRA_API_KEY}"
         }
       }
     }
   }
   ```
   This file only holds variable references, never the real credentials, so it's safe to commit. If `.mcp.json` already has other `mcpServers` entries, add `atlassian` alongside them rather than overwriting the whole file.

5. Check whether `project/.mcp.env` is listed in `.gitignore` (as `project/.mcp.env`, or a broader pattern that already covers it — e.g. the project already ignores the whole `project/` folder):
   - If not → add `project/.mcp.env`, so the credentials file from the next step never gets committed.

6. Write the three values collected in step 2 into `project/.mcp.env`, overwriting it if it already exists (create the `project/` folder first if it somehow doesn't exist):
   ```
   export JIRA_URL="<value>"
   export JIRA_EMAIL="<value>"
   export JIRA_API_KEY="<value>"
   ```

7. The remaining steps require the terminal and cannot run from inside this session. Do not report a technical checklist of what was set up (no "pinned to version", "gitignored", etc.) — just walk the user through the remaining steps themselves. Give them ONE step at a time, each command in its own fenced code block (so it's copyable), and ask them to screenshot the result and send it so you can check it before giving the next step (rather than just asking "did it work?"):
   - **Step 1** — always include the explicit `cd` to the project root, don't assume their terminal is already there:
     ```
     cd <absolute-path-to-project>
     source project/.mcp.env && claude
     ```
   - **Step 2** (after reviewing the step 1 screenshot):
     ```
     /mcp
     ```
     → nếu thấy "atlassian" (global) đang connected, disconnect nó. Chụp màn hình gửi mình xem.
   - **Step 3** (after reviewing the step 2 screenshot):
     ```
     /mcp
     ```
     → chọn "atlassian" (project-scoped) → approve. Chụp màn hình gửi mình xem.
   - **Step 4** (after reviewing the step 3 screenshot) — give the test prompt in its own fenced code block so it's copyable, then ask them to screenshot the result:
     ```
     List my Jira projects.
     ```
   If the user asks why they must do this manually (rather than Claude running it), only then explain: Claude has no tool to enable/disable MCP connectors or restart its own CLI process, so those two actions can't be scripted from inside this session — everything else was already done automatically.

## Example project structure

```text
my-project/
├── .mcp.json          ← committed, no secrets — must stay at project root (Claude Code convention)
├── project/
│   └── .mcp.env       ← gitignored, holds real credentials, cleared by /reset
├── src/
└── ...
```
