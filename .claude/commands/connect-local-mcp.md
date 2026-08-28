---
name: "Connect Atlassian MCP (Project-Scoped)"
description: "Set up a project-scoped Atlassian MCP server (separate from the global one), for connecting to one or more Jira/Confluence instances per project. Usage: /connect-local-mcp"
---

You are setting up a project-scoped Atlassian MCP connection for this repo, separate from any global/user-level Atlassian MCP connector, so this project can talk to a different Jira/Confluence site than the account connected globally. This command supports **multiple** sites for the same project — each site gets its own label, its own `.mcp.json` server entry, and its own credentials in `.claude/settings.local.json`, so Claude can call the right one by tool name without ever needing to disconnect another.

**Labels are always derived from the site's hostname, never freely chosen.** Given a site URL, the label is its hostname with the Atlassian TLD suffix stripped (e.g. `https://dc32-ai-framework.atlassian.net` → `dc32-ai-framework`), lowercased. This makes the label directly comparable to the site itself — no memorizing which short nickname maps to which URL. There is no "default/unlabeled" site anymore: every entry, including the first one ever set up for a project, gets an explicit site-derived label everywhere it appears (`.mcp.json` server key, `.claude/settings.local.json` env var suffix, `project_config.md` line).

Two forms of the label are used:
- **Slug** (for the `.mcp.json` server key, e.g. `atlassian-dc32-ai-framework`): lowercase hostname with the suffix stripped, hyphens kept as-is.
- **Env label** (for the `.claude/settings.local.json` / `.mcp.json` env var suffix, e.g. `_DC32_AI_FRAMEWORK`): same as the slug, but uppercased and with every non-alphanumeric character (including hyphens) replaced with `_` — environment variable names cannot contain hyphens.

## What this command automates vs. what you must do by hand

Claude has no tool to enable/disable (approve) an MCP connector for the very first time, or to reload/restart its own session — those two actions genuinely require the user, and only apply the first time a given server key (`atlassian-<slug>`) is ever added to `.mcp.json` in this project. Everything else — creating the config file, collecting credentials, storing them safely, pinning the MCP package version, and activating the credentials in the current session — is handled automatically by this command, including for a server key that's already configured but wasn't yet approved in *this* session (e.g. it was set up in an earlier session, or the user is retrying after the reload/new-session step below).

## Steps

