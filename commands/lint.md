---
allowed-tools: [Bash]
description: Finds a linter if it exists and runs it
---

# Lint

Auto-fix linting issues in the project by finding the pre-configured linter and running it.

## Steps

* Scan the codebase for evidence of a linter
  * If a linter is found
    * Figure out the command required to run the linter such that changes are applied
    * Run that command
  * If no linter is found
    * Tell the user no linter has been found
