---
allowed-tools: [Bash]
description: Creates focused commits with consistent commit message format
---

# Commit

Create small, focused commits following best practices for commit messages and atomic changes.

## Steps

* Review current changes
  * Check git status to see modified files
  * Review staged and unstaged changes
  * Ensure changes are focused and related
* Stage appropriate changes
  * Add files that belong together logically
  * Avoid staging unrelated changes in the same commit
  * Use `git add -p` for partial file commits when needed
* Create commit message
  * Follow conventional commit format when possible
  * Use imperative mood ("Add feature" not "Added feature")
  * Keep first line under 50 characters
  * Add detailed description if needed
* Create the commit
  * Commit with the crafted message
  * Verify the commit was created successfully
* Report status
  * Show the commit hash and message
  * Confirm the commit is ready for pushing
