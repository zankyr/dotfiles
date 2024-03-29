# Add Homebrew in PATH - required since its original path has changed
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
for file in ~/.{path,bash_prompt,exports,aliases,functions,work,work-resky,terns,exercism,work-etna}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
    # Ensure existing Homebrew v1 completions continue to work
    export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
    complete -o default -o nospace -F _git g;
fi;

# Init pyenv every time you open your prompt,
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Enable tab completion for docker and docker compose
if which brew &> /dev/null ; then
	DOCKER_HOME=/Applications/Docker.app/Contents/Resources/etc
	BREW_HOME="$(brew --prefix)/etc/bash_completion.d"
	
	for file in $DOCKER_HOME/{docker.bash-completion,docker-compose.bash-completion}; do
		[ -r "$file" ] && [  -f "$file" ] && ln -Fs "$file" $BREW_HOME 
	done;

fi

# Enable pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then 
    eval "$(pyenv virtualenv-init -)"; 
fi

# REMOVED: jenv has several issues with maven when you install/switch Java version.
# jenv configuration
#export PATH="$HOME/.jenv/bin:$PATH"
#eval "$(jenv init -)"


# Configuration for https://github.com/nvbn/thefuck
eval $(thefuck --alias)



