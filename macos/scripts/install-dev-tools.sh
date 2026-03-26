#!/usr/bin/env bash
set -euo pipefail

log() {
  printf '[dev-tools] %s\n' "$*"
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
}

install_nvm() {
  if command -v nvm >/dev/null 2>&1; then
    log "nvm already present: $(command -v nvm)"
    return
  fi

  if [[ -z "${XDG_CONFIG_HOME:-}" ]]; then
    export XDG_CONFIG_HOME="$HOME/.config"
  fi

  mkdir -p "$XDG_CONFIG_HOME"
  local nvm_root="$XDG_CONFIG_HOME/nvm"

  if [[ -s "$nvm_root/nvm.sh" ]]; then
    log "nvm already installed in $nvm_root"
    return
  fi

  require_cmd curl
  log "Installing nvm (latest) to $nvm_root (XDG-aware, no profile edits)"
  NVM_DIR="$nvm_root" PROFILE=/dev/null \
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
  log "nvm installed to $nvm_root"
}

install_uv() {
  if command -v uv >/dev/null 2>&1; then
    log "uv already present: $(command -v uv)"
    return
  fi

  require_cmd curl
  log "Installing uv (latest)"
  curl -fsSL https://astral.sh/uv/install.sh | sh
  log "uv install complete"
}

install_nvm
install_uv
