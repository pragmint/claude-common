---
name: lint
disable-model-invocation: true
description: >
  Finds the project's linter and runs it with auto-fix enabled. Use this skill
  whenever the user wants to lint or auto-fix code style issues. Trigger when
  the user says "lint", "run the linter", "fix lint errors", "auto-fix style",
  or similar.
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
