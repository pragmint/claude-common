---
allowed-tools: [Task, Bash]
description: High-level command that orchestrates other commands and agents to complete complex development tasks
---

# Orchestrate

A high-level command that coordinates the work of specialized agents and commands to orchestrate coherent, well-structured changes following TDD principles. Takes a task description and automatically manages the full development workflow.

## Usage

```
/orchestrate "Add user authentication to the API"
```

## Arguments

- `task`: A string describing the development task to be completed

## Workflow

The orchestrator follows a structured development process:

### 1. Health Check Phase
- Uses `/healthy-run` to verify the system is currently working
- Uses `/test` to ensure all tests are passing
- Reports any issues before proceeding

### 2. Planning Phase
- Uses `/plan` command to create a comprehensive plan document
- Uses `analyst` agent for technical analysis and research
- Breaks down complex tasks into manageable increments
- Requires user approval of the plan before proceeding to the next step

### 3. Setup Phase
- Uses `/branch` command to create a feature branch
- Ensures clean working state

### 4. Development Cycle
For each increment in the plan:
1. Uses `unit-tester` agent to write a failing test
2. Uses `incremental-implementer` agent to make all failing tests pass
3. Uses `careful-refactorer` agent to improve code quality while keeping the test suite in a passing state
4. Uses `/test`, `/build`, `/lint` commands to verify system health
5. Reviews the document that the planning phase generated to see if there are more steps to take (going back to the beginning of the development cycle if so).
5. Uses `/commit` command for atomic changes

### 5. Quality Gates
- Runs `/healthy-run` to verify system integrity
- Ensures all tests are passing
- Verifies build is successful

## Key Principles

- **TDD Red-Green-Refactor**: Follows test-driven development at the system level
- **Atomic Changes**: Each commit represents a complete, working increment
- **System Stability**: Maintains deployable state throughout development
- **Quality First**: Prioritizes test coverage and code quality
- **Incremental Progress**: Breaks complex changes into manageable pieces

## Error Handling

- Stops execution if health checks fail initially
- Rolls back incomplete changes if critical failures occur
- Reports all issues clearly to the user
- Provides recovery suggestions when possible

## Integration Strategy

- Coordinates timing of dependent changes across agents
- Manages conflicts between different workstreams
- Adapts workflow based on project-specific constraints
- Uses specialized agents for their specific strengths
