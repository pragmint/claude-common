#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

link_file() {
  local src="$1"
  local dest="$2"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "  skip   $dest (already exists)"
  else
    ln -s "$src" "$dest"
    echo "  linked $dest -> $src"
  fi
}

echo "Linking Claude Common resources to $CLAUDE_DIR"
echo ""

# Commands
mkdir -p "$CLAUDE_DIR/commands"
echo "Commands:"
for file in "$REPO_DIR/commands"/*.md; do
  [ -f "$file" ] || continue
  link_file "$file" "$CLAUDE_DIR/commands/$(basename "$file")"
done

echo ""

# Agents
mkdir -p "$CLAUDE_DIR/agents"
echo "Agents:"
for file in "$REPO_DIR/agents"/*.md; do
  [ -f "$file" ] || continue
  link_file "$file" "$CLAUDE_DIR/agents/$(basename "$file")"
done

echo ""

# Skills (link each skill directory as a unit)
mkdir -p "$CLAUDE_DIR/skills"
echo "Skills:"
for dir in "$REPO_DIR/skills"/*/; do
  [ -d "$dir" ] || continue
  skill_name="$(basename "$dir")"
  link_file "$dir" "$CLAUDE_DIR/skills/$skill_name"
done

echo ""
echo "Done."
