export DISPLAY=:0.0
launchctl setenv PATH $PATH 2>/dev/null

[ -n "$PS1" ] && bind "set completion-ignore-case on"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    source $(brew --prefix)/etc/bash_completion
fi
# Bash completions2
if [ -f $(brew --prefix)/share/bash-completion/bash_completion ]; then
  . $(brew --prefix)/share/bash-completion/bash_completion
fi

# TODO this never works for me... Dunno why
#shopt -s globstar

export RSYNC_RSH="ssh"
alias rsync='rsync -v --progress --partial'

if which gsed 2>&1 >/dev/null; then
    alias sed='gsed'
fi
if which gfind 2>&1 >/dev/null; then
    alias find='gfind'
fi

alias ls='ls -GF'
alias ll="ls -la"
alias less='less -R'

export GREP_OPTIONS='--color=auto'
export GREP_COLOR='1;32'

export SOURCES_ROOT="$HOME/source"

# Git 
alias g="git"
alias gs="git status"
alias gd="git diff" 
alias ga="git add" 
alias gc="git commit -m"
alias gp="git pull" 
alias gps="git push" 
alias gss="find . -maxdepth 1 -mindepth 1 -type d -exec sh -c '(echo {} && cd {} && git status -s && echo)' \;"

export GIT_BASE_URL="git@git"
export GITHUB_USER=pal

# Setting for the new UTF-8 terminal support in Lion
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Default Editor
export EDITOR=code

# Also add homeshick! :)
source "$HOME/.homesick/repos/homeshick/homeshick.sh"
