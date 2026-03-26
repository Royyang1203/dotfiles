#!/usr/bin/env bash
set -euo pipefail

BIN_DIR="${HOME}/.local/bin"
mkdir -p "$BIN_DIR"

log() {
  printf '[user-tools] %s\n' "$*"
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
      echo "Unsupported architecture: $(uname -m). Update install-cli-tools.sh for other targets." >&2
      exit 1
      ;;
  esac
}

download_eza() {
  if command -v eza >/dev/null 2>&1; then
    log "eza already present: $(command -v eza)"
    return
  fi

  ensure_arch
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  case "$ARCH" in
    x86_64)
      eza_asset="eza_x86_64-unknown-linux-gnu.tar.gz"
      ;;
    arm64)
      eza_asset="eza_aarch64-unknown-linux-gnu.tar.gz"
      ;;
  esac
  url="https://github.com/eza-community/eza/releases/latest/download/${eza_asset}"
  log "Downloading eza from $url"
  curl -fsSL "$url" -o "${tmpdir}/eza.tar.gz"
  tar -xzf "${tmpdir}/eza.tar.gz" -C "$tmpdir"
  install -m 755 "${tmpdir}/eza" "${BIN_DIR}/eza"
  log "Installed eza to ${BIN_DIR}/eza"
}

resolve_fzf_version() {
  if [[ -n "${FZF_VERSION:-}" ]]; then
    echo "$FZF_VERSION"
    return
  fi

  local latest
  latest=$(curl -fsSL https://api.github.com/repos/junegunn/fzf/releases/latest |
    awk -F '"' '/tag_name/ {print $4; exit}') || true
  if [[ -z "$latest" ]]; then
    echo "0.60.3"
  else
    echo "$latest"
  fi
}

download_fzf() {
  if command -v fzf >/dev/null 2>&1; then
    log "fzf already present: $(command -v fzf)"
    return
  fi

  ensure_arch
  version=$(resolve_fzf_version)
  version_no_v="${version#v}"
  case "$ARCH" in
    x86_64)
      fzf_asset="fzf-${version_no_v}-linux_amd64.tar.gz"
      ;;
    arm64)
      fzf_asset="fzf-${version_no_v}-linux_arm64.tar.gz"
      ;;
  esac

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  url="https://github.com/junegunn/fzf/releases/download/${version}/${fzf_asset}"
  log "Downloading fzf ${version} from $url"
  curl -fsSL "$url" -o "${tmpdir}/fzf.tar.gz"
  tar -xzf "${tmpdir}/fzf.tar.gz" -C "$tmpdir"
  install -m 755 "${tmpdir}/fzf" "${BIN_DIR}/fzf"
  log "Installed fzf to ${BIN_DIR}/fzf"
}

resolve_zoxide_version() {
  if [[ -n "${ZOXIDE_VERSION:-}" ]]; then
    echo "$ZOXIDE_VERSION"
    return
  fi

  local latest
  latest=$(curl -fsSL https://api.github.com/repos/ajeetdsouza/zoxide/releases/latest |
    awk -F '"' '/tag_name/ {print $4; exit}') || true
  if [[ -z "$latest" ]]; then
    echo "v0.9.6"
  else
    echo "$latest"
  fi
}

download_zoxide() {
  if command -v zoxide >/dev/null 2>&1; then
    log "zoxide already present: $(command -v zoxide)"
    return
  fi

  ensure_arch
  version=$(resolve_zoxide_version)
  version_no_v="${version#v}"
  case "$ARCH" in
    x86_64)
      zoxide_asset="zoxide-${version_no_v}-x86_64-unknown-linux-musl.tar.gz"
      ;;
    arm64)
      zoxide_asset="zoxide-${version_no_v}-aarch64-unknown-linux-musl.tar.gz"
      ;;
  esac

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  url="https://github.com/ajeetdsouza/zoxide/releases/download/${version}/${zoxide_asset}"
  log "Downloading zoxide ${version} from $url"
  curl -fsSL "$url" -o "${tmpdir}/zoxide.tar.gz"
  tar -xzf "${tmpdir}/zoxide.tar.gz" -C "$tmpdir"
  found=$(find "$tmpdir" -type f -name zoxide -perm -u+x | head -n 1)
  if [[ -z "$found" ]]; then
    echo "Failed to locate zoxide binary in archive" >&2
    exit 1
  fi
  install -m 755 "$found" "${BIN_DIR}/zoxide"
  log "Installed zoxide to ${BIN_DIR}/zoxide"
}

