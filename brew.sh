#!/usr/bin/env bash

# Heavily copied from https://github.com/mathiasbynens/dotfiles/blob/main/brew.sh
# Install command-line tools using Homebrew.

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install a modern version of Bash.
brew install bash
brew install bash-completion2

# Switch to using brew-installed bash as default shell
if ! fgrep -q "${BREW_PREFIX}/bin/bash" /etc/shells; then
  echo "${BREW_PREFIX}/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "${BREW_PREFIX}/bin/bash";
fi;

# Install `wget` with IRI support.
brew install wget

# Install more recent versions of some macOS tools.
brew install vim
brew install grep
brew install openssh

# Install other useful binaries.
brew install git
brew install git-lfs
brew install tree

# Install IntelliJ
brew install --cask intellij-idea

# Install maven
brew install maven

# Install docker desktop
brew install --cask docker

# Install openjdk 8
brew install --cask adoptopenjdk8

# Install pyenv, python and set it
brew install pyenv
pyenv install 3.9.0
pyenv global 3.9.0

# Remove outdated versions from the cellar.
brew cleanup