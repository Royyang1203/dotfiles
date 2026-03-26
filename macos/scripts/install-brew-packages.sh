#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This installer is intended for macOS/Homebrew setups." >&2
  exit 1
fi

install_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return
  fi

  if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install Homebrew." >&2
    exit 1
  fi

  echo "Homebrew not found. Installing..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

activate_brew() {
  if command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
    return
  fi

  local candidates=(
    /opt/homebrew/bin/brew
    /usr/local/bin/brew
  )

  for candidate in "${candidates[@]}"; do
    if [ -x "$candidate" ]; then
      eval "$("$candidate" shellenv)"
      return
    fi
  done

  echo "Unable to locate Homebrew binary after installation." >&2
  exit 1
}

install_homebrew
activate_brew

packages=(
  git
  zsh
  tmux
  fzf
  zoxide
  eza
  neovim
  ripgrep
  fd
  bat
  htop
  tree
  fastfetch
)

echo "Installing Homebrew packages: ${packages[*]}"
brew install "${packages[@]}"

casks=(
  font-meslo-lg-nerd-font
)
echo "Installing Homebrew casks: ${casks[*]}"
brew install --cask "${casks[@]}"
