---
allowed-tools: [Bash]
description: Finds a linter if it exists and runs it
---

# Lint

Auto-fix linting issues in the project by finding the pre-configured linter and running it.

## Steps

1. Scan the codebase for evidence of a linter
  a. If linter is found
    1. Figure out the command required to run the linter such that changes are applied
    2. Run that command
  b. If no linter is found
    1. Tell the user no linter has been found
