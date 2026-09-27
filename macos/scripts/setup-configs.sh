#!/usr/bin/env bash
# Link app configs (git, tmux, Claude, Codex) from this repo into $HOME.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
# Backups go outside the config folders, so Claude and Codex do not load a
# backed-up skill as a second copy.
backup_root="${HOME}/.local/state/dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

log() {
  printf '[configs] %s\n' "$*"
}

# link <source> <path under $HOME>
link() {
  local src="$1"
  local rel="$2"
  local dest="${HOME}/${rel}"

  if [ ! -e "$src" ]; then
    echo "Source missing: $src" >&2
    exit 1
  fi
  if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
    return
  fi
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    mkdir -p "$(dirname "${backup_root}/${rel}")"
    mv "$dest" "${backup_root}/${rel}"
    log "Backed up ~/${rel} to ${backup_root}"
  fi
  mkdir -p "$(dirname "$dest")"
  ln -s "$src" "$dest"
  log "Linked ~/${rel}"
}

install_oh_my_tmux() {
  if [ -d "${HOME}/.tmux/.git" ]; then
    return
  fi
  log "Cloning oh-my-tmux into ~/.tmux"
  git clone --single-branch https://github.com/gpakosz/.tmux.git "${HOME}/.tmux"
}

# Codex rewrites config.toml with trusted project paths and plugin state, so
# copy a starting version once instead of linking it.
seed_codex_config() {
  local dest="${HOME}/.codex/config.toml"
  if [ -e "$dest" ]; then
    log "Keeping existing ~/.codex/config.toml"
    return
  fi
  mkdir -p "$(dirname "$dest")"
  cp "${repo_root}/codex/config.toml" "$dest"
  log "Copied starting ~/.codex/config.toml"
}

# ----- git -----
link "${repo_root}/git/.gitconfig" .gitconfig
link "${repo_root}/git/ignore" .config/git/ignore

# ----- tmux (oh-my-tmux + local overrides) -----
install_oh_my_tmux
link "${HOME}/.tmux/.tmux.conf" .tmux.conf
link "${repo_root}/tmux/.tmux.conf.local" .tmux.conf.local

# ----- Claude -----
link "${repo_root}/claude/settings.json" .claude/settings.json
link "${repo_root}/claude/output-styles" .claude/output-styles
for skill in "${repo_root}"/claude/skills/*/; do
  name="$(basename "$skill")"
  link "${repo_root}/claude/skills/${name}" ".claude/skills/${name}"
done

# ----- Codex -----
link "${repo_root}/codex/rules/default.rules" .codex/rules/default.rules
for skill in "${repo_root}"/codex/skills/*/; do
  name="$(basename "$skill")"
  link "${repo_root}/codex/skills/${name}" ".codex/skills/${name}"
done
seed_codex_config
