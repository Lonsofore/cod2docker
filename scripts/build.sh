#!/bin/bash -ex

IMAGE_NAME=${1:-rutkowski/cod2}
COD_PATCH=${2:-0}
MYSQL_VARIANT=${3:-1}
PUSH=${4:-""}
VERSION=$(cat __version__)

tag="${IMAGE_NAME}:${VERSION}-server1.${COD_PATCH}"
if [[ "$MYSQL_VARIANT" -eq 2 ]]; then
    tag="${tag}-voron"
fi

docker build \
    --build-arg cod2_patch="${COD_PATCH}" \
    --build-arg mysql_variant="${MYSQL_VARIANT}" \
    --build-arg sqlite_enabled=1 \
    -t $tag \
    .

if [[ "$PUSH" != "" ]]
then
    docker push ${tag}
fi
