#!/bin/bash

image_name="cod2"
login="lonsofore"

ver="0"  # 1.0
docker_version=$(cat __version__)
tag="${login}/${image_name}:1.${ver}-${docker_version}"
ver1="1_${ver}"

docker build \
    --build-arg cod2_version="${ver1}" \
    --build-arg libcod_mysql=1 \
    --build-arg libcod_sqlite=1 \
    -t $tag \
    .
