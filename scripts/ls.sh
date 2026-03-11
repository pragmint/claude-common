#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

print_status() {
  local src="$1"
  local dest="$2"
  local name="$3"

  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    echo "  [linked]   $name"
  elif [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "  [conflict] $name"
  else
    echo "  [unlinked] $name"
  fi
}

echo "Commands:"
for file in "$REPO_DIR/commands"/*.md; do
  [ -f "$file" ] || continue
  print_status "$file" "$CLAUDE_DIR/commands/$(basename "$file")" "commands/$(basename "$file" .md)"
done

echo ""
echo "Agents:"
for file in "$REPO_DIR/agents"/*.md; do
  [ -f "$file" ] || continue
  print_status "$file" "$CLAUDE_DIR/agents/$(basename "$file")" "agents/$(basename "$file" .md)"
done

echo ""
echo "Skills:"
for dir in "$REPO_DIR/skills"/*/; do
  [ -d "$dir" ] || continue
  skill_name="$(basename "$dir")"
  print_status "$dir" "$CLAUDE_DIR/skills/$skill_name" "skills/$skill_name"
done
