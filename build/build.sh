#!/bin/bash

export ORG="acend"
export APP="theia"
export TAG=$(date '+%y%m')

cleanup() {
    echo -e "\nCleanup:\n"
    docker stop $APP
    docker container prune --force
    docker image prune --force
}

trap cleanup EXIT
trap cleanup SIGTERM

build() {
    echo -e "\nBuild:\n"
    set -e
    if [ -n "$(which docker)" ]; then
        DOCKER_BUILDKIT=1 docker build -t $ORG/$APP:$TAG .
        test_image
        docker push $ORG/$APP:$TAG
    elif [ -n "$(which buildah)" ]; then
        sudo buildah bud -t docker.io/$ORG/$APP:$TAG .
        sudo buildah push docker.io/$ORG/$APP:$TAG
    fi
}

test_image() {
    echo -e "\nTest:\n"
    set -e
    docker run -d --rm -p 3000:3000 --name $APP $ORG/$APP:$TAG
    docker images | grep $APP
    sleep 15

    curl -s localhost:3000

    echo -e "\n\nLogs:\n"
    docker logs $APP
}

build

exit 0
