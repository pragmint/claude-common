---
allowed-tools: [Bash]
description: Creates a new feature branch from an up-to-date main branch
---

# Branch

Create a new feature branch from the main branch, ensuring the main branch is up-to-date with the remote.

## Steps

* Switch to main branch
  * Check current branch status
  * Switch to main branch (usually `main` or `master`)
* Update main branch
  * Pull latest changes from the remote repository
  * Ensure the main branch is clean and up-to-date
* Create feature branch
  * Generate a descriptive branch name based on the task
  * Create and switch to the new feature branch
  * Confirm the branch was created successfully
* Report status
  * Inform the user of the new branch name
  * Confirm the branch is ready for development
