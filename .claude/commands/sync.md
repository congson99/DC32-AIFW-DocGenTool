---
name: "Sync"
description: "Fetch the latest content from Confluence into project/context/ and project/reference/ based on project/project_config.md. Optionally pass the Confluence URL project_config.md was published to, to pull it down first. Usage: /sync [project-config-confluence-url]"
---

You are syncing project context files from Confluence into the local `project/` folder.

## Input

`$ARGUMENTS` is an optional Confluence page URL — the page `project/project_config.md` was published to via `/config`'s mandatory last step. Give it to pull/refresh `project/project_config.md` straight from Confluence instead of getting the file from `dev/config` or a teammate. Not needed if `project/project_config.md` already exists here and is configured.

## Pre-flight — get project_config.md in place

1. Decide whether to pull it from Confluence first:
   - **`$ARGUMENTS` given** → treat it as the source page. Continue to step 2 below.
   - **`$ARGUMENTS` empty**:
     - `project/project_config.md` exists and already has a `## 1. Project Setup` heading (i.e. it's configured) → skip straight to the Steps section below, no pull needed.
     - Missing, or still the unconfigured placeholder → ask the user: "project/project_config.md isn't set up here yet. Send me the Confluence page link it was published to (from /config), and I'll pull it down." Once given, continue to step 2 below using that link.

2. Resolve which Atlassian connector can reach the given URL's hostname — the same two candidates `/connect-mcp` checks, just for this one ad-hoc page instead of a configured `### MCP Config` entry:
   - Any project-scoped connector already set up (`.mcp.json`'s `atlassian-<slug>` entries) whose site matches → use it.
   - Otherwise, the global connector (`mcp__claude_ai_Atlassian__*`), if its accessible-resources include this hostname.
   - Neither reaches it → stop and tell the user: "No Atlassian connection can reach `<hostname>` yet. Run `/connect-mcp` (or `/connect-local-mcp` for a dedicated connection) first, then run `/sync <url>` again."

3. Fetch the page's content, convert it to clean Markdown, and write it verbatim to `project/project_config.md` — overwriting whatever is currently there, creating `project/project_config.md` (and the `project/` folder) if it doesn't exist yet.

4. Confirm: `✓ Pulled project/project_config.md from <url>`, then continue to the Steps section below.

## Steps

1. Check whether `project/status.md` exists and contains a `Latest MCP connect:` line with a real timestamp:
   - If not found → run `/connect-mcp` (follow `.claude/commands/connect-mcp.md` in full, including its report) to connect the MCP servers first, then continue to step 2.

2. Read `project/project_config.md` and scan for unfilled placeholders (pattern `<...>`) only within `## 2. Context Sync` section. Stop scanning at `## 3.`. Ignore placeholders inside code blocks (fenced with ` ``` `).
   - If any placeholders are found → stop and inform the user:
     ```
     project/project_config.md has unfilled placeholders:
       - <placeholder 1> (section: <section name>)
       - <placeholder 2> (section: <section name>)
       ...
     This branch doesn't edit project_config.md — go to the dev/config branch (in this same clone) and run /config to complete these sections, then come back here and run /sync again.
     ```

3. Read `project/project_config.md` and locate the `## 2. Context Sync` section. Parse only the entries within that section. Each entry has this format:
   ```
   - <local-file-path>
     url: <confluence-page-url>
   ```
   Stop parsing at the next `## ` heading (i.e. `## 3.`) — do not read entries from other sections.

4. For each valid entry:
   a. Fetch the Confluence page content using the provided URL. A project can have more than one Atlassian site connected (see `/connect-local-mcp`), so match this entry's URL to the right one: extract its hostname, find the `project/status.md` `Latest MCP connect:` line whose `[<hostname>]` matches, and use the connector it recorded — `(via project-scoped connector: <server-key>)` means call that `mcp__<server-key>__*` tool set, `(via global connector)` means call `mcp__claude_ai_Atlassian__*` tools. If no recorded hostname matches this entry's URL, treat it as unresolved and report it as failed in step 6 rather than guessing a connector.
   b. Convert the page content to clean Markdown.
   c. Write the result to the specified local file path, creating the file if it does not exist.
   d. Track success or failure per entry.

5. Report results:
```
Sync complete:

✓ project/context/project.md — fetched from <url>
✗ project/context/<filename>.md — failed: <reason>

Skipped (no URL): <count> entries
```

6. After syncing, scan the following folders for **orphaned files** — `.md` files that exist locally but have no matching entry in `project/project_config.md`:
   - `project/context/`
   - `project/reference/business-rules/principles/`
   - `project/reference/business-rules/shared-references/`
   - `project/reference/ui-behavior/principles/`
   - `project/reference/ui-behavior/shared-references/`
   - `project/reference/navigation/`
   - `project/reference/messages/`
   - `project/reference/test-scenarios/principles/`

   If orphaned files are found → ask the user:
   ```
   The following local files are not mapped in project_config.md:
     - project/reference/business-rules/old-rules.md
     - ...

   Delete these files? (yes/no)
   ```
   - **yes** → delete all listed files and confirm: `✓ Deleted <count> orphaned file(s).`
   - **no** → leave them untouched and note: `Orphaned files kept.`

   If no orphaned files are found → skip this step silently.

7. Update `project/status.md` with the sync timestamp. This file is local bookkeeping only (gitignored, never shared or published) — separate from `project/project_config.md`, which is also gitignored but is the one meant to be shared with the team:
   - Get the current date and time at the moment sync completes.
   - Check if `project/status.md` already exists:
     - **If it exists and already has a `Latest sync:` line** → update that line in place with the new timestamp.
     - **If it exists but has no `Latest sync:` line yet** (e.g. the file currently only has a `Latest MCP connect:` block from a prior `/connect-mcp` run) → add a `Latest sync: YYYY/MM/DD HH:MM:SS` line as the first line in the file, right after the intro blockquote and before `Latest MCP connect:`.
     - **If `project/status.md` does not exist at all** → create it with this content:
       ```
       # Status

       > Local bookkeeping only — not shared with the team, not published. Tracks the last /sync for this project.

       Latest sync: YYYY/MM/DD HH:MM:SS
       ```
   - Use the format `YYYY/MM/DD HH:MM:SS` for the timestamp.
