export MAVEN_OPTS='-Xmx2048m -XX:MaxPermSize=512M'

mi() {
  mvn install "$@"
}

mci() {
  mvn clean install "$@"
}

fast() {
  mvn install -Pfast.install "$@"
}

fastclean() {
  mvn clean install -Pfast.install "$@"
}
