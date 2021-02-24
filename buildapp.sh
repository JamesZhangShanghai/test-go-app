#!/bin/sh

set -x
export REGISTRY_ADDR="192.168.56.210:30500"
# remove all none tag images
if [ ! -z "$(docker images -q --filter 'dangling=true')" ]; then
  docker rmi $(docker images -q --filter "dangling=true")
fi

set -ex
docker build -t ${REGISTRY_ADDR}/gowebdemo:v1 .

docker push ${REGISTRY_ADDR}/gowebdemo:v1
