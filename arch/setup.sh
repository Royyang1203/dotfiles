#!/bin/bash
set -e

echo "[0/7] Updating system..."
sudo pacman -Syu --noconfirm

# ---------------------------
# 1. Essential Base Tools
# ---------------------------
echo "[1/7] Installing essential base tools..."
sudo pacman -S --noconfirm \
  base-devel \
  git \
  curl \
  wget \
  htop \
  vim \
  stow \
  lsb-release \
  ca-certificates

# ---------------------------
# 2. File & System Utilities
# ---------------------------
echo "[2/7] Installing file & system utilities..."
sudo pacman -S --noconfirm \
  man-db \
  man-pages \
  which \
  tree \
  zip \
  unzip \
  tar \
  p7zip \
  unrar

# ---------------------------
# 3. Networking Tools
# ---------------------------
echo "[3/7] Installing networking tools..."
sudo pacman -S --noconfirm \
  net-tools \
  inetutils \
  openssh \
  rsync

# ---------------------------
# 4. Fonts
# ---------------------------
echo "[4/7] Installing fonts..."
sudo pacman -S --noconfirm \
  noto-fonts \
  noto-fonts-cjk \
  noto-fonts-emoji \
  ttf-dejavu

# ---------------------------
# 5. Shell & Terminal Environment
# ---------------------------
echo "[5/7] Installing shell & terminal environment..."
sudo pacman -S --noconfirm \
  zsh \
  tmux \
  fzf \
  zoxide \
  neofetch \
  bat \
  fd \
  ripgrep \
  eza \
  neofetch \
  kitty

echo "[Shell] Installing oh-my-zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "[Shell] Installing powerlevel10k theme..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# ---------------------------
# 6. Hyprland Environment
# ---------------------------
echo "[6/7] Installing Hyprland environment..."
sudo pacman -S --noconfirm \
  hyprland \
  xdg-desktop-portal-hyprland \
  waybar \
  rofi \
  fuzzel \
  wlogout \
  wl-clipboard \
  grim \
  slurp

# ---------------------------
# 7. AUR Helper (paru) + Stow Symlinks
# ---------------------------
echo "[7/7] Installing paru (AUR helper)..."
if ! command -v paru &> /dev/null; then
  git clone https://aur.archlinux.org/paru.git /tmp/paru
  cd /tmp/paru
  makepkg -si --noconfirm
  cd -
fi

echo "[Dotfiles] Creating symlinks with stow..."
cd ~/dotfiles

# example: link configs into home
# stow zsh
# stow tmux
# stow alacritty
# stow hyprland
#stow waybar

echo "Arch setup completed successfully!"

