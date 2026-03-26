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

install_zinit() {
  require_cmd git
  ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  mkdir -p "$(dirname "$ZINIT_HOME")"

  if [ -d "$ZINIT_HOME/.git" ]; then
    log "Zinit already installed at $ZINIT_HOME"
    return
  fi

  log "Cloning Zinit into $ZINIT_HOME"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
}

install_zinit

log "Configuring zsh via ZDOTDIR"
repo_root="$(cd "${script_dir}/.." && pwd)"
zsh_src="${repo_root}/zsh"

mkdir -p "${HOME}/.config/zsh" "${HOME}/.cache/zsh" "${HOME}/.local/share" "${HOME}/.local/share/zsh"

bootstrap="${HOME}/.zshenv"
tmp_bootstrap="$(mktemp)"
cat <<'EOF' >"$tmp_bootstrap"
# Managed by dotfiles/macos/scripts/setup-zsh.sh
export ZDOTDIR="$HOME/.config/zsh"
if [ -r "$ZDOTDIR/.zshenv" ]; then
  source "$ZDOTDIR/.zshenv"
fi
EOF
if [ -f "$bootstrap" ] || [ -L "$bootstrap" ]; then
  cp -a "$bootstrap" "${bootstrap}.bak.$(date +%Y%m%d-%H%M%S)"
fi
mv "$tmp_bootstrap" "$bootstrap"

for file in .zshenv .zprofile .zshrc p10k.zsh; do
  src="${zsh_src}/${file}"
  dest="${HOME}/.config/zsh/${file}"
  if [ ! -f "$src" ]; then
    echo "Source file missing: $src" >&2
    exit 1
  fi
  if [ -f "$dest" ] || [ -L "$dest" ]; then
    cp -a "$dest" "${dest}.bak.$(date +%Y%m%d-%H%M%S)"
  fi
  cp "$src" "$dest"
done

# Wrapper files in ~ to ensure config loads even if ZDOTDIR is not
# picked up by the terminal emulator (macOS Terminal.app quirk).
log "Writing wrapper files in ~"
for file in .zshrc .zprofile; do
  wrapper="${HOME}/${file}"
  if [ -f "$wrapper" ] || [ -L "$wrapper" ]; then
    cp -a "$wrapper" "${wrapper}.bak.$(date +%Y%m%d-%H%M%S)"
  fi
  cat <<EOF >"$wrapper"
# Managed by dotfiles — source real config from XDG location
export ZDOTDIR="\$HOME/.config/zsh"
source "\$ZDOTDIR/${file}"
EOF
done

log "Zsh setup complete"
