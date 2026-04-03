---
name: analyst
description: >
  Reviews and analyzes proposed solutions, plans, and code for simplicity, logic, and quality.
  Use this skill when the user wants a second opinion on a technical approach, wants to review
  a plan before implementing it, or asks whether a solution is well-designed. Trigger on phrases
  like "review this plan", "analyze this approach", "is this a good solution", "what do you think
  of this design", "check this before I implement it", or when the user shares a PLAN.md or
  technical proposal and wants feedback.
---

## Goal

Objectively analyze a proposed solution, plan, or implementation approach. Surface quality issues,
identify simpler alternatives, and provide actionable recommendations — before implementation begins.

## Input

The solution, plan, or code to analyze:

$ARGUMENTS

If no specific target is provided, look for a `PLAN.md` or `planning/` directory in the project root.

---

## Step 1: Understand the problem being solved

Before evaluating the solution, understand what it's trying to accomplish:

- Read any referenced plan documents, requirements, or issue descriptions
- Identify the actual problem (not the stated solution)
- Note any constraints or context that should shape the evaluation

If the problem statement is unclear, ask one focused question to clarify before proceeding.

---

## Step 2: Analyze the proposed solution

Evaluate the solution across these dimensions:

**Simplicity**
- Is there a simpler approach that achieves the same goal?
- Does it introduce complexity that isn't justified by the requirements?
- Are there abstractions being added speculatively, for hypothetical future needs?

**Logic and correctness**
- Does the solution actually solve the stated problem?
- Are there edge cases or failure modes that aren't handled?
- Are the assumptions valid?

**Maintainability**
- Will this be easy to understand and modify in the future?
- Does it follow established patterns already present in the codebase?
- Are names clear and intentions obvious?

**Security**
- Does the solution introduce any security implications (injection, unvalidated input, exposed secrets)?
- Are trust boundaries correctly enforced?

**Performance**
- Are there obvious performance concerns for the expected scale?
- Is there premature optimization that adds complexity without proven need?

**Testability**
- Can this be tested? Are the units well-defined?
- Does the design make dependencies explicit or hidden?

---

## Step 3: Form a verdict

Summarize your analysis with a clear verdict:

- **Approve** — the solution is sound; proceed with implementation
- **Approve with notes** — the solution is acceptable but has minor issues worth addressing
- **Request changes** — the solution has significant issues that should be resolved before implementation
- **Reject** — the solution doesn't solve the right problem or has fundamental flaws

---

## Step 4: Report findings

Structure your response as:

**Verdict**: [Approve / Approve with notes / Request changes / Reject]

**Summary**: One or two sentences on the overall assessment.

**Issues found** (if any): List each issue with:
- What the problem is
- Why it matters
- A concrete suggested fix

**What looks good** (if anything): Call out specific design decisions that are well-reasoned — a useful signal for the implementer about what to preserve.

**Decision criteria applied**:
- Prefer simple over clever
- Choose readable over concise when they conflict
- Favor established patterns over novel approaches
- Prioritize correctness over optimization
- Ensure the solution solves the actual problem, not an imagined one
