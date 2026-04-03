---
name: incremental-implementer
description: >
  Implements the simplest possible code to make failing tests pass, following TDD principles.
  Use this skill when the user is in the green phase of TDD (tests are written and failing,
  now needs implementation), when tests exist and code needs to be written to satisfy them,
  or when implementing a feature incrementally one test at a time. Trigger on phrases like
  "make these tests pass", "implement this", "write the code for these tests", "TDD green phase",
  or when failing tests exist and the user wants them passing.
---

## Goal

Write the simplest code that makes failing tests pass. No more, no less. Let the tests drive
what gets implemented — avoid speculation about future requirements.

## Input

The failing tests or feature area to implement:

$ARGUMENTS

If no specific target is provided, run the test suite to discover what's currently failing.

---

## Step 1: Discover the current state

1. Run the test suite to identify all failing tests
2. Read the output carefully — note which tests are failing and what they expect
3. If there are no failing tests, report this and ask the user what they want to implement

---

## Step 2: Focus on one failing test

Pick the first (or simplest) failing test:

1. Read the test carefully — understand what behavior it is asserting
2. Identify what code needs to exist to satisfy this assertion
3. Do not look ahead at other failing tests — implement only what this test requires

---

## Step 3: Implement the minimum

Write the simplest code that will make the focused test pass:

- **Fake it first if needed**: returning a hardcoded value is a valid first step if a more
  general implementation isn't yet required by the tests
- **Don't over-engineer**: avoid abstractions, interfaces, or generalization not required by
  the current test
- **Don't break passing tests**: run the suite after each change to verify no regressions
- **Stay in the green**: if an intermediate state breaks other tests, fix it before moving on

---

## Step 4: Repeat

Once the current test is passing:

1. Run the full suite — confirm no regressions
2. Move to the next failing test
3. If the new test requires generalizing a previously faked implementation, do so now
4. Repeat until all failing tests pass

---

## Step 5: Verify and report

After all target tests pass:

1. Run the full test suite — confirm everything is green
2. Run the build — confirm no compile errors
3. Review what was implemented: is anything speculative or not required by the tests?
   Remove anything that isn't justified by a test.

Report:
- Which tests are now passing
- What code was written (files changed, key decisions made)
- Any implementation notes the user should know (e.g., hardcoded values that a future test should drive out)
