#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=_lib.sh
source "$REPO_DIR/scripts/_lib.sh"

all=false
claude_user=""
while [ $# -gt 0 ]; do
  case "$1" in
    --all|-a) all=true; shift ;;
    --user|-u) claude_user="${2:-}"; shift 2 ;;
    *) shift ;;
  esac
done

pick_claude_dir "$claude_user"

if ! $all && ! command -v fzf &>/dev/null; then
  echo "Error: fzf is required. Install with: brew install fzf"
  exit 1
fi

# Collect linked items
declare -a linked_items=()
declare -A item_src=()
declare -A item_dest=()

for file in "$REPO_DIR/commands"/*.md; do
  [ -f "$file" ] || continue
  name="commands/$(basename "$file" .md)"
  dest="$CLAUDE_DIR/commands/$(basename "$file")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$file" ]; then
    linked_items+=("$name")
    item_src["$name"]="$file"
    item_dest["$name"]="$dest"
  fi
done

for file in "$REPO_DIR/agents"/*.md; do
  [ -f "$file" ] || continue
  name="agents/$(basename "$file" .md)"
  dest="$CLAUDE_DIR/agents/$(basename "$file")"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$file" ]; then
    linked_items+=("$name")
    item_src["$name"]="$file"
    item_dest["$name"]="$dest"
  fi
done

for dir in "$REPO_DIR/skills"/*/; do
  [ -d "$dir" ] || continue
  skill_name="$(basename "$dir")"
  name="skills/$skill_name"
  dest="$CLAUDE_DIR/skills/$skill_name"
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$dir" ]; then
    linked_items+=("$name")
    item_src["$name"]="$dir"
    item_dest["$name"]="$dest"
  fi
done

if [ "${#linked_items[@]}" -eq 0 ]; then
  echo "Nothing to unlink — no resources are currently linked."
  exit 0
fi

if $all; then
  for name in "${linked_items[@]}"; do
    rm "${item_dest[$name]}"
    echo "Unlinked $name"
  done
  exit 0
fi

# Single-select from linked items
fzf_exit=0
selected=$(printf '%s\n' "${linked_items[@]}" | \
  fzf --prompt="Unlink > " \
      --header="ENTER: unlink item  |  ESC: cancel") || fzf_exit=$?

if [ "$fzf_exit" -ne 0 ] || [ -z "$selected" ]; then
  echo "Cancelled."
  exit 0
fi

rm "${item_dest[$selected]}"
echo "Unlinked $selected"