1. Determine how this command is being invoked, since that changes what needs asking:
   - **A site URL is already known** — either passed in from `/connect-mcp` (it routes here when a project-scoped candidate exists for an entry but was never approved this session — that's an approval problem, not a credentials problem), or the user is manually re-running this command right after the reload/new-session step in step 7 to finish activating a site they just set up. In this case, derive its slug and check `.mcp.json`:
     - **That exact `atlassian-<slug>` entry already exists** → this isn't a new site or a credentials change, just finishing activation. Skip straight to step 7 — don't ask for email/API token again, and don't ask for an overwrite confirmation; nothing is being replaced.
     - **No matching entry** (the caller's information was stale) → treat it like a brand-new site: go to step 2, whose first question is already answered (skip asking for the URL again, just derive the slug/env label from it and continue from there).
   - **No site URL is known yet — the user is starting this command themselves** to add or change a site → read `.mcp.json` (if it doesn't exist at all, treat this the same as "none exist yet" below) and list any existing project-scoped Atlassian entries (each keyed `atlassian-<slug>`). For each one found, look up its site URL from the matching `JIRA_BASE_URL_<ENV-LABEL>` key in `.claude/settings.local.json`'s `env` so you can show the user what's already configured.
     - **None exist yet** → skip straight to step 2.
     - **One or more already exist** → tell the user what's currently configured (site URL for each), then ask for the new site's URL (step 2's first question) so its label can be derived and compared against the existing ones — do this comparison immediately after that answer, before asking anything further (see step 2):
       - **Derived label is new** → proceeds as a new entry alongside the existing ones, no further prompt needed.
       - **Derived label matches an existing entry** (the user typed a URL for a site already configured — could be an intentional credential rotation) → confirm before proceeding: "This will replace the credentials for '<site>' (currently configured). Continue? (yes/no)" If declined, stop here.

2. Ask the user for the values needed to connect, one at a time — wait for the answer to each before asking the next. All prompts in this command are written in English; only switch to Vietnamese in the chat if the user is writing to you in Vietnamese, translating on the fly rather than changing this file:
   - If the site URL is not already known (i.e. this is the "no site URL known yet" branch of step 1), ask for it first:
     ```
     Let's set up a separate Atlassian connection for this project. What's your Jira/Confluence site URL? (e.g. https://mycompany.atlassian.net)
     ```
     Once known, derive the **slug** and **env label** from its hostname as described above (e.g. `https://dc32-ai-framework.atlassian.net` → slug `dc32-ai-framework`, env label `DC32_AI_FRAMEWORK`) and use them for the rest of this flow. **Immediately do the step 1 collision check right here**, before asking anything else: if this slug matches an entry already listed in step 1, ask for the overwrite confirmation now and wait for the answer — don't go on to ask for email/API token first and only discover the collision afterward. If declined, stop here; if confirmed (or there was no collision), continue to the next question below.
   - Then ask for the account email:
     ```
     What's your Atlassian account email?
     ```
   - Then ask for the API token:
     ```
     What's your API token? (If you don't have one yet, create it at: https://id.atlassian.com/manage-profile/security/api-tokens)
     ```

3. Determine which `@bodywave/jira-mcp` version to pin: if `.mcp.json` already has any `atlassian-<slug>` entry, reuse the exact version already pinned there instead of looking up a new one — keeps every site in this project on the same, already-tested version instead of drifting apart. Only if this is the very first Atlassian entry being created, look up the current published version: run `npm view @bodywave/jira-mcp version`. This is a third-party package executed via `npx` with real Jira credentials in its environment, so pin it to an exact version rather than leaving it on `latest` — otherwise the code that actually runs could change silently between sessions without the user noticing.

4. Create or update `.mcp.json` in the project root (this file's location is fixed — Claude Code only auto-loads project-scoped MCP servers from `.mcp.json` at the root of the directory `claude` is launched from). Add or update **only the one entry** for the site you're setting up right now under `mcpServers`, leaving every other entry — including any other Atlassian site already set up — completely untouched:
   ```json
   // Site with slug "dc32-ai-framework" / env label "DC32_AI_FRAMEWORK":
   {
     "mcpServers": {
       "atlassian-dc32-ai-framework": {
         "command": "npx",
         "args": ["-y", "@bodywave/jira-mcp@<version from step 3>"],
         "env": {
           "JIRA_BASE_URL": "${JIRA_BASE_URL_DC32_AI_FRAMEWORK}",
           "JIRA_USER_EMAIL": "${JIRA_USER_EMAIL_DC32_AI_FRAMEWORK}",
           "JIRA_API_TOKEN": "${JIRA_API_TOKEN_DC32_AI_FRAMEWORK}"
         }
       }
     }
   }
   ```
   The env var names actually passed to the `@bodywave/jira-mcp` subprocess are always the plain `JIRA_BASE_URL`/`JIRA_USER_EMAIL`/`JIRA_API_TOKEN` — that's what the package reads (confirmed against its README, github.com/mottysisam/bodywave-jira) — only the outer `${...}` placeholder name takes the `_<ENV-LABEL>` suffix, since that's what Claude Code resolves from `.claude/settings.local.json`. Using the wrong subprocess-facing names (e.g. `JIRA_URL`/`JIRA_EMAIL`/`JIRA_API_KEY`) leaves them undefined inside the MCP subprocess, which surfaces as an opaque "Invalid URL" error when a Jira/Confluence tool is called — don't drift from these names.
   This file only holds variable references, never the real credentials, so it's safe to commit.

5. Write the three values collected in step 2 into `.claude/settings.local.json`'s `env` key, under the suffixed names (`JIRA_BASE_URL_<ENV-LABEL>`, `JIRA_USER_EMAIL_<ENV-LABEL>`, `JIRA_API_TOKEN_<ENV-LABEL>`). This file is a built-in Claude Code convention — automatically gitignored, never shared with the team — so the real credentials never get committed:
   - Read the file first (create it as `{}` if it doesn't exist yet).
   - Merge in (or update) just these three keys, preserving every other existing key in the file untouched — including any other site's credentials, `enabledMcpjsonServers`, `permissions`, etc.
   - Claude Code reads this `env` key itself and uses it to expand the `${VAR}` placeholders in `.mcp.json` — no shell/terminal sourcing is needed for this to work.

6. If `project/project_config.md` exists and already has a `### MCP Config` subsection, add or update the matching line there too, so `/connect-mcp`'s resolution step and the shared config stay in sync: `- Atlassian (<slug>): <url>`.
   If `project/project_config.md` doesn't exist yet, or has no `### MCP Config` section, skip this step and mention to the user that running `/config` will register this site in the shared project config.

7. Activate the credentials, without asking the user to do anything, whenever possible:
   - Try `ToolSearch` for this server's tool prefix `mcp__atlassian-<slug>__*` (e.g. `select:mcp__atlassian-<slug>__jira_add_account,mcp__atlassian-<slug>__jira_test_account`).
   - **Tools found** (this server key was already approved in this session — e.g. from a previous run, or surviving a `/reset` that only cleared credentials, not approval) → the running MCP subprocess won't pick up the env vars just written to `.claude/settings.local.json` until it restarts, but `@bodywave/jira-mcp` also accepts credentials at runtime: call `jira_add_account` with `id` (the slug), `name` (the project name if known, else the slug/site), `url`, `email`, and `api_key` set to the same three values just written to `.claude/settings.local.json`. Then call `jira_test_account` (pass `id`). Report the result immediately — do not ask the user to run `/mcp`, reload, or screenshot anything; the connection is either verified now or it failed with a concrete error to report.
     - If `jira_test_account` fails, surface the actual error (bad token, wrong URL, etc.) and go back to step 2 to collect a corrected value — don't fall through to the manual flow below for a credentials problem.
   - **No tools found at all for this prefix** (this server key has never been approved in this Claude Code session before — the one thing Claude truly cannot do for itself) → this needs the user, once, to approve the new entry. Walk them through it one step at a time, waiting for confirmation before the next:
     1. **If running in a terminal-launched `claude` session**: start a new session in the project directory:
        ```
        cd <absolute-path-to-project>
        claude
        ```
     2. **If running in a VS Code-extension chat** (like the one running this command): reload the window — open the Command Palette (Cmd+Shift+P on macOS, Ctrl+Shift+P on Windows/Linux), then paste this command name into it and press Enter (lighter than restarting the app; fall back to fully quitting and reopening VS Code if the new server still isn't listed after reload):
        ```
        Developer: Reload Window
        ```
     3. Ask them to run this, find the entry for this server key (often under "Project MCPs"), select it, and approve it:
        ```
        /mcp
        ```
     4. A reload or a new terminal session may end the conversation currently giving these instructions — don't assume you'll still be running to "retry" anything. Tell the user plainly: once they've approved it, if this chat is still active, say so and you'll retry the "Tools found" branch above (ToolSearch, then `jira_add_account` + `jira_test_account`) right here; if this chat did *not* survive the reload/restart, just run `/connect-local-mcp` again in the new session/window — thanks to step 1, it'll recognize the site is already configured and go straight into this same activation check, with no need to re-enter the URL, email, or API token.
   - There's no need to disconnect any other Atlassian-capable connector — a global "claude.ai Atlassian" one, or any other site set up via this command — since each lives under its own distinct tool prefix (`mcp__claude_ai_Atlassian__*`, `mcp__atlassian-<slug>__*`), so all of them can safely stay connected at once. `/connect-mcp` is what decides which one to actually use for a given site.
   If the user asks why the one-time approval step can't be automated, only then explain: Claude has no tool to approve a brand-new MCP connector or reload/restart its own session from inside itself — everything else, including activating credentials afterward, is done automatically.

## Example project structure

```text
my-project/
├── .mcp.json                    ← committed, no secrets — must stay at project root (Claude Code convention); one entry per Atlassian site
├── .claude/
│   └── settings.local.json      ← auto-gitignored by Claude Code, holds real credentials under "env" (one set of keys per site) — persists across /reset and branch switches, since it's a durable local connection, not per-project state
├── src/
└── ...
```
