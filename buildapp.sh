#!/bin/sh

set -x

# remove all none tag images
if [ ! -z "$(docker images -q --filter 'dangling=true')" ]; then
  docker rmi $(docker images -q --filter "dangling=true")
fi

set -ex
docker build -t ${regisryAddr}/gowebdemo:v1 .

docker push ${regisryAddr}/gowebdemo:v1
