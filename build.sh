#!/bin/bash -ex

REPO=${1:-lonsofore}
IMAGE_NAME=${2:-cod2}
VER=${3:-0}  # 1.0


docker_version=$(cat __version__)
tag="${REPO}/${IMAGE_NAME}:1.${VER}-${docker_version}"
ver1="1_${VER}"

docker build \
    --build-arg cod2_version="${ver1}" \
    --build-arg libcod_mysql=1 \
    --build-arg libcod_sqlite=1 \
    -t $tag \
    .
