#!/bin/bash -ex

IMAGE_NAME=${1:-rutkowski/cod2}
PUSH=${2:-""}

cod_patches=( 0 2 3 )
mysql_options=( 1 2 )

for cod_patch in "${cod_patches[@]}"
do
    for mysql_option in "${mysql_options[@]}"
    do
        echo "Building and pushing with parameters cod_patch=$cod_patch, mysql_option=$mysql_option"

        ./build.sh $IMAGE_NAME $cod_patch $mysql_option $PUSH

        echo "Done"
    done
done
