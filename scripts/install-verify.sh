#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-install-verify.XXXXXX")"
BIN_DIR="$WORK_DIR/bin"

cleanup() {
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

log() {
  printf "[install-verify] %s\n" "$1"
}

install_chezmoi_if_needed() {
  if command -v chezmoi >/dev/null 2>&1; then
    log "Using existing chezmoi: $(chezmoi --version | head -n1)"
    return
  fi

  mkdir -p "$BIN_DIR"
  log "chezmoi not found, installing local copy"
  sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$BIN_DIR"
  export PATH="$BIN_DIR:$PATH"
  log "Installed chezmoi: $(chezmoi --version | head -n1)"
}

assert_exists() {
  local path="$1"
  if [[ ! -e "$path" ]]; then
    printf "[install-verify] missing expected file: %s\n" "$path" >&2
    exit 1
  fi
}

assert_not_exists() {
  local path="$1"
  if [[ -e "$path" ]]; then
    printf "[install-verify] unexpected file exists: %s\n" "$path" >&2
    exit 1
  fi
}

main() {
  install_chezmoi_if_needed

  export HOME="$WORK_DIR/home"
  export XDG_CONFIG_HOME="$WORK_DIR/config"
  export XDG_DATA_HOME="$WORK_DIR/data"
  export XDG_STATE_HOME="$WORK_DIR/state"

  mkdir -p "$HOME" "$XDG_CONFIG_HOME" "$XDG_DATA_HOME" "$XDG_STATE_HOME"

  log "Initializing chezmoi source from repository"
  chezmoi init "$REPO_ROOT"

  log "Applying dotfiles to isolated HOME"
  chezmoi apply --force

  log "Checking managed files are in sync"
  chezmoi status

  log "Validating expected managed files"
  assert_exists "$HOME/.zshrc"
  assert_exists "$HOME/.zprofile"
  assert_exists "$HOME/.gitconfig"
  assert_exists "$HOME/.tmux.conf"
  assert_exists "$HOME/.p10k.zsh"
  assert_exists "$HOME/.condarc"
  assert_exists "$HOME/.zsh_config/01-environment.zsh"

  log "Validating ignored directories are not applied"
  assert_not_exists "$HOME/scripts"
  assert_not_exists "$HOME/softwares"

  log "All checks passed"
}

main "$@"
