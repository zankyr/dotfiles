#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

function usage {
	cat <<HELP_USAGE

Usage: $0 OPTIONS

A script to quickly configure your MacOs Envoriment.

Options:
	-i, --install Install the scripts in the system.
	-u, --update  Update the scripts from the system to the current folder.
	-h, --help    Show usage

HELP_USAGE
}

# Copy all the files and folders to the home dir, then compile .bash_profile
function install {

	# Install Homebrew if missing
	source ./install/brew.sh

	# Copy all the required dotfiles to the home folder
	#rsync --exclude ".git/" \
	#	--exclude ".DS_Store" \
	#	--exclude "bootstrap.sh" \
	#	--exclude "README.md" \
	#	-avh --no-perms . ~;
	#source ~/.bash_profile;

	# Install brew formulaes and casks
	brew bundle --file=./install/Brewfile
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

case $1 in 
	"-i" | "--install" )
	install
	;;
	"-u" | "--update" )
	update
	;;
	* )
	usage
	;;
esac



#read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
#echo "";
#if [[ $REPLY =~ ^[Yy]$ ]]; then
	#doIt;
#fi;

unset install;