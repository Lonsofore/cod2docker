#!/bin/bash -ex

IMAGE_NAME=${1:-lonsofore/cod2}
IMAGE_NAME_NEW=${2:-ghcr.io/lonsofore/cod2}

docker_version=$(cat __version__)

versions[0]=0
versions[1]=2
versions[2]=3

for ver in ${versions[*]}
do
    ver1="1_${ver}"
    
    source_tag="${IMAGE_NAME}:1.${ver}"
    tag="${IMAGE_NAME_NEW}:1.${ver}"
    full_tag="${tag}-${docker_version}"
    docker tag ${source_tag} ${tag}
    docker tag ${source_tag} ${full_tag}
    docker push ${tag}
    docker push ${full_tag}
    
    source_tag="${IMAGE_NAME}:1.${ver}-voron"
    tag="${IMAGE_NAME_NEW}:1.${ver}-voron"
    full_tag="${tag}-${docker_version}"
    docker tag ${source_tag} ${tag}
    docker tag ${source_tag} ${full_tag}
    docker push ${tag}
    docker push ${full_tag}
done

source_tag="${IMAGE_NAME}:latest"
tag="${IMAGE_NAME_NEW}:latest"
docker tag ${source_tag} ${tag}
docker push ${tag}
