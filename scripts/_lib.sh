#!/usr/bin/env bash
# _lib.sh — shared helpers; source this from other scripts

# Sets CLAUDE_DIR based on an optional user/account name.
#
# Usage: pick_claude_dir [user]
#   user=""   — auto-detect: use the single dir, or fzf if multiple exist
#   user="~"  — always use ~/.claude (the default account)
#   user=foo  — use ~/.claude-foo
pick_claude_dir() {
  local user="${1:-}"

  # User explicitly provided — resolve directly, no fzf needed
  if [ -n "$user" ]; then
    if [ "$user" = "~" ]; then
      CLAUDE_DIR="$HOME/.claude"
    else
      CLAUDE_DIR="$HOME/.claude-$user"
    fi
    if [ ! -d "$CLAUDE_DIR" ]; then
      echo "Error: $CLAUDE_DIR does not exist." >&2
      exit 1
    fi
    return 0
  fi

  # Auto-detect: collect ~/.claude and ~/.claude-* directories
  local -a dirs=()
  [ -d "$HOME/.claude" ] && dirs+=("$HOME/.claude")
  for d in "$HOME"/.claude-*/; do
    d="${d%/}"
    [ -d "$d" ] || continue
    dirs+=("$d")
  done

  if [ "${#dirs[@]}" -eq 0 ]; then
    echo "Error: no ~/.claude* directories found." >&2
    exit 1
  fi

  if [ "${#dirs[@]}" -eq 1 ]; then
    CLAUDE_DIR="${dirs[0]}"
    return 0
  fi

  # Multiple accounts — need fzf to pick
  if ! command -v fzf &>/dev/null; then
    echo "Error: multiple ~/.claude* directories found; fzf is required to select one. Install with: brew install fzf" >&2
    exit 1
  fi

  local fzf_exit=0
  local chosen
  chosen=$(printf '%s\n' "${dirs[@]}" | sed "s|^$HOME/|~/|" | \
    fzf --prompt="Account > " \
        --header="Multiple Claude accounts found — select one  |  ESC: cancel") || fzf_exit=$?

  if [ "$fzf_exit" -ne 0 ] || [ -z "$chosen" ]; then
    echo "Cancelled." >&2
    exit 0
  fi

  # Expand leading ~/ back to $HOME
  CLAUDE_DIR="${chosen/#\~/$HOME}"
}
