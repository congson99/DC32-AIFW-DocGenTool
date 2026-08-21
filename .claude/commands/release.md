---
name: "Release"
description: "Cut a release for the config, BA, or QA tool: sync and check for conflicts, diff dev against the latest release, get the changelog/version (and Requires version, for BA/QA) confirmed, lock the framework, squash-merge dev into release, tag + publish a GitHub Release, and update both that tool's own README and main's version table. Usage: /release <config|ba|qa>"
---

You are cutting a release for one of this repo's three tools (Project Configuration, BA Documentation, QA Documentation). All three follow the exact same procedure below — only the branch names, tag prefix, and display name differ, resolved once at the start from the target argument.

## Input

`<target>` is `config`, `ba`, or `qa` (case-insensitive) — exactly as typed by the user after `/release`.

- If missing or not one of these three → ask: "Which tool do you want to release — config, ba, or qa?"

Resolve immediately from `<target>` and use throughout:

| target | Dev branch | Release branch | Tag prefix | Display name (short) |
|---|---|---|---|---|
| config | `dev/config` | `release/config` | `config` | Project Configuration Tool (**Config**) |
| ba | `dev/BA` | `release/BA` | `ba` | BA Documentation Tool (**BA**) |
| qa | `dev/QA` | `release/QA` | `qa` | QA Documentation Tool (**QA**) |

The relevant section in `main`'s `README.md` is the one headed `### N. <Display name>`, containing this tool's `<table>`.

## Pre-flight

1. If a `gh` call later in this flow fails with an auth error, stop and tell the user to run `gh auth login` — don't try to work around it.
2. `git fetch --all --prune --tags` so local branches and tags reflect the real remote state before anything is compared.

## Steps

Throughout every step below, any fix or edit made on `<dev-branch>` is proposed and confirmed with the user before it's applied — never edit it unasked. The one exception is the `edit_framework` flip in Step 5.3, which is this flow's own explicit job and doesn't need a separate ask.

### Step 1 — Sync and check for conflicts

Only these three branches are relevant to this release; no need to touch any others.

1. In this order — `main`, `<release-branch>`, `<dev-branch>` (ending on `<dev-branch>`, since Step 2 continues there) — `git checkout <branch>` then `git pull --ff-only`.
   - **All three fast-forward cleanly** → continue to Step 2.
   - **Any one fails** (diverged history, merge conflict, anything blocking a clean fast-forward) → stop, explain exactly which branch and what the problem is, and ask the user how they want it resolved. Do not resolve it yourself without asking. Only continue once it's fixed and re-pulled clean.

### Step 2 — Check for in-progress work

1. On `<dev-branch>` (already checked out from Step 1), run `git status`, and check `git stash list` for anything left on this branch.
   - **Clean, nothing ambiguous** → continue silently to Step 3.
   - **Anything uncommitted, a relevant stash exists, or the state is otherwise unclear** → describe exactly what you found and ask the user how to proceed (commit it now, stash it, discard it, or abort the release). Do not guess or decide for them. Only continue once resolved.

### Step 3 — Diff against the latest release and propose the next version

1. Find the latest released version for this tag prefix: `git tag -l "<prefix>/*" --sort=-v:refname` (first line = latest, e.g. `ba/1.2`).
   - **No tags exist yet** → first-ever release for this tool. Baseline = the root commit of `<release-branch>` (`git log --reverse --oneline <release-branch> | head -1`, conventionally titled "Initial empty branch for ... tool source"). Default proposed version: `1.0`.
   - **A latest tag exists** (e.g. `<prefix>/1.2`) → baseline = that tag's commit. Default proposed version: bump the minor number by 1 (`1.2` → `1.3`).
2. Diff `<dev-branch>` against the baseline commit (`git log --oneline <baseline>..<dev-branch>` and `git diff --stat`/`-p` as needed) and write a short, plain-language bullet list of what changed — describe it the way you'd explain it to the tool's end user (a BA, QA, or whoever runs `/config`), in terms of what's new or different for them to do or expect. No file names, command internals, code terms, or implementation detail — if a bullet needs a technical word to make sense, rewrite it around the outcome instead (e.g. "Restricted to English/Vietnamese only" rather than "Added AskUserQuestion validation to the Language sub-question in config.md").
3. Show the user the bullet list together with the proposed next version, and ask them to confirm or edit either one. Keep asking until they explicitly confirm a final version + changelist.
   - Confirmed version **greater than** the current latest (or this is the first release) → normal path, continue to Step 3.4 below.
   - Confirmed version **less than or equal to** an existing latest version → exception path, go to Step 4 instead of continuing here.
4. (Normal path only) Now that version + changelist are confirmed:
   - **`<target>` is `ba` or `qa`** → ask: "Does <Display short> v<version> require a specific version of Config?" Record the answer — or "none" — for use in Steps 5 and 8.
   - **`<target>` is `config`** → nothing to ask here; Config's table has no such column. Skip straight to Step 5.

### Step 4 — Exception: releasing at or below an already-released version

Only runs when Step 3.3 found the confirmed version ≤ an existing tag for this prefix.

