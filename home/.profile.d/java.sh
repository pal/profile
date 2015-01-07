#JENV
export JENV_ROOT=/usr/local/opt/jenv
if which jenv > /dev/null; then
    eval "$(jenv init -)"
    jenv global 1.8

    export JAVA_HOME="/usr/local/opt/jenv/versions/$(jenv global)"
fi

showjarversion() {
  unzip -q -c $1 META-INF/MANIFEST.MF
}


