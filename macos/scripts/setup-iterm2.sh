#!/usr/bin/env bash
# Point iTerm2 at the settings in this repo. iTerm2 saves changes back here.
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
prefs_dir="$(cd "${script_dir}/../iterm2" && pwd)"
domain="com.googlecode.iterm2"

log() {
  printf '[iterm2] %s\n' "$*"
}

if pgrep -xq iTerm2; then
  echo "Quit iTerm2 first. It overwrites its settings when it quits." >&2
  exit 1
fi

if defaults read "$domain" >/dev/null 2>&1; then
  backup="${HOME}/.config/iterm2/${domain}.bak.$(date +%Y%m%d-%H%M%S).plist"
  mkdir -p "$(dirname "$backup")"
  defaults export "$domain" "$backup"
  log "Backed up current settings to ${backup}"
fi

defaults write "$domain" PrefsCustomFolder -string "$prefs_dir"
defaults write "$domain" LoadPrefsFromCustomFolder -bool true
# Save changes to the custom folder automatically, without asking.
defaults write "$domain" NoSyncNeverRemindPrefsChangesLostForFile -bool true
defaults write "$domain" NoSyncNeverRemindPrefsChangesLostForFile_selection -int 0

log "iTerm2 now loads settings from ${prefs_dir}"
