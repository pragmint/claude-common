# Claude Common

A collection of reusable Claude Code commands, agents, and skills for use across projects.

## Getting Started

**1. Clone the repo**

```sh
git clone <repo-url> ~/claude-common
cd ~/claude-common
```

**2. Install the `skills` CLI**

```sh
bash skills.sh install
```

**3. Add `~/.local/bin` to your PATH** (if not already there)

```sh
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**4. Link resources to Claude Code**

```sh
skills link --all       # link everything at once
skills link             # or pick individual items interactively
```

## CLI Reference

```
skills link   [-a|--all]  fzf single-select from unlinked items (--all links everything)
skills unlink [-a|--all]  fzf single-select from linked items (--all unlinks everything)
skills select             fzf multi-select to set full linked/unlinked state in one pass
skills scrape             Pick a folder, find .claude resources inside, copy into repo
skills ls|list            Show current link status of all resources
skills install            Add 'skills' to ~/.local/bin
skills uninstall          Remove 'skills' from ~/.local/bin
```

## Available Resources

**Commands**
- `branch` - Create a feature branch from an up-to-date main
- `build` - Discover and run the project build system
- `commit` - Create focused, atomic commits
- `healthy-run` - Start the app and verify it's running correctly
- `lint` - Find and run the project linter
- `orchestrate` - Full TDD workflow coordinating agents and commands
- `plan` - Create a structured plan document
- `test` - Discover and run the test suite

**Agents**
- `analyst` - Reviews plans and code for quality issues
- `unit-tester` - Writes failing tests (TDD red phase)
- `incremental-implementer` - Makes failing tests pass (TDD green phase)
- `careful-refactorer` - Improves code quality without breaking tests

**Skills**
- `pragmint` - Pragmint skill definitions

## Contributing

Keep all commands and agents general-purpose and project-agnostic. Do not embed project-specific details.
