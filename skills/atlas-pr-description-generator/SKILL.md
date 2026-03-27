---
name: atlas-pr-description-generator
description: >
  Generates a structured PR description for the current branch based on git history and diffs,
  gets user approval, then updates the GitHub PR using the `gh` CLI. Use whenever the user asks
  to generate, write, or update a PR description.
---

## Goal

Analyse the current branch's commits and diff, draft a PR description in the Atlas format, get
user approval, then push it to the open GitHub PR.

---

## Step 1: Gather context

Run the following in parallel:

1. Identify the current branch and its base (usually `dev`):
   ```bash
   git rev-parse --abbrev-ref HEAD
   ```

2. Get all commits on this branch since diverging from the base:
   ```bash
   git log dev..HEAD --oneline
   ```

3. Get the full diff of changes:
   ```bash
   git diff dev...HEAD --stat
   git diff dev...HEAD
   ```

4. Check if a PR already exists for this branch:
   ```bash
   gh pr view --json number,title,body 2>/dev/null || echo "no PR"
   ```

---

## Step 2: Draft the PR description

Using the commit messages, diff stats, and code changes, draft a description using **exactly**
this format:

```markdown
# TL;DR
{One or two sentences summarising the entire PR at a high level — what it does and why.}

# What's changed?
- {Bullet point per logical change — what was added, modified, or removed}
- {Keep bullets concrete and specific, not vague}
- {Group related changes if there are many}

# How to test?
1. {Step-by-step instructions to manually verify the changes work}
2. {Cover the main happy path and any key edge cases changed by this PR}
3. {Be specific — mention which page, form, or action to use}

# Why make this change?
{One paragraph explaining the motivation — what problem this solves, what gap it fills, or what
requirement it satisfies. Link to a ticket if one is referenced in the commits or branch name.}

# Breaking changes or important notes
- {List any breaking changes, migration steps, or important caveats}
- {If none, write: None.}
```

**Guidelines:**
- Extract ticket references from the branch name (e.g. `fix/WFM1-961/...` → `WFM1-961`) and
  mention them in the "Why" section.
- Keep the TL;DR to 1–2 sentences max.
- "What's changed" bullets should describe *what* changed, not just file names.
- "How to test" steps must be actionable — a developer unfamiliar with the area should be able
  to follow them.
- If there are no breaking changes, explicitly state "None."

---

## Step 3: Present for approval

Show the full drafted description to the user and ask:

> "Does this look good? Reply **yes** to update the PR, or tell me what to change."

Wait for the user's response. If they request changes, revise the draft and show it again.
Repeat until they approve.

---

## Step 4: Update the PR

Once approved, update the PR description using the `gh` CLI:

```bash
gh pr edit --body "$(cat <<'EOF'
{approved description here}
EOF
)"
```

If no PR exists yet, inform the user and offer to create one:

```bash
gh pr create --title "{derived from TL;DR or first commit}" --body "..."
```

Confirm success by printing the PR URL:

```bash
gh pr view --json url -q .url
```
