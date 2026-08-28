---
name: "Sync"
description: "Fetch the latest content from Confluence into project/context/ and project/reference/ based on project/project_config.md. Optionally pass the Confluence URL project_config.md was published to, to pull it down first. Usage: /sync [project-config-confluence-url]"
---

You are syncing project context files from Confluence into the local `project/` folder.

## Input

`$ARGUMENTS` is an optional Confluence page URL — the page `project/project_config.md` was published to via `/config`'s mandatory last step. Give it to pull/refresh `project/project_config.md` straight from Confluence instead of getting the file from `dev/config` or a teammate. Not needed once this URL has already been recorded from a previous `/sync` run (see `project/status.md`'s `Project config source:` line below) — a plain `/sync` then reuses it automatically.

## Pre-flight — get project_config.md in place

1. Decide which URL, if any, should be used to refresh `project_config.md` before syncing, and whether to ask first:

   | # | `$ARGUMENTS` given? | `Project config source:` stored? | `project_config.md` configured? | Behavior |
   |---|---|---|---|---|
   | A | yes | — | no (missing or still the placeholder) | Nothing to lose — use `$ARGUMENTS` as the source immediately, no confirmation needed. Continue to step 2. |
   | A′ | yes | — | yes | Already configured — confirm before overwriting: "project_config.md is already configured here. Overwrite it from `<$ARGUMENTS>`? (yes/no)" — **yes** → use `$ARGUMENTS` as the source, continue to step 2. **no** → skip the pull, go straight to the Steps section below using `project_config.md` as it already stands, and leave any stored `Project config source:` untouched. |
   | B | no | yes | — | Reuse the stored URL as the source automatically, no confirmation — continue to step 2. This is what lets a plain `/sync` keep `project_config.md` current without the user re-supplying the link every time. |
   | C | no | no | yes | Nothing stored yet, but the file is already usable — ask once, and don't require an answer: "project/status.md has no saved project-config source link yet — want to give me the Confluence URL it was published to, so future /sync runs can auto-refresh it? (optional — reply with the link, or say no/skip)" — **link given** → use it as the source, continue to step 2 (this doubles as the overwrite confirmation, no second prompt needed). **declined/skipped** → go straight to the Steps section below using `project_config.md` as it already stands, and don't record a source. |
   | D | no | no | no (missing or still the placeholder) | Nothing usable exists, so this one isn't optional — ask the user: "project/project_config.md isn't set up here yet. Send me the Confluence page link it was published to (from /config), and I'll pull it down." Once given, treat it as the source (same as case A) and continue to step 2. |

2. Resolve which Atlassian connector can reach the source URL's hostname — the same two candidates `/connect-mcp` checks, just for this one ad-hoc page instead of a configured `### MCP Config` entry:
   - Any project-scoped connector already set up (`.mcp.json`'s `atlassian-<slug>` entries) whose site matches → use it.
   - Otherwise, the global connector (`mcp__claude_ai_Atlassian__*`), if its accessible-resources include this hostname.
   - Neither reaches it → resolve it yourself, the same way `.claude/commands/connect-mcp.md` step 4 resolves an unmatched Atlassian entry — don't just tell the user to go run `/connect-mcp` separately (`project_config.md` may not even exist yet at this point, so there's no `### MCP Config` entry for it to parse). Ask the user directly, in plain terms: connect through their shared Atlassian account (via claude.ai), or set up a dedicated connection just for this project. Then drive whichever they pick yourself: walk them through authorizing the global connector one step at a time, or run `/connect-local-mcp` for this specific site (follow `.claude/commands/connect-local-mcp.md` in full, passing this hostname/URL as the already-known site so it skips straight past its own URL question). Once resolved, continue with that connector. (If this URL came from the stored `Project config source:` line rather than a freshly given one, mention that too, so the user understands why a plain `/sync` suddenly needs attention.)

3. Fetch the page's content, convert it to clean Markdown, and write it verbatim to `project/project_config.md` — overwriting whatever is currently there, creating `project/project_config.md` (and the `project/` folder) if it doesn't exist yet.

4. Confirm: `✓ Pulled project/project_config.md from <url>`, then continue to the Steps section below. Carry this URL forward — it gets recorded as the `Project config source:` in `project/status.md` in step 7 below, alongside the sync timestamp.

## Steps

1. Check whether `project/status.md` exists and contains a `Latest MCP connect:` line with a real timestamp:
   - If not found → run `/connect-mcp` yourself (follow `.claude/commands/connect-mcp.md` in full, including its report) to connect the MCP servers first — don't ask the user to run it separately — then continue to step 2.

2. Read `project/project_config.md` once and locate the `## 2. Context Sync` section (stop at the next `## ` heading, i.e. `## 3.`) — keep its content for step 3 below, so that step doesn't need to re-read this file. Scan it for unfilled placeholders (pattern `<...>`), ignoring any inside code blocks (fenced with ` ``` `):
   - If any placeholders are found → stop and inform the user:
     ```
     project/project_config.md has unfilled placeholders:
       - <placeholder 1> (section: <section name>)
       - <placeholder 2> (section: <section name>)
       ...
     This branch doesn't edit project_config.md — these sections need to be completed first, then run /sync again.
     ```

3. Parse only the entries within the `## 2. Context Sync` section already read in step 2. Each entry has this format:
   ```
   - <local-file-path>
     url: <page-url>
   ```

