---
name: standup-generator
description: >
  Generates a formatted standup report from Linear tickets assigned to $LINEAR_CURRENT_USER.
  Fetches live issue data (Todo, In Progress, In Review, Done, Dev Complete, Canceled, Duplicate), calculates time waiting for review,
  and formats a markdown report. Use whenever the user asks to generate, write, or create a standup
  report or standup update.
---

## Goal

Fetch all Linear tickets assigned to the current user and produce a clean markdown
standup report grouped by status.

Do **not** pre-check or validate env vars before proceeding. Just attempt each step. If a
command fails due to a missing or invalid env var, report the specific error and stop.

---

## Step 1: Fetch issues from Linear

Run the following command to fetch all relevant issues in one shot. The query returns issue
titles, URLs, state names, GitHub PR attachments, and state-transition history:

```bash
BODY=$(printf '{"query":"{ issues(filter: { assignee: { displayName: { eq: \"%s\" } }, state: { name: { in: [\"Todo\", \"In Progress\", \"In Review\", \"Done\", \"Dev Complete\", \"Canceled\", \"Duplicate\"] } } }, first: 100) { nodes { id title url identifier state { name } attachments { nodes { title url } } history { nodes { createdAt fromState { name } toState { name } } } } } }"}' "$LINEAR_CURRENT_USER")

curl -s "https://api.linear.app/graphql" \
  -H "Authorization: $LINEAR_API_KEY" \
  -H "Content-Type: application/json" \
  -d "$BODY"
```

---

## Step 2: Process the data

Parse the JSON response. For each issue:

1. **GitHub PR URL** — scan `attachments.nodes` and find the first URL containing `github.com`.
   If none exists, omit the GitHub field entirely.

2. **Time Waiting for Review** — only relevant for issues currently in `"In Review"` state:
   - Walk `history.nodes` (they are ordered newest-first) and find the **most recent** entry
     where `toState.name == "In Review"`.
   - Calculate `(now - that entry's createdAt)` in days, rounded to one decimal place.
   - If no such history entry exists, omit the field.

3. **Group issues** by state in this order:
   - `In Review`
   - `In Progress`
   - `Dev Complete`
   - `Todo`
   - `Done`
   - `Canceled`
   - `Duplicate`

   Omit any group that has no issues.

---

## Step 3: Format the report

Produce the report using **exactly** this structure. The outer heading for each group uses `#`.
Each issue uses a flat field list — no sub-headings. Follow the field order shown.

```
# Review Needed

Title: {issue title}
Linear: {issue url}
Github: {github pr url — omit this line if no PR exists}
Time Waiting for Review: {X.X days}
Notes:

---

Title: ...
```

```
# In Progress

Title: {issue title}
Linear: {issue url}
Github: {github pr url — omit this line if no PR exists}
Notes:

---

Title: ...
```

```
# Todo

Title: {issue title}
Linear: {issue url}
Notes:

---
```

```
# Done

Title: {issue title}
Linear: {issue url}
Github: {github pr url — omit this line if no PR exists}
Notes:

---
```

```
# Dev Complete

Title: {issue title}
Linear: {issue url}
Github: {github pr url — omit this line if no PR exists}
Notes:

---
```

```
# Canceled

Title: {issue title}
Linear: {issue url}
Notes:

---
```

```
# Duplicate

Title: {issue title}
Linear: {issue url}
Notes:

---
```

**Formatting rules:**
- `Notes:` is always included but left blank — the user fills it in before posting.
- Use `---` as a horizontal rule separator between issues within a group, but not after the last
  issue in a group.
- `In Progress`, `Dev Complete`, `Todo`, `Done`, `Canceled`, and `Duplicate` issues do **not** have a `Time Waiting for Review` field.
- `Canceled` and `Duplicate` issues do **not** have a `Github` field.
- If a group has only one issue, no separator is needed.

---

## Step 4: Write the report to disk

Write the report to the dir saved in the `$LINEAR_STANDUP_DIR` env var. Name
the file using today's date in `YYYY-MM-DD` format — e.g. `2026-03-30.md`.
Create the directory if it does not exist:

```bash
mkdir -p "$LINEAR_STANDUP_DIR"
```

Then write the file using the Write tool (not a shell redirect), with the full report content.

---

## Step 5: Present and confirm

Output the full formatted report in a single code block so the user can copy it directly.
Tell the user the file path it was written to.

Then ask:

> "Anything to update before you post? You can fill in the Notes fields or let me know if
> any tickets are missing."

If the user requests changes, apply them, re-output the updated report, and overwrite the file.