1. List every existing tag/release for this prefix with version ≥ the confirmed version — these are what will be destroyed — and ask for explicit confirmation:
   > "This will permanently delete <Display> \<list of versions\> from `<release-branch>`, and their GitHub tags/releases. Continue?"
   - **No** → stop the entire release here, make no changes.
2. Find the new baseline: the highest existing tag for this prefix with version **strictly less than** the confirmed version — or, if none exists, the release branch's root commit (same rule as Step 3.1).
3. Re-diff `<dev-branch>` against this new baseline and re-show the bullet list + confirmed version for a final confirm (the changelist can differ now that the baseline shifted).
4. Once confirmed:
   1. `git checkout <release-branch>`, `git reset --hard <new-baseline-commit>`, `git push --force origin <release-branch>`.
   2. For every tag/release listed in 4.1: `gh release delete <tag> --yes --cleanup-tag` (removes both the GitHub Release and its git tag in one step).
   3. In `main`'s `README.md`, within this tool's `<table>` only, find and remove every row whose version matches one of the deleted versions.
   4. Commit and push this `main` cleanup.
   5. `git checkout <dev-branch>` to resume the release.
5. Do the Step 3.4 branch (ask Requires for BA/QA, skip for Config — it hasn't run yet on this path), then continue to Step 5, treating the confirmed version exactly like a fresh next version (baseline = the one found in 4.2).

### Step 5 — Update this tool's own README, audit scope, fix if needed, then lock the framework

Do the version-line update and the audit/fix **before** touching `edit_framework` — once it's `NO`, framework files (`README.md` included) can no longer be edited, so everything here must land while it's still `YES`.

1. In `<dev-branch>`'s own `README.md`, update the version line right under the title (e.g. `v1.0`) to the confirmed version:
   - **`ba`/`qa`**, with a Requires answer other than "none": `v<version> (requires Config v<x.y>)`.
   - **`ba`/`qa`**, answer was "none", or **`config`** (no such question was asked): just `v<version>` with no parenthetical.
   Commit this on its own (e.g. `Bump version to v<version>`).
2. Diff everything this release would carry: `git diff <release-branch>...<dev-branch> --stat`, then inspect content as needed (not just filenames). Check specifically for:
   - Any tracked file under `project/` or `workspace/` — these must never be tracked (see `.gitignore`).
   - Any literal secret/credential value (a real token, password, API key) instead of an env-var placeholder like `${VAR}`.
   - Anything else clearly specific to whichever real project this branch was tested against, rather than generic framework content (e.g. a real Jira site slug hardcoded somewhere, a real client name used as an example).
   - **Nothing found** → go to 5.3.
   - **Something found** → report exactly what and where, propose a specific fix, and get the user's confirmation before applying it. Once applied, commit it on its own (e.g. `Fix <what was wrong>`) before moving on — do not bundle it with the `edit_framework` flip below.
3. Read `framework/framework_config.md`:
   - Already `edit_framework: NO` → nothing to change, nothing to commit here.
   - `edit_framework: YES` → change it to `NO` and commit this on its own, e.g. `Lock framework editing`.

### Step 6 — Push, open the PR, and squash-merge

1. `git push origin <dev-branch>`.
2. `gh pr create --base <release-branch> --head <dev-branch> --title "Release v<version>" --body "<the confirmed bullet list>"`.
3. `gh pr merge <pr-number> --squash` — never pass `--delete-branch`; `<dev-branch>` is the permanent working branch, not a throwaway.
4. `git fetch origin <release-branch>` and fast-forward the local `<release-branch>` to match, so Step 7 tags the right commit.

### Step 7 — Tag and publish the GitHub Release

1. `gh release create <prefix>/<version> --target <release-branch> --title "<Display short> v<version>" --notes "<the confirmed bullet list>"` (e.g. tag `ba/1.0`, title `BA v1.0`).

### Step 8 — Update main

1. `git checkout main`.
2. In this tool's section of `README.md`, add a new row to its `<table>` for this version:
   - **Version** cell: link to `https://github.com/congson99/DC32-AIFW-DocGenTool/tree/<prefix>/<version>`, text `v<version>` — same link style already used in the file.
   - **Highlights** cell: a short one-line summary condensed from the confirmed bullet list, matching the terse style of existing rows (e.g. "Baseline project configuration tool" for Config's own row). Before writing it, sanity-check that it actually describes **this** tool (<Display short>) — if the text names a different tool, or matches another tool's existing row verbatim (a likely copy-paste/carry-over mistake, including one the user themselves just dictated), stop and flag it back to them instead of writing it as-is.
   - **Requires** cell (BA/QA only — Config's table has no such column, skip this bullet entirely for `config`): reuse the answer already collected in Step 3.4 or 4.5 — don't ask again. Leave blank if it was "none".
   - New rows go at the top of the table body, directly under the header row, so the newest version is listed first.
3. Commit (e.g. `Add <Display short> v<version> release entry`) and push `main`.

## Report

Summarize what happened, e.g.:
```
✓ Released <Display short> v<version>
- PR #<n> squash-merged into <release-branch>
- Tag & release: <prefix>/<version> — <url>
- <dev-branch>'s README and main's version row both updated
```
If Step 4 ran, also list which old versions were removed and from where (release branch, GitHub tags/releases, main).
