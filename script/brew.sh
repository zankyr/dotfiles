#!/usr/bin/env bash

# Stop the script if any command fails
set -e


# check if `brew` is installed. If not, install it
which brew

if [[ $? != 0 ]] ; then
    echo "Homebrew not found, installing it..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
	echo "Homebrew already installed"
fi
