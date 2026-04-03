---
name: bun-tester
description: >
  Writes and runs unit tests using Bun's test runner, with a purity-first testing philosophy.
  Use this skill when the user wants to add tests for a module or function, improve test coverage,
  assess testability, or evaluate whether code should be refactored before testing. Trigger on
  phrases like "add tests for this", "write unit tests", "test coverage for this function",
  "is this testable", "test this module with bun", or when new code is written and the user
  wants tests added. Specializes in Bun's test runner — prefer this over unit-tester when the
  project uses Bun.
---

## Goal

Write meaningful, high-quality unit tests using Bun's test runner. Prioritize testing pure
functions thoroughly. For impure code, evaluate refactoring opportunities before writing
tests that rely on heavy mocking.

## Input

The module, function, or code area to test:

$ARGUMENTS

---

## Step 1: Purity analysis

Read the source code and classify the module:

**Pure** — The function:
- Takes explicit inputs (parameters) and returns explicit outputs
- Has no side effects (no file I/O, network calls, database access, external state mutation)
- Does not depend on injected services, singletons, or global state
- May import other pure functions, types, schemas, or constants (these are fine)

**Impure** — The function:
- Reads from the filesystem, network, or database
- Depends on injected services or modules with side effects
- Mutates external state
- Uses `Date.now()`, `Math.random()`, or other non-deterministic sources without injection

Report your findings:

- If **pure**: state that the module is functionally pure and explain why, then proceed directly to writing tests
- If **impure**: identify each impure dependency explicitly. Discuss with the developer whether refactoring would be beneficial. Suggest specific strategies:
  - Extract pure logic into separate functions
  - Use dependency injection to make impure dependencies mockable
  - Separate orchestration (impure) from computation (pure)
  - Move I/O to the boundaries

  Wait for the developer's decision before proceeding. If they choose to refactor, help with that first. If they choose to test as-is, proceed with appropriate mocking.

---

## Step 2: Write tests

Use Bun's test runner with these conventions:

```typescript
import { describe, it, expect, beforeEach, afterEach, mock, spyOn } from 'bun:test';
```

**For pure functions:**
- Test all meaningful input combinations including edge cases
- Test boundary conditions (empty arrays, zero values, undefined optional params)
- Test error cases (invalid inputs, expected thrown errors)
- Group related tests in `describe` blocks
- No mocks needed — this is the value of pure functions

**For impure functions (when developer chooses to test as-is):**
- Use `mock()` and `spyOn()` from `bun:test`
- Mock at the boundary — mock the I/O, not the business logic
- Keep mocks minimal and focused
- Always clean up mocks in `afterEach`

**Test structure — always Arrange/Act/Assert:**

```typescript
it('should return aggregated scores for a valid team', () => {
  // Arrange
  const team = createTestTeam({ id: 'alpha', capabilities: ['ci-cd'] });
  const scores = [createTestScore({ capabilityId: 'ci-cd', score: 3 })];

  // Act
  const result = aggregateTeamScores(team, scores);

  // Assert
  expect(result.overall).toBe(3);
  expect(result.capabilities).toHaveLength(1);
});
```

**Test file placement:**
- Test files live alongside source files as `*.test.ts` (e.g., `myModule.test.ts` next to `myModule.ts`)
- Import from the module under test using relative paths

**Coverage targets:**
- Pure modules: aim for 80–95% — these are cheap to test comprehensively
- Impure modules tested as-is: focus on happy path and critical error paths; 50–70% is often appropriate
- Don't chase coverage on I/O wiring code

---

## Step 3: Run and verify

After writing tests:

1. Run the specific test file: `bun test path/to/file.test.ts`
2. If tests fail, diagnose and fix — do not leave failing tests
3. Iterate until all tests pass

---

## Step 4: Report

Summarize:
- What was tested and why those cases were chosen
- Purity classification and reasoning
- Coverage assessment — what's covered, what was intentionally left untested and why
- Any bugs found in source code while writing tests (report these to the developer)
- Any refactoring recommendations if the module was impure

---

## Quality standards

- Never test implementation details — test behavior and outputs
- Never write a test that would pass even if the function were broken
- Prefer specific assertions (`toBe`, `toEqual`, `toContain`) over loose ones (`toBeTruthy`)
- Use descriptive test names that explain the scenario and expected outcome
- For Zod schemas, test both valid parsing and expected validation errors
