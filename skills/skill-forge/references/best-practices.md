# Skill Best Practices Checklist

Use this when auditing an existing skill in Fix mode. Work through every category.

---

## 1. Triggering (description frontmatter)

The `description` field is the primary mechanism by which Claude decides to invoke a skill. A weak description means the skill never fires.

**Check for:**

- Does the description say *when* to use the skill, not just *what* it does? Both are needed.
- Does it include concrete trigger phrases a user would actually type? ("fix this skill", "convert this command", etc.)
- Does it cover edge cases where the skill should fire even if the user doesn't name it explicitly?
- Is it slightly "pushy" — does it lean toward triggering rather than leaving it ambiguous? This counteracts Claude's natural tendency to undertrigger.
- Is it under ~100 words? Longer descriptions get truncated in context.

**Common failures:**
- Description only describes the output, not the invocation context
- No example trigger phrases
- Too abstract ("manages skill lifecycle") vs. concrete ("use when the user says 'fix this skill' or points at a SKILL.md")

---

## 2. Progressive disclosure

Skills use a three-level loading system. Content should live at the right level.

| Level | What belongs here | Size target |
|-------|------------------|-------------|
| Metadata (name + description) | Triggering signal only | ~100 words |
| SKILL.md body | Core workflow, routing logic, output rules | Under 500 lines |
| `references/`, `scripts/`, `assets/` | Deep detail, reference material, reusable code | Unlimited |

**Check for:**

- Is SKILL.md doing too much? If it has large reference tables, exhaustive checklists, or detailed domain content, those belong in `references/`.
- Are there clear pointers from SKILL.md to the reference files, with guidance on *when* to read each one?
- For large reference files (>300 lines), is there a table of contents?
- Are scripts that Claude writes fresh every time good candidates for bundling in `scripts/`?

**Signs of poor disclosure:**
- SKILL.md is over 400 lines and contains content that could be separated
- Reference files exist but SKILL.md never says when to read them
- The same helper script appears in multiple test transcripts (should be bundled)

---

## 3. Instruction quality

**Check for:**

- Are instructions written in the imperative form? ("Read the file", not "You should read the file")
- Does the skill explain *why* steps matter, not just *what* to do? LLMs follow reasoning better than raw directives.
- Are edge cases addressed? What happens if the input is ambiguous, missing, or malformed?
- Is the expected output format clearly defined? If the skill produces a file or a structured response, is the format specified?
- Are there examples? Even one concrete example per key concept helps significantly.
- Are MUST/ALWAYS/NEVER used sparingly? If they appear frequently, the instructions are probably over-constrained. Prefer explaining the reasoning instead.

**Signs of thin instructions:**
- Steps are one-liners with no elaboration
- No output format definition
- No edge case handling
- Heavy use of imperative commands without explaining why

---

## 4. Structure and organization

**Check for:**

- Does the skill have a clear entry point? It should be obvious where to start.
- Is related content grouped? (All output formatting rules together, all input handling together)
- Are file paths and dependency assumptions documented?
- If the skill supports multiple variants or modes, are they clearly separated?

**Domain organization pattern** — when a skill handles multiple cases, organize by variant:
```
my-skill/
├── SKILL.md          (detect variant, route to reference)
└── references/
    ├── variant-a.md
    └── variant-b.md
```

---

## 5. Bundled resources

**Check for:**

- `scripts/` — deterministic or repetitive operations the skill currently asks Claude to write ad-hoc. If a test run would likely produce the same script every time, bundle it.
- `references/` — documentation, checklists, schemas, reference tables that are too long for SKILL.md.
- `assets/` — templates, icons, fonts, static files used in output.

Resources should be referenced from SKILL.md with clear guidance on when and why to load them.

---

## 6. Output definition

**Check for:**

- Is it clear what the skill produces? (A file? A report? Modified files? A response in chat?)
- Is the output location defined? (Where files get written)
- Is there a "report back" step that tells the user what was done?

---

## Audit output format

When reporting audit findings, use this structure:

```
## Issues found

### [Category] Short description of issue
- What's wrong
- Why it matters
- What was changed

(repeat per issue)

## Changes made
- [file path]: what changed
```
