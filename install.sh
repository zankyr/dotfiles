#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=false
STOW_PACKAGES=(zsh git vim starship mise)

# ------------------------------------------------------------------------------

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Set up a fresh macOS development environment from this dotfiles repo.

Options:
  --dry-run   Simulate changes without applying them (no installs, no writes)
  -h, --help  Show this message
EOF
}

BOLD='\033[1m'
RESET='\033[0m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'

log()  { echo -e "  ${GREEN}✔${RESET}  $*"; }
step() { echo; echo -e "${BOLD}${BLUE}==> $*${RESET}"; }
warn() { echo -e "  ${YELLOW}⚠${RESET}  $*" >&2; }
error(){ echo -e "  ${RED}✖${RESET}  $*" >&2; }

stow_flags() {
  local flags=(--dir="$DOTFILES" --target="$HOME")
  $DRY_RUN && flags+=(--simulate)
  echo "${flags[@]}"
}

# ------------------------------------------------------------------------------

install_homebrew() {
  step "Homebrew"
  if command -v brew &>/dev/null; then
    log "already installed, skipping"
    return
  fi
  if $DRY_RUN; then
    log "[dry-run] would install Homebrew"
    return
  fi
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Apple Silicon: add brew to PATH for the rest of this script
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

install_packages() {
  step "Homebrew packages (Brewfile)"
  if [[ ! -f "$DOTFILES/Brewfile" ]]; then
    warn "Brewfile not found, skipping"
    return
  fi
  if $DRY_RUN; then
    log "[dry-run] would run: brew bundle --file=$DOTFILES/Brewfile"
    return
  fi
  brew bundle -v --file="$DOTFILES/Brewfile"
}

stow_dotfiles() {
  step "Stowing dotfiles"
  if ! command -v stow &>/dev/null; then
    warn "stow not found — install it first (brew install stow), skipping"
    return
  fi
  for pkg in "${STOW_PACKAGES[@]}"; do
    local pkg_dir="$DOTFILES/$pkg"
    if [[ ! -d "$pkg_dir" ]]; then
      warn "package '$pkg' not found, skipping"
      continue
    fi
    log "stow $pkg"
    # shellcheck disable=SC2046
    stow $(stow_flags) "$pkg"
  done
}

apply_macos_defaults() {
  step "macOS defaults"
  local macos_script="$DOTFILES/macos/.macos"
  if [[ ! -f "$macos_script" ]]; then
    warn ".macos script not found, skipping"
    return
  fi
  if $DRY_RUN; then
    log "[dry-run] would run: $macos_script"
    return
  fi
  bash "$macos_script"
}

set_default_shell() {
  step "Default shell"
  local zsh_path
  zsh_path="$(command -v zsh)"
  if [[ "$SHELL" == "$zsh_path" ]]; then
    log "zsh is already the default shell, skipping"
    return
  fi
  if $DRY_RUN; then
    log "[dry-run] would run: chsh -s $zsh_path"
    return
  fi
  # zsh must be in /etc/shells for chsh to accept it
  if ! grep -qxF "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$zsh_path"
  log "default shell set to $zsh_path"
}

# ------------------------------------------------------------------------------

main() {
  for arg in "$@"; do
    case "$arg" in
      --dry-run)   DRY_RUN=true ;;
      -h|--help)   usage; exit 0 ;;
      *)           error "Unknown option: $arg"; usage; exit 1 ;;
    esac
  done

  $DRY_RUN && echo -e "${CYAN}(dry-run mode — no changes will be made)${RESET}"

  install_homebrew
  install_packages
  stow_dotfiles
  apply_macos_defaults
  set_default_shell

  echo
  echo -e "${BOLD}${GREEN}Done.${RESET}"
  $DRY_RUN && echo -e "${CYAN}(dry-run: nothing was actually changed)${RESET}"
}

main "$@"
