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

ARCH=""
ensure_arch() {
  if [[ -n "$ARCH" ]]; then
    return
  fi

  case "$(uname -m)" in
    x86_64|amd64)
      ARCH="x86_64"
      ;;
    arm64|aarch64)
      ARCH="arm64"
      ;;
    *)
      echo "Unsupported architecture: $(uname -m). Update install-dev-tools.sh for other targets." >&2
      exit 1
      ;;
  esac
}

download_nvim() {
  if command -v nvim >/dev/null 2>&1; then
    log "neovim already present: $(command -v nvim)"
    return
  fi

  local opt_root="${HOME}/.local/opt"
  local nvim_symlink="${HOME}/.local/bin/nvim"
  mkdir -p "$opt_root"

  ensure_arch
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN

  case "$ARCH" in
    x86_64)
      nvim_asset="nvim-linux-x86_64.tar.gz"
      ;;
    arm64)
      nvim_asset="nvim-linux-arm64.tar.gz"
      ;;
  esac

  url="https://github.com/neovim/neovim/releases/latest/download/${nvim_asset}"
  log "Downloading Neovim tarball from $url"
  curl -fsSL "$url" -o "${tmpdir}/nvim.tar.gz"
  tar -xzf "${tmpdir}/nvim.tar.gz" -C "$tmpdir"
  nvim_dir=$(find "$tmpdir" -maxdepth 1 -type d -name 'nvim-linux*' | head -n 1)
  if [[ -z "$nvim_dir" ]]; then
    echo "Failed to locate extracted Neovim directory" >&2
    exit 1
  fi
  rm -rf "${opt_root}/$(basename "$nvim_dir")"
  mv "$nvim_dir" "$opt_root/"
  ln -sf "${opt_root}/$(basename "$nvim_dir")/bin/nvim" "$nvim_symlink"
  log "Installed Neovim to ${opt_root}/$(basename "$nvim_dir")"
  log "Symlinked Neovim to ${nvim_symlink}"
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
download_nvim
