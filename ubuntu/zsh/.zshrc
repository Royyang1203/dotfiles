# ~/.config/zsh/.zshrc

# ----- Powerlevel10k instant prompt (keep near top) -----
if [[ -r "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ----- Completion cache in XDG -----
export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
autoload -Uz compinit
compinit -C -d "$ZSH_COMPDUMP"

# ----- Zinit (plugin manager) -----
ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
source "${ZINIT_HOME}/zinit.zsh"

# Theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

# Oh-My-Zsh snippets
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::archlinux
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

zinit cdreplay -q

# ----- Powerlevel10k config -----
source "${XDG_CONFIG_HOME}/zsh/p10k.zsh"

# ----- Keybindings -----
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[w' kill-region

# ----- History settings -----
HISTFILE="${XDG_DATA_HOME}/zsh/history"
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ----- Interactive defaults -----
setopt autocd
setopt correct

# ----- Completion styling -----
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --color=always --group-directories-first $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza --color=always --group-directories-first $realpath'

# ----- Aliases -----
alias ls='eza --icons'
alias ll='eza -l --icons'
alias la='eza -la --icons'
alias lt='eza --tree --icons'
alias vim='nvim'
alias c='clear'

# ----- Shell integrations -----
eval "$(fzf --zsh)"
export _ZO_DATA_DIR="$XDG_DATA_HOME/zoxide"
eval "$(zoxide init --cmd z zsh)"

# ----- nvm -----
export NVM_DIR="$XDG_CONFIG_HOME/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
