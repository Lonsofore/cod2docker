#!/bin/bash -ex

REPO=${1:-lonsofore}
IMAGE_NAME=${2:-cod2}
PUSH=${3:-""}


docker_version=$(cat __version__)

versions[0]=0
versions[1]=2
versions[2]=3

for ver in ${versions[*]}
do
    ver1="1_${ver}"
    
    tag="${REPO}/${IMAGE_NAME}:1.${ver}"
    full_tag="${tag}-${docker_version}"
    docker build \
        --build-arg cod2_version="${ver1}" \
        --build-arg libcod_mysql=1 \
        --build-arg libcod_sqlite=1 \
        -t ${tag} \
        -t ${full_tag} \
        .
    if [[ "$PUSH" != "" ]]
    then
        docker push ${full_tag}
        docker push ${tag}
    fi
    
    tag="${REPO}/${IMAGE_NAME}:1.${ver}-voron"
    full_tag="${tag}-${docker_version}"
    docker build \
        --build-arg cod2_version="${ver1}" \
        --build-arg libcod_mysql=2 \
        --build-arg libcod_sqlite=1 \
        -t ${tag} \
        -t ${full_tag} \
        .
    if [[ "$PUSH" != "" ]]
    then
        docker push ${full_tag}
        docker push ${tag}
    fi
done

tag="${REPO}/${IMAGE_NAME}:latest"
docker tag ${REPO}/${IMAGE_NAME}:1.3 $tag
if [[ "$PUSH" != "" ]]
then
    docker push ${tag}
fi
