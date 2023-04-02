#!/bin/bash

CRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

docker login 

docker buildx create --name multiarch --driver docker-container --use


#,linux/arm/v7 linux/arm64 linux/amd64
export ARCH_SUPPORT="linux/arm64,linux/amd64"

export TAG="release"
export DOCKER_REPO="smzahraee"

#build node and node-api
export SUGARFUNGE_NODE_BRANCH="main"
export SUGARFUNGE_NODE_IMAGE="$DOCKER_REPO/node"
export GSUGARFUNGE_NODE_DOCKER_TAG="release"
export SUGARFUNGE_API_BRANCH="main"


git clone -b $SUGARFUNGE_NODE_BRANCH  --recurse-submodules https://github.com/functionland/sugarfunge-node
cd sugarfunge-node && git pull
cd ..
git clone -b $SUGARFUNGE_API_BRANCH --recurse-submodules https://github.com/functionland/sugarfunge-api
cd sugarfunge-api && git pull
cd ..

echo "Building $SUGARFUNGE_NODE_IMAGE ..."
docker buildx build --platform $ARCH_SUPPORT -t $SUGARFUNGE_NODE_IMAGE:$GSUGARFUNGE_NODE_DOCKER_TAG --push .