4. For each valid entry, branch on the entry URL's hostname:

   **Confluence entry** (an Atlassian site hostname):
   a. Fetch the Confluence page content using the provided URL. A project can have more than one Atlassian site connected (see `/connect-local-mcp`), so match this entry's URL to the right one: extract its hostname, find the `project/status.md` `Latest MCP connect:` line whose `[<hostname>]` matches, and use the connector it recorded — `(via project-scoped connector: <server-key>)` means call that `mcp__<server-key>__*` tool set, `(via global connector)` means call `mcp__claude_ai_Atlassian__*` tools. If no recorded hostname matches this entry's URL, treat it as unresolved and report it as failed in step 5 rather than guessing a connector.
   b. Convert the page content to clean Markdown.
   c. Write the result to the specified local file path, creating the file if it does not exist.
   d. Track success or failure per entry.

   **Figma entry** (hostname is `figma.com` / `www.figma.com`): a Figma link never has clean-Markdown page content the way a Confluence page does, so the goal is just to record identifying info rather than fail outright:
   a. Confirm a Figma MCP connector is available (`mcp__claude_ai_Figma__*` tools). If not, report this entry as failed: `not connected — run /connect-mcp first`.
   b. Extract `fileKey` from the URL, and `nodeId` if the URL has a `node-id` query param (converting its `-` to `:`).
   c. Call `get_metadata` with `fileKey` (and `nodeId` if extracted) to look up a name — the node's name when `nodeId` was given, otherwise the file's top-level page/document name.
   d. Write the local file:
      - Name obtained → `# <name>` as a heading, followed by a blank line and `Figma: <url>`.
      - Name not obtainable (lookup failed, or the URL had no usable node/file reference) → just `Figma: <url>`, no heading.
   e. Track this as a success (✓) either way — there's always at least the link to show.

   **Any other hostname** → unresolved, report as failed in step 5 (same as an unmatched Confluence hostname).

5. Report results:
```
Sync complete:

✓ project/context/project.md — fetched from <url>
✓ project/reference/navigation/<file>.md — fetched from <url> (Figma: <name, or "no name found">)
✗ project/context/<filename>.md — failed: <reason>

Skipped (no URL): <count> entries
```

6. Check whether `project/reference/test-cases/shared-references/common_system_pages.md` exists. This is a cache `/gen-test-cases` builds from live Figma fetches (Common System Pages — Error Page, No Permission Page, 404 Page, etc.) and reuses across every feature afterward — `/sync` doesn't populate it, but a `/sync` run is the natural checkpoint for catching upstream changes, since it exists specifically to refresh stale local content. Ask the user: "Found a cached Common System Pages file (`common_system_pages.md`) that `/gen-test-cases` reuses across features — refresh it so the next `/gen-test-cases` run re-fetches the current Figma designs instead of possibly outdated ones? (yes/no)"
   - **yes** → delete the file, confirm: `✓ Deleted common_system_pages.md — /gen-test-cases will re-derive it fresh next time it needs a Common System Page.`
   - **no** → leave it untouched.
   - If the file doesn't exist → skip this step silently.

7. After syncing, scan the following folders for **orphaned files** — `.md` files that exist locally but have no matching entry in `project/project_config.md`:
   - `project/context/`
   - `project/reference/business-rules/principles/`
   - `project/reference/business-rules/shared-references/`
   - `project/reference/data-definition/shared-references/`
   - `project/reference/ui-behavior/principles/`
   - `project/reference/ui-behavior/shared-references/`
   - `project/reference/navigation/`
   - `project/reference/flow/`
   - `project/reference/messages/`
   - `project/reference/sample-doc/`
   - `project/reference/test-scenarios/principles/`
   - `project/reference/test-scenarios/shared-references/`
   - `project/reference/test-cases/principles/`
   - `project/reference/test-cases/shared-references/` (skip `common_system_pages.md` here — handled separately in step 6 above, not a project_config-mapped orphan)

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

8. Update `project/status.md`. This file is local bookkeeping only (gitignored, never shared or published) — separate from `project/project_config.md`, which is also gitignored but is the one meant to be shared with the team:
   - Get the current date and time at the moment sync completes, for `Latest sync:`.
   - If pre-flight actually pulled `project_config.md` using a source URL this run (cases A, A′-yes, B, C-given, or D above) → that URL is the value for `Project config source:`. If pre-flight skipped the pull (cases A′-no or C-declined) → leave `Project config source:` exactly as it already is (don't add or remove it).
   - `Project config source:` always sits immediately before `Latest sync:`, both before any `Latest MCP connect:` block.
   - Check if `project/status.md` already exists:
     - **If it exists and already has a `Latest sync:` line** → update it in place. Add or update the `Project config source:` line immediately above it if this run has a URL to record (per the rule above).
     - **If it exists but has no `Latest sync:` line yet** (e.g. the file currently only has a `Latest MCP connect:` block from a prior `/connect-mcp` run) → insert `Project config source: <url>` (only if applicable) and `Latest sync: YYYY/MM/DD HH:MM:SS` as the first lines of the file, in that order, right after the intro blockquote and before `Latest MCP connect:`.
     - **If `project/status.md` does not exist at all** → create it with this content:
       ```
       # Status

       > Local bookkeeping only — not shared with the team, not published. Tracks the last /sync for this project.

       Project config source: <url>
       Latest sync: YYYY/MM/DD HH:MM:SS
       ```
       (omit the `Project config source:` line entirely if this run had no URL to record)
   - Use the format `YYYY/MM/DD HH:MM:SS` for the timestamp.
