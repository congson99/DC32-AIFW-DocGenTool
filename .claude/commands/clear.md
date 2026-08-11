---
name: "Clear"
description: "Delete all synced context/reference files, reset project_config.md to its unconfigured state, and clear all feature folders in workspace/. Usage: /clear"
---

You are resetting `project/` and `workspace/` so the repo is ready for a new project.

## Steps

1. Check if `project/context/` or `project/reference/` contain any files, `project/project_config.md` contains a `## 1. Project Setup` heading (i.e. it has been configured), or `workspace/` contains any feature folders:
   - If none of these → stop and inform: "project/ and workspace/ are already at their default state. Nothing to clear."
2. Ask the user to confirm:
   ```
   Reset project/ for a new project? This deletes all synced context/reference files under project/context/ and project/reference/, resets project_config.md to its unconfigured state (all MCP URLs, Confluence mappings, and Task Automation settings will be lost), and deletes all feature folders in workspace/ (gitignored — left over from switching to a BA/QA doc-gen branch in this same clone). This cannot be undone. (yes/no)
   ```
   - If user cancels → stop: "Cancelled. Nothing was deleted."
3. On confirmation:
   - Delete all files and subfolders inside `project/context/` and `project/reference/` (keep the empty folders themselves).
   - Delete all contents inside `workspace/` (all feature subfolders and files), if any exist.
   - Overwrite `project/project_config.md` with exactly this content:
     ```
     # Project Config

     > This file has not been configured yet. Run `/config` to set it up.
     ```
4. Confirm: "✓ Cleared project/context/ and project/reference/, reset project_config.md to its unconfigured state, and cleared workspace/. Run /config to configure this project."
