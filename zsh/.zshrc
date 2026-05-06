eval "$(/opt/homebrew/bin/brew shellenv)"

# Completions
FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
autoload -Uz compinit && compinit

# Shell options
setopt NO_CASE_GLOB
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt CORRECT
setopt AUTO_CD

# Source supporting files
for file in ~/.{aliases,functions}; do
    [[ -r "$file" ]] && source "$file"
done
unset file

# Runtime version manager
eval "$(mise activate zsh)"

# thefuck
eval "$(thefuck --alias)"

# Prompt
eval "$(starship init zsh)"
