# Converting Artifacts to Skills

Reference for Convert mode. Find the section matching the artifact type.

---

## Commands → Skills

### Why convert?

Commands require the user to type a slash prefix. Skills trigger contextually based on what the user is trying to do. Converting a command to a skill means the behavior is available without the user needing to remember a specific invocation syntax.

### What to do with the original command

After creating the skill, update the source command's YAML frontmatter to add:

```yaml
disable-model-invocation: true
```

This prevents the command from triggering model invocation on its own. The skill now owns the behavior; the command stub remains for any tooling that references it by name.

### Mapping command concepts to skill concepts

| Command concept | Skill equivalent |
|----------------|-----------------|
| `allowed-tools:` frontmatter | Mention required tools in `compatibility:` frontmatter (optional) or in the skill body |
| `description:` frontmatter | `description:` frontmatter — but rewrite it to be trigger-oriented, not just descriptive |
| Step-by-step `## Steps` body | Skill workflow body — preserve the logic, but add *why* to each step |
| Implicit input (`$ARGUMENTS`) | Make input handling explicit: what the user provides, what to do if it's missing |

### Things to improve during conversion

Commands are often written tersely — that's fine for human-readable docs but makes poor skill instructions. When converting:

- Expand terse steps into full instructions with reasoning
- Add edge case handling (what if the input is ambiguous?)
- Define the output clearly
- Consider whether any steps are repetitive enough to warrant a bundled script
- Write a trigger-oriented description (see best-practices.md §1)

### Deriving the skill name

Use the command filename in kebab-case, dropping `.md`. Example: `commit.md` → `commit`, `healthy-run.md` → `healthy-run`.

---

## Agents → Skills

### When agents become skills

An agent definition is a subagent persona — it describes *how* to behave when spawned by another command. Convert an agent to a skill when:

- The agent's behavior would be more useful if it triggered contextually
- The agent has been used repeatedly as a standalone workflow, not just as a subprocess
- The agent contains domain knowledge that's valuable outside the orchestration context

### How to convert

1. Read the agent's role definition and responsibilities
2. Identify the "user-facing" trigger — what would a user say to want this behavior?
3. Write a skill description around that trigger
4. Preserve the agent's reasoning patterns and domain knowledge in the skill body
5. Remove subagent-specific framing ("when spawned by...", "return results to the caller") — replace with direct workflow instructions

### What to do with the original agent

If the agent is still used as a subagent in orchestration commands, keep it. Agents and skills serve different purposes — an agent can exist alongside a skill that covers similar ground.

---

## Rules → Skills

### When rules become skills

Rules are declarative constraints. They become skills when:

- They describe a workflow, not just a constraint
- They've grown to include enough context that a skill's progressive disclosure would help
- They're being triggered by commands but would benefit from contextual triggering

### How to convert

1. Identify the behavior the rule is trying to enforce
2. Determine if this is better expressed as a skill workflow or left as a rule
   - Pure constraints ("never commit secrets") → stay as rules
   - Operational workflows with steps → convert to skills
3. For workflows: extract the steps, add reasoning, write as a skill
4. For hybrid cases: keep the rule for the constraint, create a skill for the associated workflow

---

## Markdown → Skills

### Runbooks and workflow documents

These are the most common source. A runbook usually has:
- A goal/purpose section
- Prerequisites
- Step-by-step instructions
- Expected outcomes

Map these to a skill:

| Runbook section | Skill equivalent |
|----------------|-----------------|
| Title / purpose | `description:` frontmatter |
| Prerequisites | Input handling + compatibility |
| Steps | Skill workflow body |
| Expected outcomes | Output definition and report-back step |
| Long reference tables / appendices | `references/` files |

### Loose notes / brainstorming docs

If the source is exploratory rather than procedural:

1. Identify the core task or decision the document is working toward
2. Use that as the skill's purpose
3. Extract any concrete steps or patterns as the workflow
4. Flag anything that was inferred rather than explicit

### Design documents

If the source is a design or spec doc (not a how-to), convert it to a skill that *implements* what the doc describes, not one that explains the design. The skill should be action-oriented.

---

## General conversion principles

**Preserve intent, not form.** The source document's structure is rarely the right structure for a skill. Extract the *purpose* and *steps*, then design the skill fresh.

**Explain the why.** Source documents often have terse steps. Skills work better when Claude understands the reasoning behind each step — it can then handle edge cases the original author didn't anticipate.

**Right-size the reference files.** If the source is long, don't just dump it into `references/` as-is. Edit it to be useful as a reference: add a table of contents, remove content that's now redundant with SKILL.md, focus it on the detail that SKILL.md legitimately delegates.
