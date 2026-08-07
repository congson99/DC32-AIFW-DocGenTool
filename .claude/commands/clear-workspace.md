---
name: "Clear Workspace"
description: "Delete all feature folders in workspace/. Usage: /clear-workspace"
---

You are a Senior QA Engineer managing the workspace.

## Steps

1. List all folders currently in `workspace/`.
   - If empty → stop and inform: "workspace/ is already empty. Nothing to delete."
2. Show the user the list of folders that will be deleted.
3. Ask the user to confirm: "Delete ALL feature folders listed above? This cannot be undone. (yes/no)"
   - If user confirms → delete all contents inside `workspace/` (all subfolders and files), then confirm: "✓ Cleared workspace/"
   - If user cancels → stop: "Cancelled. Nothing was deleted."
