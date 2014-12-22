export DOCKER_CERT_PATH=/Users/pl/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
export DOCKER_HOST=tcp://192.168.59.103:2376

# Docker exec bash
db() {
  docker exec -ti ${1} bash
}
# Docker run image
dr() {
  docker run -t ${1}
}
