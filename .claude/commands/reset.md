---
name: "Reset"
description: "Delete all synced context/reference files, reset project_config.md to its unconfigured state, and clear all feature folders in workspace/. Usage: /reset"
---

You are resetting `project/` and `workspace/` so the repo is ready for a new project.

## Steps

1. Check if `project/context/` or `project/reference/` contain any files, `project/project_config.md` contains a `## 1. Project Setup` heading (i.e. it has been configured), `project/status.md` exists, `project/.mcp.env` exists, or `workspace/` contains any feature folders:
   - If none of these → stop and inform: "project/ and workspace/ are already at their default state. Nothing to clear."
2. Ask the user to confirm:
   ```
   Reset the project for a fresh start? This clears the synced config, credentials, and any in-progress feature work. Cannot be undone. (yes/no)
   ```
   - If user cancels → stop: "Cancelled. Nothing was deleted."
3. On confirmation:
   - Delete all files and subfolders inside `project/context/` and `project/reference/` (keep the empty folders themselves).
   - Delete `project/status.md` if it exists.
   - Delete `project/.mcp.env` if it exists.
   - Delete all contents inside `workspace/` (all feature subfolders and files), if any exist.
   - Overwrite `project/project_config.md` with exactly this content:
     ```
     # Project Config

     > This file has not been configured yet. Run `/config` to set it up.
     ```
4. Confirm: "✓ Project reset. Run /config to set up a new project."
