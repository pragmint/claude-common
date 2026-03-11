#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v fzf &>/dev/null; then
  echo "Error: fzf is required. Install with: brew install fzf"
  exit 1
fi

# Step 1: pick a top-level folder in $HOME to search
fzf_exit=0
search_root=$(find "$HOME" -maxdepth 1 -mindepth 1 -type d -not -name ".*" 2>/dev/null | \
  sort | \
  fzf --prompt="Search in > " \
      --header="Select a folder to scrape for .claude resources  |  ESC: cancel") || fzf_exit=$?

if [ "$fzf_exit" -ne 0 ] || [ -z "$search_root" ]; then
  echo "Cancelled."
  exit 0
fi

declare -a display_items=()  # lines shown in fzf: "name\tsource-label"
declare -A item_src=()       # "name\tsource-label" -> source path
declare -A item_dest=()      # "name\tsource-label" -> dest path in repo

collect_from() {
  local claude_dir="$1"
  local label="$2"

  # Commands
  if [ -d "$claude_dir/commands" ]; then
    for file in "$claude_dir/commands"/*.md; do
      [ -f "$file" ] || [ -L "$file" ] || continue
      if [ -L "$file" ] && [[ "$(readlink "$file")" == "$REPO_DIR"/* ]]; then
        continue
      fi
      local name="commands/$(basename "$file" .md)"
      local key="$name	$label"
      display_items+=("$key")
      item_src["$key"]="$file"
      item_dest["$key"]="$REPO_DIR/commands/$(basename "$file")"
    done
  fi

  # Agents
  if [ -d "$claude_dir/agents" ]; then
    for file in "$claude_dir/agents"/*.md; do
      [ -f "$file" ] || [ -L "$file" ] || continue
      if [ -L "$file" ] && [[ "$(readlink "$file")" == "$REPO_DIR"/* ]]; then
        continue
      fi
      local name="agents/$(basename "$file" .md)"
      local key="$name	$label"
      display_items+=("$key")
      item_src["$key"]="$file"
      item_dest["$key"]="$REPO_DIR/agents/$(basename "$file")"
    done
  fi

  # Skills
  if [ -d "$claude_dir/skills" ]; then
    for dir in "$claude_dir/skills"/*/; do
      [ -d "$dir" ] || [ -L "$dir" ] || continue
      if [ -L "${dir%/}" ] && [[ "$(readlink "${dir%/}")" == "$REPO_DIR"/* ]]; then
        continue
      fi
      local skill_name="$(basename "$dir")"
      local name="skills/$skill_name"
      local key="$name	$label"
      display_items+=("$key")
      item_src["$key"]="$dir"
      item_dest["$key"]="$REPO_DIR/skills/$skill_name"
    done
  fi
}

# Find all .claude dirs within the selected folder
while IFS= read -r claude_dir; do
  if [[ "$claude_dir" == "$REPO_DIR"* ]]; then
    continue
  fi
  label="$(basename "$(dirname "$claude_dir")")"
  collect_from "$claude_dir" "$label"
done < <(find "$search_root" -maxdepth 5 -name ".claude" -type d 2>/dev/null)

if [ "${#display_items[@]}" -eq 0 ]; then
  echo "No items found in $search_root that aren't already from this repo."
  exit 0
fi

# Step 2: multi-select items to copy
fzf_exit=0
selected=$(printf '%s\n' "${display_items[@]}" | \
  fzf --multi \
      --prompt="Scrape > " \
      --header="TAB: toggle  |  ENTER: copy to repo  |  ESC: cancel" \
      --delimiter="	" \
      --with-nth="1,2") || fzf_exit=$?

if [ "$fzf_exit" -ne 0 ] || [ -z "$selected" ]; then
  echo "Cancelled."
  exit 0
fi

echo ""
while IFS= read -r key; do
  src="${item_src[$key]}"
  dest="${item_dest[$key]}"
  name="$(echo "$key" | cut -f1)"

  if [ -e "$dest" ]; then
    echo "  skip   $name (already exists in repo)"
    continue
  fi

  if [ -d "$src" ] || { [ -L "$src" ] && [ -d "$(readlink "$src")" ]; }; then
    cp -r "$src" "$dest"
  else
    cp "$src" "$dest"
  fi
  echo "  copied $name"
done <<< "$selected"

echo ""
echo "Done. Run 'skills link' to make copied items available in Claude Code."
