---
name: unit-tester
description: >
  Writes focused unit tests following TDD principles, one test at a time. Use this skill
  when the user wants to add test coverage, write the next failing test in a TDD cycle, or
  improve the testability of their code. Trigger on phrases like "write a test for this",
  "add test coverage", "TDD red phase", "what should I test next", "write failing tests",
  or when starting a new increment in a TDD workflow.
---

## Goal

Write one focused, failing unit test at a time. Tests should be small, specific, and isolated.
Each test should fail for the right reason — not because of a syntax error or missing dependency,
but because the implementation doesn't yet exist or doesn't satisfy the assertion.

## Input

The feature, function, or behavior to test:

$ARGUMENTS

If no specific target is provided, check for a plan document (PLAN.md or similar) to determine
the next logical test to write.

---

## Step 1: Understand the context

Before writing any test:

1. Read any plan document to understand the overall goal and current progress
2. Look at the existing test files to understand conventions (naming, structure, imports, test runner)
3. Look at the existing implementation (if any) to understand what's already covered
4. Identify the next most valuable test to write — the smallest behavior that isn't yet tested

Do not write tests for things that are already tested. Do not skip ahead to complex cases
when simpler foundational cases aren't covered yet.

---

## Step 2: Write one test

Write a single failing test:

- **One assertion per test** (or a tight cluster of related assertions for a single behavior)
- **Descriptive name**: the test name should read like a specification — what the function does
  under this condition, not what the test is checking
- **Arrange / Act / Assert structure**: separate setup, execution, and assertion clearly
- **No implementation details**: test behavior and outputs, not how the code works internally
- **Fast and isolated**: no real network calls, file I/O, or database access unless the function
  requires it and it can't be avoided

Use the testing framework and conventions already established in the project.

---

## Step 3: Verify the test fails correctly

Run the new test in isolation:

1. It should fail — if it passes immediately, something is wrong (testing the wrong thing,
   implementation already exists, assertion is too loose)
2. The failure message should make sense — it should describe the missing behavior, not a
   crash or import error
3. If the test errors rather than fails, fix the test setup before proceeding

---

## Step 4: Report

Tell the user:
- The test that was written (file, test name, what behavior it covers)
- Why this test was chosen as the next one
- What the failing output looks like
- A clear handoff: "Run the implementation skill to make this test pass"
