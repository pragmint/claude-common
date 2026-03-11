#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"

all=false
if [ "${1:-}" = "--all" ] || [ "${1:-}" = "-a" ]; then
  all=true
fi

if ! $all && ! command -v fzf &>/dev/null; then
  echo "Error: fzf is required. Install with: brew install fzf"
  exit 1
fi

# Collect unlinked items
declare -a unlinked_items=()
declare -A item_src=()
declare -A item_dest=()

for file in "$REPO_DIR/commands"/*.md; do
  [ -f "$file" ] || continue
  name="commands/$(basename "$file" .md)"
  dest="$CLAUDE_DIR/commands/$(basename "$file")"
  if ! { [ -L "$dest" ] && [ "$(readlink "$dest")" = "$file" ]; }; then
    unlinked_items+=("$name")
    item_src["$name"]="$file"
    item_dest["$name"]="$dest"
  fi
done

for file in "$REPO_DIR/agents"/*.md; do
  [ -f "$file" ] || continue
  name="agents/$(basename "$file" .md)"
  dest="$CLAUDE_DIR/agents/$(basename "$file")"
  if ! { [ -L "$dest" ] && [ "$(readlink "$dest")" = "$file" ]; }; then
    unlinked_items+=("$name")
    item_src["$name"]="$file"
    item_dest["$name"]="$dest"
  fi
done

for dir in "$REPO_DIR/skills"/*/; do
  [ -d "$dir" ] || continue
  skill_name="$(basename "$dir")"
  name="skills/$skill_name"
  dest="$CLAUDE_DIR/skills/$skill_name"
  if ! { [ -L "$dest" ] && [ "$(readlink "$dest")" = "$dir" ]; }; then
    unlinked_items+=("$name")
    item_src["$name"]="$dir"
    item_dest["$name"]="$dest"
  fi
done

if [ "${#unlinked_items[@]}" -eq 0 ]; then
  echo "Nothing to link — all resources are already linked."
  exit 0
fi

if $all; then
  for name in "${unlinked_items[@]}"; do
    src="${item_src[$name]}"
    dest="${item_dest[$name]}"
    mkdir -p "$(dirname "$dest")"
    if [ -e "$dest" ] || [ -L "$dest" ]; then
      echo "Skipped: $name (destination exists but is not a link to this repo)"
    else
      ln -s "$src" "$dest"
      echo "Linked $name"
    fi
  done
  exit 0
fi

# Single-select from unlinked items
fzf_exit=0
selected=$(printf '%s\n' "${unlinked_items[@]}" | \
  fzf --prompt="Link > " \
      --header="ENTER: link item  |  ESC: cancel") || fzf_exit=$?

if [ "$fzf_exit" -ne 0 ] || [ -z "$selected" ]; then
  echo "Cancelled."
  exit 0
fi

src="${item_src[$selected]}"
dest="${item_dest[$selected]}"

mkdir -p "$(dirname "$dest")"

if [ -e "$dest" ] || [ -L "$dest" ]; then
  echo "Skipped: $selected (destination exists but is not a link to this repo)"
else
  ln -s "$src" "$dest"
  echo "Linked $selected"
fi
