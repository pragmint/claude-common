---
name: conventional-commit
description: >
  Creates git commits that strictly follow the Conventional Commits v1.0.0 specification
  (https://www.conventionalcommits.org). Use whenever the user asks to commit, make a commit,
  or stage and commit changes — especially when they mention "conventional commits", "commit
  format", or "semantic commits". Also triggers on phrases like "/commit", "commit my changes",
  "commit this", or "commit with conventional format". Prefer this skill over ad-hoc committing
  when in a repo that uses structured commit messages.
---

## Goal

Stage and commit changes using a commit message that strictly conforms to the
Conventional Commits v1.0.0 specification. Read `references/spec.md` for the
full format rules before writing any commit message.

---

## Step 1: Inspect the working tree

Run these in parallel:

```bash
git status
git diff --stat HEAD
git diff HEAD
```

Identify:
- Which files are modified, added, or deleted
- Whether any changes are already staged vs. unstaged
- The overall nature of the change (new feature, bug fix, refactor, etc.)

---

## Step 2: Determine what to stage

If the user specified files, stage only those. Otherwise, group the changes
and ask whether to commit everything or a subset — especially if unrelated
changes exist in the working tree.

Stage with specific paths, not `git add -A` or `git add .`, to avoid
accidentally including secrets or unrelated files.

---

## Step 3: Draft the commit message

Read `references/spec.md` now for the exact format and rules.

Work through these questions in order:

1. **Type** — what kind of change is this? Choose from:
   `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`
   Use `feat` for new capability, `fix` for bug corrections. See `references/spec.md`
   for the full type guide.

2. **Scope** — is there a logical component, module, or area this change belongs to?
   Keep it short (one word or hyphenated phrase). Omit if the change spans many areas.

3. **Breaking change** — does this change the public API or break existing callers?
   If yes, add `!` before the colon AND include a `BREAKING CHANGE:` footer.

4. **Description** — one line, imperative mood, lowercase, no trailing period,
   under 72 characters. Summarises *what* changed, not *why*.

5. **Body** — include only if the description alone doesn't convey enough context.
   Explain *why* the change was made, or what problem it solves. Wrap at 72 characters.

6. **Footers** — include `BREAKING CHANGE: <description>` if applicable.
   Other footers (e.g. `Closes #123`, `Reviewed-by: ...`) are optional.

---

## Step 4: Commit

Use a heredoc to pass the message to avoid shell escaping issues:

```bash
git commit -m "$(cat <<'EOF'
<type>[(<scope>)]: <description>

[optional body]

[optional footer(s)]
EOF
)"
```

Verify the commit was created:

```bash
git log -1 --oneline
```

---

## Step 5: Report back

Show the user:
- The full commit message as written
- The commit hash (short form)
- Any staged files included

If the commit fails (e.g. pre-commit hook), diagnose the error, fix it, and
retry as a new commit — never use `--no-verify` unless the user explicitly asks.
