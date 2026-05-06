# Rik's dotfiles

Quickly configure a fresh macOS development environment.

## Caution

**Use these scripts at your own risk.**

These scripts will modify system configurations and overwrite existing files. Review the code and remove anything that doesn't suit your setup before running.

## Installation

Clone the repository and run the installer:

```bash
git clone https://github.com/zankyr/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

The installer will, in order:

1. Install [Homebrew](https://brew.sh/) if not already present
2. Install all packages and apps from `Brewfile`
3. Symlink all dotfiles into `$HOME` via [GNU Stow](https://www.gnu.org/software/stow/)
4. Apply macOS system defaults (`.macos`)
5. Set zsh as the default shell

To preview what would happen without making any changes:

```bash
./install.sh --dry-run
```

## Structure

Files are organised into [Stow](https://www.gnu.org/software/stow/) packages. Each directory maps directly to `$HOME`:

```
zsh/        → ~/.zshrc, ~/.zshenv, ~/.aliases, ~/.functions, ~/.hushlogin
git/        → ~/.gitconfig, ~/.gitignore_global
vim/        → ~/.vimrc, ~/.vim/
starship/   → ~/.config/starship.toml
mise/       → ~/.config/mise/config.toml
macos/      → run directly by install.sh (not symlinked)
```

Running `stow <package>` from the repo root creates the symlinks. Running `stow -D <package>` removes them.

## Customisation

- **Packages and apps** — edit `Brewfile` and run `brew bundle`
- **Shell config** — edit files under `zsh/`
- **Prompt** — edit `starship/.config/starship.toml`
- **Runtime versions** (Java, etc.) — edit `mise/.config/mise/config.toml`
- **macOS settings** — edit `macos/.macos`

Because Stow uses symlinks, editing a file in `$HOME` (e.g. `~/.aliases`) is the same as editing it in the repo — no sync step needed.

## Thanks to

* [Mathias Bynens](https://mathiasbynens.be/) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)
