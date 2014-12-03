export DISPLAY=:0.0
launchctl setenv PATH $PATH 2>/dev/null

[ -n "$PS1" ] && bind "set completion-ignore-case on"

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

export SOURCES_ROOT=~/Source


