#!/bin/bash
# CLI arguments:
# 1 Address to the origin RTMP server (rtmp://[x.x.x.x]/ingest)
# 2 The stream name (rtmp://x.x.x.x/ingest/[stream name])
# 3 The destination file prefix

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker build -t qvazar/transcoder ${DIR} && echo "Running..." && \
docker run --rm --volumes-from transcoder-sink --name hls-transcoder qvazar/transcoder "$@"