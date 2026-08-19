---
name: "Sync"
description: "Fetch content from Confluence pages into local project files based on project/project_config.md. Usage: /sync"
---

You are syncing project context files from Confluence into the local `project/` folder.

## Steps

1. Check whether `project/project_config.md` exists:
   - If not → stop and inform the user: "project/project_config.md not found. See README.md for setup."

2. Check whether `project/status.md` exists and contains a `Latest MCP connect:` line with a real timestamp:
   - If not found → run `/connect-mcp` (follow `.claude/commands/connect-mcp.md` in full, including its report) to connect the MCP servers first, then continue to step 3.

3. Read `project/project_config.md` and scan for unfilled placeholders (pattern `<...>`) only within `## 2. Context Sync` section. Stop scanning at `## 3.`. Ignore placeholders inside code blocks (fenced with ` ``` `).
   - If any placeholders are found → stop and inform the user:
     ```
     project/project_config.md has unfilled placeholders:
       - <placeholder 1> (section: <section name>)
       - <placeholder 2> (section: <section name>)
       ...
     Please complete these sections before running /sync.
     ```

4. Read `project/project_config.md` and locate the `## 2. Context Sync` section. Parse only the entries within that section. Each entry has this format:
   ```
   - <local-file-path>
     url: <confluence-page-url>
   ```
   Stop parsing at the next `## ` heading (i.e. `## 3.`) — do not read entries from other sections.

5. For each valid entry:
   a. Fetch the Confluence page content using the provided URL. A project can have more than one Atlassian site connected (see `/connect-local-mcp`), so match this entry's URL to the right one: extract its hostname, find the `project/status.md` `Latest MCP connect:` line whose `[<hostname>]` matches, and use the connector it recorded — `(via project-scoped connector: <server-key>)` means call that `mcp__<server-key>__*` tool set, `(via global connector)` means call `mcp__claude_ai_Atlassian__*` tools. If no recorded hostname matches this entry's URL, treat it as unresolved and report it as failed in step 6 rather than guessing a connector.
   b. Convert the page content to clean Markdown.
   c. Write the result to the specified local file path, creating the file if it does not exist.
   d. Track success or failure per entry.

6. Report results:
```
Sync complete:

✓ project/context/project.md — fetched from <url>
✗ project/context/<filename>.md — failed: <reason>

Skipped (no URL): <count> entries
```

7. After syncing, scan the following folders for **orphaned files** — `.md` files that exist locally but have no matching entry in `project/project_config.md`:
   - `project/context/`
   - `project/reference/business-rules/principles/`
   - `project/reference/business-rules/shared-references/`
   - `project/reference/ui-behavior/principles/`
   - `project/reference/ui-behavior/shared-references/`
   - `project/reference/navigation/`
   - `project/reference/flow/`
   - `project/reference/messages/`
   - `project/reference/sample-doc/`

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

8. Update `project/status.md` with the sync timestamp. This file is local bookkeeping only (gitignored, never shared or published) — separate from `project/project_config.md`, which is also gitignored but is the one meant to be shared with the team:
   - Get the current date and time at the moment sync completes.
   - Check if `project/status.md` already exists:
     - **If it exists and already has a `Latest sync:` line** → update that line in place with the new timestamp.
     - **If it exists but has no `Latest sync:` line yet** (e.g. the file currently only has a `Latest MCP connect:` block from a prior `/connect-mcp` run) → add a `Latest sync: YYYY/MM/DD HH:MM:SS` line as the first line in the file, right after the intro blockquote and before `Latest MCP connect:`.
     - **If `project/status.md` does not exist at all** → create it with this content:
       ```
       # Status

       > Local bookkeeping only — not shared with the team, not published. Tracks the last /connect-mcp and /sync for this project.

       Latest sync: YYYY/MM/DD HH:MM:SS
       ```
   - Use the format `YYYY/MM/DD HH:MM:SS` for the timestamp.
