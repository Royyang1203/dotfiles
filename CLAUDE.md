# dotfiles

Personal setup for macOS, Ubuntu and Arch Linux. Most of the work is in `macos/`.

**This repo is public.** Never commit secrets or private data. See [Never commit](#never-commit).

## Layout

```
macos/
  Brewfile              Tools and apps for every Mac. bootstrap.sh installs it.
  Brewfile.mas          App Store apps. Optional: needs App Store sign-in.
  Brewfile.meetings     Zoom, Teams, Webex, Tencent Meeting. Optional.
  zsh/                  zsh config (symlinked into ~/.config/zsh)
  iterm2/               iTerm2 settings (iTerm2 reads and writes this folder)
  git/                  .gitconfig and global gitignore (symlinked)
  tmux/                 .tmux.conf.local for oh-my-tmux (symlinked)
  claude/               Claude Code settings, output styles, own skills (symlinked)
  codex/                Codex rules and skills (symlinked), starting config.toml (copied)
  fonts/                Fonts installed by hand. Font files are not in git.
  scripts/
    bootstrap.sh            Runs the steps below, in order
    install-brew-packages.sh  Installs Homebrew, then `brew bundle` on Brewfile
    setup-zsh.sh            zinit, ZDOTDIR, zsh symlinks
    setup-iterm2.sh         Points iTerm2 at macos/iterm2/
    install-ai-tools.sh     Claude Code and Codex, native installers
    setup-configs.sh        Symlinks git, tmux, Claude, Codex configs
    optional/
      install-ca-toolchain.sh  GTKWave, RISC-V GCC, Icarus Verilog 12 (course tools)
ubuntu/                 Ubuntu scripts and zsh config
arch/                   Arch Linux setup.sh
config/                 vscode_setting.json (outdated, not used by any script)
```

## How the macOS setup works

- **Symlinks, not copies.** Files in `~/.config/zsh`, `~/.gitconfig`, `~/.claude/settings.json` and others point into this repo. An edit on the machine is an edit in the repo. Check `git diff` after changing settings.
- **Backups.** When a script replaces an existing file, it keeps the old one:
  - `setup-zsh.sh`: `<file>.bak.<timestamp>` next to the file.
  - `setup-configs.sh`: `~/.local/state/dotfiles-backup/<timestamp>/`. These backups are outside `~/.claude` and `~/.codex`, so a backed-up skill does not load twice.
- **Re-runnable.** Every script checks what is already done and skips it. Running `bootstrap.sh` again is safe.
- **Exceptions to symlinks:**
  - `~/.codex/config.toml` is copied once, only when it does not exist. Codex writes trusted project paths into it. Those paths contain private folder names.
  - iTerm2 does not use a symlink. It loads `macos/iterm2/` as its custom settings folder and saves changes back there.
  - Claude Code and Codex install with their own installers, not Homebrew, because they update themselves often.

## New Mac setup

Do the steps in this order. Steps marked **(manual)** need the owner: they involve accounts, passwords or system settings. An AI agent must not do them. It stops and asks the owner.

### 1. Before the repo (manual)

1. Sign in to the Apple ID. Install macOS updates.
2. Turn on FileVault.
3. Sign in to the App Store app.
4. Open the password manager in Safari. Nothing else needs to be installed first.

### 2. Get the repo and run bootstrap

```bash
xcode-select --install
```

```bash
git clone https://github.com/Royyang1203/dotfiles.git ~/dotfiles
```

```bash
~/dotfiles/macos/scripts/bootstrap.sh
```

- Clone with HTTPS. The repo is public, so no sign-in is needed. A new Mac has no SSH key yet.
- Run `bootstrap.sh` from Terminal.app, not iTerm2.
- The Homebrew installer asks for the macOS password. Some casks (BlackHole, Background Music, OrbStack) can ask for permission or a restart.

### 3. After bootstrap (manual)

**Sign in**

- [ ] `gh auth login`. `.gitconfig` already uses `gh` for GitHub HTTPS, so `git push` works after this.
- [ ] Run `claude` once and sign in.
- [ ] Run `codex` once and sign in.
- [ ] VS Code: turn on Settings Sync with the GitHub account. It restores settings and extensions.
- [ ] `rclone config`: add the Google Drive remote `gdrive` again.

**Apps**

- [ ] `brew bundle --file=~/dotfiles/macos/Brewfile.mas` (needs App Store sign-in).
- [ ] Only if needed: `brew bundle --file=~/dotfiles/macos/Brewfile.meetings`.
- [ ] Only if needed: `~/dotfiles/macos/scripts/optional/install-ca-toolchain.sh` (uses `sudo` for `/opt/riscv`).
- [ ] Set the default browser in System Settings.

**Files that are not in this repo**

- [ ] `Kaiu.ttf` (標楷體): copy from the old Mac. See `macos/fonts/README.md`.
- [ ] `~/.ssh/config`: copy from the password manager or a private backup. It lists lab servers.
- [ ] SSH keys: make a new key on each Mac. Add it to GitHub and to the servers.
- [ ] WireGuard: import the `CGILab-1` to `CGILab-4` tunnels. Get them from the password manager or the lab admin.

**System settings and permissions**

- [ ] Open iTerm2. If it asks about settings, choose to use the settings from the custom folder. Check that the prompt icons show, not boxes.
- [ ] Give Accessibility and Screen Recording permission to the apps that ask: Raycast, Rectangle, AltTab, BetterDisplay, Ice, Shottr.
- [ ] Audio MIDI Setup: make Multi-Output Devices named `<output> & BlackHole` (for example `AirPods & BlackHole`). Each one sends sound to the output and to BlackHole 2ch, for recording in OBS.
- [ ] Set login items: Rectangle, Raycast, Scroll Reverser, BetterDisplay, Ice, AlDente, Stats, Shottr, Notion, Cloudflare WARP.

### 4. Check the result

```bash
brew bundle check --file=~/dotfiles/macos/Brewfile
```

Open a new iTerm2 window, then check:

- The prompt shows Powerlevel10k with icons.
- `ls` shows icons (it is `eza`).
- `z`, `fzf` (`Ctrl+R`), `claude` and `codex` work.
- `ls -la ~/.config/zsh ~/.gitconfig ~/.claude/settings.json` shows symlinks into `~/dotfiles`.

## Rules for AI agents

- **Ask the owner first** before:
  - any step marked **(manual)** above;
  - `sudo`;
  - deleting files, apps or backups;
  - changing System Settings or app permissions;
  - `git push`.
- **Change the repo, not the machine.** To add a package, edit a Brewfile, then run `brew bundle`. To change zsh, edit `macos/zsh/`. Do not append lines to `~/.zshrc`; it only sources the repo config.
- **Keep scripts re-runnable.** A new step checks if its work is done, and backs up before it replaces a file.
- **Before a commit, check for private data.** Look at the diff of every file that an app writes by itself: `macos/iterm2/`, `macos/claude/settings.json`, `macos/codex/rules/`.
- **Write commit messages** in the existing style: `feat(macos): ...`.

### Where things go

| To add | Put it in | Then |
|---|---|---|
| A CLI tool or app for every Mac | `macos/Brewfile`, in the right section | `brew bundle --file=macos/Brewfile` |
| An app not every Mac needs | `macos/Brewfile.meetings` or a new optional Brewfile | Document it in step 3 above |
| An App Store app | `macos/Brewfile.mas` (get the id with `mdls -raw -name kMDItemAppStoreAdamID <app>`) | |
| A config file | The matching folder in `macos/`, plus a `link` line in `setup-configs.sh` | Run `setup-configs.sh` |
| A Claude skill | `macos/claude/skills/<name>/` | Run `setup-configs.sh` |
| A Codex skill | `macos/codex/skills/<name>/` | Run `setup-configs.sh` |

## Never commit

This repo is public. These stay out of git:

- API keys, tokens, passwords. For example `~/.codex/auth.json`, `~/.config/rclone/rclone.conf`.
- SSH private keys and `~/.ssh/config`.
- WireGuard and other VPN configs.
- `~/.claude.json` (sign-in state and project history).
- The live `~/.codex/config.toml` (private project paths).
- Commercial fonts (`macos/fonts/*.ttf` and `*.otf` are in `.gitignore`).
- VS Code settings: they contain lab server names. Settings Sync handles them.

## Known gaps

- `bootstrap.sh` has not been tested on a new Mac or a new macOS user account yet.
- `ubuntu/scripts/setup-zsh.sh` still copies zsh files, so Ubuntu config can drift.
- `config/vscode_setting.json` is outdated. `config/git`, `config/ssh`, `config/tmux` are empty folders.
- On the current Mac, Homebrew copies of `claude-code` and `codex` are still installed but not used.
