#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt-get >/dev/null 2>&1; then
  echo "apt-get not found; this installer targets Ubuntu/Debian systems." >&2
  exit 1
fi

sudo apt-get update

packages=(
  git
  zsh
  tmux
  htop
)

echo "Installing APT packages: ${packages[*]}"
sudo apt-get install -y "${packages[@]}"
