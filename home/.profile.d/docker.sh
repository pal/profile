
# Docker exec bash
db() {
  docker exec -ti ${1} bash
}
# Docker run image
dr() {
  docker run -t ${1}
}
