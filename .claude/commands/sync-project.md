---
name: "Sync Project Files"
description: "Fetch content from Confluence pages into local project files based on project/project_config.md. Usage: /sync-project"
---

You are syncing project context files from Confluence into the local `project/` folder.

## Steps

1. Check whether `project/project_config.md` exists:
   - If not → stop and inform the user: "project/project_config.md not found. See README.md for setup."

2. Check whether `## 0. Status` in `project/project_config.md` contains a `Latest MCP connect:` line with a real timestamp (not a placeholder):
   - If not found → connect the MCP servers first, then continue to step 3:
     a. Read `project/project_config.md` and locate the `### MCP Config` subsection under `## 1. Project Setup`. Parse all entries (format: `- <server-name>: <url>`). Stop parsing at the next `### ` heading.
     b. Skip any entry where the URL is still a placeholder (e.g. `<confluence-mcp-url>`).
        - If all entries are placeholders → stop and inform the user:
          ```
          No MCP URLs configured. Open project/project_config.md and fill in the URLs under "### MCP Config" (under "## 1. Project Setup").
          ```
     c. For each valid entry, check whether the connection actually works (e.g. by trying to look up a matching Atlassian MCP tool):
        - **If it works** → the entry is connected, nothing more to do.
        - **If it fails** → this session cannot run an OAuth flow itself, so tell the user to authorize manually:
          ```
          <Server name> MCP is not connected. To authorize it:
          1. Open claude.ai (web) → Settings → Connectors (or Integrations).
          2. Find "<Server name>" in the list.
          3. Click Connect / Authorize.
          4. Log in and grant access.
          5. Come back here and let me know when it's done, so I can retry the connection.
          ```
          Do not tell the user to "paste the link into the chat" or "follow the prompts" — that mechanism does not work in this environment.
        - After the user confirms they've authorized, re-check the entries that failed. Repeat this step if any are still failing.
     d. Update `project/project_config.md` with the MCP connect timestamp:
        - Get the current date and time at the moment connection completes.
        - Check if a `## 0. Status` section already exists in the file:
          - **If it exists** → update or add the `Latest MCP connect:` line in place with the new timestamp.
          - **If it does not exist** → insert the following block right after the guidance blockquote and its `---` separator near the top of the file, before `## 1. Project Setup` (with one blank line before the next section):
            ```
            ## 0. Status
            Latest MCP connect: YYYY/MM/DD HH:MM:SS
            ---
            ```
        - Use the format `YYYY/MM/DD HH:MM:SS` for the timestamp.
     e. Report a short connection summary:
        ```
        MCP Connection Summary:

        ✓ <server-name> — connected
        ✗ <server-name> — failed: <reason>
        ```

3. Read `project/project_config.md` and scan for unfilled placeholders (pattern `<...>`) only within `## 2. Context Sync` section. Stop scanning at `## 3.`. Ignore placeholders inside code blocks (fenced with ` ``` `).
   - If any placeholders are found → stop and inform the user:
     ```
     project/project_config.md has unfilled placeholders:
       - <placeholder 1> (section: <section name>)
       - <placeholder 2> (section: <section name>)
       ...
     Please complete these sections before running /sync-project.
     ```

4. Read `project/project_config.md` and locate the `## 2. Context Sync` section. Parse only the entries within that section. Each entry has this format:
   ```
   - <local-file-path>
     url: <confluence-page-url>
   ```
   Stop parsing at the next `## ` heading (i.e. `## 3.`) — do not read entries from other sections.

5. For each valid entry:
   a. Fetch the Confluence page content using the provided URL.
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
   - `project/reference/messages/`

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

8. Update `project/project_config.md` with the sync timestamp:
   - Get the current date and time at the moment sync completes.
   - Check if a `## 0. Status` section already exists in the file:
     - **If it exists** → update the `Latest sync:` line in place with the new timestamp.
     - **If it does not exist** → insert the following block immediately after the `# Project Config` title line (with one blank line before the next section):
       ```
       ## 0. Status
       Latest sync: YYYY/MM/DD HH:MM:SS
       ---
       ```
   - Use the format `YYYY/MM/DD HH:MM:SS` for the timestamp.
