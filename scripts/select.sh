#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=_lib.sh
source "$REPO_DIR/scripts/_lib.sh"

claude_user=""
while [ $# -gt 0 ]; do
  case "$1" in
    --user|-u) claude_user="${2:-}"; shift 2 ;;
    *) shift ;;
  esac
done

pick_claude_dir "$claude_user"

if ! command -v fzf &>/dev/null; then
  echo "Error: fzf is required. Install with: brew install fzf"
  exit 1
fi

# Collect all resources, track current link status
declare -a all_items=()
declare -A item_src=()
declare -A item_dest=()
declare -a currently_linked=()

for file in "$REPO_DIR/commands"/*.md; do
  [ -f "$file" ] || continue
  name="commands/$(basename "$file" .md)"
  all_items+=("$name")
  item_src["$name"]="$file"
  item_dest["$name"]="$CLAUDE_DIR/commands/$(basename "$file")"
  if [ -L "${item_dest[$name]}" ] && [ "$(readlink "${item_dest[$name]}")" = "$file" ]; then
    currently_linked+=("$name")
  fi
done

for file in "$REPO_DIR/agents"/*.md; do
  [ -f "$file" ] || continue
  name="agents/$(basename "$file" .md)"
  all_items+=("$name")
  item_src["$name"]="$file"
  item_dest["$name"]="$CLAUDE_DIR/agents/$(basename "$file")"
  if [ -L "${item_dest[$name]}" ] && [ "$(readlink "${item_dest[$name]}")" = "$file" ]; then
    currently_linked+=("$name")
  fi
done

for dir in "$REPO_DIR/skills"/*/; do
  [ -d "$dir" ] || continue
  skill_name="$(basename "$dir")"
  name="skills/$skill_name"
  all_items+=("$name")
  item_src["$name"]="$dir"
  item_dest["$name"]="$CLAUDE_DIR/skills/$skill_name"
  if [ -L "${item_dest[$name]}" ] && [ "$(readlink "${item_dest[$name]}")" = "$dir" ]; then
    currently_linked+=("$name")
  fi
done

# Build fzf pre-select binding using pos(N)+select for each linked item
bind_cmd="start:deselect-all"
for i in "${!all_items[@]}"; do
  item="${all_items[$i]}"
  for linked in "${currently_linked[@]+"${currently_linked[@]}"}"; do
    if [ "$linked" = "$item" ]; then
      bind_cmd+="+pos($((i+1)))+select"
      break
    fi
  done
done

# Run fzf multi-select (capture exit code separately to distinguish ESC from empty selection)
fzf_exit=0
selected=$(printf '%s\n' "${all_items[@]}" | \
  fzf --multi \
      --prompt="Claude Common > " \
      --header="TAB: toggle  |  ENTER: confirm  |  ESC: cancel" \
      --bind "$bind_cmd") || fzf_exit=$?

if [ "$fzf_exit" -ne 0 ]; then
  echo "Cancelled."
  exit 0
fi

# Build a map of selected items
declare -A selected_map=()
while IFS= read -r item; do
  selected_map["$item"]=1
done <<< "$selected"

# Apply changes
echo ""
linked_count=0
unlinked_count=0

for item in "${all_items[@]}"; do
  src="${item_src[$item]}"
  dest="${item_dest[$item]}"

  if [ "${selected_map[$item]+_}" ]; then
    # Should be linked
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      : # already correct, no-op
    elif [ -e "$dest" ] || [ -L "$dest" ]; then
      echo "  skip     $item (exists but is not a link to this repo)"
    else
      mkdir -p "$(dirname "$dest")"
      ln -s "$src" "$dest"
      echo "  linked   $item"
      linked_count=$((linked_count + 1))
    fi
  else
    # Should be unlinked
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      rm "$dest"
      echo "  unlinked $item"
      unlinked_count=$((unlinked_count + 1))
    fi
  fi
done

echo ""
echo "Done. $linked_count linked, $unlinked_count unlinked."
