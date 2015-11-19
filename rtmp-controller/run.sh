#!/bin/bash
# CLI arguments:
# 1 Address to the origin RTMP server (rtmp://[x.x.x.x]/ingest)
# 2 The stream name (rtmp://x.x.x.x/ingest/[stream name])
# 3 The destination file prefix

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

DOCKER_IP=$(ip -4 address show docker0 | grep -Eo '([[:digit:]]{1,3}.){3}[[:digit:]]{1,3}')
NPM_REGISTRY_PORT=4873 
NPM_REGISTRY="http://${DOCKER_IP}:${NPM_REGISTRY_PORT}/"

docker build --build-arg=NPM_CONFIG_REGISTRY=${NPM_REGISTRY} -t qvazar/rtmp-controller ${DIR}
echo "Running rtmp-controller..."
docker run -d --name rtmp-controller --link mongodb:mongodb -e NODE_ENV=debug -e DAL_DEBUG_HOST=mongodb qvazar/rtmp-controller