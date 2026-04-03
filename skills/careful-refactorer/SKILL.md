---
name: careful-refactorer
description: >
  Improves code quality through safe, incremental refactoring while keeping tests green and
  the build passing. Use this skill when the user wants to clean up code without changing
  behavior, reduce duplication, improve readability, or restructure code after a feature is
  working. Trigger on phrases like "refactor this", "clean this up", "improve code quality",
  "reduce duplication", "rename for clarity", "this is too complex", or after a feature is
  implemented and the user wants a quality pass.
---

## Goal

Improve code quality through careful, incremental refactoring. Every change must preserve
existing behavior and keep tests passing. No refactoring without a green baseline.

## Input

The file(s) or area to refactor, and any specific quality goals:

$ARGUMENTS

If no specific target is provided, ask the user what area they want to improve.

---

## Step 1: Establish a green baseline

Before making any changes:

1. Run the test suite to confirm all tests pass
2. Run the build to confirm no build errors
3. If tests are failing, **stop** — do not proceed. Refactoring on a red baseline is unsafe.
   Report the failures and ask the user to fix them first.

---

## Step 2: Identify refactoring opportunities

Read the target code carefully. Look for:

- **Duplication**: Same logic in multiple places — extract to a shared function
- **Long methods or functions**: Break into smaller, well-named pieces
- **Poor names**: Variables, functions, or classes whose names don't communicate intent
- **Complex conditionals**: Nested logic that can be simplified with early returns or extracted predicates
- **Dead code**: Unused imports, variables, or functions
- **Inconsistent style**: Formatting or patterns that differ from the surrounding codebase
- **Unnecessary abstraction**: Layers of indirection that add complexity without benefit

Prioritize by impact: focus on changes that most improve readability and maintainability.

---

## Step 3: Refactor incrementally

For each refactoring:

1. Make one focused change at a time — extract a method, rename a variable, simplify a conditional
2. Run the test suite after **each change**
3. If tests go red, undo the change immediately — do not proceed with a broken baseline
4. Commit frequently to create safe rollback points

Types of safe refactoring (in rough order of safety):
- Rename (variables, functions, classes) — safe with good IDE support
- Extract function/method — safe when the extracted unit has no hidden dependencies
- Inline function — safe when the function is trivially simple
- Remove dead code — safe when confirmed unused
- Simplify conditionals (early returns, guard clauses) — safe but read carefully
- Restructure (move code between files/modules) — higher risk, do last

---

## Step 4: Verify the final state

After all changes:

1. Run the full test suite — all tests must pass
2. Run the build — no errors or new warnings
3. Review the diff: does every change clearly improve something?

---

## Step 5: Report

Summarize what was done:

- What refactorings were applied (and to which files)
- What the code looks like now vs. before
- Any areas that were considered but left alone (and why)
- Any follow-up opportunities worth noting for a future pass
