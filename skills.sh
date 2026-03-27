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
  scrape)    bash "$REPO_DIR/scripts/scrape.sh" "${@:2}" ;;
  ls|list)   bash "$REPO_DIR/scripts/ls.sh" ;;
  install)
    BIN_DIR="$HOME/.local/bin"
    COMP_DIR="$HOME/.zsh/completions"
    mkdir -p "$BIN_DIR" "$COMP_DIR"

    if [ -L "$BIN_DIR/skills" ] || [ -e "$BIN_DIR/skills" ]; then
      echo "Already installed at $BIN_DIR/skills"
    else
      ln -s "$REPO_DIR/skills.sh" "$BIN_DIR/skills"
      echo "Installed skills -> $REPO_DIR/skills.sh"
    fi

    if [ -L "$COMP_DIR/_skills" ] || [ -e "$COMP_DIR/_skills" ]; then
      echo "Already installed at $COMP_DIR/_skills"
    else
      ln -s "$REPO_DIR/completions/_skills" "$COMP_DIR/_skills"
      echo "Installed completion -> $COMP_DIR/_skills"
    fi

    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
      echo ""
      echo "Note: $BIN_DIR is not in your PATH."
      echo "Add this to your shell config (~/.zshrc):"
      echo ""
      echo '  export PATH="$HOME/.local/bin:$PATH"'
    fi

    if ! grep -qF 'fpath=(~/.zsh/completions' "$HOME/.zshrc" 2>/dev/null; then
      echo ""
      echo "Note: add this to ~/.zshrc before compinit for tab completion:"
      echo ""
      echo '  fpath=(~/.zsh/completions $fpath)'
      echo '  autoload -U compinit && compinit'
    fi
    ;;
  uninstall)
    BIN_DIR="$HOME/.local/bin"
    COMP_DIR="$HOME/.zsh/completions"

    if [ -L "$BIN_DIR/skills" ] && [ "$(readlink "$BIN_DIR/skills")" = "$REPO_DIR/skills.sh" ]; then
      rm "$BIN_DIR/skills"
      echo "Uninstalled $BIN_DIR/skills"
    elif [ -e "$BIN_DIR/skills" ]; then
      echo "Skipped: $BIN_DIR/skills exists but is not a symlink to this repo"
    else
      echo "Nothing to uninstall"
    fi

    if [ -L "$COMP_DIR/_skills" ] && [ "$(readlink "$COMP_DIR/_skills")" = "$REPO_DIR/completions/_skills" ]; then
      rm "$COMP_DIR/_skills"
      echo "Uninstalled $COMP_DIR/_skills"
    elif [ -e "$COMP_DIR/_skills" ]; then
      echo "Skipped: $COMP_DIR/_skills exists but is not a symlink to this repo"
    fi
    ;;
  *)
    echo "Usage: skills <command>"
    echo ""
    echo "Commands:"
    echo "  link [-a|--all]  Select and link a resource (--all links everything)"
    echo "  unlink [-a|--all]  Select and unlink a resource (--all unlinks everything)"
    echo "  select     Interactively choose what is linked/unlinked"
  echo "  scrape     Copy items from ~/.claude into this repo"
    echo "  ls|list    Show current link status of all resources"
    echo "  install    Add 'skills' to ~/.local/bin for use anywhere"
    echo "  uninstall  Remove 'skills' from ~/.local/bin"
    exit 1
    ;;
esac
