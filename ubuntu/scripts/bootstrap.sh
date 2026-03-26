#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log() {
  printf '\n[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
}

log "Checking prerequisites"
require_cmd git
require_cmd curl

log "Setting up zsh"
"${script_dir}/setup-zsh.sh"

log "Installing CLI tools"
"${script_dir}/install-cli-tools.sh"

log "Installing dev tools (nvm/uv/nvim)"
"${script_dir}/install-dev-tools.sh"

log "Bootstrap complete"
