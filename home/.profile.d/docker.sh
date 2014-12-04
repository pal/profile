export DOCKER_HOST=tcp://192.168.59.103:2375

# Docker exec bash
db() {
  docker exec -ti ${1} bash
}
# Docker run image
dr() {
  docker run -t ${1}
}
