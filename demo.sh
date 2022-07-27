#!/usr/bin/env bash
		
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

if type __git_complete; then
    echo "Inside IF"
else
	echo "Inside else"
fi;