# Orchestration Definition

Slash Commands Docs: https://docs.anthropic.com/en/docs/claude-code/slash-commands

## Ensure the system is green

- Run tests
- Health check
- Telemetry Looks Normal
    - Look at historical data

## Next Task

Understand what our next goal is.

Perspective:
- Technical perspective
    - Current state
    - Desired state
- Business perspective
    - Current state
    - Desired state

Pre Steps:
- Research
- Checking out code

## Do the Task

1. Make failing accptance tests (where applicable)
2. Failing unit test
3. Write simplist solution to pass the test
4. Refactor the tests while staying green
5. Refactor production code while staying green
6. Repeat steps 2 - 5 until acceptance test is passing
7. Review changes to:
    - Verify correctness
    - Verify Code Quality
8. Create pull request
    - Commit
    - Push to branch
    - Create PR

## Other

- Be efficient with tokens.
- Paired down requirements.
- Make use of sub agents.
- Does not have access to deploy to main.

## Expectations

We do not expect a large percent of success. Even a 10% - 20% would be
acceptable for this.

We also expect when coming into this env:
1. Automated test suite
2. Linter
3. Telemetry / Logging
3. Lower Environments
4. Test Database
5. Version Control

