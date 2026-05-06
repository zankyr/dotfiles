#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
RESET='\033[0m'

function usage {
	cat <<HELP_USAGE

Usage: $0 OPTIONS

A script to quickly configure your macOS environment.

Options:
	-i, --install    Install the dotfiles in the system.
	-u, --update     Update the dotfiles from ~ to the current folder.
	--uninstall      Remove dotfiles from the system.
	-h, --help       Show usage

HELP_USAGE
}

# Copy all the files and folders to the home dir, then source .bash_profile
function install {
	rsync --exclude ".git/" \
		--exclude ".DS_Store" \
		--exclude "bootstrap.sh" \
		--exclude "README.md" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

# Sync the expected files from the home dir to the current folder
function update {
	SRC_FOLDER=$HOME;

	rsync --exclude "$SRC_FOLDER/.git/" \
		--exclude "$SRC_FOLDER/.DS_Store" \
		--exclude "$SRC_FOLDER/bootstrap.sh" \
		--exclude "$SRC_FOLDER/README.md" \
		-avhr --files-from=from-file.txt --no-perms $SRC_FOLDER .;
}

# Returns "stow" if dotfiles were installed as symlinks, "rsync" otherwise
function detect_install_mode {
	if [ -L "$HOME/.aliases" ]; then
		echo "stow"
	else
		echo "rsync"
	fi
}

function uninstall {
	echo -e "\n${BOLD}╔══════════════════════════════════════╗${RESET}"
	echo -e "${BOLD}║       dotfiles uninstaller           ║${RESET}"
	echo -e "${BOLD}╚══════════════════════════════════════╝${RESET}\n"
	echo -e "This will remove dotfiles from your home directory."
	echo -e "${YELLOW}Note: macOS system settings will NOT be reverted.${RESET}\n"

	local mode
	mode=$(detect_install_mode)

	# --- Step 1: Remove dotfiles ---
	echo -e "${BOLD}[1/2] Remove dotfiles from ~${RESET}"
	echo -e "      Detected install mode: ${YELLOW}${mode}${RESET}\n"

	read -rp "      Proceed with removal? [y/N] " confirm
	if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
		echo -e "      Aborted."
		return 1
	fi

	if [ "$mode" = "stow" ]; then
		if ! command -v stow &>/dev/null; then
			echo -e "      ${RED}Error: stow not found. Install it with: brew install stow${RESET}"
			return 1
		fi
		echo -e "      Running: stow -D ."
		stow -D .
		echo -e "      ${GREEN}Symlinks removed.${RESET}"
	else
		if [ ! -f "from-file.txt" ]; then
			echo -e "      ${RED}Error: from-file.txt not found. Cannot determine which files to remove.${RESET}"
			return 1
		fi
		echo -e "      Removing files listed in from-file.txt from ~...\n"
		while IFS= read -r entry || [ -n "$entry" ]; do
			[ -z "$entry" ] && continue
			local target="$HOME/$entry"
			if [ -e "$target" ] || [ -L "$target" ]; then
				rm -rf "$target"
				echo -e "      ${GREEN}Removed:${RESET} $target"
			fi
		done < from-file.txt
	fi

	# --- Step 2: Homebrew packages ---
	echo -e "\n${BOLD}[2/2] Remove Homebrew packages?${RESET}"
	echo -e "      ${YELLOW}WARNING: only removes packages originally installed by these dotfiles.${RESET}\n"

	read -rp "      Remove core CLI tools? [y/N] " remove_core
	if [[ "$remove_core" =~ ^[Yy]$ ]]; then
		brew uninstall --ignore-dependencies \
			coreutils moreutils findutils gnu-sed wget tree vim grep openssh \
			git-lfs pyenv bash bash-completion@2 2>/dev/null
		brew uninstall --cask docker 2>/dev/null
		echo -e "      ${GREEN}Core tools removed.${RESET}"
	fi

	read -rp "      Remove IDEs? (IntelliJ IDEA, PyCharm CE, VS Code) [y/N] " remove_ides
	if [[ "$remove_ides" =~ ^[Yy]$ ]]; then
		brew uninstall --cask \
			intellij-idea-ce intellij-idea pycharm-ce visual-studio-code 2>/dev/null
		echo -e "      ${GREEN}IDEs removed.${RESET}"
	fi

	read -rp "      Remove apps? (Slack, Spotify, Telegram, Rectangle, etc.) [y/N] " remove_apps
	if [[ "$remove_apps" =~ ^[Yy]$ ]]; then
		brew uninstall --cask \
			slack spotify telegram-desktop rectangle postman \
			dbeaver-community sublime-text calibre 2>/dev/null
		brew uninstall bat thefuck wifi-password 2>/dev/null
		echo -e "      ${GREEN}Apps removed.${RESET}"
	fi

	echo -e "\n${GREEN}${BOLD}Uninstall complete.${RESET}"
	echo -e "Note: Homebrew itself was not removed."
	echo -e "      To uninstall Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\"\n"
}

case $1 in
	"-i" | "--install" )
		install
		;;
	"-u" | "--update" )
		update
		;;
	"--uninstall" )
		uninstall
		;;
	* )
		usage
		;;
esac

unset install
unset uninstall
