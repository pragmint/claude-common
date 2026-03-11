#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

unlink_file() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    rm "$dest"
    echo "  unlinked $dest"
  elif [ -e "$dest" ]; then
    echo "  skip     $dest (not a symlink to this repo)"
  else
    echo "  skip     $dest (not found)"
  fi
}

echo "Unlinking Claude Common resources from $CLAUDE_DIR"
echo ""

# Commands
echo "Commands:"
for file in "$REPO_DIR/commands"/*.md; do
  [ -f "$file" ] || continue
  unlink_file "$file" "$CLAUDE_DIR/commands/$(basename "$file")"
done

echo ""

# Agents
echo "Agents:"
for file in "$REPO_DIR/agents"/*.md; do
  [ -f "$file" ] || continue
  unlink_file "$file" "$CLAUDE_DIR/agents/$(basename "$file")"
done

echo ""

# Skills
echo "Skills:"
for dir in "$REPO_DIR/skills"/*/; do
  [ -d "$dir" ] || continue
  skill_name="$(basename "$dir")"
  unlink_file "$dir" "$CLAUDE_DIR/skills/$skill_name"
done

echo ""
echo "Done."
