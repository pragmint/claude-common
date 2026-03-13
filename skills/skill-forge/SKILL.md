---
name: skill-forge
description: >
  Audits, repairs, and transforms artifacts into high-quality Claude Code skills.
  Use this skill whenever the user wants to fix or improve an existing skill
  (poor triggering, weak instructions, missing progressive disclosure), convert a
  slash command into a skill, or transform any other artifact — agent definition,
  rule, runbook, or loose markdown — into a proper skill. Trigger on phrases like
  "fix this skill", "improve this skill", "convert this command to a skill",
  "make this a skill", "this should be a skill", or whenever the user points at
  any markdown file and asks for it to be restructured or skill-ified.
---

## What this skill does

skill-forge has two modes:

- **Fix mode** — audits an existing skill for quality problems and rewrites it in place.
- **Convert mode** — takes a non-skill artifact (command, agent, rule, markdown) and produces a new skill from it.

Read the input, determine which mode applies, then follow the workflow below.

---

## Step 1: Identify the input

Read the file the user points at. If no file is specified, ask for it.

Determine the artifact type:

| Type | Signals |
|------|---------|
| **Skill** | Has `SKILL.md` filename or YAML frontmatter with `name:` + `description:` fields |
| **Command** | YAML frontmatter with `allowed-tools:` and/or `description:`, imperative step-by-step body, lives in `commands/` |
| **Agent** | YAML frontmatter with a role definition, lives in `agents/`, describes a subagent persona |
| **Rule** | Short declarative constraints, often lives in `.claude/rules/` or similar |
| **Markdown** | Everything else — runbook, workflow doc, loose notes |

---

## Step 2: Route to the right workflow

### Fix mode (input is a Skill)

Read `references/best-practices.md` for the full audit checklist.

High-level process:
1. Audit the skill against every category in the checklist
2. List the issues found — be specific (e.g. "description doesn't mention trigger phrases", "all instructions are in one SKILL.md block but exceed 300 lines")
3. Apply all fixes in one pass:
   - Rewrite the `description` frontmatter if triggering is weak
   - Restructure content into `references/` files if the skill body is too long or has separable detail
   - Strengthen thin or vague instructions
   - Add pointers to reference files where content was moved
4. Write the updated skill files

### Convert mode (input is a Command, Agent, Rule, or Markdown)

Read `references/conversion.md` for type-specific guidance.

High-level process:
1. Extract the artifact's intent, workflow, and any structured steps
2. Design a skill structure (SKILL.md + any needed `references/` or `scripts/`)
3. Write the skill to `skills/<derived-name>/SKILL.md` (and subdirectories as needed)
4. If the source was a **command**, also update the original command file — add `disable-model-invocation: true` to its YAML frontmatter. This prevents the command from triggering model invocation directly now that the skill owns the behavior.

---

## Step 3: Determine output location

- **Fix mode**: overwrite the existing skill in place. If new `references/` files are needed, create the `references/` subdirectory alongside `SKILL.md`.
- **Convert mode**: create `skills/<name>/SKILL.md`. Derive `<name>` from the artifact's title or filename in kebab-case.

If the output location would overwrite something unexpected, confirm with the user before writing.

---

## Step 4: Write the output

Write all files. Then report:

- What files were written or modified
- A brief summary of the key changes made (triggering improvements, structure changes, content added)
- Any areas that needed significant inference from sparse source material — flag these so the user knows where to review

---

## Quality bar

The output skill should pass every item in `references/best-practices.md`. If a fix or conversion would benefit from bundled scripts (e.g. the skill's instructions currently ask Claude to write the same helper script every time), note this explicitly even if you don't write the scripts — the user can follow up.
