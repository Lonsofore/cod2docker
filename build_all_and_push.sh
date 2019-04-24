image_name="cod2"
login="lonsofore"

versions[0]=0
versions[1]=2
versions[2]=3

for ver in ${versions[*]}
do
    ver1="1_${ver}"
    
    tag="${login}/${image_name}:1.${ver}"
    docker build \
        --build-arg cod2_version="${ver1}" \
        --build-arg libcod_mysql=1 \
        --build-arg libcod_sqlite=1 \
        -t $tag \
        .
    docker push ${tag}
    
    tag="${login}/${image_name}:1.${ver}-voron"
    docker build \
        --build-arg cod2_version="${ver1}" \
        --build-arg libcod_mysql=2 \
        --build-arg libcod_sqlite=1 \
        -t $tag \
        .
    docker push ${tag}
done

docker tag ${login}/${image_name}:1.3 ${login}/${image_name}:latest
docker push ${login}/${image_name}:latest