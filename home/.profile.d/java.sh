
setjava() {
    if [ -z "$1" ]; then
        echo "Current JAVA_HOME: $JAVA_HOME"
        echo "Current java: $(jenv version)"
    else
        jenv global $1
        export JAVA_HOME=$(jenv javahome)
    fi
}

showjarversion() {
    unzip -q -c $1 META-INF/MANIFEST.MF
}

_setjava() {
           local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts="$(jenv whence java)"

        COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}

complete -F _setjava setjava

#JENV
export JENV_ROOT=/usr/local/opt/jenv
eval "$(jenv init -)"
setjava 1.8
