#!/usr/bin/env bash
# Install Claude Code and Codex with their native installers. Both update
# themselves, so they are not in the Brewfile.
set -euo pipefail

log() {
  printf '[ai-tools] %s\n' "$*"
}

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required." >&2
  exit 1
fi

# Both installers put binaries in ~/.local/bin. .zprofile already adds it to
# PATH; adding it here stops the Codex installer from editing ~/.zprofile.
export PATH="${HOME}/.local/bin:${PATH}"

if [ -x "${HOME}/.local/bin/claude" ]; then
  log "Claude Code already installed"
else
  log "Installing Claude Code"
  curl -fsSL https://claude.ai/install.sh | bash
fi

if [ -x "${HOME}/.local/bin/codex" ]; then
  log "Codex already installed"
else
  log "Installing Codex"
  curl -fsSL https://chatgpt.com/codex/install.sh | sh
fi

log "Sign in: run 'claude' and 'codex' once each."