resolve_ripgrep_version() {
  if [[ -n "${RIPGREP_VERSION:-}" ]]; then
    echo "$RIPGREP_VERSION"
    return
  fi

  local latest
  latest=$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest |
    awk -F '"' '/tag_name/ {print $4; exit}') || true
  if [[ -z "$latest" ]]; then
    echo "14.1.1"
  else
    echo "$latest"
  fi
}

download_ripgrep() {
  if command -v rg >/dev/null 2>&1; then
    log "ripgrep already present: $(command -v rg)"
    return
  fi

  ensure_arch
  version=$(resolve_ripgrep_version)
  version_no_v="${version#v}"
  case "$ARCH" in
    x86_64)
      rg_asset="ripgrep-${version_no_v}-x86_64-unknown-linux-musl.tar.gz"
      ;;
    arm64)
      rg_asset="ripgrep-${version_no_v}-aarch64-unknown-linux-musl.tar.gz"
      ;;
  esac

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  url="https://github.com/BurntSushi/ripgrep/releases/download/${version}/${rg_asset}"
  log "Downloading ripgrep ${version} from $url"
  curl -fsSL "$url" -o "${tmpdir}/rg.tar.gz"
  tar -xzf "${tmpdir}/rg.tar.gz" -C "$tmpdir"
  found=$(find "$tmpdir" -type f -name rg -perm -u+x | head -n 1)
  if [[ -z "$found" ]]; then
    echo "Failed to locate rg binary in archive" >&2
    exit 1
  fi
  install -m 755 "$found" "${BIN_DIR}/rg"
  log "Installed ripgrep to ${BIN_DIR}/rg"
}

resolve_fd_version() {
  if [[ -n "${FD_VERSION:-}" ]]; then
    echo "$FD_VERSION"
    return
  fi

  local latest
  latest=$(curl -fsSL https://api.github.com/repos/sharkdp/fd/releases/latest |
    awk -F '"' '/tag_name/ {print $4; exit}') || true
  if [[ -z "$latest" ]]; then
    echo "v10.3.0"
  else
    echo "$latest"
  fi
}

download_fd() {
  if command -v fd >/dev/null 2>&1; then
    log "fd already present: $(command -v fd)"
    return
  fi

  ensure_arch
  version=$(resolve_fd_version)
  version_no_v="${version#v}"
  case "$ARCH" in
    x86_64)
      fd_asset="fd-v${version_no_v}-x86_64-unknown-linux-musl.tar.gz"
      ;;
    arm64)
      fd_asset="fd-v${version_no_v}-aarch64-unknown-linux-musl.tar.gz"
      ;;
  esac

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  url="https://github.com/sharkdp/fd/releases/download/${version}/${fd_asset}"
  log "Downloading fd ${version} from $url"
  curl -fsSL "$url" -o "${tmpdir}/fd.tar.gz"
  tar -xzf "${tmpdir}/fd.tar.gz" -C "$tmpdir"
  found=$(find "$tmpdir" -type f -name fd -perm -u+x | head -n 1)
  if [[ -z "$found" ]]; then
    echo "Failed to locate fd binary in archive" >&2
    exit 1
  fi
  install -m 755 "$found" "${BIN_DIR}/fd"
  log "Installed fd to ${BIN_DIR}/fd"
}

resolve_tree_version() {
  if [[ -n "${TREE_VERSION:-}" ]]; then
    echo "$TREE_VERSION"
    return
  fi

  echo "2.3.0"
}

