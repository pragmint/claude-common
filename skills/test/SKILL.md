---
name: test
disable-model-invocation: true
description: >
  Discovers and runs the test suite for the project. Use this skill whenever
  the user wants to run tests or verify the test suite passes. Trigger when
  the user says "run tests", "run the tests", "test", "check tests", or
  similar.
---

# Test

Automatically discover and run the project's test suite, providing clear feedback on test results.

## Steps

* Scan the codebase for evidence of a test framework
  * Look for common test files (package.json, Makefile, pytest.ini, etc.)
  * Check for test directories or test file patterns
  * If tests are found
    * Determine the appropriate test command
    * Run the test suite
    * Report results clearly
  * If no tests are found
    * Tell the user no test suite has been found
