#!/bin/bash


docker run --user="$(id -u):$(id -g)" -v $(pwd):/go/clair golang:1.14.1-buster "bash" "-c" "cd /go/clair; ls -la; go mod vendor"
make container-build

GIT_HASH=`git rev-parse --short=7 HEAD`
skopeo copy --dest-creds "${QUAY_USER}:${QUAY_TOKEN}" \
    "docker-daemon:clair-local:latest" \
    "docker://clairv4:latest"

skopeo copy --dest-creds "${QUAY_USER}:${QUAY_TOKEN}" \
    "docker-daemon:clair-local:latest" \
    "docker://clairv4:${GIT_HASH}"
