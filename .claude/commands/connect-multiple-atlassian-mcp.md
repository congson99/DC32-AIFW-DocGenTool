---
name: "Connect Multiple Atlassian MCP"
description: "Set up a project-scoped Atlassian MCP server (separate from the global one), for connecting to a different Jira/Confluence instance per project. Usage: /connect-multiple-atlassian-mcp"
---

You are setting up a project-scoped Atlassian MCP connection for this repo, separate from any global/user-level Atlassian MCP connector, so this project can talk to a different Jira/Confluence site than the account connected globally.

## What this command automates vs. what you must do by hand

Claude has no tool to enable/disable MCP connectors or to restart its own CLI process, so those two actions cannot be scripted from inside this session. Everything else below — creating the config file, collecting credentials, storing them safely, pinning the MCP package version — is handled automatically by this command.

## Steps

1. Check whether `.mcp.json` already exists and already has a `mcpServers.atlassian` entry:
   - If yes → ask the user to confirm before overwriting: "A project-scoped `atlassian` MCP entry already exists in .mcp.json. Overwrite it? (yes/no)" If declined, stop here.

2. Ask the user for the three values needed to connect:
   - Jira/Confluence site URL (e.g. `https://mycompany.atlassian.net`)
   - Atlassian account email
   - Atlassian API token — if they don't have one, point them to: https://id.atlassian.com/manage-profile/security/api-tokens

3. Look up the current published version of the MCP package: run `npm view @bodywave/jira-mcp version`. This is a third-party package executed via `npx` with real Jira credentials in its environment, so pin it to this exact version rather than leaving it on `latest` — otherwise the code that actually runs could change silently between sessions without the user noticing.

4. Create or update `.mcp.json` in the project root:
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

5. Check whether `.mcp.env` is listed in `.gitignore`:
   - If not → add it, so the credentials file from the next step never gets committed.

6. Write the three values collected in step 2 into `.mcp.env` in the project root, overwriting it if it already exists:
   ```
   export JIRA_URL="<value>"
   export JIRA_EMAIL="<value>"
   export JIRA_API_KEY="<value>"
   ```

7. Report what was set up and give the user the exact remaining steps, since these require the terminal and cannot run from inside this session:
   ```
   ✓ .mcp.json created/updated (safe to commit — pinned to @bodywave/jira-mcp@<version>)
   ✓ .mcp.env created (gitignored — holds your real credentials)

   Now, in your terminal:
   1. Run: source .mcp.env && claude
   2. Once Claude Code restarts, run /mcp — if a global "atlassian" MCP shows as connected, disconnect it first (it would otherwise collide with the project-scoped one on the same server name).
   3. Run /mcp again, select the project-scoped "atlassian" MCP, and approve it.
   4. Test it by asking: "List my Jira projects."
   ```

## Example project structure

```text
my-project/
├── .mcp.json        ← committed, no secrets
├── .mcp.env         ← gitignored, holds real credentials
├── src/
└── ...
```
