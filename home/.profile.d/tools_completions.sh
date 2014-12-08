_go() {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="$(cd ${SOURCE_ROOT} && find -mindepth 1 -maxdepth 1 -type d -printf %f\\n)"

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

_base() {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="$(cd ${SOURCES_ROOT} && find -mindepth 1 -maxdepth 1 -type d -printf %f\\n)"

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

_clone() {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="$(getrepos.py)"

        COMPREPLY=( $(compgen -W "${opts}" -X '!*'${cur}'*') )
}

complete -F _go go
complete -F _base base
complete -F _clone clone
