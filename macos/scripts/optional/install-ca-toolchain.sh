#!/usr/bin/env bash
# Computer architecture course toolchain (optional, not run by bootstrap.sh).
#   - GTKWave (waveform viewer), from the randomplum/gtkwave tap
#   - RISC-V GCC 14.2.0 (riscv32-unknown-elf), extracted to /opt/riscv
#   - Icarus Verilog 12, extracted to ~/.local/iverilog-12
# .zshrc adds /opt/riscv/bin and ~/.local/iverilog-12/bin to PATH when they exist.
set -euo pipefail

release_url="https://github.com/nycu-arclab/ca-devtools/releases/download/apple_darwin_2026"
riscv_tarball="riscv32-unknown-elf-gcc-14.2.0-apple-darwin.tar.gz"
iverilog_tarball="iverilog-12-macos.tar.gz"

log() {
  printf '[ca-toolchain] %s\n' "$*"
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "Missing required command: $cmd" >&2
    exit 1
  fi
}

require_cmd brew
require_cmd curl

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

install_gtkwave() {
  if brew list randomplum/gtkwave/gtkwave >/dev/null 2>&1; then
    log "GTKWave already installed"
    return
  fi
  log "Installing GTKWave (HEAD build)"
  brew install --HEAD randomplum/gtkwave/gtkwave
}

install_riscv() {
  if [ -x /opt/riscv/bin/riscv32-unknown-elf-gcc ]; then
    log "RISC-V GCC already installed in /opt/riscv"
    return
  fi
  log "Downloading ${riscv_tarball}"
  curl -fL -o "${tmp_dir}/${riscv_tarball}" "${release_url}/${riscv_tarball}"
  log "Extracting to /opt (needs sudo)"
  sudo tar -xzf "${tmp_dir}/${riscv_tarball}" -C /opt
}

install_iverilog() {
  if [ -x "${HOME}/.local/iverilog-12/bin/iverilog" ]; then
    log "Icarus Verilog 12 already installed in ~/.local/iverilog-12"
    return
  fi
  log "Downloading ${iverilog_tarball}"
  curl -fL -o "${tmp_dir}/${iverilog_tarball}" "${release_url}/${iverilog_tarball}"
  mkdir -p "${HOME}/.local"
  tar -xzf "${tmp_dir}/${iverilog_tarball}" -C "${HOME}/.local"
}

install_gtkwave
install_riscv
install_iverilog

log "Done. Open a new shell, then check:"
log "  riscv32-unknown-elf-gcc --version"
log "  iverilog -V"
