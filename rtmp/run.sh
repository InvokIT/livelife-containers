#!/bin/bash
# CLI arguments:
# 1 Address to the origin RTMP server (rtmp://[x.x.x.x]/ingest)
# 2 The stream name (rtmp://x.x.x.x/ingest/[stream name])
# 3 The destination file prefix

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

DOCKER_GATEWAY=$(ip addr show dev docker0 | grep -m 1 inet | grep -Eo '(.?[[:digit:]]+){4}' | grep -Eo '[^[:blank:]]+')
echo DOCKER_GATEWAY is ${DOCKER_GATEWAY}
docker build -t qvazar/rtmp ${DIR} && echo "Running..." && docker run --rm --name rtmp -p 1935:1935 -e RTMP_CTRL_ADDRESS=${DOCKER_GATEWAY} qvazar/rtmp