download_tree() {
  if command -v tree >/dev/null 2>&1; then
    log "tree already present: $(command -v tree)"
    return
  fi

  if ! command -v make >/dev/null 2>&1; then
    echo "make is required to build tree from source" >&2
    exit 1
  fi

  version=$(resolve_tree_version)
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  url="https://gitlab.com/OldManProgrammer/unix-tree/-/archive/${version}/unix-tree-${version}.tar.bz2"
  log "Downloading tree ${version} from $url"
  curl -fsSL "$url" -o "${tmpdir}/tree.tar.bz2"
  tar -xjf "${tmpdir}/tree.tar.bz2" -C "$tmpdir"
  src_dir=$(find "$tmpdir" -maxdepth 1 -type d -name "unix-tree-${version}*" | head -n 1)
  if [[ -z "$src_dir" ]]; then
    echo "Failed to locate extracted tree source directory" >&2
    exit 1
  fi
  (cd "$src_dir" && make)
  if [[ ! -x "${src_dir}/tree" ]]; then
    echo "Failed to build tree binary" >&2
    exit 1
  fi
  install -m 755 "${src_dir}/tree" "${BIN_DIR}/tree"
  log "Installed tree to ${BIN_DIR}/tree"
}

resolve_bat_version() {
  if [[ -n "${BAT_VERSION:-}" ]]; then
    echo "$BAT_VERSION"
    return
  fi

  local latest
  latest=$(curl -fsSL https://api.github.com/repos/sharkdp/bat/releases/latest |
    awk -F '"' '/tag_name/ {print $4; exit}') || true
  if [[ -z "$latest" ]]; then
    echo "v0.24.0"
  else
    echo "$latest"
  fi
}

download_bat() {
  if command -v bat >/dev/null 2>&1; then
    log "bat already present: $(command -v bat)"
    return
  fi

  ensure_arch
  version=$(resolve_bat_version)
  version_no_v="${version#v}"
  case "$ARCH" in
    x86_64)
      bat_asset="bat-v${version_no_v}-x86_64-unknown-linux-gnu.tar.gz"
      ;;
    arm64)
      bat_asset="bat-v${version_no_v}-aarch64-unknown-linux-gnu.tar.gz"
      ;;
  esac

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  url="https://github.com/sharkdp/bat/releases/download/${version}/${bat_asset}"
  log "Downloading bat ${version} from $url"
  curl -fsSL "$url" -o "${tmpdir}/bat.tar.gz"
  tar -xzf "${tmpdir}/bat.tar.gz" -C "$tmpdir"
  found=$(find "$tmpdir" -type f -name bat -perm -u+x | head -n 1)
  if [[ -z "$found" ]]; then
    echo "Failed to locate bat binary in archive" >&2
    exit 1
  fi
  install -m 755 "$found" "${BIN_DIR}/bat"
  log "Installed bat to ${BIN_DIR}/bat"
}

resolve_fastfetch_version() {
  if [[ -n "${FASTFETCH_VERSION:-}" ]]; then
    echo "$FASTFETCH_VERSION"
    return
  fi

  local latest
  latest=$(curl -fsSL https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest |
    awk -F '"' '/tag_name/ {print $4; exit}') || true
  if [[ -z "$latest" ]]; then
    echo "2.56.0"
  else
    echo "$latest"
  fi
}

download_fastfetch() {
  if command -v fastfetch >/dev/null 2>&1; then
    log "fastfetch already present: $(command -v fastfetch)"
    return
  fi

  ensure_arch
  version=$(resolve_fastfetch_version)
  case "$ARCH" in
    x86_64)
      fastfetch_asset="fastfetch-linux-amd64.tar.gz"
      ;;
    arm64)
      fastfetch_asset="fastfetch-linux-aarch64.tar.gz"
      ;;
  esac

  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' RETURN
  url="https://github.com/fastfetch-cli/fastfetch/releases/download/${version}/${fastfetch_asset}"
  log "Downloading fastfetch ${version} from $url"
  curl -fsSL "$url" -o "${tmpdir}/fastfetch.tar.gz"
  tar -xzf "${tmpdir}/fastfetch.tar.gz" -C "$tmpdir"
  found=$(find "$tmpdir" -type f -name fastfetch -perm -u+x | head -n 1)
  if [[ -z "$found" ]]; then
    echo "Failed to locate fastfetch binary in archive" >&2
    exit 1
  fi
  install -m 755 "$found" "${BIN_DIR}/fastfetch"
  log "Installed fastfetch to ${BIN_DIR}/fastfetch"
}

download_eza
download_fzf
download_zoxide
download_ripgrep
download_fd
download_tree
download_bat
download_fastfetch

log "Ensure ${BIN_DIR} is on PATH (e.g., export PATH=\"${BIN_DIR}:\$PATH\")"
