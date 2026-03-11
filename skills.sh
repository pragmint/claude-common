#!/usr/bin/env bash
set -euo pipefail

SOURCE="${BASH_SOURCE[0]}"
while [ -L "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ "$SOURCE" != /* ]] && SOURCE="$DIR/$SOURCE"
done
REPO_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

command="${1:-}"

case "$command" in
  link)      bash "$REPO_DIR/scripts/link.sh" "${@:2}" ;;
  unlink)    bash "$REPO_DIR/scripts/unlink.sh" "${@:2}" ;;
  select)    bash "$REPO_DIR/scripts/select.sh" ;;
  ls|list)   bash "$REPO_DIR/scripts/ls.sh" ;;
  install)
    BIN_DIR="$HOME/.local/bin"
    mkdir -p "$BIN_DIR"
    if [ -L "$BIN_DIR/skills" ] || [ -e "$BIN_DIR/skills" ]; then
      echo "Already installed at $BIN_DIR/skills"
    else
      ln -s "$REPO_DIR/skills.sh" "$BIN_DIR/skills"
      echo "Installed skills -> $REPO_DIR/skills.sh"
    fi
    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
      echo ""
      echo "Note: $BIN_DIR is not in your PATH."
      echo "Add this to your shell config (~/.zshrc or ~/.bashrc):"
      echo ""
      echo '  export PATH="$HOME/.local/bin:$PATH"'
    fi
    ;;
  uninstall)
    BIN_DIR="$HOME/.local/bin"
    if [ -L "$BIN_DIR/skills" ] && [ "$(readlink "$BIN_DIR/skills")" = "$REPO_DIR/skills.sh" ]; then
      rm "$BIN_DIR/skills"
      echo "Uninstalled $BIN_DIR/skills"
    elif [ -e "$BIN_DIR/skills" ]; then
      echo "Skipped: $BIN_DIR/skills exists but is not a symlink to this repo"
    else
      echo "Nothing to uninstall"
    fi
    ;;
  *)
    echo "Usage: skills <command>"
    echo ""
    echo "Commands:"
    echo "  link [-a|--all]  Select and link a resource (--all links everything)"
    echo "  unlink [-a|--all]  Select and unlink a resource (--all unlinks everything)"
    echo "  select     Interactively select which resources to link"
    echo "  ls|list    Show current link status of all resources"
    echo "  install    Add 'skills' to ~/.local/bin for use anywhere"
    echo "  uninstall  Remove 'skills' from ~/.local/bin"
    exit 1
    ;;
esac
