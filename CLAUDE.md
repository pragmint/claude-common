# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Purpose

This is a meta-configuration repository containing reusable Claude Code skills. Components are distributed via the `skills` CLI, which symlinks resources into `~/.claude`.

## Structure

```
skills/           # All skill definitions — each subdirectory is one skill
  <name>/
    SKILL.md      # Skill entry point (YAML frontmatter + workflow body)
    references/   # Deep detail, checklists, domain content (optional)
    scripts/      # Bundled helper scripts (optional)
scripts/          # Implementation of the skills CLI subcommands
completions/      # Shell tab-completion for the skills CLI
skills.sh         # CLI entry point — routes to scripts/
```

## CLI (`skills.sh`)

`skills.sh` is the main entry point, installed as `skills` in `~/.local/bin` via `skills install`. It routes subcommands to the scripts in `scripts/`:

- `link [-a|--all]` — fzf single-select from unlinked items; `--all` links everything
- `unlink [-a|--all]` — fzf single-select from linked items; `--all` unlinks everything
- `select` — fzf multi-select to set the full linked/unlinked state in one pass
- `scrape` — pick a top-level folder in `$HOME`, find all `.claude` resources inside it (excluding symlinks back to this repo), fzf multi-select, then copy chosen items into the repo
- `ls|list` — show current link status of all resources
- `install` / `uninstall` — symlink/remove `skills` in `~/.local/bin`

`skills.sh` resolves its real path by following symlinks so it works correctly when invoked via the installed `~/.local/bin/skills` symlink.

Each script in `scripts/` uses `REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"` to resolve the repo root.

## Skill Format

Each skill lives in `skills/<name>/SKILL.md` with YAML frontmatter:

```yaml
---
name: skill-name
description: >
  When to use this skill and example trigger phrases. Under ~100 words —
  longer descriptions get truncated. Should be "pushy" toward triggering
  to counteract Claude's natural tendency to undertrigger.
---
```

The body is the workflow Claude follows when the skill is invoked. Use imperative step headings. Long reference material (checklists, schemas, domain content) belongs in `references/` and should be linked from `SKILL.md` with guidance on when to load it.

Skills may set `disable-model-invocation: true` in frontmatter when they exist purely to suppress model invocation on a matching slash command that has been superseded by a skill.

## TDD Workflow Skills

Four skills work together for test-driven development:

- **analyst** — reviews plans and code for quality issues before implementation
- **unit-tester** — writes one failing test at a time (TDD red phase)
- **incremental-implementer** — writes minimal code to pass failing tests (TDD green phase)
- **careful-refactorer** — improves code quality without breaking tests (refactor phase)

## Contributing Guidelines

Keep all skills general-purpose and project-agnostic. When adding a skill, consult `skills/skill-forge/references/best-practices.md` for the quality checklist — pay particular attention to the triggering description and progressive disclosure (what belongs in `SKILL.md` vs. `references/`).
